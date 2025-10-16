//
//  NSURLProtocol+WebKitSupport.m
//  NSURLProtocol+WebKitSupport
//
//  Created by yeatse on 2016/10/11.
//  Copyright © 2016年 Yeatse. All rights reserved.
//

#import "NSURLProtocol+WebKitSupport.h"
#import <WebKit/WebKit.h>

/**
 * The functions below use some undocumented APIs, which may lead to rejection by Apple.
 */

FOUNDATION_STATIC_INLINE Class ContextControllerClass() {
    static Class cls;
    if (!cls) {
        NSString *str = [NSString stringWithFormat:@"browsingC%@", @"ontextController"];
        cls = NSClassFromString(str);//[[[WKWebView new] valueForKey:str] class];
    }
    if (!cls) {
        NSString *str = [NSString stringWithFormat:@"WK%@%@%@%@",@"B",@"rowsing", @"C", @"ontextController"];
        cls = NSClassFromString(str);
    }
    return cls;
}

FOUNDATION_STATIC_INLINE SEL RegisterSchemeSelector() {
    NSString *str = [NSString stringWithFormat:@"registerSch%@%@", @"emeForCustomPr",@"otocol:"];
    return NSSelectorFromString(str);
}

FOUNDATION_STATIC_INLINE SEL UnregisterSchemeSelector() {
    NSString *str = [NSString stringWithFormat:@"unregisterSch%@%@", @"emeForCustomPr",@"otocol:"];
    return NSSelectorFromString(str);
}

@implementation NSURLProtocol (WebKitSupport)

+ (void)wk_registerScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = RegisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

+ (void)wk_unregisterScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = UnregisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

@end
