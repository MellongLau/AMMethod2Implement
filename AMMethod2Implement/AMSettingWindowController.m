//
//  AMSetting.m
//  AMMethod2Implement
//
//  Created by JohnnyLiu on 15/3/30.
//  Copyright (c) 2015年 Tendencystudio. All rights reserved.
//

#import "AMSettingWindowController.h"
#import "AMMenuGenerator.h"

@interface AMSettingWindowController ()

@property (weak) IBOutlet NSPopUpButton *shortcutMask1;
@property (weak) IBOutlet NSPopUpButton *shortcutMask2;
@property (weak) IBOutlet NSTextField *controlTextField;

@end

@implementation AMSettingWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    NSDictionary *userMenu = [[NSUserDefaults standardUserDefaults] objectForKey:kMenuActionTitle];
    if (userMenu != nil) {
        
        NSArray *items = userMenu[kMenuShortcut];
        if (items.count == 1) {
            [self.shortcutMask1 selectItemWithTitle:items[0]];
        }
        if (items.count == 2) {
            [self.shortcutMask2 selectItemWithTitle:items[1]];
        }
        self.controlTextField.stringValue = userMenu[kMenuKeyEquivalent];
        
    }
}

- (IBAction)onApplyButtonClicked:(NSButton *)sender {
    
    NSMutableArray *maskKeys = [NSMutableArray array];
    if (self.shortcutMask1.selectedItem.title != nil && self.shortcutMask1.selectedItem.title.length > 0) {
        [maskKeys addObject:self.shortcutMask1.selectedItem.title];
    }
    if (self.shortcutMask2.selectedItem.title != nil && self.shortcutMask2.selectedItem.title.length > 0) {
        [maskKeys addObject:self.shortcutMask2.selectedItem.title];
    }
    
    NSDictionary *menuItem = @{kMenuTitle:kMenuActionTitle, kMenuShortcut:maskKeys, kMenuKeyEquivalent:self.controlTextField.stringValue};
    [[NSUserDefaults standardUserDefaults] setObject:menuItem forKey:kMenuActionTitle];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self close];
}

@end
