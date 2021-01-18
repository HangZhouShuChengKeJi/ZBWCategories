//
//  UIStoryboard+ZBWAddition.h
//  ZBWCategories
//
//  Created by 朱博文 on 2019/11/6.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (ZBWAddition)

@end


@interface UIStoryboard (ZBWAddition_Adapter_iPad)

+ (UIStoryboard*_Nullable)zbw_storyboardAdapter:(nonnull NSString*)name bundle:(nullable NSBundle*)storyboardBundleOrNil;

@end
