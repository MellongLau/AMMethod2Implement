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

@interface AMIDEHelper : NSObject

+ (BOOL)openFile:(NSString *)filePath;
+ (NSString *)getCurrentEditFilePath;
+ (NSString *)getMFilePathOfCurrentEditFile;
+ (NSString *)getCurrentClassName;
+ (BOOL)isHeaderFile;
+ (NSString *)getHFilePathOfCurrentEditFile;

+ (void)selectText:(NSString *)text;
+ (void)selectTextWithRegex:(NSString *)regex highlightText:(NSString *)text;
+ (void)replaceText:(NSString *)text withNewText:(NSString *)newText;

+ (NSString *)getCurrentSelectMethod;
+ (NSArray *)getCurrentClassNameByCurrentSelectedRangeWithFileType:(AMIDEFileType)fileType;
+ (NSRange)getInsertRangeWithClassImplementContentRange:(NSRange)range;
+ (NSRange)getClassImplementContentRangeWithClassNameItemList:(NSArray *)classNameItemList mFileText:(NSString *)mFileText;

@end
