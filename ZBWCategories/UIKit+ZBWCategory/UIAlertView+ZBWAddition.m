
#import "UIAlertView+ZBWAddition.h"

#import <objc/runtime.h>

static const void *ZBW_UIAlertViewOriginalDelegateKey                   = &ZBW_UIAlertViewOriginalDelegateKey;

static const void *ZBW_UIAlertViewTapBlockKey                           = &ZBW_UIAlertViewTapBlockKey;
static const void *ZBW_UIAlertViewWillPresentBlockKey                   = &ZBW_UIAlertViewWillPresentBlockKey;
static const void *ZBW_UIAlertViewDidPresentBlockKey                    = &ZBW_UIAlertViewDidPresentBlockKey;
static const void *ZBW_UIAlertViewWillDismissBlockKey                   = &ZBW_UIAlertViewWillDismissBlockKey;
static const void *ZBW_UIAlertViewDidDismissBlockKey                    = &ZBW_UIAlertViewDidDismissBlockKey;
static const void *ZBW_UIAlertViewCancelBlockKey                        = &ZBW_UIAlertViewCancelBlockKey;
static const void *ZBW_UIAlertViewShouldEnableFirstOtherButtonBlockKey  = &ZBW_UIAlertViewShouldEnableFirstOtherButtonBlockKey;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

@implementation UIAlertView (ZBW_Block)

+ (instancetype)zbw_showWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(UIAlertViewStyle)style
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(ZBW_UIAlertViewCompletionBlock)tapBlock {
    
    NSString *firstObject = otherButtonTitles.count ? otherButtonTitles[0] : nil;
    
    UIAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:cancelButtonTitle
                                       otherButtonTitles:firstObject, nil];
    
    alertView.alertViewStyle = style;
    
    if (otherButtonTitles.count > 1) {
        for (NSString *buttonTitle in [otherButtonTitles subarrayWithRange:NSMakeRange(1, otherButtonTitles.count - 1)]) {
            [alertView addButtonWithTitle:buttonTitle];
        }
    }
    
    if (tapBlock) {
        alertView.zbwTapBlock = tapBlock;
    }
    
    [alertView show];
    
#if !__has_feature(objc_arc)
    return [alertView autorelease];
#else
    return alertView;
#endif
}


+ (instancetype)zbw_showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(ZBW_UIAlertViewCompletionBlock)tapBlock {
    
    return [self zbw_showWithTitle:title
                       message:message
                         style:UIAlertViewStyleDefault
             cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:otherButtonTitles
                      tapBlock:tapBlock];
}

#pragma mark -

- (void)_checkAlertViewDelegate {
    if (self.delegate != (id<UIAlertViewDelegate>)self) {
        objc_setAssociatedObject(self, ZBW_UIAlertViewOriginalDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UIAlertViewDelegate>)self;
    }
}

- (ZBW_UIAlertViewCompletionBlock)zbwTapBlock {
    return objc_getAssociatedObject(self, ZBW_UIAlertViewTapBlockKey);
}

- (void)setZbwTapBlock:(ZBW_UIAlertViewCompletionBlock)tapBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, ZBW_UIAlertViewTapBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
}

- (ZBW_UIAlertViewCompletionBlock)zbwWillDismissBlock {
    return objc_getAssociatedObject(self, ZBW_UIAlertViewWillDismissBlockKey);
}

- (void)setZbwWillDismissBlock:(ZBW_UIAlertViewCompletionBlock)willDismissBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, ZBW_UIAlertViewWillDismissBlockKey, willDismissBlock, OBJC_ASSOCIATION_COPY);
}

- (ZBW_UIAlertViewCompletionBlock)zbwDidDismissBlock {
    return objc_getAssociatedObject(self, ZBW_UIAlertViewDidDismissBlockKey);
}

- (void)setZbwDidDismissBlock:(ZBW_UIAlertViewCompletionBlock)didDismissBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, ZBW_UIAlertViewDidDismissBlockKey, didDismissBlock, OBJC_ASSOCIATION_COPY);
}

- (ZBW_UIAlertViewBlock)zbwWillPresentBlock {
    return objc_getAssociatedObject(self, ZBW_UIAlertViewWillPresentBlockKey);
}

- (void)setZbwWillPresentBlock:(ZBW_UIAlertViewBlock)willPresentBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, ZBW_UIAlertViewWillPresentBlockKey, willPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (ZBW_UIAlertViewBlock)zbwDidPresentBlock {
    return objc_getAssociatedObject(self, ZBW_UIAlertViewDidPresentBlockKey);
}

- (void)setZbwDidPresentBlock:(ZBW_UIAlertViewBlock)didPresentBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, ZBW_UIAlertViewDidPresentBlockKey, didPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (ZBW_UIAlertViewBlock)zbwCancelBlock {
    return objc_getAssociatedObject(self, ZBW_UIAlertViewCancelBlockKey);
}

- (void)setZbwCancelBlock:(ZBW_UIAlertViewBlock)cancelBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, ZBW_UIAlertViewCancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY);
}

- (void)setZbwShouldEnableFirstOtherButtonBlock:(BOOL(^)(UIAlertView *alertView))shouldEnableFirstOtherButtonBlock {
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, ZBW_UIAlertViewShouldEnableFirstOtherButtonBlockKey, shouldEnableFirstOtherButtonBlock, OBJC_ASSOCIATION_COPY);
}

- (BOOL(^)(UIAlertView *alertView))zbwShouldEnableFirstOtherButtonBlock {
    return objc_getAssociatedObject(self, ZBW_UIAlertViewShouldEnableFirstOtherButtonBlockKey);
}

#pragma mark - UIAlertViewDelegate

- (void)willPresentAlertView:(UIAlertView *)alertView {
    ZBW_UIAlertViewBlock block = alertView.zbwWillPresentBlock;
    
    if (block) {
        block(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, ZBW_UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [originalDelegate willPresentAlertView:alertView];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    ZBW_UIAlertViewBlock block = alertView.zbwDidPresentBlock;
    
    if (block) {
        block(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, ZBW_UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(didPresentAlertView:)]) {
        [originalDelegate didPresentAlertView:alertView];
    }
}


- (void)alertViewCancel:(UIAlertView *)alertView {
    ZBW_UIAlertViewBlock block = alertView.zbwCancelBlock;
    
    if (block) {
        block(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, ZBW_UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertViewCancel:)]) {
        [originalDelegate alertViewCancel:alertView];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ZBW_UIAlertViewCompletionBlock completion = alertView.zbwTapBlock;
    
    if (completion) {
        completion(alertView, buttonIndex);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, ZBW_UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [originalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    ZBW_UIAlertViewCompletionBlock completion = alertView.zbwWillDismissBlock;
    
    if (completion) {
        completion(alertView, buttonIndex);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, ZBW_UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [originalDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    ZBW_UIAlertViewCompletionBlock completion = alertView.zbwDidDismissBlock;
    
    if (completion) {
        completion(alertView, buttonIndex);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, ZBW_UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [originalDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    BOOL(^shouldEnableFirstOtherButtonBlock)(UIAlertView *alertView) = alertView.zbwShouldEnableFirstOtherButtonBlock;
    
    if (shouldEnableFirstOtherButtonBlock) {
        return shouldEnableFirstOtherButtonBlock(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, ZBW_UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        return [originalDelegate alertViewShouldEnableFirstOtherButton:alertView];
    }
    
    return YES;
}

@end

#pragma clang diagnostic pop
