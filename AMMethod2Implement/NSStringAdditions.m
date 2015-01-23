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
//    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch            = [pred evaluateWithObject:self];
//    return isMatch;
    NSRegularExpression *regularExpression = [NSRegularExpression
                                  regularExpressionWithPattern:regex
                                  options:NSRegularExpressionAnchorsMatchLines
                                  error:NULL];
    
    NSRange range   = [regularExpression rangeOfFirstMatchInString:self
                                      options:0
                                        range:NSMakeRange(0, [self length])];
    return range.location != NSNotFound;
}

@end
