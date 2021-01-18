//
//  UIActionSheet+ZBWAddition.h
//  testtest
//
//  Created by Bowen on 16/7/25.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

typedef void (^ZBW_UIActionSheetBlock) (UIActionSheet *actionSheet);
typedef void (^ZBW_UIActionSheetCompletionBlock) (UIActionSheet *alertView, NSInteger buttonIndex);

@interface UIActionSheet (ZBWAddition)<UIActionSheetDelegate>

@property (nonatomic, copy)ZBW_UIActionSheetCompletionBlock zbwTapBlock;

+ (instancetype)zbw_showWithTitle:(NSString *)title
                cancelButtonTitle:(NSString *)cancelButtonTitle
           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                otherButtonTitles:(NSArray *)otherButtonTitles
                         tapBlock:(ZBW_UIActionSheetCompletionBlock)tapBlock;

@end
#pragma clang diagnostic pop
