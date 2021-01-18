//
//  UIButton+Block.h
//  testtest
//
//  Created by Bowen on 16/7/22.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton(ZBW_Block)

@property (nonatomic) dispatch_block_t  zbwClickCallback;

@end
