//
//  NSObject+NSCoding.m
//  Template
//
//  Created by Bowen on 15/9/11.
//  Copyright (c) 2015年 Bowen. All rights reserved.
//

#import "NSObject+NSCoding.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ZBWObjectForAutoCoding : NSObject
@end
@implementation ZBWObjectForAutoCoding

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [NSObject class];
        // 实现NSCoding协议
        class_addProtocol(aClass, @protocol(NSCoding));
        
        IMP imp = imp_implementationWithBlock(^(id obj, NSCoder *coder){
            [obj zbw_autoEncodeWithCoder:coder];
        });
        
        if (!class_addMethod(aClass, @selector(encodeWithCoder:), imp, "V@:@")){
            class_replaceMethod(aClass, @selector(encodeWithCoder:), imp, "V@:@");
        }
        
        imp = imp_implementationWithBlock((id)^(id obj, NSCoder *decoder){
            Class aClass = object_getClass(obj);
            struct objc_super superClazz = {
                .receiver = obj,
                .super_class = class_getSuperclass(aClass)
            };
            
            obj = ((id(*)(void *,SEL))objc_msgSendSuper)(&superClazz, @selector(init));
            [obj zbw_autoDecodeWithCoder:decoder];
            return obj;
        });
        if (!class_addMethod(aClass, @selector(initWithCoder:), imp, "@@:@")) {
            class_replaceMethod(aClass, @selector(initWithCoder:), imp, "@@:@");
        }
    });
}

@end

@implementation NSObject (ZBWNSCoding)

#define zbw_msgSend_Getter(returnType, getterSEL) ((returnType (*) (id, SEL))objc_msgSend)(self, getterSEL)
#define zbw_msgSend_Setter(setterSEL, valueType, value) ((void (*) (id, SEL, valueType))objc_msgSend)(self, setterSEL, (valueType)value)

- (void)zbw_autoEncodeWithCoder:(NSCoder *)encoder
{
    NSArray *currentPropertyList = [self.class zbwOP_propertyList];
    [currentPropertyList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZBWProperty *property = (ZBWProperty *)obj;
        NSString *name = property.name;
        ZBWOPType type = property.valueType;
        
        SEL getter = NSSelectorFromString(name);
        
        switch (type)
        {
            case ZBWOPTypeChar:
            {
                BOOL value = zbw_msgSend_Getter(BOOL, getter);
                [encoder encodeBool:value forKey:name];
            }
                break;
            case ZBWOPTypeInt:
            {
                int value = zbw_msgSend_Getter(int, getter);
                [encoder encodeInt:value forKey:name];
            }
                break;
            case ZBWOPTypeShort:
            {
                short value = zbw_msgSend_Getter(short, getter);
                [encoder encodeInt:value forKey:name];
            }
                break;
            case ZBWOPTypeLong:
            {
                long value = zbw_msgSend_Getter(long, getter);
                [encoder encodeInteger:value forKey:name];
            }
                break;
            case ZBWOPTypeLongLong:
            {
                long long value = zbw_msgSend_Getter(long long, getter);
                [encoder encodeInteger:(NSInteger)value forKey:name];
            }
                break;
            case ZBWOPTypeUnsignedChar:
            {
                unsigned char value = zbw_msgSend_Getter(unsigned char, getter);
                [encoder encodeInt:value forKey:name];
            }
                break;
            case ZBWOPTypeUnsignedInt:
            {
                unsigned int value = zbw_msgSend_Getter(unsigned int, getter);
                [encoder encodeInteger:value forKey:name];
            }
                break;
            case ZBWOPTypeUnsignedShort:
            {
                unsigned short value = zbw_msgSend_Getter(unsigned short, getter);
                [encoder encodeInteger:value forKey:name];
            }
                break;
            case ZBWOPTypeUnsignedLong:
            {
                unsigned long value = zbw_msgSend_Getter(unsigned long, getter);
                [encoder encodeInteger:value forKey:name];
            }
                break;
            case ZBWOPTypeUnsignedLongLong:
            {
                unsigned long long value = zbw_msgSend_Getter(unsigned long long, getter);
                [encoder encodeInteger:(NSInteger)value forKey:name];
            }
                break;
            case ZBWOPTypeFloat:
            {
                float value = zbw_msgSend_Getter(float, getter);
                [encoder encodeFloat:value forKey:name];
            }
                break;
            case ZBWOPTypeDouble:
            {
                double value = zbw_msgSend_Getter(double, getter);
                [encoder encodeDouble:value forKey:name];
            }
                break;
            case ZBWOPTypeBool:
            {
                BOOL value = zbw_msgSend_Getter(BOOL, getter);
                [encoder encodeBool:value forKey:name];
            }
                break;
            case ZBWOPTypeVoid:
                break;
            case ZBWOPTypeCharString:
            {
                char * value = zbw_msgSend_Getter(char *, getter);
                [encoder encodeBytes:(uint8_t *)value length:strlen(value) forKey:name];
            }
                break;
            case ZBWOPTypeObject:
            {
                if ([property.objectClass conformsToProtocol:@protocol(NSCoding)])
                {
                    id value = zbw_msgSend_Getter(id, getter);
                    [encoder encodeObject:value forKey:name];
                }
            }
                break;
            case ZBWOPTypeClassObject:
                break;
            case ZBWOPTypeSelector:
                break;
            case ZBWOPTypeArray:
                break;
            case ZBWOPTypeStruct:
                break;
            case ZBWOPTypeUnion:
                break;
            case ZBWOPTypeBitField:
                break;
            case ZBWOPTypePointer:
                break;
            case ZBWOPTypeUnknow:
                break;
                
            default:
                break;
        }
        
    }];
}

