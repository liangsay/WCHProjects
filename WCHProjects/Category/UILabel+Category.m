//
//  UILabel+Category.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

/**
 *  @author King, 15-06-15 11:06:32
 *
 *  获取Label的Size
 *
 *  @param text    <#text description#>
 *  @param font    <#font description#>
 *  @param maxSize <#maxSize description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)sizeOfStringWithMaxHeight:(CGFloat)maxHeight {
    //    CGSize size=[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.width ,maxHeight) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize size =[self.text boundingRectWithSize:(CGSize){self.width, maxHeight} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil].size;
    self.height = size.height;
    return size;
}

- (void)setTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment
{
    self.backgroundColor = [UIColor clearColor];
    self.textColor = textColor ?: [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:fontSize ?: 15];
    self.textAlignment = alignment;
}

+ (instancetype)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:textColor fontSize:fontSize textAlignment:alignment];
    return label;
}

+ (instancetype)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment position:(CGPoint)position
{
    UILabel *label = [self labelWithTextColor:textColor fontSize:fontSize textAlignment:alignment];
    label.frame = (CGRect){position, CGSizeZero};
    return label;
}

+ (instancetype)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment size:(CGSize)size
{
    UILabel *label = [self labelWithTextColor:textColor fontSize:fontSize textAlignment:alignment];
    label.frame = (CGRect){CGPointZero, size};
    return label;
}

+ (instancetype)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)alignment frame:(CGRect)frame
{
    UILabel *label = [self labelWithTextColor:textColor fontSize:fontSize textAlignment:alignment];
    label.frame = frame;
    return label;
}

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
- (void)labWithAttributedText:(NSString *)value1 value2:(NSString *)value2 {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor fontBlack] range:NSMakeRange(0,str.string.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontNavTitle] range:[str.string rangeOfString:value1]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontContent] range:[str.string rangeOfString:value2]];
    self.attributedText = str;
}
//NSStringDrawingOptions(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
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
                        context:(NSStringDrawingContext*)context {
//    [self.text boundingRectWithSize:size options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:context];
    if (!attributes) {
        attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
        NSMutableAttributedString *attributedText = (NSMutableAttributedString *)self.attributedText;
        if (attributedText) {
            [attributedText enumerateAttributesInRange:(NSRange){0,self.text.length} options:NSAttributedStringEnumerationReverse|NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                [attributes addEntriesFromDictionary:attrs];
            }];
        }
    }
    if (!options) {
        options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    }
    if (self.text.length) {
        return [self.text boundingRectWithSize:size options:options attributes:attributes context:context].size;
    }
    return CGSizeZero;
}
@end
