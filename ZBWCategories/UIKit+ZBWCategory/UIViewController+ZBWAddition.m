//
//  UIViewController+ZBWAddition.m
//  ZBWCategories
//
//  Created by 朱博文 on 2019/11/6.
//

#import "UIViewController+ZBWAddition.h"

@implementation UIViewController (ZBWAddition)


@end


@implementation UIViewController (ZBWAddition_Adapter_iPad)

- (instancetype _Nullable)zbw_initWithNibName:(nullable NSString*)nibNameOrNil bundle:(nullable NSBundle*)nibBundleOrNil {
    UIViewController*tmpVC;

    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)) {
        NSString*ipad = [nibNameOrNil stringByAppendingString:@"_iPad"];
        
        if (!nibBundleOrNil) {
            nibBundleOrNil = [NSBundle mainBundle];
        }
        NSString *path = [nibBundleOrNil pathForResource:ipad ofType:@"xib"];
        if (path) {
            tmpVC = [self initWithNibName:ipad bundle:nibBundleOrNil];
            if (tmpVC) {
                return tmpVC;
            }
        }
    }
    tmpVC = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    return tmpVC;
}

@end
