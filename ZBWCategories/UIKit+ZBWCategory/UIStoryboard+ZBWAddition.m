//
//  UIStoryboard+ZBWAddition.m
//  ZBWCategories
//
//  Created by 朱博文 on 2019/11/6.
//

#import "UIStoryboard+ZBWAddition.h"

@implementation UIStoryboard (ZBWAddition)

@end


@implementation UIStoryboard (ZBWAddition_Adapter_iPad)

+ (UIStoryboard*_Nullable)zbw_storyboardAdapter:(nonnull NSString*)name bundle:(nullable NSBundle*)storyboardBundleOrNil {
    UIStoryboard*storyBoard;

    if((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)) {
        NSString *ipad = [name stringByAppendingString:@"_iPad"];
        NSString *file = [storyboardBundleOrNil pathForResource:ipad ofType:@"storyboard"];
        if (file && [[NSFileManager defaultManager] fileExistsAtPath:file]) {
            storyBoard = [UIStoryboard storyboardWithName:ipad bundle:storyboardBundleOrNil];
            if (storyBoard) {
                return storyBoard;
            }
        }
    }
        
    storyBoard = [UIStoryboard storyboardWithName:name bundle:storyboardBundleOrNil];
    return storyBoard;
}

@end
