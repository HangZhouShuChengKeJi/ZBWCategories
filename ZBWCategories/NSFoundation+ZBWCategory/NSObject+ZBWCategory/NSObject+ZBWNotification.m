//
//  NSObject+NSObject_ZBWNotification.m
//  ZBWNotificationHelper
//
//  Created by Bowen on 15/10/12.
//  Copyright © 2015年 Bowen. All rights reserved.
//

#import "NSObject+ZBWNotification.h"
#import <objc/runtime.h>

static void *NSObject_ZBWNotification_Thread;
static void *NSObject_ZBWNotification_NotificationList;
static void *NSObject_ZBWNotification_NotificationList_Lock;
static void *NSObject_ZBWNotification_Notification_Selector_Map;
static void *NSObject_ZBWNotification_Has_Add_Port;
static void *NSObject_ZBWNotification_MackPort;

@implementation NSObject (NSObject_ZBWNotification)

#pragma mark- 注册通知
- (void)zbw_monitorNotification:(NSString *)name selector:(SEL)aSelector object:(id)object
{
    NSAssert([self respondsToSelector:aSelector], ([NSString stringWithFormat:@"对象%@的方法%@没有实现",NSStringFromClass(self.class), NSStringFromSelector(aSelector)]));
    
    if (name.length == 0)
    {
        return;
    }
    
    NSMutableDictionary *map = [self zbw_notificationSelectorMap];
    NSString *selectorStr = map[name];
    
    @synchronized(self)
    {
        if (![self zbw_hasAddPort])
        {
            [self zbw_setObserverThread:[NSThread currentThread]];

            [[NSRunLoop currentRunLoop] addPort:[self zbw_mackPort] forMode:NSRunLoopCommonModes];
            [self zbw_setHasAddPort];
        }
    }
    
    if (selectorStr)
    {
        map[name] = NSStringFromSelector(aSelector);
    }
    else
    {
        map[name] = NSStringFromSelector(aSelector);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zbw_onNotification:) name:name object:object];
    }
}

- (void)zbw_monitorNotification:(NSString *)name object:(id)object callback:(ZBWNotificationBlock)callback
{
    if (name.length == 0 || !callback)
    {
        return;
    }
    
    NSMutableDictionary *map = [self zbw_notificationSelectorMap];
    NSString *selectorStr = map[name];
    
    @synchronized(self)
    {
        if (![self zbw_hasAddPort])
        {
            [self zbw_setObserverThread:[NSThread currentThread]];
            
            [[NSRunLoop currentRunLoop] addPort:[self zbw_mackPort] forMode:NSRunLoopCommonModes];
            [self zbw_setHasAddPort];
        }
    }
    
    if (selectorStr)
    {
        map[name] = [callback copy];
    }
    else
    {
        map[name] = [callback copy];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zbw_onNotification:) name:name object:object];
    }
}

#pragma mark- 注销通知
- (void)zbw_cancelMonitorNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self zbw_setNotificationSelectorMap:nil];
    
    NSLock *lock = [self zbw_notificationListLock];
    [lock lock];
    NSMutableArray *notificationArray = [self zbw_notificationList];
    [notificationArray removeAllObjects];
    [self zbw_setNotificationList:nil];
    [lock unlock];
    [self zbw_setNotificationListLock:nil];
}

- (void)zbw_cancelMonitorNotification:(NSString *)aName object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:aName object:anObject];
    
    NSMutableDictionary *map = [self zbw_notificationSelectorMap];
    [map removeObjectForKey:aName];
}


#pragma 处理通知
- (void)zbw_onNotification:(NSNotification *)notification
{
    NSThread *observerThread = [self zbw_observerThread];
    
    // 如果监听线程已经无效，丢弃
    if (!observerThread || observerThread.isFinished || observerThread.isCancelled)
    {
        [self zbw_setObserverThread:nil];
        return;
    }
    
    // 【监听线程 ==【当前线程】， 执行回调
    if (observerThread && observerThread == [NSThread currentThread])
    {
        NSMutableDictionary *map = [self zbw_notificationSelectorMap];
        id selectorStr = map[notification.name];
        if (selectorStr)
        {
            if ([selectorStr isKindOfClass:[NSString class]])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:NSSelectorFromString(selectorStr) withObject:notification];
#pragma clang diagnostic pop
            }
            else
            {
                ((ZBWNotificationBlock)selectorStr)(notification);
            }
        }
    }
    // 【监听线程】!=【当前线程】，把notification加入到临时队列，调度到监听线程执行。
    else
    {
        // 加入到队列中
        NSLock *lock = [self zbw_notificationListLock];
        [lock lock];
        
        NSMutableArray *notificationArray = [self zbw_notificationList];
        [notificationArray addObject:notification];
        
        [lock unlock];
        
        [[self zbw_mackPort] sendBeforeDate:[NSDate date]
                                   components:nil
                                         from:nil
                                     reserved:0];
    }
}

