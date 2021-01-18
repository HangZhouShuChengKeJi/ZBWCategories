//
//  NSSet+ZBWAddtion.m
//  Orange
//
//  Created by Bowen on 2018/1/3.
//  Copyright © 2018年 Bowen. All rights reserved.
//

#import "NSSet+ZBWAddtion.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSSet (ZBWAddtion)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clazz = NSClassFromString(@"__NSCFSet");
        
        SEL addObjectSel = @selector(addObject:);
        Method oldMethod = class_getInstanceMethod(clazz, addObjectSel);
        
        if (!oldMethod) {
            return;
        }
        IMP oldImp = method_getImplementation(oldMethod);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL newSel = @selector(zbw_addObject:);
#pragma clang diagnostic pop
        IMP newImp = imp_implementationWithBlock(^(id sender, id object){
            if (!object) {
                return;
            }
            void (*orgIMP)(id,SEL,id) = (void (*)(id,SEL,id))objc_msgSend;
            orgIMP(sender, newSel, object);
        });
        
        if (class_addMethod(clazz, newSel, oldImp, method_getTypeEncoding(oldMethod))) {
            method_setImplementation(oldMethod, newImp);
        }
    });
}

@end
