//
//  UIImage+UIColor.m
//  Utility
//
//  Created by Bowen on 16/6/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "UIImage+ZBWAddition.h"

@implementation UIImage (ZBW_UIColor)

+ (UIImage *)zbw_createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [theImage stretchableImageWithLeftCapWidth:theImage.size.width/2 topCapHeight:theImage.size.height/2];
}

+ (UIImage *)zbw_createImageWithColor:(UIColor *)color
                       gradientColors:(NSArray *)colorList
                                 size:(CGSize)size
                           horizontal:(BOOL)horizontal {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CFMutableArrayRef colors = CFArrayCreateMutable(NULL,3, NULL);
    [colorList enumerateObjectsUsingBlock:^(UIColor *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CFArrayAppendValue(colors, [obj CGColor]);
    }];
//    CGFloat colorPositions[] = {
//       0.0f,
//       0.5f,
//       1
//    };


    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef,colors,NULL);  // 最后一个参数可不传，默认均匀渐变

    CGPoint startPoint = horizontal ? CGPointMake(0, size.height/2) : CGPointMake(size.width/2, 0);
    CGPoint endPoint = horizontal ? CGPointMake(size.width, size.height/2) : CGPointMake(size.width/2, size.height);
    
    CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    // 释放渐变对象
    CGGradientRelease(gradientRef);
    CFRelease(colors);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [theImage stretchableImageWithLeftCapWidth:theImage.size.width/2 topCapHeight:theImage.size.height/2];
}

+ (UIImage *)zbw_createCycleImageWithColor:(UIColor *)color radius:(CGFloat)radius; {
    return [self zbw_createCycleImageWithBgColor:nil fillColor:color diameter:radius borderColor:nil borderWidth:0];
}

+ (UIImage *)zbw_createCycleImageWithColor:(UIColor *)color
                                    radius:(CGFloat)radius
                               borderColor:(UIColor *)borderColor
                               borderWidth:(CGFloat)borderWidth {
    return [self zbw_createCycleImageWithBgColor:nil fillColor:color diameter:radius borderColor:borderColor borderWidth:borderWidth];
}

+ (UIImage *)zbw_createCycleImageWithBgColor:(UIColor *)bgColor
                                   fillColor:(UIColor *)fillColr
                                    diameter:(CGFloat)diameter
                                 borderColor:(UIColor *)borderColor
                                 borderWidth:(CGFloat)borderWidth {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter, diameter), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (bgColor) {
        CGContextSetFillColorWithColor(context, [bgColor CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, diameter, diameter));
    }
    
    CGContextSetFillColorWithColor(context, [fillColr CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, diameter, diameter));
    
    if (borderColor && borderWidth > 0) {
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, borderWidth);
        CGContextStrokeEllipseInRect(context, CGRectMake(borderWidth/2, borderWidth/2, diameter - borderWidth, diameter - borderWidth));
    }
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


