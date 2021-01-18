//
//  UIColor.m
//  Utility
//
//  Created by Bowen on 16/6/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "UIColor+ZBWAddition.h"

@implementation UIColor (ZBW_Constructor)

+ (instancetype)zbw_colorWithHexStr:(NSString *)hexStr
{
    if (![hexStr isKindOfClass:[NSString class]] || hexStr.length == 0) {
        return [UIColor clearColor];
    }
    
    hexStr = [[hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([hexStr hasPrefix:@"0X"]) {
        hexStr = [hexStr substringFromIndex:2];
    } else if ([hexStr hasPrefix:@"#"]){
        hexStr = [hexStr substringFromIndex:1];
    }
    
//    if (hexStr.length != 6 && hexStr.length != 8) {
//        return [UIColor clearColor];
//    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9A-F]{6,8}"];
    if (![predicate evaluateWithObject:hexStr]) {
        return [UIColor clearColor];
    }
    
    unsigned int hexNum = 0;
    [[NSScanner scannerWithString:hexStr] scanHexInt:&hexNum];
    
    return [UIColor zbw_colorWithNum:hexNum];
}


+ (instancetype)zbw_colorWithNum:(NSUInteger)num
{
    int a = (int)((num & 0xFF000000) >> 24);
    a = a == 0 ? 255 : a;
    int r = (int)((num & 0xFF0000) >> 16);
    int g = (int)((num & 0xFF00) >> 8);
    int b = (int)(num & 0xFF);
    float constValue = 255.0f;
    
    return [UIColor colorWithRed:r/constValue
                           green:g/constValue
                            blue:b/constValue
                           alpha:a/constValue];    
}

+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString
{
    return [self zbw_colorWithHexStr:hexColorString];
}

@end
