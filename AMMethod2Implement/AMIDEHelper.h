//
//  AMIDEHelper.h
//  AMMethod2Implement
//
//  Created by Long on 14-4-15.
//  Copyright (c) 2014年 Tendencystudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AMIDEFileTypeMFile = 0,
    AMIDEFileTypeHFile
}AMIDEFileType;

typedef enum {
    AMImplementTypeMethod = 0,
    AMImplementTypeConstString,
    AMImplementTypeSelector,
    AMImplementTypeInvocation,
    AMImplementTypeGetter
}AMImplementType;

@interface AMIDEHelper : NSObject

/**
 *  Open file in Xcode editor.
 *
 *  @param filePath file path.
 *
 *  @return return YES if open file success.
 */
+ (BOOL)openFile:(NSString *)filePath;

/**
 *  Get current edit file path.
 *
 *  @return current edit file path
 */
+ (NSString *)getCurrentEditFilePath;

/**
 *  Get .m file of current edit file.
 *
 *  @return .m file path.
 */
+ (NSString *)getMFilePathOfCurrentEditFile;

/**
 *  Get current class name by "Current Edit File Path"
 *
 *  @return class name.
 */
+ (NSString *)getCurrentClassName;

/**
 *  Check current opened file is .h file.
 *
 *  @return return YES if current fils is .h file.
 */
+ (BOOL)isHeaderFile;

/**
 *  Get .h file of current edit file.
 *
 *  @return .h file path.
 */
+ (NSString *)getHFilePathOfCurrentEditFile;

/**
 *  Highlight text and scroll to visible in current edit file.
 *
 *  @param target text.
 */
+ (void)selectText:(NSString *)text;

/**
 *  Search regex string and scroll to visible in current edit file.
 *
 *  @param regex regex string.
 *  @param text  highlight text.
 */
+ (void)selectTextWithRegex:(NSString *)regex highlightText:(NSString *)text;

/**
 *  Replace text in current editor.
 *
 *  @param text    text to be replace.
 *  @param newText new text.
 */
+ (void)replaceText:(NSString *)text withNewText:(NSString *)newText;

/**
 *  Get current selected range string.
 *
 *  @return selected range string.
 */
+ (NSString *)getCurrentSelectMethod;

/**
 *  Get all class name by @interface or @implementation of .h file or .m file of the current edit file.
 *
 *  @param fileType AMIDEFileTypeMFile or AMIDEFileTypeHFile
 *
 *  @return class name.
 */
+ (NSArray *)getCurrentClassNameByCurrentSelectedRangeWithFileType:(AMIDEFileType)fileType;

/**
 *  Get target insert position for code generation.
 *
 *  @param range content range: contentRange = [AMIDEHelper getClassImplementContentRangeWithClassNameItemList:currentClassName fileText:textView.textStorage.string fileType:AMIDEFileTypeMFile];
 *
 *  @return target insert range.
 */
+ (NSRange)getInsertRangeWithClassImplementContentRange:(NSRange)range;

/**
 *  Get class @interface or @implementation code range(before @end) in .h or .m file.
 *
 *  @param classNameItemList all class name by: NSArray *currentClassName = [AMIDEHelper getCurrentClassNameByCurrentSelectedRangeWithFileType:AMIDEFileTypeHFile];
 *  @param fileText          target string for match, should be .m (fileType should be AMIDEFileTypeMFile) or .h (fileType should be AMIDEFileTypeHFile) file content string.
 *  @param fileType          AMIDEFileTypeMFile or AMIDEFileTypeHFile
 *
 *  @return range from @interface/@implementation to @end, not include @end.
 */
+ (NSRange)getClassImplementContentRangeWithClassNameItemList:(NSArray *)classNameItemList
                                                     fileText:(NSString *)fileText
                                                     fileType:(AMIDEFileType)fileType;

@end
