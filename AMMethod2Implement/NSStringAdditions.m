//
//  NSStringAdditions.m
//  AMMethod2Implement
//
//  Created by Long on 14-4-15.
//  Copyright (c) 2014年 Tendencystudio. All rights reserved.
//

#import "NSStringAdditions.h"

@implementation NSString (Additions)

- (BOOL)matches:(NSString *)regex
{

    return [self matches:regex range:NSMakeRange(0, self.length)];
}

- (BOOL)matches:(NSString *)regex range:(NSRange)searchRange
{
    
    NSRegularExpression *regularExpression = [NSRegularExpression
                                              regularExpressionWithPattern:regex
                                              options:NSRegularExpressionAnchorsMatchLines
                                              error:NULL];
    BOOL isMatch = [regularExpression numberOfMatchesInString:self options:0 range:searchRange] > 0;
    return isMatch;
}

- (NSInteger)getMatchIndexWithRegexList:(NSArray *)regexList
{
    int i = 0;
    for (NSString *regexItem in regexList) {
        if ([self matches:regexItem]) {
            return i;
        }
        i++;
    }
    return -1;
}

- (NSRange)firstMatch:(NSString *)regex
{
    
    NSRegularExpression *regularExpression = [NSRegularExpression
                                              regularExpressionWithPattern:regex
                                              options:NSRegularExpressionAnchorsMatchLines
                                              error:NULL];
    NSTextCheckingResult *result = [regularExpression firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    return result.range;
}


@end
