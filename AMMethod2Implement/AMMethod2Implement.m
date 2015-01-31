//
//  AMAMMethod2Implement.m
//  AMAMMethod2Implement
//
//  Created by Mellong on 14-4-15.
//    Copyright (c) 2014年 Tendencystudio. All rights reserved.
//

#import "AMMethod2Implement.h"
#import "AMIDEHelper.h"

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
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            NSString *title = [NSString stringWithFormat:@"Implement Method (v%@)", [self getBundleVersion]];
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:title action:@selector(doImplementMethodAction) keyEquivalent:@"a"];
            [actionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
        
        [self initData];
        
    }
    return self;
}

- (NSString *)getBundleVersion
{
    return @"1.7";
}

static NSArray *implementMap;
static NSArray *declareMap;
static NSArray *implementContent;

- (void)initData
{
    declareMap =    @[
                      @"^([-+]\\s*\\(\\w+\\s*\\**\\)\\s*.+)$",
                      @"^extern\\s+NSString\\s*\\*\\s*const\\s+(\\w+)$"
                      ];
    implementMap = @[
                     @"^([-+]\\s*\\(\\w+\\s*\\**\\)\\s*.+)",
                     @"^NSString\\s*\\*\\s*const\\s+%@\\s*\\=\\s*\\@\"(.*)\";$"
                     ];
    
    implementContent = @[
                     @"\n\n%@{\n\t<#value#>\n}",
                     @"\n\nNSString * const %@ = @\"<#value#>\";"
                     ];
}


// For menu item:
- (void)doImplementMethodAction
{
    NSString *selectString = [AMIDEHelper getCurrentSelectMethod];

    NSArray *result = [AMIDEHelper getCurrentClassNameByCurrentSelectedRange];
    
    [AMIDEHelper openFile:[AMIDEHelper getMFilePathOfCurrentEditFile]];
    NSTextView *textView = [AMXcodeHelper currentSourceCodeTextView];
    NSRange contentRange = [AMIDEHelper getClassImplementContentRangeWithClassNameItemList:result mFileText:textView.textStorage.string];
    NSRange range = [AMIDEHelper getInsertRangeWithClassImplementContentRange:contentRange];
    [textView scrollRangeToVisible:range];

    BOOL shouldSelect = YES;
    NSArray *methodList = [selectString componentsSeparatedByString:@";"];
    NSMutableString *stringResult = [NSMutableString string];
    for (NSString *methodItem in methodList) {
        if (methodItem.length == 0) {
            continue;
        }

        NSInteger matchIndex = [methodItem getMatchIndexWithRegexList:declareMap];
        if (matchIndex != -1)
        {

            NSRange textRange = [AMIDEHelper getClassImplementContentRangeWithClassNameItemList:result mFileText:textView.textStorage.string];
//            NSRegularExpression *regularExpression = [NSRegularExpression
//                                                      regularExpressionWithPattern:implementMap[matchIndex]
//                                                      options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionDotMatchesLineSeparators
//                                                      error:NULL];
//            NSTextCheckingResult *result = [regularExpression firstMatchInString:textView.textStorage.string options:0 range:textRange];
//            if (result.range.location != NSNotFound) {
//                if (shouldSelect) {
//                    [AMIDEHelper selectTextWithRegex:implementMap[matchIndex] highlightText:@"<#value#>"];
//                    shouldSelect = NO;
//                }
//
//                
//                return;
//            }

            NSRegularExpression *regex = [NSRegularExpression
                                          regularExpressionWithPattern:declareMap[matchIndex]
                                          options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionDotMatchesLineSeparators
                                          error:NULL];
            NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:methodItem options:0 range:NSMakeRange(0, methodItem.length)];
            if (textCheckingResult.range.location != NSNotFound) {
                NSString *result = [methodItem substringWithRange:[textCheckingResult rangeAtIndex:textCheckingResult.numberOfRanges-1]];
                [stringResult appendFormat:implementContent[matchIndex], result];
                NSLog(@"Result:%@", result);
                
            }

        }
    }
    [textView insertText:[stringResult stringByAppendingString:@"\n"] replacementRange:range];
}

