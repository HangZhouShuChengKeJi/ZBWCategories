//
//  UIImage+UIColor.h
//  Utility
//
//  Created by Bowen on 16/6/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZBW_UIColor)

/**
 创建一个 size(1,1)的图片
 */
+ (UIImage *)zbw_createImageWithColor:(UIColor *)color;

/**
 创建一个指定size的渐变图片。
 */
+ (UIImage *)zbw_createImageWithColor:(UIColor *)color
                       gradientColors:(NSArray *)colorList
                                 size:(CGSize)size
                           horizontal:(BOOL)horizontal;

/**
 创建一个圆形图片
 */
+ (UIImage *)zbw_createCycleImageWithColor:(UIColor *)color radius:(CGFloat)radius;

/**
 创建一个圆角图片
 */
+ (UIImage *)zbw_createCycleImageWithColor:(UIColor *)bgColor
                                 fillColor:(UIColor *)fillColr
                                  diameter:(CGFloat)diameter
                                        tl:(BOOL)tl
                                        tr:(BOOL)tr
                                        bl:(BOOL)bl
                                        br:(BOOL)br;

/**
创建一个圆形图片
*/
+ (UIImage *)zbw_createCycleImageWithColor:(UIColor *)color
                                    radius:(CGFloat)radius
                               borderColor:(UIColor *)borderColor
                               borderWidth:(CGFloat)borderWidth;

+ (UIImage *)zbw_createCycleImageWithBgColor:(UIColor *)bgColor
                                   fillColor:(UIColor *)fillColr
                                    diameter:(CGFloat)diameter
                               borderColor:(UIColor *)borderColor
                               borderWidth:(CGFloat)borderWidth;

/**
 创建圆角图片 (带边框的、虚线-实线)
 */
+ (UIImage *)zbw_createCornerImageWithColor:(UIColor *)bgColor
                                       size:(CGSize)size
                                       dash:(BOOL)dash
                                borderColor:(UIColor *)borderColor
                                borderWidth:(CGFloat)borderWidth;

@end

@interface UIImage(ZBW_Orientation)
- (UIImage *)zbw_fixOrientation;
- (UIImage *)zbw_imageAtRectAfterFixOrientation:(CGRect)rect;

@end

@interface UIImage (ZBW_Scaled)

+ (UIImage *)zbw_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end


@interface UIImage (Alpha)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
@end

@interface UIImage (RoundedCorner)
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
@end

@interface UIImage (Resize)
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
@end

@interface UIImage (CS_Extensions)
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees bgColor:(UIColor *)color;
- (UIImage *)imageRotatedFillWithBgColorByDegrees:(CGFloat)degrees;

@end;



typedef NS_ENUM(unsigned int, ZBWTrackColor) {
    ZBWTrackColor_None = 0,
    ZBWTrackColor_Red = 1,
    ZBWTrackColor_blue = 1 << 1
};


@interface UIImage (ZBW_Addition)

+ (UIImage *)zbw_imageClear:(UIImage *)image;

+ (unsigned char *)zbw_Red:(UIImage *)image;


+ (UIImage *)zbw_imageClearColor:(UIImage *)image redData:(unsigned char *)redData trackColor:(ZBWTrackColor)color;

+ (UIImage *)zbw_imageClearRed:(UIImage *)image redData:(unsigned char *)redData;

+ (UIImage *)zbw_imageClearBlue:(UIImage *)image redData:(unsigned char *)redData;

+ (UIImage *)zbw_imageClearTrace:(UIImage *)image redData:(unsigned char *)redData;

+ (UIColor *)zbw_bgColor:(UIImage *)image;

@end


