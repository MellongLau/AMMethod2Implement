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

/**
 *  Search with regex and return first match range result.
 *
 *  @param regex regex string.
 *
 *  @return first match range result
 */
- (NSRange)firstMatch:(NSString *)regex;
- (NSInteger)getMatchIndexWithRegexList:(NSArray *)regexList;

- (NSString *)removeSpaceAndNewline;

@end
