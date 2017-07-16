//
//  UIButton+Category.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliangcom.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, UIButtonLayoutType)
{
    UIButtonLayoutTypeLeftTitleRightImage = 0,
};

@interface UIButton (Category)

/**
 *  赋值
 */
- (void)setTitleFontSize:(CGFloat)fontSize color:(UIColor *)color title:(NSString *)title;
/**
 *  赋值
 */
- (void)setNormalHighlightedFont:(UIFont *)font color:(UIColor *)color;

/**
 *  赋值
 */
- (void)setNormalHighlightedTitle:(NSString *)title;

/**
 *  赋值
 */
- (void)setNormalHighlightedImage:(UIImage *)image;

/**
 *  赋值
 */
- (void)setNormalHighlightedImageName:(NSString *)imageName;

/**
 *  用给定的颜色来创建背景图片
 */
@property (nonatomic) UIColor *backgroundImageColor;

/**
 *  用给定的颜色来创建背景图片
 */
- (void)setBackgroundImageColor:(UIColor *)backgroundImageColor forState:(UIControlState)state;

/**
 *  用给定的颜色来创建背景图片
 */
- (UIColor *)backgroundImageColorForState:(UIControlState)state;

/**
 *  设背景透明
 */
- (void)setBackgroundColorAndImageClear;

/**
 *  调整布局
 *  @param type      布局类型
 *  @param midSpace  图片和文字的中间间距
 *  @param sizeToFit 是否调用sizeToFit方法
 */
- (void)adjustLayoutWithType:(UIButtonLayoutType)type midSpace:(CGFloat)midSpace sizeToFit:(BOOL)sizeToFit;

- (void)setButtonRadiu:(CGFloat)radius border:(CGFloat)border color:(UIColor *)color;

- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;
- (void)centerImageAndButton:(CGFloat)gap imageOnTop:(BOOL)imageOnTop;

#pragma mark --左文右字
/**
 *  左文右图
 */
- (void)setLeftTitleAndRightImage;
- (void)setLeftTitleAndRightImage:(CGFloat)padding;
/**
 *  @author King, 15-05-16 10:05:51
 *
 *  在btn上面添加向右箭头
 */
- (void)addRightImageView;

#pragma mark - button倒计时
- (void)setTheCountdownButton:(UIButton *)button startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;
@end
