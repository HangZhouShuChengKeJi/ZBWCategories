//
//  UIScrollView+ZBWAddition.m
//  UIScrollView+ZBWAddition
//
//  Created by Bowen on 16/6/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "UIScrollView+ZBWAddition.h"
#import <objc/runtime.h>

#define ZBWScrollViewSpeed_USE_KVO  0

@interface ZBWScrollViewObserver : NSObject

@property (nonatomic, weak) UIScrollView        *scrollView;
@property (nonatomic, assign) CGFloat           lastOffset;
@property (nonatomic, assign) NSTimeInterval    lastTime;
@property (nonatomic, assign) BOOL              isObserving;
@property (nonatomic, assign) BOOL              vDirection;
@property (nonatomic, assign) ZBWScrollViewObserveType  type;

@property (nonatomic) CADisplayLink *displayLink;

@property (copy, nonatomic) void (^speedChanged)(CGFloat currentSpeed);
@property (copy, nonatomic) void (^contentOffsetChanged)(CGPoint contentOffset, CGSize contentSize, CGSize bounds);

@end

@implementation ZBWScrollViewObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self.contentOffsetChanged && [keyPath isEqualToString:@"contentOffset"]) {
        self.contentOffsetChanged(self.scrollView.contentOffset, self.scrollView.contentSize, self.scrollView.bounds.size);
//        [self.scrollView.bounds ]
//        [self calculate];
    }
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calculate)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

- (void)calculateDirection
{
//    CGSize contentSize = self.scrollView.contentSize;
    
//    self.vDirection = contentSize.height >= self.scrollView.frame.size.height;
    self.vDirection = YES;
}

- (void)calculate
{
    UIScrollView *scrollView = self.scrollView;
    CGPoint contentOffset = scrollView.contentOffset;
    
    CGFloat offset = self.vDirection ? contentOffset.y : contentOffset.x;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    CGFloat addOffset = fabs(offset - self.lastOffset);
    CGFloat addTime = fabs(now - self.lastTime);
    
    self.lastOffset = offset;
    self.lastTime = now;

    if (addTime > 0.1) {
        return;
    }
    
    if (addOffset <= FLT_EPSILON) {
        return;
    }
    
    CGFloat speed = addOffset / addTime;
//    NSLog(@"%f, addtime: %f", addOffset, addTime);
    
    self.speedChanged ? self.speedChanged(speed) : nil;
}

- (void)startObserve:(ZBWScrollViewObserveType)type
{
    if (self.isObserving) {
        return;
    }
    
    self.isObserving = YES;
    self.type = type;

    if (type & ZBWScrollViewObserveType_Speed) {
        [self calculateDirection];
        self.displayLink.paused = NO;
    }
    
    if (type & ZBWScrollViewObserveType_Offset) {
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)stopObserve
{
    if (!self.isObserving) {
        return;
    }
    self.isObserving = NO;
        
    if (self.type & ZBWScrollViewObserveType_Offset) {
        @try {
            [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    
    if (self.type & ZBWScrollViewObserveType_Speed) {
        _displayLink.paused = YES;
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

@end

@implementation UIScrollView (ZBW_ScrollSpeed)

- (ZBWScrollViewObserver *)zbw_scrollViewObserver
{
    ZBWScrollViewObserver *observer = objc_getAssociatedObject(self, _cmd);
    if (!observer) {
        observer = [[ZBWScrollViewObserver alloc] init];
        observer.scrollView = self;
        objc_setAssociatedObject(self, _cmd, observer, OBJC_ASSOCIATION_RETAIN);
    }
    return observer;
}

- (void)setZbw_speedChanged:(void (^)(CGFloat))zbw_speedChanged
{
    ZBWScrollViewObserver *observer = [self zbw_scrollViewObserver];
    observer.speedChanged = zbw_speedChanged;
}

- (void (^)(CGFloat))zbw_speedChanged
{
    ZBWScrollViewObserver *observer = [self zbw_scrollViewObserver];
    return observer.speedChanged;
}

- (void)setZbw_contentOffsetChanged:(void (^)(CGPoint, CGSize, CGSize))zbw_contentOffsetChanged {
    ZBWScrollViewObserver *observer = [self zbw_scrollViewObserver];
    observer.contentOffsetChanged = zbw_contentOffsetChanged;
}

- (void (^)(CGPoint, CGSize, CGSize))zbw_contentOffsetChanged {
    ZBWScrollViewObserver *observer = [self zbw_scrollViewObserver];
    return observer.contentOffsetChanged;
}

- (void)zbw_startObserve:(ZBWScrollViewObserveType)type
{
    ZBWScrollViewObserver *observer = [self zbw_scrollViewObserver];
    [observer startObserve:type];
}

- (void)zbw_stopObserve
{
    ZBWScrollViewObserver *observer = [self zbw_scrollViewObserver];
    [observer stopObserve];
}

@end
