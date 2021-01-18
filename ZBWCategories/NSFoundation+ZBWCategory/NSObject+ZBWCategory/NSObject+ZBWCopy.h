//
//  NSObject+ZBWCopy.h
//  Template
//
//  Created by Bowen on 16/10/27.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZBWCopy)


/**
 浅拷贝

 @return 拷贝对象
 */
- (id)zbw_shallowCopy;


/**
 深拷贝

 @return 拷贝对象
 */
- (id)zbw_deepCopy;

@end
