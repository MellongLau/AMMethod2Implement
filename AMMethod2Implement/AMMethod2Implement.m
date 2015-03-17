//
//  AMAMMethod2Implement.m
//  AMAMMethod2Implement
//
//  Created by Mellong on 14-4-15.
//    Copyright (c) 2014年 Tendencystudio. All rights reserved.
//

#import "AMMethod2Implement.h"
#import "AMIDEHelper.h"

typedef enum {
    AMImplementTypeMethod = 0,
    AMImplementTypeConstString,
    AMImplementTypeSelector
}AMImplementType;

static AMMethod2Implement *sharedPlugin;

@interface AMMethod2Implement()

@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation AMMethod2Implement

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
        
        // Create menu items, initialize UI, etc.
        
        [self createMenuItem];
        [self initData];
        
    }
    return self;
}

- (void)createMenuItem
{
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSString *title            = [NSString stringWithFormat:@"Implement Method (v%@)", [self getBundleVersion]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:title action:@selector(doImplementMethodAction) keyEquivalent:@"a"];
        [actionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (NSString *)getBundleVersion
{
    NSString *bundleVersion = [[self.bundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return bundleVersion;
}

static NSArray *implementMap;
static NSArray *declareMap;
static NSArray *implementContent;

- (void)initData
{
    declareMap =    @[
                      @"^([-+]\\s*\\(\\w+\\s*\\**\\)\\s*.+)$",
                      @"^extern\\s+NSString\\s*\\*\\s*const\\s+(\\w+)$",
                      @"\\@selector\\((\\w+\\:)\\)"
                      ];
    implementMap = @[
                     @"",
                     @"^NSString\\s*\\*\\s*const\\s+%@\\s*\\=\\s*\\@\"(.*)\";$",
                     @"^([-+]\\s*\\(void\\)\\s*%@\\s*\\(\\w+\\s*\\**\\)\\s*\\w+)"
                     ];
    
    implementContent = @[
                     @"\n\n%@ {\n\t\n}",
                     @"\n\nNSString * const %@ = @\"<#value#>\";",
                     @"\n\n- (void)%@(id)sender {\n\t\n}"
                     ];
}


- (void)implementMethod:selectString
{
    NSArray *currentClassName          = [AMIDEHelper getCurrentClassNameByCurrentSelectedRangeWithFileType:AMIDEFileTypeHFile];
    NSArray *methodList                = [selectString componentsSeparatedByString:@";"];
    NSMutableString *stringResult      = [NSMutableString string];
    NSDictionary *selectTextDictionary = nil;
    BOOL shouldSelect                  = YES;
    BOOL hasOpenMFile = NO;
    for (NSString *methodItem in methodList) {
        if (methodItem.length == 0) {
            continue;
        }
        
        

        NSInteger matchIndex = [methodItem getMatchIndexWithRegexList:declareMap];
        if (matchIndex != -1)
        {
            if (hasOpenMFile == NO) {
                
                [AMIDEHelper openFile:[AMIDEHelper getMFilePathOfCurrentEditFile]];
                hasOpenMFile = YES;
            }

            NSTextView *textView = [AMXcodeHelper currentSourceCodeTextView];
            NSString *mFileText  = textView.textStorage.string;
            NSRange contentRange = [AMIDEHelper getClassImplementContentRangeWithClassNameItemList:currentClassName fileText:mFileText fileType:AMIDEFileTypeMFile];
 
            
            NSRegularExpression *regex = [NSRegularExpression
                                          regularExpressionWithPattern:declareMap[matchIndex]
                                          options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionDotMatchesLineSeparators
                                          error:NULL];
            NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:methodItem options:0 range:NSMakeRange(0, methodItem.length)];
            if (textCheckingResult.range.location != NSNotFound) {
                NSString *result = [methodItem substringWithRange:[textCheckingResult rangeAtIndex:textCheckingResult.numberOfRanges-1]];
                
                BOOL isImplementFound = NO;
                if (matchIndex == AMImplementTypeMethod) {
                    
                    NSRange textRange = [mFileText rangeOfString:methodItem options:NSCaseInsensitiveSearch];
                    isImplementFound = textRange.location != NSNotFound;
                    
                } else if (matchIndex == AMImplementTypeConstString) {
                    
                    NSString *matchRegex = [NSString stringWithFormat:implementMap[matchIndex], result];
                    isImplementFound = [mFileText matches:matchRegex range:contentRange];
                    
                }
                
                if (isImplementFound) {
                    if (selectTextDictionary == nil) {
                        selectTextDictionary = @{@"type":@(matchIndex),
                                                 @"firstSelectMethod":matchIndex==AMImplementTypeMethod?methodItem:[NSString stringWithFormat:implementMap[matchIndex], result]};
                    }
                }else {
                    if (shouldSelect) {
                        selectTextDictionary = @{@"type":@(matchIndex),
                                                 @"firstSelectMethod":matchIndex==AMImplementTypeMethod?methodItem:[NSString stringWithFormat:implementMap[matchIndex], result]};
                        shouldSelect = NO;
                    }
                    
                    [stringResult appendFormat:implementContent[matchIndex], result];
                    NSLog(@"Result:%@", result);
                }
                
            }
        }
    }
    
    if (stringResult.length > 0) {
        NSTextView *textView = [AMXcodeHelper currentSourceCodeTextView];
        NSRange contentRange = [AMIDEHelper getClassImplementContentRangeWithClassNameItemList:currentClassName fileText:textView.textStorage.string fileType:AMIDEFileTypeMFile];
        NSRange range        = [AMIDEHelper getInsertRangeWithClassImplementContentRange:contentRange];
        [textView insertText:[stringResult stringByAppendingString:@"\n"] replacementRange:range];
    }
    
    if (selectTextDictionary != nil) {
        NSInteger type = [selectTextDictionary[@"type"] integerValue];
        if (type == AMImplementTypeMethod) {
            [AMIDEHelper selectText:selectTextDictionary[@"firstSelectMethod"]];
        }else if (type == AMImplementTypeConstString){
            [AMIDEHelper selectTextWithRegex:selectTextDictionary[@"firstSelectMethod"] highlightText:@"<#value#>"];
        }
    }
}

- (void)declareMethod:(NSString *)selectString{
    
    NSInteger matchIndex = [selectString getMatchIndexWithRegexList:declareMap];
    if (matchIndex != -1)
    {
        
        if (matchIndex == AMImplementTypeMethod) {
            NSArray *currentClassName          = [AMIDEHelper getCurrentClassNameByCurrentSelectedRangeWithFileType:AMIDEFileTypeMFile];
            [AMIDEHelper openFile:[AMIDEHelper getHFilePathOfCurrentEditFile]];
            NSTextView *textView               = [AMXcodeHelper currentSourceCodeTextView];
            NSString *hFileText                = textView.textStorage.string;
            NSRange trimStringRange = [selectString rangeOfString:@"{"];
            if (trimStringRange.location != NSNotFound) {
                selectString = [selectString substringWithRange:NSMakeRange(0, trimStringRange.location)];
                NSLog(@"#2trimString: %@", selectString);
            }
            NSString *trimString = [selectString removeSpaceAndNewline];
            NSString *declareMethod = [trimString stringByAppendingString:@";"];
            NSRange contentRange = [AMIDEHelper getClassImplementContentRangeWithClassNameItemList:currentClassName fileText:hFileText fileType:AMIDEFileTypeHFile];
            NSRange textRange = [hFileText rangeOfString:trimString options:NSCaseInsensitiveSearch range:contentRange];
            if (textRange.location == NSNotFound)
            {
                
                NSRange range = [AMIDEHelper getInsertRangeWithClassImplementContentRange:contentRange];
                if (range.location != NSNotFound) {
                    [textView insertText:[NSString stringWithFormat:@"\n%@\n", declareMethod] replacementRange:range];
                    
                }
                
            }
            [AMIDEHelper selectText:declareMethod];
            
        }else if (matchIndex == AMImplementTypeSelector) {
            NSTextView *textView               = [AMXcodeHelper currentSourceCodeTextView];
            NSString *fileText                = textView.textStorage.string;
            NSRegularExpression *regex = [NSRegularExpression
                                          regularExpressionWithPattern:declareMap[matchIndex]
                                          options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionDotMatchesLineSeparators
                                          error:NULL];
            NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:selectString options:0 range:NSMakeRange(0, selectString.length)];
            if (textCheckingResult.range.location != NSNotFound) {
                NSString *result = [selectString substringWithRange:[textCheckingResult rangeAtIndex:textCheckingResult.numberOfRanges-1]];
                if (result.length > 0) {
                    NSString *matchRegex = [NSString stringWithFormat:implementMap[matchIndex], result];
                    NSString *stringResult = [NSString stringWithFormat:implementContent[matchIndex], result];
                    BOOL isImplementFound = [fileText matches:matchRegex range:NSMakeRange(0, fileText.length)];
                    if (!isImplementFound) {
                        NSArray *currentClassName = [AMIDEHelper getCurrentClassNameByCurrentSelectedRangeWithFileType:AMIDEFileTypeMFile];
                        NSRange contentRange      = [AMIDEHelper getClassImplementContentRangeWithClassNameItemList:currentClassName fileText:fileText fileType:AMIDEFileTypeMFile];
                        NSRange range             = [AMIDEHelper getInsertRangeWithClassImplementContentRange:contentRange];
                        [textView insertText:[stringResult stringByAppendingString:@"\n"] replacementRange:range];
                    }
                    [AMIDEHelper selectTextWithRegex:matchRegex highlightText:@""];
                }
            }
        }
    }
}

// For menu item:
- (void)doImplementMethodAction
{
    NSString *selectString             = [AMIDEHelper getCurrentSelectMethod];
    
    if ([AMIDEHelper isHeaderFile]) {
        
        [self implementMethod:selectString];
    }else {
        [self declareMethod:selectString];
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
