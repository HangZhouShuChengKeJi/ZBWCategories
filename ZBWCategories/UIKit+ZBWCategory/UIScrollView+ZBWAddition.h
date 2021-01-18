//
//  UIScrollView+ZBWAddition.h
//  UIScrollView+ZBWAddition
//
//  Created by Bowen on 16/6/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZBWScrollViewObserveType) {
    /**
     监听offset
     */
    ZBWScrollViewObserveType_Offset = 1,
    /**
     监听速度
     */
    ZBWScrollViewObserveType_Speed = 1 << 1
};

@interface UIScrollView (ZBW_ScrollSpeed)

/**
 *  监听scrollView的滚动速度。currentSpeed：每秒滚动的距离(point)
 */
@property (copy, nonatomic) void (^zbw_speedChanged)(CGFloat currentSpeed);


/**
 监听scrollView的offset改变
 */
@property (copy, nonatomic) void (^zbw_contentOffsetChanged)(CGPoint contentOffset, CGSize contentSize, CGSize viewSize);

/**
 *  开始监听
 */
- (void)zbw_startObserve:(ZBWScrollViewObserveType)type;

/**
 *  停止监听
 */
- (void)zbw_stopObserve;

@end
