//
//  NSObject+NSCoding.h
//  Template
//
//  Created by Bowen on 15/9/11.
//  Copyright (c) 2015年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZBWJson/ZBWJson.h>

/**
 *  使用runtime，遍历所有属性，对所有属性进行encode和decode。
 */
@interface NSObject (ZBWNSCoding)

- (void)zbw_autoEncodeWithCoder:(NSCoder *)encoder;

- (void)zbw_autoDecodeWithCoder:(NSCoder *)decoder;

@end

/*  已经不需要要开发者在.m源文件中添加NSCodingImplement宏了。使用runtime自动实现NSCoding了。
 
// 实现NSCoding协议中的方法
#define NSCodingImplement \
- (void)encodeWithCoder:(NSCoder *)aCoder\
{\
    [self autoEncodeWithCoder:aCoder];\
}\
\
- (id)initWithCoder:(NSCoder *)aDecoder\
{\
    self = [super init];\
    \
    [self autoDecodeWithCoder:aDecoder];\
    return self;\
}
 
*/
