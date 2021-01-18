//
//  NSObject+ZBWCell.m
//  Orange
//
//  Created by Bowen on 2017/7/23.
//  Copyright © 2017年 Bowen. All rights reserved.
//

#import "NSObject+ZBWCell.h"
#import <objc/runtime.h>

const void * kNSObject_ZBW_CacheData_CellHeight_Key = &kNSObject_ZBW_CacheData_CellHeight_Key;
const void * kNSObject_ZBW_CacheData_CellSelected_Key = &kNSObject_ZBW_CacheData_CellSelected_Key;

@implementation NSObject (ZBW_Cell)

- (CGFloat)zbw_cacheCellHeight
{
    NSNumber *value = objc_getAssociatedObject(self, kNSObject_ZBW_CacheData_CellHeight_Key);
    if (value) {
        return value.floatValue;
    }
    return kZBW_CacheCellHeight_None;
}

- (void)setZbw_cacheCellHeight:(CGFloat)zbw_cacheCellHeight
{
    objc_setAssociatedObject(self, kNSObject_ZBW_CacheData_CellHeight_Key, @(zbw_cacheCellHeight), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)zbw_cellSelected {
    NSNumber *value = objc_getAssociatedObject(self, kNSObject_ZBW_CacheData_CellSelected_Key);
    if (value) {
        return value.boolValue;
    }
    return NO;
}

- (void)setZbw_cellSelected:(BOOL)zbw_cellSelected {
    objc_setAssociatedObject(self, kNSObject_ZBW_CacheData_CellSelected_Key, @(zbw_cellSelected), OBJC_ASSOCIATION_RETAIN);
}

@end
