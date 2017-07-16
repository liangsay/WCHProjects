//
//  NSObject+Category.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)

#pragma mark - 打印
/**
 *  打印属性到控制台
 */
- (void)printProperties;

/**
 *  打印本类及父类属性到控制台
 */
- (void)printPropertiesWithSuperClass;


#pragma mark - 取属性
/**
 *  取类属性列表
 */
+ (NSMutableArray *)propertyKeys;

/**
 *  递归取本类及父类属性
 */
+ (NSMutableArray *)propertyKeysWithSuperClass;

/**
 *  格式自身成字符串。若为空，则返回空串
 */
- (NSString *)toString;

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray *)modes;
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay;
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(id)anArgument;
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget;
@end