- (void)implementObjcMethodWithCurrentSelectString:(NSString *)selectString
{
    NSString *methodName = selectString;

    NSArray *result = [methodName componentsSeparatedByString:@";"];
    if (result.count == 0) {
        return;
    }
    
    methodName = result[0];

    NSLog(@"%@", methodName);
    [AMIDEHelper openFile:[AMIDEHelper getMFilePathOfCurrentEditFile]];
    
    NSTextView *textView = [AMXcodeHelper currentSourceCodeTextView];
    NSRange textRange = [textView.textStorage.string rangeOfString:methodName options:NSCaseInsensitiveSearch];
    if (textRange.location == NSNotFound) {
        NSString *className = [AMIDEHelper getCurrentClassName];
        NSString *implementationString = [NSString stringWithFormat:@"@implementation %@", className];
        NSString *endString = @"@end";
        NSRange startRange = [textView.textStorage.string rangeOfString:implementationString options:NSCaseInsensitiveSearch];
        if (startRange.location == NSNotFound) {
            startRange = NSMakeRange(0, textView.textStorage.string.length);
        }
        NSRange searchRange = NSMakeRange(startRange.location, textView.textStorage.string.length - startRange.location);
        NSRange endRange = [textView.textStorage.string rangeOfString:endString options:NSCaseInsensitiveSearch range:searchRange];
        
        [textView scrollRangeToVisible:endRange];
        
        NSString *newString = [NSString stringWithFormat:@"\n%@{\n    \n}\n\n%@", methodName, endString];
        [textView insertText:newString replacementRange:endRange];

    }
    [AMIDEHelper selectText:methodName];
}

- (void)implementConstStringWithCurrentSelectString:(NSString *)selectString index:(NSInteger)index
{
    NSString *methodName = selectString;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:implementMap[index]
                                  options:NSRegularExpressionAnchorsMatchLines
                                  error:NULL];
    
    NSString *regexString = @"^NSString\\s*\\*\\s*const\\s+%@\\s*\\=\\s*\\@\"(.*)\";$";
    
    [AMIDEHelper openFile:[AMIDEHelper getMFilePathOfCurrentEditFile]];
    
    NSTextView *textView = [AMXcodeHelper currentSourceCodeTextView];
    
    NSString *className = [AMIDEHelper getCurrentClassName];
    NSString *implementationString = [NSString stringWithFormat:@"@implementation %@", className];
    NSString *endString = @"@end";
    NSRange startRange = [textView.textStorage.string rangeOfString:implementationString options:NSCaseInsensitiveSearch];
    NSRange searchRange = NSMakeRange(startRange.location, textView.textStorage.string.length - startRange.location);
    NSRange endRange = [textView.textStorage.string rangeOfString:endString options:NSCaseInsensitiveSearch range:searchRange];
    [textView scrollRangeToVisible:endRange];
    __block NSMutableString *stringResult = [NSMutableString string];
    
    __block NSString *firstResult = @"";
    [regex enumerateMatchesInString:methodName
                            options:0
                              range:NSMakeRange(0, methodName.length)
                         usingBlock:^(NSTextCheckingResult *results, NSMatchingFlags flags, BOOL *stop) {

                             NSString *result = [methodName substringWithRange:[results rangeAtIndex:results.numberOfRanges-1]];
                             NSLog(@"Const string name is: %@",result);
                             NSString *matchRegex = [NSString stringWithFormat:regexString, result];
                            if (![textView.textStorage.string matches:matchRegex]) {
                              [stringResult appendFormat:@"NSString * const %@ = @\"<#value#>\";\n", result];
                              
                            }
                             if (firstResult.length == 0) {
                                 firstResult = result;
                             }

                             
                         }];
    if (stringResult.length > 0) {
        NSString *newString = [NSString stringWithFormat:@"%@\n\n@end", stringResult];
        [textView insertText:newString replacementRange:endRange];
        
    }
    NSString *matchRegex = [NSString stringWithFormat:regexString, firstResult];
    [AMIDEHelper selectTextWithRegex:matchRegex highlightText:@"<#value#>"];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
