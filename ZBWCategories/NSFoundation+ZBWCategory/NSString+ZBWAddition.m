//
//  NSString+ZBWAddition.m
//  Template
//
//  Created by Bowen on 16/7/11.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "NSString+ZBWAddition.h"

@implementation NSString (ZBWAddition)

- (NSString *)URLEncodedString
{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding);
}

- (NSString *)URLDecodedString
{
    return [self URLDecodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString *)URLDecodedStringWithCFStringEncoding:(CFStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)self, CFSTR(""), encoding);
}

- (NSString *)httpsUrl
{
    NSString *urlStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (urlStr.length == 0) {
        return @"";
    }
    if ([urlStr hasPrefix:@"https://"]) {
        return urlStr;
    }
    if ([urlStr hasPrefix:@"http://"]) {
        return [urlStr stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"https:"];
    }
    if ([urlStr rangeOfString:@"://"].location == NSNotFound) {
        return [NSString stringWithFormat:@"https://%@", urlStr];
    }
    return urlStr;
}

+ (NSDictionary*)urlQueryDictionary:(NSURL*)url{
    NSMutableDictionary *mute = @{}.mutableCopy;
    
    NSString *absoluteString = url.absoluteString;
    NSString *queryStr = nil;
    
    // query
    NSRange queryRange = [absoluteString rangeOfString:@"?"];
    // 路由
    NSRange routerRange = [absoluteString rangeOfString:@"#"];
        
    BOOL existQuery = queryRange.location != NSNotFound;
    BOOL existRouter = routerRange.location != NSNotFound;
    
    if (existQuery && existRouter) {
        queryStr = [absoluteString substringWithRange:NSMakeRange(queryRange.location + 1,
                                                               routerRange.location - queryRange.location - 1)];
    } else if (existQuery) {
        queryStr = [absoluteString substringFromIndex:queryRange.location + 1];
    }
    if (queryStr.length == 0) {
        return nil;
    }
    
    for (NSString *query in [queryStr componentsSeparatedByString:@"&"]) {
        NSArray *components = [query componentsSeparatedByString:@"="];
        if (components.count == 0) {
            continue;
        }
        NSString *key = [components[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        id value = nil;
        if (components.count == 1) {
            value = @"";
        }
        if (components.count == 2) {
            value = [components[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            value = [value length] ? value : @"";
        }
        if (components.count > 2) {
            continue;
        }
        mute[key] = value ?: @"";
    }
    return mute.count ? mute.copy : nil;
}

+ (NSString *)zbwUrl_queryString:(NSDictionary *)params {
    if (!params || params.allKeys.count == 0) {
        return @"";
    }
    NSMutableString *str = [NSMutableString string];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![key isKindOfClass:NSString.class] || ![obj isKindOfClass:NSString.class] ) {
            return;
        }
        if (str.length > 0) {
            [str appendString:@"&"];
        }
        [str appendString:key];
        [str appendString:@"="];
        [str appendString:[obj URLEncodedString]];
    }];
    
    return str;
}

+ (NSString *)zbwUrl_urlWithQuery:(NSDictionary *)params sourceUrl:(NSURL *)url cleanOldParams:(BOOL)cleanOldParams {
    if (!url) {
        return nil;
    }
    
    NSString *absoluteString = url.absoluteString;
    // query
    NSRange queryRange = [absoluteString rangeOfString:@"?"];
    // 路由
    NSRange routerRange = [absoluteString rangeOfString:@"#"];
    
    NSString *urlWithoutQuery = absoluteString;
    NSString *routerPath = nil;
    NSString *query = nil;
    
    BOOL existQuery = queryRange.location != NSNotFound;
    BOOL existRouter = routerRange.location != NSNotFound;
    
    
    if (existQuery && existRouter) {
        urlWithoutQuery = [absoluteString substringToIndex:queryRange.location];
        query = [absoluteString substringWithRange:NSMakeRange(queryRange.location + 1,
                                                               routerRange.location - queryRange.location - 1)];
        routerPath = [absoluteString substringFromIndex:routerRange.location];
    } else if (existQuery) {
        urlWithoutQuery = [absoluteString substringToIndex:queryRange.location];
        query = [absoluteString substringFromIndex:queryRange.location + 1];
    } else if (existRouter) {
        urlWithoutQuery = [absoluteString substringToIndex:routerRange.location];
        routerPath = [absoluteString substringFromIndex:routerRange.location];
    }
    
    if (cleanOldParams) {
        NSString *paramsStr = [self zbwUrl_queryString:params];
        return [NSString stringWithFormat:@"%@?%@%@",
                urlWithoutQuery,
                paramsStr,
                routerPath.length > 0 ? routerPath : @""];
    } else {
        NSDictionary *dic = [self urlQueryDictionary:url];
        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
        if (dic) {
            [newDic addEntriesFromDictionary:dic];
        }
        if (params) {
            [newDic addEntriesFromDictionary:params];
        }
    
        NSString *paramsStr = [self zbwUrl_queryString:newDic];
        return [NSString stringWithFormat:@"%@?%@%@",
                urlWithoutQuery,
                paramsStr,
                routerPath.length > 0 ? routerPath : @""];
    }
}

+ (BOOL)isSame:(NSString *)str1 with:(NSString *)str2 {
    if (str1 == str2) {
        return YES;
    }
    
    if (![str1 isKindOfClass:[NSString class]] || ![str2 isKindOfClass:NSString.class]) {
        return NO;
    }
    
    return [str1 isEqualToString:str2];
}

@end


@implementation NSString (Empty)

+ (BOOL)checkEmpty:(NSString *)string;
{
    if (string == nil) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end

@implementation NSString (HTMLEntities)

- (NSString *)stringByDecodingHTMLEntities {
    NSUInteger myLength = [self length];
    NSUInteger ampIndex = [self rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return self;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:self];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&nbsp;" intoString:NULL])
            [result appendString:@" "];
        else if ([scanner scanString:@"&cap;" intoString:NULL])
            [result appendString:@"∩"];
        else if ([scanner scanString:@"&middot;" intoString:NULL])
            [result appendString:@"·"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                //[scanner scanUpToString:@";" intoString:&unknownEntity];
                //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
            }
            
        }
        else {
            NSString *amp;
            //an isolated & symbol
            [scanner scanString:@"&" intoString:&amp];
            [result appendString:amp];
        }
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}

@end


@implementation NSString (ZBWRegular)
+ (BOOL)zbw_validateStr:(NSString *)str regPattern:(NSString *)pattern {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL match = [predicate evaluateWithObject:str];
    
    return match;
}
@end
