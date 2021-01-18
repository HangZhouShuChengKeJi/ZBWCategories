//
//  UIImagePickerController+ZBWAddition.m
//  testtest
//
//  Created by Bowen on 16/7/26.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "UIImagePickerController+ZBWAddition.h"
#import <objc/runtime.h>

const void *ZBW_UIImagePickerController_DidFinishPickingMediaBlock_Key = &ZBW_UIImagePickerController_DidFinishPickingMediaBlock_Key;
const void *ZBW_UIImagePickerController_OrientationMask_Key = &ZBW_UIImagePickerController_OrientationMask_Key;

@implementation UIImagePickerController (ZBWAddition)

- (void)setZbwDidFinishPickingMediaBlock:(void (^)(NSDictionary *))zbwDidFinishPickingMediaBlock
{
    objc_setAssociatedObject(self, ZBW_UIImagePickerController_DidFinishPickingMediaBlock_Key, zbwDidFinishPickingMediaBlock, OBJC_ASSOCIATION_COPY);
    
    self.delegate = self;
}

- (void (^)(NSDictionary *))zbwDidFinishPickingMediaBlock
{
    return objc_getAssociatedObject(self, ZBW_UIImagePickerController_DidFinishPickingMediaBlock_Key);
}

- (void)setZbwOrientationMask:(UIInterfaceOrientationMask)zbwOrientationMask {
    objc_setAssociatedObject(self, ZBW_UIImagePickerController_OrientationMask_Key, @(zbwOrientationMask), OBJC_ASSOCIATION_RETAIN);
}

- (UIInterfaceOrientationMask)zbwOrientationMask {
    NSNumber *value = objc_getAssociatedObject(self, ZBW_UIImagePickerController_OrientationMask_Key);
    if (value) {
        return value.integerValue;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark- UINavigationControllerDelegate

#pragma mark- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.zbwDidFinishPickingMediaBlock ? self.zbwDidFinishPickingMediaBlock(info) : nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.zbwDidFinishPickingMediaBlock ? self.zbwDidFinishPickingMediaBlock(nil) : nil;
}


-(BOOL)shouldAutorotate{
    return NO;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.zbwOrientationMask;
}

@end
