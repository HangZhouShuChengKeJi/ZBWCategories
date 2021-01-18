//
//  NSDictionary+ZBWAddition.m
//  Template
//
//  Created by Bowen on 16/6/15.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "NSDictionary+ZBWAddition.h"
#import <objc/runtime.h>
#import <objc/message.h>

void zbw_swizzleDictionary(Class aClass, SEL orgSEL, SEL swizzleSEL, IMP swizzleIMP)
{
    Method orgMethod = class_getInstanceMethod(aClass, orgSEL);
    IMP orgIMP = method_getImplementation(orgMethod);
    if (class_addMethod(aClass, swizzleSEL, orgIMP, method_getTypeEncoding(orgMethod))) {
        method_setImplementation(orgMethod, swizzleIMP);
    };
}

@implementation NSDictionary (ZBW_SafeAccess)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orgSEL = @selector(setObject:forKey:);
        SEL swizzleSEL = NSSelectorFromString(@"zbw_swizzle_setObject:forKey:");
        
        /**
         *  "setObject:forKey:", 参数非空检查
         *
         */
        IMP swizzleIMP = imp_implementationWithBlock(^(id obj, id aObj, id key){
            if (!key) {
                return ;
            }
            
            if (!aObj) {
                [(NSMutableDictionary *)obj removeObjectForKey:key];
                return;
            }
            
            void (*orgIMP) (id , SEL, id, id) = (void (*) (id , SEL, id, id))objc_msgSend;
            orgIMP(obj, swizzleSEL, aObj, key);
        });
        zbw_swizzleDictionary(NSClassFromString(@"__NSDictionaryM"), orgSEL, swizzleSEL, swizzleIMP);
        
#if 0
        /**
         *  dic[key] = value
         */
        SEL orgSEL0 = @selector(setObject:forKeyedSubscript:);
        SEL swizzleSEL0 = NSSelectorFromString(@"zbw_swizzle_setObject:forKeyedSubscript:");
        IMP swizzleIMP0 = imp_implementationWithBlock(^(id obj, id aObj, id key){
            if (!key) {
                return ;
            }
            
            if (!aObj) {
                [(NSMutableDictionary *)obj removeObjectForKey:key];
                return;
            }
            
            void (*orgIMP) (id , SEL, id, id) = (void (*) (id , SEL, id, id))objc_msgSend;
            orgIMP(obj, swizzleSEL0, aObj, key);
        });
        zbw_swizzleDictionary(NSClassFromString(@"__NSDictionaryM"), orgSEL0, swizzleSEL0, swizzleIMP0);
#endif
        // removeObjectForKey:
        SEL orgSEL1 = @selector(removeObjectForKey:);
        SEL swizzleSEL1 = NSSelectorFromString(@"zbw_swizzle_removeObjectForKey:");
        IMP swizzleIMP1 = imp_implementationWithBlock(^(id obj, id key){
            if (!key) {
                return ;
            }
            
            void (*orgIMP) (id , SEL, id) = (void (*) (id , SEL, id))objc_msgSend;
            orgIMP(obj, swizzleSEL1, key);
        });
        zbw_swizzleDictionary(NSClassFromString(@"__NSDictionaryM"), orgSEL1, swizzleSEL1, swizzleIMP1);
        
    });
}


- (id)objectForKeySafety:(id)aKey{
    id obj = [self objectForKey:aKey];
    if ([obj isEqual:[NSNull null]]) {
        return nil;
    }
    else
        return obj;
}

@end

@implementation NSDictionary (ZBW_Addition)

@end

