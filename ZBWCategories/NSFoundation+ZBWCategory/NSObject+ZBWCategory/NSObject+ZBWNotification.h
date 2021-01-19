//
//  NSObject+NSObject_ZBWNotification.h
//  ZBWNotificationHelper
//
//  Created by Bowen on 15/10/12.
//  Copyright © 2015年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZBWNotificationBlock)(NSNotification * _Nonnull notification);

/**********************************************************************************************************
 * 【NSObject (NSObject_ZBWNotification)】
 *  监听 、取消监听广播。 广播回被调度到【监听线程】回调。（注意：一个对象实例，不要同时在多个线程中监听广播）
 *
 **********************************************************************************************************/
@interface NSObject (NSObject_ZBWNotification)<NSMachPortDelegate>

// 监听广播
- (void)zbw_monitorNotification:(NSString *_Nonnull)name
                       selector:(SEL _Nonnull )aSelector
                         object:(id _Nullable )object;

- (void)zbw_monitorNotification:(NSString *_Nonnull)name
                         object:(id _Nonnull )object
                       callback:(ZBWNotificationBlock _Nonnull )callback;

// 取消监听
- (void)zbw_cancelMonitorNotification;

- (void)zbw_cancelMonitorNotification:(nullable NSString *)aName
                              object:(nullable id)anObject;

@end
