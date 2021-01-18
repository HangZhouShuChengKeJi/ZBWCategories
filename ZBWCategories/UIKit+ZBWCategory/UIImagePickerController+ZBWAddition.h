//
//  UIImagePickerController+ZBWAddition.h
//  testtest
//
//  Created by Bowen on 16/7/26.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIImagePickerController.h>

@interface UIImagePickerController(ZBWAddition)<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) void(^zbwDidFinishPickingMediaBlock)(NSDictionary *info);

@property (nonatomic, assign) UIInterfaceOrientationMask    zbwOrientationMask;

@end
