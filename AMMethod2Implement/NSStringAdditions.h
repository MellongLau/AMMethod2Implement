//
//  NSStringAdditions.h
//  AMMethod2Implement
//
//  Created by Long on 14-4-15.
//  Copyright (c) 2014年 Tendencystudio. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (Additions)


- (BOOL)matches:(NSString *)regex;
- (BOOL)matches:(NSString *)regex range:(NSRange)searchRange;
- (NSRange)firstMatch:(NSString *)regex;
- (NSInteger)getMatchIndexWithRegexList:(NSArray *)regexList;

- (NSString *)removeSpaceAndNewline;

@end
