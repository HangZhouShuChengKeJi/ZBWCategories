//
//  NSTimer+ZBWWeakTimer.h
//  Template
//
//  Created by xuhao on 16/11/7.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ZBWWeakTimer)

+ (NSTimer *)zbw_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(void(^)(id userInfo))block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;

+ (NSTimer *)zbw_timerWithTimeInterval:(NSTimeInterval)interval
                             block:(void(^)(id userInfo))block
                          userInfo:(id)userInfo
                           repeats:(BOOL)repeats;


@end
