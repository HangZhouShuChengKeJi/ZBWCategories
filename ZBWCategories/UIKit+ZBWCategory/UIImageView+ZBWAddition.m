//
//  UIImageView+CGAddition.m
//  Orange
//
//  Created by Bowen on 2017/5/6.
//  Copyright © 2017年 Bowen. All rights reserved.
//

#import "UIImageView+ZBWAddition.h"
#import <objc/runtime.h>
#import <SDWebImage/SDWebImage.h>

const void *zbw_imageTouchedBlock_KEY = &zbw_imageTouchedBlock_KEY;
const void *zbw_imageDidLoadBlock_KEY = &zbw_imageDidLoadBlock_KEY;
const void *zbw_url_KEY = &zbw_url_KEY;
const void *zbw_isGif_KEY = &zbw_isGif_KEY;
const void *zbw_identify_KEY = &zbw_identify_KEY;
const void *zbw_tapGesture_KEY = &zbw_tapGesture_KEY;

const void *zbw_imageStatus_KEY = &zbw_imageStatus_KEY;
//const void *zbw_ImageTouched_KEY = &zbw_ImageTouched_KEY;

@implementation UIImageView (ZBWAddition)

#pragma mark- Getter Setter

- (ZBWImageStatus)zbw_status {
    NSNumber *value = objc_getAssociatedObject(self, zbw_imageStatus_KEY);
    return value ? value.integerValue : ZBWImageStatus_Init;
}

- (void)setZbw_status:(ZBWImageStatus)zbw_status {
    objc_setAssociatedObject(self, zbw_imageStatus_KEY, @(zbw_status), OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)zbw_url {
    return objc_getAssociatedObject(self, zbw_url_KEY);
}

- (void)setZbw_url:(NSString *)zbw_url {
    objc_setAssociatedObject(self, zbw_url_KEY, zbw_url, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)zbw_isGif {
    NSNumber *isGif = (NSNumber *)objc_getAssociatedObject(self, zbw_isGif_KEY);
    
    return isGif ? [isGif boolValue] : NO;
}

- (void)setZbw_isGif:(BOOL)zbw_isGif {
    objc_setAssociatedObject(self, zbw_isGif_KEY, @(zbw_isGif), OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)zbw_identify {
    return objc_getAssociatedObject(self, zbw_identify_KEY);
}

- (void)setZbw_identify:(NSString *)zbw_identify {
    NSString *identify = self.zbw_identify;
    if (identify == zbw_identify || [identify isEqualToString:zbw_identify]) {
        return;
    }
    objc_setAssociatedObject(self, zbw_identify_KEY, zbw_identify, OBJC_ASSOCIATION_RETAIN);

    if (identify) {
        // 删除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:[UIImageView zbw_notifyNameOfIdentify:identify] object:nil];
    }
    if (zbw_identify) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zbw_onIdentifyNotif:) name:[UIImageView zbw_notifyNameOfIdentify:zbw_identify] object:nil];
    }
}

- (zbw_ImageTouched)zbw_imageTouchedBlock {
    return objc_getAssociatedObject(self, zbw_imageTouchedBlock_KEY);
}

- (void)setZbw_imageTouchedBlock:(zbw_ImageTouched)zbw_imageTouchedBlock {
    objc_setAssociatedObject(self, zbw_imageTouchedBlock_KEY, zbw_imageTouchedBlock, OBJC_ASSOCIATION_RETAIN);
    
    if (zbw_imageTouchedBlock) {
        if (![self zbw_tapGesture]) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(zbw_singlePressOccur:)];
            
            tapGesture.numberOfTouchesRequired = 1;
            tapGesture.numberOfTapsRequired = 1;
            [self addGestureRecognizer:tapGesture];
            [self setZbw_tapGesture:tapGesture];
        }
    } else {
        UITapGestureRecognizer *tapGesture = [self zbw_tapGesture];
        if (tapGesture) {
            [self removeGestureRecognizer:tapGesture];
            [self setZbw_tapGesture:nil];
        }
    }
    
    self.userInteractionEnabled = zbw_imageTouchedBlock != nil;
}

- (zbw_ImageDidLoadBlock)zbw_imageDidLoadBlock {
    return objc_getAssociatedObject(self, zbw_imageDidLoadBlock_KEY);
}

- (void)setZbw_imageDidLoadBlock:(zbw_ImageDidLoadBlock)zbw_imageDidLoadBlock {
    objc_setAssociatedObject(self, zbw_imageDidLoadBlock_KEY, zbw_imageDidLoadBlock, OBJC_ASSOCIATION_RETAIN);
}


- (UITapGestureRecognizer *)zbw_tapGesture {
    return objc_getAssociatedObject(self, zbw_tapGesture_KEY);
}