#pragma mark- NSMachPortDelegate  端口回调

- (void)handleMachMessage:(void *)msg
{
    NSLock *lock = [self zbw_notificationListLock];
    [lock lock];
    
    NSMutableArray *notificationArray = [self zbw_notificationList];
    while (notificationArray.count > 0)
    {
        NSNotification *notification = [notificationArray[0] copy];
        [notificationArray removeObjectAtIndex:0];
        
        [lock unlock];
        [self zbw_onNotification:notification];
        [lock lock];
    }
    
    [lock unlock];
}


#pragma mark- 成员变量  Setter  、  Getter
#pragma mark- 是否已经添加了mackPort端口 的标记
- (BOOL)zbw_hasAddPort
{
    NSNumber *value = objc_getAssociatedObject(self, &NSObject_ZBWNotification_Has_Add_Port);
    return value.boolValue;
}

- (void)zbw_setHasAddPort
{
    objc_setAssociatedObject(self, &NSObject_ZBWNotification_Has_Add_Port, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark- NSMackPort 端口
- (NSMachPort *)zbw_mackPort
{
    NSMachPort *port = objc_getAssociatedObject(self, &NSObject_ZBWNotification_MackPort);
    if (!port)
    {
        port = [[NSMachPort alloc] init];
        port.delegate = self;
        objc_setAssociatedObject(self, &NSObject_ZBWNotification_MackPort, port, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return port;
}

- (void)zbw_setMackPort:(NSMachPort *)port
{
    objc_setAssociatedObject(self, &NSObject_ZBWNotification_MackPort, port, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark- NotificationName - Selector 的键值对

- (NSMutableDictionary *)zbw_notificationSelectorMap
{
    NSMutableDictionary *map = objc_getAssociatedObject(self, &NSObject_ZBWNotification_Notification_Selector_Map);
    if (!map)
    {
        map = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, &NSObject_ZBWNotification_Notification_Selector_Map, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return map;
}

- (void)zbw_setNotificationSelectorMap:(NSMutableDictionary *)map
{
    objc_setAssociatedObject(self, &NSObject_ZBWNotification_Notification_Selector_Map, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark notification队列锁
- (NSLock *)zbw_notificationListLock
{
    NSLock *lock = objc_getAssociatedObject(self, &NSObject_ZBWNotification_NotificationList_Lock);
    
    if (!lock)
    {
        lock = [[NSLock alloc] init];
        objc_setAssociatedObject(self, &NSObject_ZBWNotification_NotificationList_Lock, lock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return lock;
}

- (void)zbw_setNotificationListLock:(NSLock *)lock
{
    objc_setAssociatedObject(self, &NSObject_ZBWNotification_NotificationList_Lock, lock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark notification队列
- (NSMutableArray *)zbw_notificationList
{
    NSMutableArray *array = objc_getAssociatedObject(self, &NSObject_ZBWNotification_NotificationList);
    if (!array)
    {
        array = [NSMutableArray arrayWithCapacity:2];
        objc_setAssociatedObject(self, &NSObject_ZBWNotification_NotificationList, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

- (void)zbw_setNotificationList:(NSMutableArray *)array
{
    objc_setAssociatedObject(self, &NSObject_ZBWNotification_NotificationList, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark 监听的线程
- (NSThread *)zbw_observerThread
{
    return objc_getAssociatedObject(self, &NSObject_ZBWNotification_Thread);
}

- (void)zbw_setObserverThread:(NSThread *)mySubThread
{
    objc_setAssociatedObject(self, &NSObject_ZBWNotification_Thread, mySubThread, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
