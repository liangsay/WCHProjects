//
//  UIView+Category.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

#pragma mark - 坐标属性
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

#pragma mark - 创建实例
/**
 *  创建指定长度的横线，0.5px，用作分隔线
 *
 *  @param length 横线的长度
 */
+ (instancetype)horizontalLineWithLength:(CGFloat)length;

/**
 *  创建指定长度的横线，0.5px，用作分隔线
 *
 *  @param length 横线的长度
 *  @param color  颜色
 */
+ (instancetype)horizontalLineWithLength:(CGFloat)length color:(UIColor *)color;

/**
 *  创建指定长度的竖线，0.5px，用作分隔线
 *
 *  @param length 竖线的长度
 */
+ (instancetype)verticalLineWithLength:(CGFloat)length;

/**
 *  创建指定长度的竖线，0.5px，用作分隔线
 *
 *  @param length 竖线的长度
 *  @param color  颜色
 */
+ (instancetype)verticalLineWithLength:(CGFloat)length color:(UIColor *)color;

#pragma mark - 设置Layer属性
/**
 *  设置圆角
 */
- (void)setLayerCornerRadius:(CGFloat)radius;

/**
 *  设置圆角
 */
- (void)setLayerBorderWidth:(CGFloat)borderWidth color:(UIColor *)color;

#pragma mark - 调试用
/**
 *  调试用，显示边框
 */
- (void)debugBorder;

/**
 *  调试用，打印frame
 */
- (void)debugFrame;


#pragma mark --拨打电话
/*!
 *  @author liujinliang, 15-12-15 09:12:09
 *
 *  @brief 拨打电话
 *
 *  @param phome <#phome description#>
 *
 *  @since <#version number#>
 */
- (void)makeCallWithPhone:(NSString *)phome;
@end
