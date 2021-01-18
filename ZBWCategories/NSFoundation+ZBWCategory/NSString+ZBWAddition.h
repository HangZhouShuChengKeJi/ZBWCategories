//
//  NSString+ZBWAddition.h
//  Template
//
//  Created by Bowen on 16/7/11.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZBWAddition)

- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
- (NSString *)URLDecodedString;
- (NSString *)URLDecodedStringWithCFStringEncoding:(CFStringEncoding)encoding;

- (NSString *)httpsUrl;

+ (NSDictionary*)urlQueryDictionary:(NSURL*)url;

+ (NSString *)zbwUrl_queryString:(NSDictionary *)params;

+ (NSString *)zbwUrl_urlWithQuery:(NSDictionary *)params sourceUrl:(NSURL *)url cleanOldParams:(BOOL)cleanOldParams;


+ (BOOL)isSame:(NSString*)str1 with:(NSString*)str2;

@end


@interface NSString (Empty)

+ (BOOL)checkEmpty:(NSString *)string;

@end


@interface NSString (HTMLEntities)

- (NSString *)stringByDecodingHTMLEntities;

@end

@interface NSString (ZBWRegular)

+ (BOOL)zbw_validateStr:(NSString *)str regPattern:(NSString *)pattern;

@end

