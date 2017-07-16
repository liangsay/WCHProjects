//
//  UIColor+Category.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

#pragma mark - 计算色值
/**
 *  传入十六进制值，以0x开头
 */
+ (instancetype)hexValue:(NSInteger)hexValue;

/**
 *  传入十进制的红绿蓝三色值
 */
+ (instancetype)red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

#pragma mark - 背景颜色
/**
 *  页面背景色f5f5f5
 */
+ (instancetype)backgroundColor;

#pragma mark - 轻灰背景颜色
/**
 *  页面背景色eeeeee
 */
+ (instancetype)backgroundLightColor;

#pragma mark - 亮灰背景颜色
/**
 *  页面背景色f8f8f8
 */
+ (instancetype)backgroundNormalColor;

/**
 *  行头背景颜色
 */
+ (instancetype)sectionbgColor;

/**
 *  主颜色，红色ec2355
 */
+ (instancetype)mainColor;

/**
 *  主颜色，红色ec2355
 */
+ (instancetype)mainSecondColor;

/**
 *  分隔线，边框dddddd
 */
+ (instancetype)borderColor;

#pragma mark - 文字颜色
/**
 *  文字,黑色4c4948
 */
+ (instancetype)fontBlack;

/**
 *  文字,灰色8b8b8b
 */
+ (instancetype)fontGray;

/*!
 *  @author liujinliang, 16-03-15 16:03:30
 *
 *  @brief 红色
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (instancetype)redColor;

/**
 *  文字,灰色0xababab
 */
+ (instancetype)fontSecondGray;
/**
 *  文字,黑色0x737373
 */
+ (instancetype)fontSecondBlack;

/**
 *  文字,浅灰cccccc
 */
+ (instancetype)fontLightGray;

/**
 *  文字,链接dc2e24
 价格颜色
 */
+ (instancetype)priceColor;

#pragma mark --文字,火ec5159
/**
 *  文字,火ec5159
 */
+ (instancetype)huoColor;
#pragma mark --文字,团efab0d
/**
 *  文字,团ec5159
 */
+ (instancetype)sunColor;
#pragma mark --文字,笋5ac7d4
/**
 *  文字,笋5ac7d4
 */
+ (instancetype)tuanColor;

#pragma mark - 按钮颜色
/**
 *  按钮,普通状态ec2355
 */
+ (instancetype)buttonNormal;

/**
 *  按钮,高亮状态d41f4c
 */
+ (instancetype)buttonHighlight;

/**
 *  按钮,不可点击cccccc
 */
+ (instancetype)buttonDisable;

/**
 *  文本默认内容颜色848a9e
 */
+ (instancetype)placeholderColor;

/**
 *  按钮shenhuise 343e61
 */
+ (instancetype)btnDarkGrayColor;

/**
 *  按钮确认红色 da1f28
 */
+ (instancetype)btnSureRedColor;

/**
 *  圈红色 cc3228
 */
+ (instancetype)circleRedColor;

/**
 *  圈红色 890300
 */
+ (instancetype)circleDarkRedColor;
/**
 *  浅深灰色 848a9e
 */
+ (instancetype)color848ae;
/**
 *  底部工具栏背景颜色
 */
+ (instancetype)tabBgColor;
@end
