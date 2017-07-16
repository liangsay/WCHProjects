//
//  UIColor+Category.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

#pragma mark - 计算色值
/**
 *  传入十六进制值，以0x开头
 */
+ (instancetype)hexValue:(NSInteger)hexValue
{
    return [UIColor colorWithRed:(((hexValue) & 0xFF0000) >> 16) / 255.0 green:(((hexValue) & 0xFF00) >> 8) / 255.0 blue:(((hexValue) & 0xFF)) / 255.0 alpha:1.0];
}

/**
 *  传入十进制的红绿蓝三色值
 */
+ (instancetype)red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

#pragma mark - 背景颜色
/**
 *  页面背景色efefef
 */
+ (instancetype)backgroundColor
{
    return [self hexValue:0xefefef];
}

#pragma mark - 轻灰背景颜色
/**
 *  页面背景色eeeeee
 */
+ (instancetype)backgroundLightColor
{
    return [self hexValue:0xeeeeee];
}

#pragma mark - 亮灰背景颜色
/**
 *  页面背景色f8f8f8
 */
+ (instancetype)backgroundNormalColor
{
    return [self hexValue:0xf8f8f8];
}

/**
 *  行头背景颜色
 */
+ (instancetype)sectionbgColor
{
    return [self hexValue:0xe6e6e6];
}
/**
 *  主颜色，5ac9d3
 */
+ (instancetype)mainColor
{
    return [self hexValue:0x008cec];
}

/**
 *  主颜色，深
 */
+ (instancetype)mainSecondColor {
    return [self hexValue:0x1eb6c4];
}

/*!
 *  @author liujinliang, 16-03-15 16:03:30
 *
 *  @brief 红色
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (instancetype)redColor {
    return [self hexValue:0xf14848];
}
/**
 *  分隔线c8c8c8
 */
+ (instancetype)borderColor
{
    return [self hexValue:0xc8c8c8];
}

#pragma mark - 文字颜色
/**
 *  文字,黑色242128
 */
+ (instancetype)fontBlack
{
    return [self hexValue:0x242128];
}

/**
 *  文字,黑色0x737373
 */
+ (instancetype)fontSecondBlack
{
    return [self hexValue:0x737373];
}

/**
 *  文字,灰色0x737373
 */
+ (instancetype)fontGray
{
    return [self hexValue:0x737373];
}

/**
 *  文字,灰色0xababab
 */
+ (instancetype)fontSecondGray
{
    return [self hexValue:0xababab];
}

/**
 *  文字,浅灰ababab
 */
+ (instancetype)fontLightGray
{
    return [self hexValue:0xababab];
}

/**
 *  文字,链接cd141c
 价格颜色
 */
+ (instancetype)priceColor
{
    return [self hexValue:0xcb151a];
}

#pragma mark --文字,火ec5159
/**
 *  文字,火ec5159
 */
+ (instancetype)huoColor
{
    return [self hexValue:0xed525a];
}

#pragma mark --文字,团efab0d
/**
 *  文字,团ec5159
 */
+ (instancetype)tuanColor
{
    return [self hexValue:0xedad0d];
}

#pragma mark --文字,笋5ac7d4
/**
 *  文字,笋5ac7d4
 */
+ (instancetype)sunColor
{
    return [self hexValue:0x5bccd4];
}

#pragma mark - 按钮颜色
/**
 *  按钮,普通状态ec2355
 */
+ (instancetype)buttonNormal
{
    return [self hexValue:0xec2355];
}

/**
 *  按钮,高亮状态d41f4c
 */
+ (instancetype)buttonHighlight
{
    return [self hexValue:0xd41f4c];
}

/**
 *  按钮,不可点击cccccc
 */
+ (instancetype)buttonDisable
{
    return [self hexValue:0xcccccc];
}

/**
 *  文本默认内容颜色848a9e
 */
+ (instancetype)placeholderColor{
    return [self hexValue:0x848a9e];
}

/**
 *  按钮shenhuise 343e61
 */
+ (instancetype)btnDarkGrayColor
{
    return [self hexValue:0x343e61];
}

/**
 *  按钮确认红色 da1f28
 */
+ (instancetype)btnSureRedColor{
    return [self hexValue:0xda1f28];
}

/**
 *  圈红色 cc3228
 */
+ (instancetype)circleRedColor{
    return [self hexValue:0xcc3228];
}

/**
 *  圈红色 890300
 */
+ (instancetype)circleDarkRedColor{
    return [self hexValue:0x890300];
}

/**
 *  浅深灰色 848a9e
 */
+ (instancetype)color848ae{
    return [self hexValue:0x848a9e];
}

/**
 *  底部工具栏背景颜色
 */
+ (instancetype)tabBgColor {
    return [self hexValue:0xf8f9fb];
}
@end
