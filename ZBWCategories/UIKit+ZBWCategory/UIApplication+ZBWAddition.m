//
//  UIApplication+ZBWAddition.m
//  ZBWCategories
//
//  Created by Bowen on 2019/10/16.
//

#import "UIApplication+ZBWAddition.h"
#import <objc/runtime.h>

const void *ZBW_UIApplication_MainWindow_Key = &ZBW_UIApplication_MainWindow_Key;

@implementation UIApplication (ZBWAddition)

- (void)setZbw_mainWindow:(UIWindow *)window {
    objc_setAssociatedObject(self, ZBW_UIApplication_MainWindow_Key, window, OBJC_ASSOCIATION_RETAIN);
}

- (UIWindow *)zbw_mainWindow {
    UIWindow *window = objc_getAssociatedObject(self, ZBW_UIApplication_MainWindow_Key);
    
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    
    return window;
}

@end
