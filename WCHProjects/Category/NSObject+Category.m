//
//  NSObject+Category.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>
@implementation NSObject (Category)

#pragma mark - 打印
/**
 *  打印属性到控制台
 */
- (void)printProperties
{
    NSMutableString *desc = [NSMutableString stringWithString:NSStringFromClass([self class])];
    
    NSArray *keys = [[self class] propertyKeys];
    if (!keys || keys.count == 0)
    {
        DLog(@"%@", desc);
        return;
    }
    
    for (NSString *key in keys)
    {
        [desc appendFormat:@"\n%@:%@", key, [self valueForKey:key]];
    }
    DLog(@"%@", desc);
}

/**
 *  打印本类及父类属性到控制台
 */
- (void)printPropertiesWithSuperClass
{
    NSMutableString *desc = [NSMutableString stringWithString:NSStringFromClass([self class])];
    
    NSArray *keys = [[self class] propertyKeysWithSuperClass];
    if (!keys || keys.count == 0)
    {
        DLog(@"%@", desc);
        return;
    }
    
    for (NSString *key in keys)
    {
        [desc appendFormat:@"\n%@:%@", key, [self valueForKey:key]];
    }
    DLog(@"%@", desc);
}

#pragma mark - 取属性
/**
 *  取类属性列表
 */
+ (NSMutableArray *)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}

/**
 *  递归取本类及父类属性
 */
+ (NSMutableArray *)propertyKeysWithSuperClass
{
    NSMutableArray *array = [self propertyKeys];
    
    Class clz = [self superclass];
    while (clz && clz != [NSObject class])
    {
        NSMutableArray *superArray = [clz propertyKeys];
        [superArray addObjectsFromArray:array];
        array = superArray;
        clz = [clz superclass];
    }
    return array;
}


/**
 *  格式自身成字符串。若为空，则返回空串
 */
- (NSString *)toString
{
    return [NSString stringWithFormat:@"%@", self == nil || self == [NSNull null] ? @"" : self];
}
@end
