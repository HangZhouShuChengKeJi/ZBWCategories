//
//  NSObject+ZBWCopy.m
//  Template
//
//  Created by Bowen on 16/10/27.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "NSObject+ZBWCopy.h"
#import "NSObject+ZBWProperty.h"
#import <UIKit/UIKit.h>

@implementation NSObject (ZBWCopy)

- (id)zbw_shallowCopy
{
    id copyObject = [[[self class] alloc] init];
    [[self.class zbwOP_propertyList] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZBWProperty *property = obj;
        if (property.isReadonly) {
            return;
        }
        id value = [self valueForKey:property.name];
        [copyObject setValue:value forKey:property.name];
    }];
    
    return copyObject;
}


- (id)zbw_deepCopy
{
    id copyObject = [[[self class] alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    Class aClass = [self class];
#pragma clang diagnostic pop
    
    if ([self isKindOfClass:[NSString class]]) {
        copyObject = [(NSString *)self copy];
        return copyObject;
    } else if ([self isKindOfClass:[NSValue class]]) {
        copyObject = [(NSValue *)self copy];
        return copyObject;
    } else if ([self isKindOfClass:[UIResponder class]]) {
        return nil;
    } else if ([self isKindOfClass:[NSArray class]]) {
        NSArray *arraySelf = (NSArray *)self;
        NSInteger count = [arraySelf count];
        NSMutableArray *copyArray = [NSMutableArray arrayWithCapacity:count];
        
        [arraySelf enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            id copyItem = [obj zbw_deepCopy];
            if (copyItem) {
                [copyArray addObject:copyItem];
            }
        }];
        
        if ([arraySelf isKindOfClass:[NSMutableArray class]]) {
            return copyArray;
        } else {
            return copyArray.copy;
        }
    } else if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicSelf = (NSDictionary *)self;
        NSMutableDictionary *copyDic = [NSMutableDictionary dictionaryWithCapacity:MAX(dicSelf.allKeys.count, 1)];
        [dicSelf enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id v = [obj zbw_deepCopy];
            if (v) {
                copyDic[key] = v;
            }
        }];
        
        if ([dicSelf isKindOfClass:[NSMutableDictionary class]]) {
            return copyDic;
        } else {
            return copyDic.copy;
        }
    }
    
    
    // 如果出错了， 使用序列化+反序列化处理
    @try {
        [[self.class zbwOP_propertyList] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZBWProperty *property = obj;
            if (property.isReadonly || property.isWeak) {
                return;
            }
            id value = [self valueForKey:property.name];
            if (!value) {
                return;
            }
            
            if ([value isKindOfClass:[NSValue class]]) {
                // 如果是value对象，直接设置
                [copyObject setValue:value forKey:property.name];
            } else if ([value isKindOfClass:[NSArray class]]) {
                // 如果是数组对象，进行遍历、深拷贝
                [copyObject setValue:[value zbw_deepCopy] forKey:property.name];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                // 如果是字典，进行遍历、深拷贝
                [copyObject setValue:[value zbw_deepCopy] forKey:property.name];
            } else {
                if (property.valueType == ZBWOPTypeObject) {
                    id v = [value zbw_deepCopy];
                    [copyObject setValue:v forKey:property.name];
                } else if (property.valueType == ZBWOPTypeClassObject) {
                    [copyObject setValue:value forKey:property.name];
                }
            }
        }];
    } @catch (NSException *exception) {
        NSDictionary *dic = [self zbw_jsonObject];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            [copyObject zbw_initWithJsonDic:dic];
        }
    } @finally {
        
    }
    
    return copyObject;
}

@end