- (void)setZbw_tapGesture:(UITapGestureRecognizer *)tapGesture {
    objc_setAssociatedObject(self, zbw_tapGesture_KEY, tapGesture, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark- UITapGestureRecognizer
- (void)zbw_singlePressOccur:(UIGestureRecognizer *)gesture
{
    self.zbw_imageTouchedBlock ? self.zbw_imageTouchedBlock(self) : nil;
}

#pragma mark- 加载图片

- (void)zbw_loadImage:(NSString *)aUrl
{
    [self zbw_loadImage:aUrl placeholderImage:nil];
}

- (void)zbw_loadImage:(NSString *)aUrl placeholderImage:(UIImage *)placeholderImage
{
    if (aUrl == nil) {
        self.image = placeholderImage;
        self.zbw_url = aUrl;
        return;
    }
    
    NSString *oldUrl = self.zbw_url;
    // 如果图片相同，并且没有“失败”，则不需重新加载
    if (oldUrl && (oldUrl == aUrl || [oldUrl isEqualToString:aUrl]) && self.zbw_status != ZBWImageStatus_failed) {
        return;
    }
    
    [self zbw_cancelLoad];
    self.zbw_url = aUrl;
    self.zbw_status = ZBWImageStatus_Loading;
    __block typeof(self) weakSelf = self;
    
    self.sd_imageIndicator = [[SDWebImageActivityIndicator alloc] init];
    [self sd_setImageWithURL:[NSURL URLWithString:aUrl]
            placeholderImage:placeholderImage
                     options:SDWebImageAvoidAutoSetImage | SDWebImageRetryFailed
                    progress:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       //        ZBWImageLog(@"图片下载回调:{\nurl:%@\nimage:%@\nerror:%@\ncacheType:%ld\n}",imageURL,image,error,cacheType);
                       if ([weakSelf.zbw_url isEqualToString:aUrl]) {
                           if (error) {
                               weakSelf.zbw_status = ZBWImageStatus_failed;
                           } else {
                               [weakSelf zbw_presentImage:image cacheType:cacheType];
                               weakSelf.zbw_isGif = image.images != nil;
                           }
                       }
                   }];
    
}

- (void)zbw_loadFile:(NSString *)filePath
{
    NSString *oldUrl = self.zbw_url;
    // 如果图片相同，并且没有“失败”，则不需重新加载
    if (oldUrl && (oldUrl == filePath || [oldUrl isEqualToString:filePath]) && self.zbw_status != ZBWImageStatus_failed) {
        return;
    }
    
    self.zbw_url = filePath;
    self.zbw_status = ZBWImageStatus_Loading;
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    
    [self presentImageWithData:data url:filePath];
}

- (void)presentImageWithData:(NSData *)data url:(NSString *)url
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage sd_imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakSelf.zbw_url isEqualToString:url]) {
                if (!image) {
                    weakSelf.zbw_status = ZBWImageStatus_failed;
                } else {
                    [weakSelf zbw_presentImage:image cacheType:SDImageCacheTypeDisk];
                }
            }
        });
    });
}

- (void)zbw_presentImage:(UIImage *)image cacheType:(SDImageCacheType)cacheType
{
    self.zbw_status = ZBWImageStatus_Loaded;
//    [self setImage:image];
    if (self.zbw_imageDidLoadBlock) {
        self.zbw_imageDidLoadBlock(image, cacheType);
    } else {
        [self setImage:image];
        if (cacheType == SDImageCacheTypeNone) {
            [self zbw_fade];
        }
    }
//    self.zbw_imageDidLoadBlock ? self.zbw_imageDidLoadBlock(image, cacheType) : nil;
}

#pragma mark- 重新加载 某一类 图片
- (void)zbw_onIdentifyNotif:(NSNotification *)notif
{
    BOOL isGifOnly = [(NSNumber *)notif.object boolValue];
    
    if (self.zbw_url.length == 0) {
        return;
    }
    
    BOOL canReload = !(isGifOnly && !self.zbw_isGif);
    
    if (canReload) {
        [self zbw_loadImage:self.zbw_url];
    }
}

+ (NSString *)zbw_notifyNameOfIdentify:(NSString *)identify
{
    return [NSString stringWithFormat:@"Notif_ZBWImageView_%@",identify];
}



+ (void)zbw_reloadGifWithIdentify:(NSString *)identify
{
    [self zbw_reloadIdentify:identify isGifOnly:YES];
}
+ (void)zbw_reloadWithIdentify:(NSString *)identify
{
    [self zbw_reloadIdentify:identify isGifOnly:NO];
}
+ (void)zbw_reloadIdentify:(NSString *)identify isGifOnly:(BOOL)gifOnly
{
    if (!identify) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:[UIImageView zbw_notifyNameOfIdentify:identify]
                                                        object:@(gifOnly)];
}

- (void)zbw_reload
{
    if (self.zbw_url.length > 0) {
        [self zbw_loadImage:self.zbw_url];
    }
}

#pragma mark- 取消加载
- (void)zbw_cancelLoad
{
    [self sd_cancelCurrentImageLoad];
    self.zbw_url = nil;
}


- (void)zbw_fade {
    [self fadeLayer:self.layer];
}

- (void)fadeLayer:(CALayer *)layer {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = .5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [layer addAnimation:animation forKey:@"fade"];
}

@end
