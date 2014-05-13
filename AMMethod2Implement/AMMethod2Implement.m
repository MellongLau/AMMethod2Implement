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

        // Sample Menu Item:
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Implement Method (v1.1)" action:@selector(doImplementMethodAction) keyEquivalent:@"a"];
            [actionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
    }
    return self;
}

// For menu item:
- (void)doImplementMethodAction
{
    NSString *methodName = [AMIDEHelper getCurrentSelectMethod];
    if ([methodName matches:@"^[-+].+"]) {
        methodName = [methodName stringByReplacingOccurrencesOfString:@";" withString:@""];
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
            
            [AMIDEHelper selectText:methodName];
        }
        [AMIDEHelper selectText:methodName];

    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
