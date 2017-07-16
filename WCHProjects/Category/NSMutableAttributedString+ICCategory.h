//
//  NSMutableAttributedString+ICCategory.h
//  ICLibraryProject
//
//  Created by Fox on 13-8-28.
//  Copyright (c) 2013年 iChance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

/**
 * For easier formatting of NSAttributedString.
 *
 * Most of these methods are called directly from NIAttributedLabel. Normally you should
 * not have to call these methods directly. Have a look at NIAttributedLabel first, it's most
 * likely what you are after.
 */
@interface NSMutableAttributedString (ICCategory)

/**
 * Sets the text alignment and the line break mode for a given range.
 *
 * TextAlignment Values:
 * - kCTLeftTextAlignment
 * - kCTCenterTextAlignment
 * - kCTRightTextAlignment
 * - kCTJustifiedTextAlignment
 * - kCTNaturalTextAlignment
 *
 * LineBreakMode Values
 * - kCTLineBreakByWordWrapping
 * - kCTLineBreakByCharWrapping
 * - kCTLineBreakByClipping
 * - kCTLineBreakByTruncatingHead
 * - kCTLineBreakByTruncatingTail
 * _ kCTLineBreakByTruncatingMiddle
 */
-(void) setTextAlignment:(CTTextAlignment)textAlignment
           lineBreakMode:(CTLineBreakMode)lineBreakMode
                   range:(NSRange)range;


/**
 * Sets the text alignment and the line break mode for the whole string.
 *
 * TextAlignment Values:
 * - kCTLeftTextAlignment
 * - kCTCenterTextAlignment
 * - kCTRightTextAlignment
 * - kCTJustifiedTextAlignment
 * - kCTNaturalTextAlignment
 *
 * LineBreakMode Values
 * - kCTLineBreakByWordWrapping
 * - kCTLineBreakByCharWrapping
 * - kCTLineBreakByClipping
 * - kCTLineBreakByTruncatingHead
 * - kCTLineBreakByTruncatingTail
 * _ kCTLineBreakByTruncatingMiddle
 
 */
-(void) setTextAlignment:(CTTextAlignment)textAlignment
           lineBreakMode:(CTLineBreakMode)lineBreakMode;

#pragma mark --设置文本样式风格
/*!
 *  @author liujinliang, 16-02-22 14:02:19
 *
 *  @brief 设置文本样式风格
 *
 *  @param textAlignment          NSTextAlignmentLeft;//对齐方式
 *  @param lineBreakMode          行模式
 *  @param lineSpacing            增加行高
 *  @param headIndent             头部缩进，相当于左padding
 *  @param tailIndent             相当于右padding
 *  @param lineHeightMultiple     行间距是多少倍
 *  @param firstLineHeadIndent    首行头缩进
 *  @param paragraphSpacing       段落后面的间距
 *  @param paragraphSpacingBefore 段落之前的间距
 *
 *  @since <#version number#>
 */
- (void) setTextAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode
              lineSpacing:(CGFloat)lineSpacing
               headIndent:(CGFloat)headIndent
               tailIndent:(CGFloat)tailIndent
       lineHeightMultiple:(CGFloat)lineHeightMultiple
      firstLineHeadIndent:(CGFloat)firstLineHeadIndent
         paragraphSpacing:(CGFloat)paragraphSpacing
   paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore;

#pragma mark --设置文本样式风格 增加行高 行间距是多少倍
/*!
 *  @author liujinliang, 16-02-22 14:02:32
 *
 *  @brief 设置文本样式风格 增加行高 行间距是多少倍
 *
 *  @param textAlignment      <#textAlignment description#>
 *  @param lineBreakMode      <#lineBreakMode description#>
 *  @param lineSpacing        增加行高
 *  @param lineHeightMultiple 行间距是多少倍
 *
 *  @since <#version number#>
 */
- (void) setTextAlignment:(NSTextAlignment)textAlignment
            lineBreakMode:(NSLineBreakMode)lineBreakMode
              lineSpacing:(CGFloat)lineSpacing
       lineHeightMultiple:(CGFloat)lineHeightMultiple;

