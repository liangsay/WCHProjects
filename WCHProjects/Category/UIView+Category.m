//
//  UIView+Category.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

#pragma mark - 坐标属性
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

#pragma mark - 创建实例
/**
 *  创建指定长度的横线，0.5px，用作分隔线
 *
 *  @param length 横线的长度
 */
+ (instancetype)horizontalLineWithLength:(CGFloat)length
{
    return [self horizontalLineWithLength:length color:[UIColor borderColor]];
}

/**
 *  创建指定长度的横线，0.5px，用作分隔线
 *
 *  @param length 横线的长度
 *  @param color  颜色
 */
+ (instancetype)horizontalLineWithLength:(CGFloat)length color:(UIColor *)color
{
    CGRect frame = CGRectMake(0, 0, length, 0.5);
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    return line;
}

/**
 *  创建指定长度的竖线，0.5px，用作分隔线
 *
 *  @param length 竖线的长度
 */
+ (instancetype)verticalLineWithLength:(CGFloat)length
{
    return [self verticalLineWithLength:length color:[UIColor borderColor]];
}

/**
 *  创建指定长度的竖线，0.5px，用作分隔线
 *
 *  @param length 竖线的长度
 *  @param color  颜色
 */
+ (instancetype)verticalLineWithLength:(CGFloat)length color:(UIColor *)color
{
    CGRect frame = CGRectMake(0, 0, 0.5, length);
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    return line;
}

#pragma mark - 设置Layer属性
/**
 *  设置圆角
 */
- (void)setLayerCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

/**
 *  设置圆角
 */
- (void)setLayerBorderWidth:(CGFloat)borderWidth color:(UIColor *)color
{
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
}

#pragma mark - 调试用
/**
 *  调试用，显示边框
 */
- (void)debugBorder
{
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.borderWidth = 1;
}

/**
 *  调试用，打印frame
 */
- (void)debugFrame
{
    NSLog(@"%@ debug frame:%@", [self class], NSStringFromCGRect(self.frame));
}

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
- (void)makeCallWithPhone:(NSString *)phome{
    NSString* numberAfterClear = [phome cleanPhoneNumber:phome];
    if (kIsStringEmpty(numberAfterClear)) {
        [NSString toast:@"拨打的电话号码不能为空"];
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",numberAfterClear];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",numberAfterClear];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    /*NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
    //NSLog(@"make call, URL=%@", phoneNumberURL);
    
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self addSubview:callWebview];*/
}


@end
