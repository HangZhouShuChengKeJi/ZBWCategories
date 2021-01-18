//
//  UIColor.h
//  Utility
//
//  Created by Bowen on 16/6/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef UIColorWithHexStr
#define UIColorWithHexStr(value) ([UIColor zbw_colorWithHexStr:value])
#endif

#ifndef UIColorWithNum
#define UIColorWithNum(value) ([UIColor zbw_colorWithNum:value])
#endif

@interface UIColor (ZBW_Constructor)

/**
 *  支持 ARGB 和 RGB， 0x、0X、#
 *  @param hexStr @"0x8f8F88"、@"0X8f8F88"、@"#8f8F88"、@"8f8F88"
 *                @"0x228f8F88"、@"0X228f8F88"、@"#228f8F88"、@"228f8F88"
 *
 */
+ (instancetype)zbw_colorWithHexStr:(NSString *)hexStr;


/**
 *
 *  @param num 0xff8788、0x99ff8788
 *
 */
+ (instancetype)zbw_colorWithNum:(NSUInteger)num;

+ (UIColor *) colorWithHexColorString:(NSString *) hexColorString;


@end
