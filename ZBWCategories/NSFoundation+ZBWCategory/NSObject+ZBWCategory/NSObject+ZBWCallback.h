//
//  NSObject+ZBWCallback.h
//  Orange
//
//  Created by Bowen on 2018/8/26.
//  Copyright © 2018年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^kZBW_DefaultCallbackBlock)(BOOL succeed,id object, NSDictionary *userInfo);

@interface NSObject (ZBWCallback)

@property (nonatomic, copy) kZBW_DefaultCallbackBlock zbw_callback;

@end
