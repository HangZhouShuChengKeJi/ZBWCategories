//
//  UIView+ZBWAddition.m
//  Utility
//
//  Created by Bowen on 16/6/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "UIView+ZBWAddition.h"
#import "UIButton+ZBWAddition.h"
#import "UIApplication+ZBWAddition.h"

/************************************************************************************
 屏幕宽高
 ************************************************************************************/
#define kZBWCATEGORIES_SCREEN_WIDTH                ((float)[[UIScreen mainScreen] bounds].size.width)
#define kZBWCATEGORIES_SCREEN_HEIGHT               ((float)[[UIScreen mainScreen] bounds].size.height)

/************************************************************************************
 // 手机型号
 ************************************************************************************/
#define kZBWCATEGORIES_IS_IPHONE_4                 (kZBWCATEGORIES_SCREEN_HEIGHT == 480)
#define kZBWCATEGORIES_IS_IPHONE_5                 (kZBWCATEGORIES_SCREEN_HEIGHT == 568)
#define kZBWCATEGORIES_IS_IPHONE_6                 (kZBWCATEGORIES_SCREEN_HEIGHT == 667)
#define kZBWCATEGORIES_IS_IPHONE_6P                (kZBWCATEGORIES_SCREEN_HEIGHT == 736)

#define kZBWCATEGORIES_IS_IPHONE_X                 (kZBWCATEGORIES_SCREEN_HEIGHT == 812)

/************************************************************************************
 // 型号适配
 ************************************************************************************/
#define kZBWCATEGORIES_PHONE_ADAPTER(iphone4Val,iphone5Val,iphone6Val,iphone6PVal) (kZBWCATEGORIES_IS_IPHONE_4 ? iphone4Val :\
(kZBWCATEGORIES_IS_IPHONE_5 ? iphone5Val :\
(kZBWCATEGORIES_IS_IPHONE_6 ? iphone6Val :\
(kZBWCATEGORIES_IS_IPHONE_6P ? iphone6PVal : iphone6PVal))))

@implementation UIView (ZBW_Line)

+ (UIView *)zbw_onePixelLineWithColor:(UIColor *)color length:(CGFloat)length horizontal:(BOOL)isHorizontal
{
    CGFloat onePixel = 1 / [UIScreen mainScreen].scale;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            isHorizontal? length : onePixel,
                                                            isHorizontal ? onePixel : length)];
    view.backgroundColor = color;
    
    return view;
}

@end

@implementation UIView (ZBW_EmptyView)

+ (UIView *)zbw_defaultEmptyView:(CGRect)frame callback:(dispatch_block_t)callback {
    UIView *emptyView = [[UIView alloc] initWithFrame:frame];
    UIButton *emptyBtn = [[UIButton alloc] initWithFrame:emptyView.bounds];
    UIColor *color = [UIColor colorWithRed:((float)((0xF2A339 & 0xFF0000) >> 16))/255.0
                                     green:((float)((0xF2A339 & 0xFF00) >> 8))/255.0
                                      blue:((float)(0xF2A339 & 0xFF))/255.0 alpha:1.0];
    [emptyBtn setTitleColor:color forState:UIControlStateNormal];
    emptyBtn.titleLabel.font = [UIFont systemFontOfSize:kZBWCATEGORIES_PHONE_ADAPTER(14,14,16,16)];
    [emptyBtn setTitle:@"网络异常，点击重试！" forState:UIControlStateNormal];
    __weak UIButton *weakEmptyBtn = emptyBtn;
    emptyBtn.zbwClickCallback = ^{
        weakEmptyBtn.hidden = YES;
        callback ? callback() : nil;
    };
    [emptyBtn setTag:99];
    emptyBtn.hidden = YES;
    [emptyView addSubview:emptyBtn];
    return emptyView;
}

@end


@implementation UIView (ZBW_ViewController)

- (UIViewController *)zbw_viewController
{
    UIResponder *responder = self.nextResponder;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    }
    
    return nil;
}

@end


@implementation UIView (ZBW_CaptureImage)

- (UIImage *)zbw_captureImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)zbw_captureImageInRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, -(rect.origin.x), -(rect.origin.y));
    
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation UIView (ZBW_Outside)

- (BOOL)zbw_outsideWithScreen
{
    return [self zbw_outsideWithView:[[UIApplication sharedApplication] zbw_mainWindow]];
}

- (BOOL)zbw_outsideWithView:(UIView *)view
{
    CGRect rect = [self convertRect:self.bounds toView:view];
    if (CGRectGetMaxX(rect) <= 0 ||
        CGRectGetMaxY(rect) <= 0 ||
        CGRectGetMinX(rect) >= CGRectGetMaxX(view.bounds) ||
        CGRectGetMinY(rect) >= CGRectGetMaxY(view.bounds)) {
        return YES;
    }
    return NO;
}


@end


@implementation UIView (TTCategory)


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

@end
