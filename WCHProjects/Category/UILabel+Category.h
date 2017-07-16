//
//  UILabel+Category.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)

/**
 *  @author King, 15-06-15 11:06:48
 *
 *  获取Label的Size
 *
 *  @param text    <#text description#>
 *  @param font    <#font description#>
 *  @param maxSize <#maxSize description#>
 *
 *  @return <#return value description#>
 */
- (CGSize )sizeOfStringWithMaxHeight:(CGFloat)maxHeight;


/**
 *  设置背景颜色、字体颜色、字体大小、文字对齐方式
 */
- (void)setTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment;

/**
 *  背景颜色、字体颜色、字体大小、文字对齐方式
 */
+ (instancetype)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment;

/**
 *  position、背景颜色、字体颜色、字体大小、文字对齐方式
 */
+ (instancetype)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment position:(CGPoint)position;

/**
 *  size、背景颜色、字体颜色、字体大小、文字对齐方式
 */
+ (instancetype)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment size:(CGSize)size;

/**
 *  frame、背景颜色、字体颜色、字体大小、文字对齐方式
 */
+ (instancetype)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment frame:(CGRect)frame;

#pragma mark --attributedText处理
/*!
 *  @author liujinliang, 16-02-19 14:02:46
 *
 *  @brief attributedText处理
 *
 *  @param value1 <#value1 description#>
 *  @param value2 <#value2 description#>
 *
 *  @since <#version number#>
 */
- (void)labWithAttributedText:(NSString *)value1 value2:(NSString *)value2;

#pragma mark --获取文本的Size
/*!
 *  @author liujinliang, 16-02-22 14:02:03
 *
 *  @brief 获取size
 *
 *  @param size       <#size description#>
 *  @param options    <#options description#>
 *  @param attributes <#attributes description#>
 *  @param context    <#context description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (CGSize )getSizeBoundingRectWithSize:(CGSize)size
                               options:(NSStringDrawingOptions)options
                            attributes:(NSMutableDictionary *)attributes
                               context:(NSStringDrawingContext*)context;
@end
