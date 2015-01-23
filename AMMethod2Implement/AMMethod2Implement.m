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
    return @"1.5";
}

// For menu item:
- (void)doImplementMethodAction
{
    NSString *selectString = [AMIDEHelper getCurrentSelectMethod];
    NSDictionary *implementMap = @{@"^\\s*[-+]\\s*\\((\\w+)\\)\\s*.+":@"implementObjcMethodWithCurrentSelectString:",
                                   @"^extern\\s+NSString\\s*\\*\\s*const\\s+(\\w+);?$":@"implementConstStringWithCurrentSelectString:"
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
    methodName = [methodName stringByReplacingOccurrencesOfString:@";" withString:@""];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^extern\\s+NSString\\s*\\*\\s*const\\s+(\\w+);?$"
                                  options:0
                                  error:NULL];

    NSArray *array   = [regex matchesInString:methodName
                                               options:0
                                                 range:NSMakeRange(0, [methodName length])];
    if (array.count == 0) {
        return;
    }

    NSTextCheckingResult *results = array[0];
    if (results.numberOfRanges == 0) {
        return;
    }

    NSString *result = [methodName substringWithRange:[results rangeAtIndex:results.numberOfRanges-1]];
    NSLog(@"result: %@", result);
    [AMIDEHelper openFile:[AMIDEHelper getMFilePathOfCurrentEditFile]];
    
    NSTextView *textView = [AMXcodeHelper currentSourceCodeTextView];
    NSString *regexString = [NSString stringWithFormat:@"^NSString\\s*\\*\\s*const\\s+%@\\s*\\=\\s*\\@\"(.*)\";$", result];
    if (![textView.textStorage.string matches:regexString]) {
        NSString *className = [AMIDEHelper getCurrentClassName];
        NSString *implementationString = [NSString stringWithFormat:@"@implementation %@", className];
        NSString *endString = @"@end";
        NSRange startRange = [textView.textStorage.string rangeOfString:implementationString options:NSCaseInsensitiveSearch];
        NSRange searchRange = NSMakeRange(startRange.location, textView.textStorage.string.length - startRange.location);
        NSRange endRange = [textView.textStorage.string rangeOfString:endString options:NSCaseInsensitiveSearch range:searchRange];
        
        [textView scrollRangeToVisible:endRange];
        NSString *stringResult = [NSString stringWithFormat:@"NSString * const %@ = @\"<#value#>\";", result];
        NSString *newString = [NSString stringWithFormat:@"%@\n\n@end", stringResult];
        [textView insertText:newString replacementRange:endRange];
    }
    [AMIDEHelper selectTextWithRegex:regexString highlightText:@"<#value#>"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
