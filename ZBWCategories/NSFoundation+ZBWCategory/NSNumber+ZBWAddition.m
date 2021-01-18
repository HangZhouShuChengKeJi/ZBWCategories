//
//  NSNumber+ZBWAddition.m
//  Template
//
//  Created by Bowen on 16/7/11.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "NSNumber+ZBWAddition.h"

@implementation NSNumber (NSNumber_HexString)

+ (NSNumber *) numberWithHexString:(NSString *) hexString
{
    NSInteger totalValue = 0;
    for (int i = 0; i < [hexString length]; i++)
    {
        NSString *hexChar = [hexString substringWithRange:NSMakeRange(i, 1)];
        NSInteger hexValue = 0;
        if ([hexChar isEqualToString:@"f"])
        {
            hexValue = 15;
        }
        else if ([hexChar isEqualToString:@"e"])
        {
            hexValue = 14;
        }
        else if ([hexChar isEqualToString:@"d"])
        {
            hexValue = 13;
        }
        else if ([hexChar isEqualToString:@"c"])
        {
            hexValue = 12;
        }
        else if ([hexChar isEqualToString:@"b"])
        {
            hexValue = 11;
        }
        else if ([hexChar isEqualToString:@"a"])
        {
            hexValue = 10;
        }
        else
        {
            hexValue = [hexChar intValue];
        }
        //totalValue = t*()
        totalValue = totalValue  * 16 + hexValue;
    }
    return [NSNumber numberWithInteger:totalValue];
}

@end
