//
//  NSTimer+ZBWWeakTimer.m
//  Template
//
//  Created by xuhao on 16/11/7.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "NSTimer+ZBWWeakTimer.h"

@implementation NSTimer (ZBWWeakTimer)

+ (NSTimer *)zbw_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(void(^)(id userInfo))block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats {
    NSMutableArray *userInfoArray = [NSMutableArray arrayWithObject:[block copy]];
    if (userInfo != nil) {
        [userInfoArray addObject:userInfo];
    }
    
    return [NSTimer scheduledTimerWithTimeInterval:interval
                                            target:self
                                          selector:@selector(timerBlockInvoke:)
                                          userInfo:[userInfoArray copy]
                                           repeats:repeats];
}


+ (NSTimer *)zbw_timerWithTimeInterval:(NSTimeInterval)interval
                             block:(void(^)(id userInfo))block
                          userInfo:(id)userInfo
                           repeats:(BOOL)repeats {
    NSMutableArray *userInfoArray = [NSMutableArray arrayWithObject:[block copy]];
    if (userInfo != nil) {
        [userInfoArray addObject:userInfo];
    }
    
    return [NSTimer timerWithTimeInterval:interval
                                   target:self
                                 selector:@selector(timerBlockInvoke:)
                                 userInfo:[userInfoArray copy]
                                  repeats:repeats];
}


+ (void)timerBlockInvoke:(NSTimer *)timer {
    NSArray *userInfo = timer.userInfo;
    void(^block)(id userInfo)   = userInfo[0];
    id info = nil;
    if (userInfo.count == 2) {
        info = userInfo[1];
    }
    if (block) {
        block(info);
    }
}

@end
