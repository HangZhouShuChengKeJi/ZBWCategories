//
//  NSData+ZBWAddition.h
//  ZBWCategories
//
//  Created by Bowen on 2019/6/23.
//  Copyright © 2019年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSData (ZBWAddition_Base64)

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;
- (NSString *)base64EncodedStringWithoutLinebreak;

@end
