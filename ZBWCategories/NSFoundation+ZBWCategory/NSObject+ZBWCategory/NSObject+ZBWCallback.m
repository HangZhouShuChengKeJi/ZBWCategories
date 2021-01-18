//
//  NSObject+ZBWCallback.m
//  Orange
//
//  Created by Bowen on 2018/8/26.
//  Copyright © 2018年 Bowen. All rights reserved.
//

#import "NSObject+ZBWCallback.h"
#import <objc/runtime.h>

static const void *kZBW_Callback_Key;

@implementation NSObject (ZBWCallback)

- (void)setZbw_callback:(kZBW_DefaultCallbackBlock)zbw_callback {
    objc_setAssociatedObject(self, &kZBW_Callback_Key, zbw_callback, OBJC_ASSOCIATION_COPY);
}

- (kZBW_DefaultCallbackBlock)zbw_callback {
    return objc_getAssociatedObject(self, &kZBW_Callback_Key);
}

@end
