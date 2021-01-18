//
//  UIButton+Block.m
//  testtest
//
//  Created by Bowen on 16/7/22.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "UIButton+ZBWAddition.h"
#import <objc/runtime.h>

@interface UIButton (ZBW_Private)

@end


const void *UIButtonBlockClickEvent = &UIButtonBlockClickEvent;
@implementation UIButton(ZBW_Block)

- (void)setZbwClickCallback:(dispatch_block_t)zbwClickCallback
{
    objc_setAssociatedObject(self, _cmd, zbwClickCallback, OBJC_ASSOCIATION_COPY);
    
    id hasEvent = objc_getAssociatedObject(self, UIButtonBlockClickEvent);
    if (hasEvent) {
        return;
    }
    
    [self addTarget:self action:@selector(zbwBlock_OnClicked:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, UIButtonBlockClickEvent, @"", OBJC_ASSOCIATION_COPY);
}

- (dispatch_block_t)zbwClickCallback
{
    return objc_getAssociatedObject(self, @selector(setZbwClickCallback:));
}

- (void)zbwBlock_OnClicked:(UIButton *)btn
{
    dispatch_block_t block = self.zbwClickCallback;
    if (block) {
        block();
    }
}

@end