#pragma mark --设置文本样式风格 range
/*!
 *  @author liujinliang, 16-02-22 14:02:19
 *
 *  @brief 设置文本样式风格
 *
 *  @param textAlignment          NSTextAlignmentLeft;//对齐方式
 *  @param lineBreakMode          行模式
 *  @param lineSpacing            增加行高
 *  @param headIndent             头部缩进，相当于左padding
 *  @param tailIndent             相当于右padding
 *  @param lineHeightMultiple     行间距是多少倍
 *  @param firstLineHeadIndent    首行头缩进
 *  @param paragraphSpacing       段落后面的间距
 *  @param paragraphSpacingBefore 段落之前的间距
 *  @param range                  指定区间
 *
 *  @since <#version number#>
 */
- (void) setTextAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode
              lineSpacing:(CGFloat)lineSpacing
               headIndent:(CGFloat)headIndent
               tailIndent:(CGFloat)tailIndent
       lineHeightMultiple:(CGFloat)lineHeightMultiple
      firstLineHeadIndent:(CGFloat)firstLineHeadIndent
         paragraphSpacing:(CGFloat)paragraphSpacing
   paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore
                    range:(NSRange)range;

#pragma mark --设置区间式格式
/*!
 * @author  liujinliang
 *
 * @brief   设置区间式格式
 *
 */
- (void)setTextWithRange:(NSRange)range
               textColor:(UIColor *)textColor textFont:(UIFont *)textFont;
/*!
 * @author  liujinliang
 *
 * @brief   设置区间式格式
 *
 */
- (void)setTextWithRange1:(NSRange)range1
               text1Color:(UIColor *)text1Color text1Font:(UIFont *)text1Font
                   range2:(NSRange)range2
               text2Color:(UIColor *)text2Color text2Font:(UIFont *)text2Font;

/**
 * Sets the text color for a given range.
 */
-(void) setTextColor:(UIColor*)color range:(NSRange)range;

/**
 * Sets the text color for the whole string.
 */
-(void) setTextColor:(UIColor*)color;

/**
 * Sets the font for a given range.
 */
-(void) setFont:(UIFont*)font range:(NSRange)range;

/**
 * Sets the font for the whole string.
 */
-(void) setFont:(UIFont*)font;

#pragma mark --//下划线 //厚的下划线
/**
 * Sets the underline style and modifier for a given range.
 *
 * Style Values:
 * - kCTUnderlineStyleNone
 * - kCTUnderlineStyleSingle
 * - kCTUnderlineStyleThick
 * - kCTUnderlineStyleDouble
 *
 * Modifier Values:
 * - kCTUnderlinePatternSolid
 * - kCTUnderlinePatternDot
 * - kCTUnderlinePatternDash
 * - kCTUnderlinePatternDashDot
 * - kCTUnderlinePatternDashDotDot
 */
-(void) setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range;

/**
 * Sets the underline style and modifier for the whole string.
 *
 * Style Values:
 * - kCTUnderlineStyleNone
 * - kCTUnderlineStyleSingle
 * - kCTUnderlineStyleThick
 * - kCTUnderlineStyleDouble
 *
 * Modifier Values:
 * - kCTUnderlinePatternSolid
 * - kCTUnderlinePatternDot
 * - kCTUnderlinePatternDash
 * - kCTUnderlinePatternDashDot
 * - kCTUnderlinePatternDashDotDot
 */
-(void) setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier;

#pragma mark --设置文字描边颜色，需要和NSStrokeWidthAttributeName设置描边宽度，这样就能使文字空心
/**
 * Sets the stroke width for a given range.
 */
-(void) setStrokeWidth:(CGFloat)width range:(NSRange)range;

/**
 * Sets the stroke width for the whole string.
 */
-(void) setStrokeWidth:(CGFloat)width;

/**
 * Sets the stroke color for a given range.
 */
-(void) setStrokeColor:(UIColor*)color range:(NSRange)range;

/**
 * Sets the stroke color for the whole string.
 */
-(void) setStrokeColor:(UIColor*)color;

#pragma mark -- 字符间距

/**
 * Sets the text kern for a given range.
 */
-(void) setKern:(CGFloat)kern range:(NSRange)range;

/**
 * Sets the text kern for the whole string.
 */
-(void) setKern:(CGFloat)kern;


@end
