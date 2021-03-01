//
//  UIImageView+CGAddition.h
//  Orange
//
//  Created by Bowen on 2017/5/6.
//  Copyright © 2017年 Bowen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

typedef void (^zbw_ImageTouched)(UIImageView *imageView);
typedef void (^zbw_ImageDidLoadBlock)(UIImage *image, SDImageCacheType cacheType);

typedef NS_ENUM(NSInteger, ZBWImageStatus) {
    ZBWImageStatus_Init = 0,
    ZBWImageStatus_Loading,
    ZBWImageStatus_Loaded,
    ZBWImageStatus_failed
};

@interface UIImageView (ZBWAddition)

@property (copy) NSString *zbw_url;
@property (nonatomic, assign, readonly) BOOL            zbw_isGif;          // 是否为gif
@property (nonatomic, copy) NSString                    *zbw_identify;      // 标识

@property (nonatomic, assign)ZBWImageStatus             zbw_status;

#pragma mark- 回调block
@property (nonatomic, copy) zbw_ImageTouched            zbw_imageTouchedBlock;
@property (nonatomic, copy) zbw_ImageDidLoadBlock       zbw_imageDidLoadBlock;

#pragma mark- 加载图片
- (void)zbw_loadImage:(NSString *)aUrl;
- (void)zbw_loadFile:(NSString *)filePath;

- (void)zbw_loadImage:(NSString *)aUrl placeholderImage:(UIImage *)placeholderImage;


#pragma mark- 重新加载
+ (void)zbw_reloadGifWithIdentify:(NSString *)identify;
+ (void)zbw_reloadWithIdentify:(NSString *)identify;

- (void)zbw_reload;

#pragma mark- 取消加载
- (void)zbw_cancelLoad;

- (void)zbw_fade;

@end
