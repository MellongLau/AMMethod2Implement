//
//  AMIDEHelper.m
//  AMMethod2Implement
//
//  Created by Long on 14-4-15.
//  Copyright (c) 2014年 Tendencystudio. All rights reserved.
//

#import "AMIDEHelper.h"

@implementation AMIDEHelper


+ (BOOL)openFile:(NSString *)filePath
{
    NSWindowController *currentWindowController = [[NSApp mainWindow] windowController];
    NSLog(@"currentWindowController %@",[currentWindowController description]);
    if ([currentWindowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        NSLog(@"Open in current Xocde");
        if ([[NSApp delegate] application:NSApp openFile:filePath]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)getCurrentEditFilePath
{
    IDESourceCodeDocument *currentSourceCodeDocument = [AMXcodeHelper currentSourceCodeDocument];
    NSString *filePath = [[currentSourceCodeDocument fileURL] path];
    return filePath;
}

+ (NSString *)getMFilePathOfCurrentEditFile
{
    NSString *fielPath = [AMIDEHelper getCurrentEditFilePath];
    if ([fielPath rangeOfString:@".h"].length > 0) {
        return [fielPath stringByReplacingOccurrencesOfString:@".h" withString:@".m"];
    }
    return fielPath;
}

+ (NSString *)getCurrentClassName
{
    NSString *fileName = [[AMIDEHelper getCurrentEditFilePath] lastPathComponent];
    return [fileName stringByDeletingPathExtension];
}

+ (void)selectText:(NSString *)text
{
    NSTextView *textView = [AMXcodeHelper currentSourceCodeTextView];
    NSRange textRange = [textView.textStorage.string rangeOfString:text options:NSCaseInsensitiveSearch];
    [textView setSelectedRange:textRange];
    [textView scrollRangeToVisible:textRange];
}

+ (void)replaceText:(NSString *)text withNewText:(NSString *)newText
{
    NSTextView *textView = [AMXcodeHelper currentSourceCodeTextView];
    NSRange textRange = [textView.textStorage.string rangeOfString:text options:NSCaseInsensitiveSearch];
    [textView scrollRangeToVisible:textRange];
    [textView insertText:newText replacementRange:textRange];
}

+ (NSString *)getCurrentSelectMethod
{
    NSTextView *textView = [AMXcodeHelper currentSourceCodeTextView];
    NSArray* selectedRanges = [textView selectedRanges];
    if (selectedRanges.count >= 1) {
        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        NSString *text = textView.textStorage.string;
        NSRange lineRange = [text lineRangeForRange:selectedRange];
        NSString *line = [text substringWithRange:lineRange];
        return line;
    }
    return nil;
}

@end
