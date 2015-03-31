//
//  AMSetting.m
//  AMMethod2Implement
//
//  Created by JohnnyLiu on 15/3/30.
//  Copyright (c) 2015年 Tendencystudio. All rights reserved.
//

#import "AMSettingWindowController.h"

@interface AMSettingWindowController ()

@property (weak) IBOutlet NSPopUpButton *shortcutMask1;
@property (weak) IBOutlet NSPopUpButton *shortcutMask2;
@property (weak) IBOutlet NSTextField *controlTextField;

@end

@implementation AMSettingWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)onApplyButtonClicked:(NSButton *)sender {
    
    NSLog(@"#%@,%@,%@", self.shortcutMask1.selectedItem.title, self.shortcutMask2.selectedItem.title, self.controlTextField.stringValue);
    [self close];
}

@end
