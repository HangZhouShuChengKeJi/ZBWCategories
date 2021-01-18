//
//  NSObject+ZBWCell.h
//  Orange
//
//  Created by Bowen on 2017/7/23.
//  Copyright © 2017年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define kZBW_CacheCellHeight_None   (0)

@interface NSObject (ZBW_Cell)

@property (nonatomic) CGFloat       zbw_cacheCellHeight;    // 缓存cell高度
@property (nonatomic) BOOL          zbw_cellSelected;

@end
