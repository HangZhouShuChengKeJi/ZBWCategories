
#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

typedef void (^ZBW_UIAlertViewBlock) (UIAlertView *alertView);
typedef void (^ZBW_UIAlertViewCompletionBlock) (UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (ZBW_Block)

+ (instancetype)zbw_showWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(UIAlertViewStyle)style
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(ZBW_UIAlertViewCompletionBlock)tapBlock;

+ (instancetype)zbw_showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(ZBW_UIAlertViewCompletionBlock)tapBlock;

@property (copy, nonatomic) ZBW_UIAlertViewCompletionBlock zbwTapBlock;
@property (copy, nonatomic) ZBW_UIAlertViewCompletionBlock zbwWillDismissBlock;
@property (copy, nonatomic) ZBW_UIAlertViewCompletionBlock zbwDidDismissBlock;

@property (copy, nonatomic) ZBW_UIAlertViewBlock zbwWillPresentBlock;
@property (copy, nonatomic) ZBW_UIAlertViewBlock zbwDidPresentBlock;
@property (copy, nonatomic) ZBW_UIAlertViewBlock zbwCancelBlock;

@property (copy, nonatomic) BOOL(^zbwShouldEnableFirstOtherButtonBlock)(UIAlertView *alertView);

@end

#pragma clang diagnostic pop