+ (UIImage *)zbw_createCornerImageWithColor:(UIColor *)color
                                      size:(CGSize)size
                                      dash:(BOOL)dash
                               borderColor:(UIColor *)borderColor
                               borderWidth:(CGFloat)borderWidth {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetLineWidth(context, borderWidth);
    
    if (dash) {
        CGFloat lengths[2] = { 2, 1 };
        CGContextSetLineDash(context, 0, lengths, 2);
    }
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    CGFloat halfH = h / 2;
    CGFloat halfLineW = borderWidth/2;
    CGFloat r = halfH - halfLineW;
    CGContextMoveToPoint(context, halfH, halfLineW);
    CGContextAddLineToPoint(context, w - halfH, halfLineW);
    CGContextAddArcToPoint(context, w - halfLineW, halfLineW, w - halfLineW, halfH, r);
    CGContextAddArcToPoint(context, w - halfLineW, h - halfLineW, w - halfH, h - halfLineW, r);
    CGContextAddArcToPoint(context, halfLineW, h - halfLineW, halfLineW, halfH, r);
    CGContextAddArcToPoint(context, halfLineW, halfLineW, halfH, halfLineW, r);
    CGContextClosePath(context);
    
    CGContextStrokePath(context);
//    CGContextStrokeEllipseInRect(context, CGRectMake(borderWidth/2, borderWidth/2, size.width - borderWidth, size.height - borderWidth));
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

/**
 创建一个圆形图片
 */
+ (UIImage *)zbw_createCycleImageWithColor:(UIColor *)bgColor
                                 fillColor:(UIColor *)fillColr
                                  diameter:(CGFloat)diameter
                                        tl:(BOOL)tl
                                        tr:(BOOL)tr
                                        bl:(BOOL)bl
                                        br:(BOOL)br {
    CGSize size = CGSizeMake(diameter, diameter);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [bgColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    CGFloat halfH = h / 2;
    CGFloat halfLineW = 0/2;
    CGFloat r = halfH - halfLineW;
    
    CGContextMoveToPoint(context, halfH, halfLineW);
    
    if (tr) {
        CGContextAddArcToPoint(context, w - halfLineW, halfLineW, w - halfLineW, halfH, r);
    } else {
        CGContextAddLineToPoint(context, w - halfLineW, halfLineW);
    }
    
    if (br) {
        CGContextAddArcToPoint(context, w - halfLineW, h - halfLineW, w - halfH, h - halfLineW, r);
    } else {
        CGContextAddLineToPoint(context, w - halfLineW, h - halfLineW);
    }
    
    if (bl) {
        CGContextAddArcToPoint(context, halfLineW, h - halfLineW, halfLineW, halfH, r);
    } else {
        CGContextAddLineToPoint(context, halfLineW, h - halfLineW);
    }
    
    if (tl) {
        CGContextAddArcToPoint(context, halfLineW, halfLineW, halfH, halfLineW, r);
    } else {
        CGContextAddLineToPoint(context, halfLineW, halfLineW);
    }
    
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, fillColr.CGColor);
    CGContextFillPath(context);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end

@implementation UIImage(ZBW_Orientation)
//Fix image's rotation
- (UIImage *)zbw_fixOrientation {
    
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    
    size_t width = self.size.width;
    size_t height = self.size.height;
    size_t bitsPerComponent = 8; // r g b a 每个component bits数目
    size_t bytesPerRow = self.size.width * 4; // 一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间
    unsigned char *data = calloc(width * height * 4, sizeof(unsigned char)); // 取图片首地址

    CGContextRef ctx = CGBitmapContextCreate(data,
                                             self.size.width,
                                             self.size.height,
                                             bitsPerComponent,
                                             bytesPerRow,
                                             space,
                                             kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    CGColorSpaceRelease(space);
    if (data != NULL) {
        free(data);
        data = NULL;
    }
    return img;
    
}
- (UIImage *)zbw_imageAtRectAfterFixOrientation:(CGRect)rect
{
    UIImage *fixedImage = [self zbw_fixOrientation];
    CGImageRef imageRef = CGImageCreateWithImageInRect([fixedImage CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}
@end


@implementation UIImage (ZBW_Scaled)

+ (UIImage *)zbw_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end


// Private helper methods
//@interface UIImage ()
//- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;
//@end

@implementation UIImage (Alpha)

// Returns true if the image has an alpha layer
- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

#pragma mark -
#pragma mark Private helper methods

// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}

@end


// Private helper methods
//@interface UIImage ()
//- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;
//@end

@implementation UIImage (RoundedCorner)

// Creates a copy of this image with rounded corners
// If borderSize is non-zero, a transparent border of the given size will also be added
// Original author: BjÃ¶rn SÃ¥llarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 image.size.width,
                                                 image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
    
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    [self addRoundedRectToPath:CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2)
                       context:context
                     ovalWidth:cornerSize
                    ovalHeight:cornerSize];
    CGContextClosePath(context);
    CGContextClip(context);
    
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    // Create a UIImage from the CGImage
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

#pragma mark -
#pragma mark Private helper methods

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: BjÃ¶rn SÃ¥llarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight {
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@end


// Private helper methods
//@interface UIImage ()
//- (UIImage *)resizedImage:(CGSize)newSize
//                transform:(CGAffineTransform)transform
//           drawTransposed:(BOOL)transpose
//     interpolationQuality:(CGInterpolationQuality)quality;
//- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
//@end

@implementation UIImage (Resize)

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality {
    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                         interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
    
    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
//        CGContextRef bitmap = CGBitmapContextCreate(NULL,
//                                                    newRect.size.width,
//                                                    newRect.size.height,
//                                                    CGImageGetBitsPerComponent(imageRef),
//                                                    0,
//                                                    CGImageGetColorSpace(imageRef),
//                                                    CGImageGetBitmapInfo(imageRef));
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);
    
    if (model == kCGColorSpaceModelMonochrome) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8,
                                                0,
                                                colorSpace,
                                                 model == kCGColorSpaceModelMonochrome ? (kCGImageAlphaNone | kCGBitmapByteOrderDefault) : ( kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    CGColorSpaceRelease(colorSpace);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

@end


CGFloat DegreesToRadians1(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees1(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (CS_Extensions)

-(UIImage *)imageAtRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees1(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
    return [self imageRotatedByDegrees:degrees bgColor:nil];
}

- (UIImage *)imageRotatedFillWithBgColorByDegrees:(CGFloat)degrees {
    return [self imageRotatedByDegrees:degrees bgColor:[UIImage zbw_bgColor:self]];
//    return [self imageRotatedByDegrees:degrees bgColor:[UIColor greenColor]];

}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees bgColor:(UIColor *)color
{
    // calculate the size of the rotated view's containing box for our drawing space
    __block CGSize rotatedSize;
    if ([NSThread isMainThread]) {
        UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
        CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians1(degrees));
        rotatedViewBox.transform = t;
        rotatedSize = rotatedViewBox.frame.size;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
            CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians1(degrees));
            rotatedViewBox.transform = t;
            rotatedSize = rotatedViewBox.frame.size;
        });
    }
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    if (color) {
        CGContextSetFillColorWithColor(bitmap, color.CGColor);
        CGContextFillRect(bitmap, CGRectMake(0, 0, rotatedSize.width, rotatedSize.height));
    }

    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians1(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

@end;


@implementation UIImage(ZBW_Addition)

+ (UIColor *)zbw_bgColor:(UIImage *)image {
    CGImageRef cgimage = [image CGImage];
    
    size_t width = CGImageGetWidth(cgimage); // 图片宽度
    size_t height = CGImageGetHeight(cgimage); // 图片高度
    unsigned char *data = calloc(width * height * 4, sizeof(unsigned char)); // 取图片首地址
    size_t bitsPerComponent = 8; // r g b a 每个component bits数目
    size_t bytesPerRow = width * 4; // 一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间
    
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    
    // 获取4个顶点的颜色
    size_t offsetPixel = 0;
    
    NSInteger redCount = 0;
    NSInteger greenCount = 0;
    NSInteger blueCount = 0;
    // 左上
    unsigned char red = data[offsetPixel];
    unsigned char green = data[offsetPixel + 1];
    unsigned char blue = data[offsetPixel + 2];
    redCount += red;
    greenCount += green;
    blueCount += blue;
    
    int pointCount = 4;
    // 右上
    offsetPixel = (width - 1) * 4;
    red = data[offsetPixel];
    green = data[offsetPixel + 1];
    blue = data[offsetPixel + 2];
    
    redCount += red;
    greenCount += green;
    blueCount += blue;
    
    // 左下
    offsetPixel = (height - 2) * width * 4;
    red = data[offsetPixel];
    green = data[offsetPixel + 1];
    blue = data[offsetPixel + 2];

    redCount += red;
    greenCount += green;
    blueCount += blue;

    // 右下
    offsetPixel = (width * height -2) * 4  ;
    red = data[offsetPixel];
    green = data[offsetPixel + 1];
    blue = data[offsetPixel + 2];

    redCount += red;
    greenCount += green;
    blueCount += blue;
    
    red = redCount/pointCount;
    green = greenCount/pointCount;
    blue = blueCount/pointCount;
    
    CGColorSpaceRelease(space);
    CGContextRelease(context);
    if (data != NULL) {
        free(data);
        data = NULL;
    }
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

+ (UIImage *)zbw_imageClear:(UIImage *)image {
    CGImageRef cgimage = [image CGImage];
    
    size_t width = CGImageGetWidth(cgimage); // 图片宽度
    size_t height = CGImageGetHeight(cgimage); // 图片高度
    unsigned char *data = calloc(width * height * 4, sizeof(unsigned char)); // 取图片首地址
    size_t bitsPerComponent = 8; // r g b a 每个component bits数目
    size_t bytesPerRow = width * 4; // 一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间
    
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    
    for (size_t i = 0; i < height; i++)
    {
        for (size_t j = 0; j < width; j++)
        {
            size_t pixelIndex = i * width * 4 + j * 4;
            
            unsigned char red = data[pixelIndex];
            unsigned char green = data[pixelIndex + 1];
            unsigned char blue = data[pixelIndex + 2];
            
            
            
//            BOOL black = NO;
            
//            if (red < 100 && green < 100 && blue < 100) {
//                black = YES;
//
//                if ((abs(red - green) > 25 || abs(red - blue) > 25 || abs(green - blue) > 25)) {
//                    black = NO;
//                }
//            }
//            data[pixelIndex] = data[pixelIndex + 1] = data[pixelIndex + 2] = black ? 0 : 255;
            
            BOOL white = NO;
            // 底色变白
//            if (red + green + blue > 380) {
//            } else if (red > 180 && green > 180 && blue > 180) {
//            } else if (red > 235 && green < 100 && blue < 100) {
//            } else if (green > 235 && red < 100 && blue < 100) {
//            } else if (blue > 235 && red < 100 && green < 100) {
//            } else if ((red > 100 || blue > 100 || green > 100) && (abs(red - green) > 25 || abs(red - blue) > 25 || abs(green - blue) > 25)) {
//            } else if ((red < 100 || blue < 100 || green < 100) && (abs(red - green) > 40 || abs(red - blue) > 40 || abs(green - blue) > 40)) {
//            } else {
//                white = NO;
//            }
            if (red > 160  && green > 160 && blue > 160) {
                white = YES;
            }
            
            if (white) {
                data[pixelIndex] = data[pixelIndex + 1] = data[pixelIndex + 2] = 255;
            } else {
                data[pixelIndex] = data[pixelIndex + 1] = data[pixelIndex + 2] = 0;
            }
        }
    }
    cgimage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(space);
    CGContextRelease(context);
    UIImage *resultImage = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    if (data != NULL) {
        free(data);
        data = NULL;
    }
    
    return  resultImage;
}

+ (unsigned char *)zbw_Red:(UIImage *)image {
    CGImageRef cgimage = [image CGImage];
    
    size_t width = CGImageGetWidth(cgimage); // 图片宽度
    size_t height = CGImageGetHeight(cgimage); // 图片高度
    unsigned char *data = calloc(width * height * 4, sizeof(unsigned char)); // 取图片首地址
    size_t bitsPerComponent = 8; // r g b a 每个component bits数目
    size_t bytesPerRow = width * 4; // 一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间
    
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    
    unsigned char *flagData = calloc(width * height, sizeof(unsigned char));
    memset(flagData, 0, width * height * sizeof(unsigned char));
    
    for (size_t i = 0; i < height; i++)
    {
        for (size_t j = 0; j < width; j++)
        {
            size_t pixelIndex = i * width * 4 + j * 4;
            
            unsigned char red = data[pixelIndex];
            unsigned char green = data[pixelIndex + 1];
            unsigned char blue = data[pixelIndex + 2];
            
            BOOL white = NO;
            
            if (MAX(MAX(green, blue), red) < 120 && (MAX(MAX(green, blue), red) - MIN(MIN(green, blue), red)) < 20) {
                continue;
            }
            
            // 红色
            if (green < 210 && ((red >= 100 && red > MAX(green, blue) && red > green + 15) || (red < 100 && red > MAX(green, blue) && red > green + 30))) {
                white = YES;
            }
            
            if (white) {
                flagData[i * width + j] = 1;
                continue;
            }
            
            // 灰色
            BOOL isGary = MAX(MAX(green, blue), red) < 150 && (MAX(MAX(green, blue), red) - MIN(MIN(green, blue), red)) < 20;
            
            if (isGary) {
                continue;
            } else {
//                // 红色
//                if (green < 210 && red > 70 && red > MAX(green, blue) && red > green + 10) {
//                    white = YES;
//                }
                
//                if (red > 120 && red > MAX(green, blue) && green < 230 && blue < 230  && (MAX(green, blue) - MIN(green, blue)) < 50) {
//                    white = YES;
//                }
//                else if (red > 240 && red > MAX(green, blue) && blue > green && blue - green > 40) {
//                    white = YES;
//                }
//                else if (red > 240 && blue < green && green < 110 && green - blue > 30) {
//                    white = YES;
//                }
//                else if (red > MAX(blue, green) && red > MAX(blue, green) + 10) {
//                    white = YES;
//                }
                
                
                
                // 蓝色
                if (blue > 240) {
                    white = YES;
                } else if (blue > MAX(red, green)) {
                    white = YES;
                }
                
                if (white) {
                    flagData[i * width + j] = 2;
                    continue;
                }
            }
        }
    }
    CGColorSpaceRelease(space);
    CGContextRelease(context);
    if (data != NULL) {
        free(data);
        data = NULL;
    }

    return flagData;
}

+ (UIImage *)zbw_imageClearColor:(UIImage *)image redData:(unsigned char *)redData trackColor:(ZBWTrackColor)color {
    return [UIImage zbw_imageClearTrace:image redData:redData value:color];
}

+ (UIImage *)zbw_imageClearRed:(UIImage *)image redData:(unsigned char *)redData {
    return [UIImage zbw_imageClearTrace:image redData:redData value:ZBWTrackColor_Red];
}

+ (UIImage *)zbw_imageClearBlue:(UIImage *)image redData:(unsigned char *)redData {
    return [UIImage zbw_imageClearTrace:image redData:redData value:ZBWTrackColor_blue];
}
    
+ (UIImage *)zbw_imageClearTrace:(UIImage *)image redData:(unsigned char *)redData {
    return [UIImage zbw_imageClearTrace:image redData:redData value:ZBWTrackColor_Red | ZBWTrackColor_blue];
}
    
+ (UIImage *)zbw_imageClearTrace:(UIImage *)image redData:(unsigned char *)redData value:(ZBWTrackColor)value {
    CGImageRef cgimage = [image CGImage];
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGColorSpaceModel model = CGColorSpaceGetModel(colorSpace);
    
    int channels = model == 0 ? 1 : 4;
    
    size_t width = CGImageGetWidth(cgimage); // 图片宽度
    size_t height = CGImageGetHeight(cgimage); // 图片高度
    unsigned char *data = calloc(width * height * channels, sizeof(unsigned char)); // 取图片首地址
    size_t bitsPerComponent = 8; // r g b a 每个component bits数目
    size_t bytesPerRow = width * channels; // 一张图片每行字节数目 (每个像素点包含r g b a 四个字节)
    
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 channels == 1 ? (kCGImageAlphaNone | kCGBitmapByteOrderDefault) : ( kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big));
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgimage);
    
    for (size_t i = 0; i < height; i++)
    {
        for (size_t j = 0; j < width; j++)
        {
            size_t pixelIndex = i * width * channels + j * channels;
            
            if ((redData[i*width + j] & value) > 0) {
                if (channels == 1) {
                    data[pixelIndex] = 255;
                } else {
                    data[pixelIndex] = data[pixelIndex + 1] = data[pixelIndex + 2] = 255;
                }
            }
        }
    }
    cgimage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *resultImage = [UIImage imageWithCGImage:cgimage];
    CGImageRelease(cgimage);
    if (data != NULL) {
        free(data);
        data = NULL;
    }
    
    return  resultImage;
}

@end