+ (NSString *)getSetMethodName:(NSString *)propertyName
{
    if ([propertyName length] == 0)
        return @"";
    
    NSString *firstChar = [propertyName substringToIndex:1];
    firstChar = [firstChar uppercaseString];
    NSString *lastName = [propertyName substringFromIndex:1];
    return [NSString stringWithFormat:@"set%@%@:", firstChar, lastName];
}

- (void)zbw_autoDecodeWithCoder:(NSCoder *)decoder
{
    NSArray *currentPropertyList = [self.class zbwOP_propertyList];
    [currentPropertyList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZBWProperty *property = (ZBWProperty *)obj;
        NSString *name = property.name;
        ZBWOPType type = property.valueType;
        if (property.isReadonly)
        {
            return ;
        }
        SEL setter = NSSelectorFromString([NSObject getSetMethodName:name]);
        
        switch (type)
        {
            case ZBWOPTypeChar:
            {
                BOOL value = [decoder decodeBoolForKey:name];
                zbw_msgSend_Setter(setter, BOOL, value);
            }
                break;
            case ZBWOPTypeInt:
            {
                int value = [decoder decodeIntForKey:name];
                zbw_msgSend_Setter(setter, int, value);
            }
                break;
            case ZBWOPTypeShort:
            {
                short value = [decoder decodeIntForKey:name];
                zbw_msgSend_Setter(setter, int, value);
            }
                break;
            case ZBWOPTypeLong:
            {
                long value = value = [decoder decodeIntegerForKey:name];
                zbw_msgSend_Setter(setter, NSInteger, value);
            }
                break;
            case ZBWOPTypeLongLong:
            {
                long long value = [decoder decodeIntegerForKey:name];
                zbw_msgSend_Setter(setter, NSInteger, value);
            }
                break;
            case ZBWOPTypeUnsignedChar:
            {
                unsigned char value = [decoder decodeIntForKey:name];
                zbw_msgSend_Setter(setter, unsigned char, value);
            }
                break;
            case ZBWOPTypeUnsignedInt:
            {
                NSInteger value = [decoder decodeIntegerForKey:name];
                zbw_msgSend_Setter(setter, unsigned int, value);
            }
                break;
            case ZBWOPTypeUnsignedShort:
            {
                unsigned short value = [decoder decodeIntegerForKey:name];
                zbw_msgSend_Setter(setter, unsigned short, value);
            }
                break;
            case ZBWOPTypeUnsignedLong:
            {
                unsigned long value = [decoder decodeIntegerForKey:name];
                zbw_msgSend_Setter(setter, unsigned long, value);
            }
                break;
            case ZBWOPTypeUnsignedLongLong:
            {
                unsigned long long value = [decoder decodeIntegerForKey:name];
                zbw_msgSend_Setter(setter, unsigned long long, value);
            }
                break;
            case ZBWOPTypeFloat:
            {
                float value = [decoder decodeFloatForKey:name];
                zbw_msgSend_Setter(setter, float, value);
            }
                break;
            case ZBWOPTypeDouble:
            {
                double value = [decoder decodeDoubleForKey:name];
                zbw_msgSend_Setter(setter, double, value);
            }
                break;
            case ZBWOPTypeBool:
            {
                BOOL value = [decoder decodeBoolForKey:name];
                zbw_msgSend_Setter(setter, BOOL, value);
            }
                break;
            case ZBWOPTypeVoid:
                break;
            case ZBWOPTypeCharString:
            {
                const unsigned char * value = [decoder decodeBytesForKey:name returnedLength:NULL];
                zbw_msgSend_Setter(setter, char *, value);
            }
                break;
            case ZBWOPTypeObject:
            {
                if ([property.objectClass conformsToProtocol:@protocol(NSCoding)])
                {
                    id value = [decoder decodeObjectForKey:name];
                    [self setValue:value forKey:name];
                }
            }
                break;
            case ZBWOPTypeClassObject:
                break;
            case ZBWOPTypeSelector:
                break;
            case ZBWOPTypeArray:
                break;
            case ZBWOPTypeStruct:
                break;
            case ZBWOPTypeUnion:
                break;
            case ZBWOPTypeBitField:
                break;
            case ZBWOPTypePointer:
                break;
            case ZBWOPTypeUnknow:
                break;
                
            default:
                break;
        }
        
    }];
}

@end
