//
//  UIActionSheet+ZBWAddition.m
//  testtest
//
//  Created by Bowen on 16/7/25.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "UIActionSheet+ZBWAddition.h"
#import <objc/runtime.h>

const void *ZBW_UIActionSheet_TapKey = &ZBW_UIActionSheet_TapKey;
const void *ZBW_UIActionSheetOriginalDelegateKey = &ZBW_UIActionSheetOriginalDelegateKey;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
@implementation UIActionSheet(ZBWAddition)

+ (instancetype)zbw_showWithTitle:(NSString *)title
                cancelButtonTitle:(NSString *)cancelButtonTitle
           destructiveButtonTitle:(NSString *)destructiveButtonTitle
                otherButtonTitles:(NSArray *)otherButtonTitles
                         tapBlock:(ZBW_UIActionSheetCompletionBlock)tapBlock
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:nil
                                                    cancelButtonTitle:cancelButtonTitle
                                               destructiveButtonTitle:destructiveButtonTitle
                                                    otherButtonTitles:otherButtonTitles.count > 0 ? otherButtonTitles[0] : nil, nil];
    
    for (int i = 1; i < otherButtonTitles.count; i++) {
        [actionSheet addButtonWithTitle: otherButtonTitles[i]];
    }
    
    
    if (tapBlock) {
        actionSheet.zbwTapBlock = tapBlock;
    }
    
    return actionSheet;
}

- (void)_checkAlertViewDelegate {
    if (self.delegate != (id<UIActionSheetDelegate>)self) {
        objc_setAssociatedObject(self, ZBW_UIActionSheetOriginalDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UIActionSheetDelegate>)self;
    }
}

- (void)setZbwTapBlock:(ZBW_UIActionSheetCompletionBlock)zbwTapBlock
{
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, ZBW_UIActionSheet_TapKey, zbwTapBlock, OBJC_ASSOCIATION_COPY);
}

- (ZBW_UIActionSheetCompletionBlock)zbwTapBlock
{
    return objc_getAssociatedObject(self, ZBW_UIActionSheet_TapKey);
}


#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.zbwTapBlock ? self.zbwTapBlock(self, buttonIndex) : nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}


@end
#pragma clang diagnostic pop
