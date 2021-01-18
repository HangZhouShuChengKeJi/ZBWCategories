//
//  UIView+ZBWAddition.h
//  Utility
//
//  Created by Bowen on 16/6/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  画线
 */
@interface UIView (ZBW_Line)

/**
 *  获取一个宽度为 1 像素的view
 *
 *  @param color        背景颜色
 *  @param length       长度
 *  @param isHorizontal 是否水平
 *
 *  @return UIView
 */
+ (UIView *)zbw_onePixelLineWithColor:(UIColor *)color
                               length:(CGFloat)length
                           horizontal:(BOOL)isHorizontal;

@end

@interface UIView (ZBW_EmptyView)

+ (UIView *)zbw_defaultEmptyView:(CGRect)frame callback:(dispatch_block_t)callback;

@end


/**
 *  获取当前view的 ViewController
 */
@interface UIView (ZBW_ViewController)

- (UIViewController *)zbw_viewController;

@end


/**
 *  截图
 */
@interface UIView (ZBW_CaptureImage)

- (UIImage *)zbw_captureImage;

- (UIImage *)zbw_captureImageInRect:(CGRect)rect;

@end

/**
 空间关系，是否在view之外
 */
@interface UIView (ZBW_Outside)

- (BOOL)zbw_outsideWithScreen;

- (BOOL)zbw_outsideWithView:(UIView *)view;

@end

//
// Copyright 2009-2011 Facebook
//

@interface UIView (TTCategory)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;



@end
