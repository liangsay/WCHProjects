//
//  NSMutableAttributedString+ICCategory.m
//  ICLibraryProject
//
//  Created by Fox on 13-8-28.
//  Copyright (c) 2013年 iChance. All rights reserved.
//

#import "NSMutableAttributedString+ICCategory.h"

@implementation NSMutableAttributedString (ICCategory)

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark --设置风格
- (void) setTextAlignment:(CTTextAlignment)textAlignment
            lineBreakMode:(CTLineBreakMode)lineBreakMode
                    range:(NSRange)range {
    
/*    CTParagraphStyleSetting paragraphStyles[2] = {
		{.spec = NSParagraphStyleSpecifierAlignment,
            .valueSize = sizeof(CTTextAlignment),
            .value = (const void*)&textAlignment},
		{.spec = NSParagraphStyleSpecifierLineBreakMode,
            .valueSize = sizeof(CTLineBreakMode),
            .value = (const void*)&lineBreakMode},
	};
	CTParagraphStyleRef style = CTParagraphStyleCreate(paragraphStyles, 2);
    [self addAttribute:(NSString*)NSParagraphStyleAttributeName
                 value:(__bridge id)style
                 range:range];
    CFRelease(style);*/
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setTextAlignment:(CTTextAlignment)textAlignment
            lineBreakMode:(CTLineBreakMode)lineBreakMode {
    [self setTextAlignment:textAlignment
             lineBreakMode:lineBreakMode
                     range:NSMakeRange(0, [self length])];
}

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
   paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [self setTextAlignment:textAlignment lineBreakMode:lineBreakMode lineSpacing:lineSpacing headIndent:headIndent tailIndent:tailIndent lineHeightMultiple:lineHeightMultiple firstLineHeadIndent:firstLineHeadIndent paragraphSpacing:paragraphSpacing paragraphSpacingBefore:paragraphSpacingBefore range:(NSRange){0,self.length}];
    
}

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
       lineHeightMultiple:(CGFloat)lineHeightMultiple {
    [self setTextAlignment:textAlignment
             lineBreakMode:lineBreakMode
               lineSpacing:lineSpacing
                headIndent:0
                tailIndent:0
        lineHeightMultiple:lineHeightMultiple
       firstLineHeadIndent:0
          paragraphSpacing:0
    paragraphSpacingBefore:0
                     range:(NSRange){0,self.length}];
}

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
                    range:(NSRange)range{
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = lineBreakMode;
    style.lineSpacing = lineSpacing;//10;//增加行高
    style.headIndent = headIndent;// 10;//头部缩进，相当于左padding
    style.tailIndent = tailIndent;// -10;//相当于右padding
    style.lineHeightMultiple = lineHeightMultiple;// 1.5;//行间距是多少倍
    style.alignment = textAlignment;// NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = firstLineHeadIndent;// 20;//首行头缩进
    style.paragraphSpacing = paragraphSpacing;// 10;//段落后面的间距
    style.paragraphSpacingBefore = paragraphSpacingBefore;// 20;//段落之前的间距
    [self removeAttribute:NSParagraphStyleAttributeName range:range];
    [self addAttribute:NSParagraphStyleAttributeName value:style range:range];
}

#pragma mark --设置区间式格式

/*!
 * @author  liujinliang
 *
 * @brief   设置区间式格式
 *
 */
- (void)setTextWithRange:(NSRange)range
               textColor:(UIColor *)textColor textFont:(UIFont *)textFont {
    [self setTextAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByCharWrapping lineSpacing:0 headIndent:0 tailIndent:0 lineHeightMultiple:1.2 firstLineHeadIndent:0 paragraphSpacing:0 paragraphSpacingBefore:0];
    if(range.location!=NSNotFound){
        [self setTextColor:textColor range:range];
        [self setFont:textFont range:range];
    }
}

/*!
 * @author  liujinliang
 *
 * @brief   设置区间式格式
 *
 */
- (void)setTextWithRange1:(NSRange)range1
               text1Color:(UIColor *)text1Color text1Font:(UIFont *)text1Font
                   range2:(NSRange)range2
               text2Color:(UIColor *)text2Color text2Font:(UIFont *)text2Font {
    [self setTextAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByCharWrapping lineSpacing:0 headIndent:0 tailIndent:0 lineHeightMultiple:1.2 firstLineHeadIndent:0 paragraphSpacing:0 paragraphSpacingBefore:0];
    if(range1.location!=NSNotFound){
        [self setTextColor:text1Color range:range1];
        [self setFont:text1Font range:range1];
    }
    if(range2.location!=NSNotFound){
        [self setTextColor:text2Color range:range2];
        [self setFont:text2Font range:range2];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setTextColor:(UIColor*)color range:(NSRange)range {
    [self removeAttribute:(NSString*)NSForegroundColorAttributeName range:range];
	[self addAttribute:(NSString*)NSForegroundColorAttributeName
                 value:color
                 range:range];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setTextColor:(UIColor*)color {
    [self setTextColor:color range:NSMakeRange(0, [self length])];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFont:(UIFont*)font range:(NSRange)range {
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, nil);
    [self removeAttribute:(NSString*)NSFontAttributeName range:range];
	[self addAttribute:(NSString*)NSFontAttributeName value:(__bridge id)fontRef range:range];
	CFRelease(fontRef);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFont:(UIFont*)font {
    [self setFont:font range:NSMakeRange(0, [self length])];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark --//下划线 //厚的下划线
- (void) setUnderlineStyle:(CTUnderlineStyle)style
                  modifier:(CTUnderlineStyleModifiers)modifier
                     range:(NSRange)range {
    [self removeAttribute:(NSString*)NSUnderlineColorAttributeName range:range];
    [self addAttribute:(NSString*)NSUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:(style|modifier)]
                 range:range];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setUnderlineStyle:(CTUnderlineStyle)style
                  modifier:(CTUnderlineStyleModifiers)modifier {
    [self setUnderlineStyle:style
                   modifier:modifier
                      range:NSMakeRange(0, [self length])];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark --设置文字描边颜色，需要和NSStrokeWidthAttributeName设置描边宽度，这样就能使文字空心
- (void) setStrokeWidth:(CGFloat)width range:(NSRange)range {
    [self removeAttribute:(NSString*)NSStrokeWidthAttributeName range:range];
    [self addAttribute:(NSString*)NSStrokeWidthAttributeName
                 value:[NSNumber numberWithFloat:width]
                 range:range];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setStrokeWidth:(CGFloat)width {
    [self setStrokeWidth:width range:NSMakeRange(0, [self length])];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setStrokeColor:(UIColor *)color range:(NSRange)range {
    [self removeAttribute:(NSString*)NSStrokeColorAttributeName range:range];
    [self addAttribute:(NSString*)NSStrokeColorAttributeName
                 value:(id)color.CGColor
                 range:range];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setStrokeColor:(UIColor *)color {
    [self setStrokeColor:color range:NSMakeRange(0, [self length])];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -- 字符间距
- (void) setKern:(CGFloat)kern range:(NSRange)range {
    [self removeAttribute:(NSString*)NSKernAttributeName range:range];
    [self addAttribute:(NSString*)NSKernAttributeName
                 value:[NSNumber numberWithFloat:kern]
                 range:range];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setKern:(CGFloat)kern {
    [self setKern:kern range:NSMakeRange(0, [self length])];
}



@end
