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
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:self];
    return isMatch;
}

@end
