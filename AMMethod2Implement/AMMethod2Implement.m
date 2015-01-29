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
    }
    return self;
}

- (NSString *)getBundleVersion
{
    return @"1.7";
}

// For menu item:
- (void)doImplementMethodAction
{
    NSString *selectString = [AMIDEHelper getCurrentSelectMethod];
    NSDictionary *implementMap = @{@"^\\s*[-+]\\s*\\(\\w+\\s*\\**\\)\\s*[^;]+;$":@"implementObjcMethodWithCurrentSelectString:",
                                   @"^extern\\s+NSString\\s*\\*\\s*const\\s+(\\w+);$":@"implementConstStringWithCurrentSelectString:"
                                   };

    [implementMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([selectString matches:key])
        {
            SEL selector = NSSelectorFromString(obj);
            if ([self respondsToSelector:selector]) {
                [self performSelector:selector withObject:selectString];
            }
        }
    }];

    
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

- (void)implementConstStringWithCurrentSelectString:(NSString *)selectString
{
    NSString *methodName = selectString;
//    methodName = [methodName stringByReplacingOccurrencesOfString:@";" withString:@""];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^extern\\s+NSString\\s*\\*\\s*const\\s+(\\w+);?$"
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
    NSLog(@"methodName---->>>>> %@",methodName);
    
    __block NSString *firstResult = @"";
    [regex enumerateMatchesInString:methodName
                            options:0
                              range:NSMakeRange(0, methodName.length)
                         usingBlock:^(NSTextCheckingResult *results, NSMatchingFlags flags, BOOL *stop) {

                             NSString *result = [methodName substringWithRange:[results rangeAtIndex:results.numberOfRanges-1]];
                             NSLog(@"??---->>>>> %@",result);
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
