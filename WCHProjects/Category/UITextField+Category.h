//
//  UITextField+Category.h
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/11.
//  Copyright © 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Category)
#pragma mark --txtField左间距
/**
 *  @author liujinliang, 15-12-11 15:12:06
 *
 *  txtField左间距
 *
 *  @param textField <#textField description#>
 *  @param leftWidth <#leftWidth description#>
 */
-(void)setTextFieldLeftPaddingWidth:(CGFloat)leftWidth;

#pragma mark --检查输入金额格式
/**
 *  @author liujinliang, 15-12-14 15:12:01
 *
 *  检查输入金额格式
 *
 *  @param toBeString <#toBeString description#>
 *  @param string     <#string description#>
 *  @param range      <#range description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)checkMoneyFormatWithString:(NSString *)toBeString string:(NSString *)string range:(NSRange)range;

#pragma mark --检查限制性输入
/*!
 *  @author liujinliang, 16-01-23 14:01:36
 *
 *  @brief *  检查限制性输入
 *
 #define 0 kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
 #define 1 kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
 #define 2 kNumbers     @"0123456789"
 #define 3 kNumbersPeriod  @"0123456789."
 #define 4 kNumbersheng  @"0123456789-"
 *
 *  @param string_ <#string_ description#>
 *  @param typ     <#typ description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#2.0.0#>
 */
-(BOOL)ChenkInputNSCharacterSet:(NSString *)string_ typeInt:(int)typ;

#pragma mark --设置文本框右视图，支持按钮事件
/*!
 *  @author liujinliang, 16-01-23 11:01:46
 *
 *  @brief 设置文本框右视图，支持按钮事件
 *
 *  @param iconName    <#iconName description#>
 *  @param selIconName <#selIconName description#>
 *  @param target      <#target description#>
 *  @param action      <#action description#>
 *
 *  @since <#2.0.0#>
 */
- (UIButton *) setRightViewWithImageName:(NSString *)iconName selIconName:(NSString *)selIconName addTarget:(id)target action:(SEL)action;

#pragma mark --设置文本框左视图
/*!
 *  @author liujinliang, 16-01-23 11:01:09
 *
 *  @brief 设置文本框左视图
 *
 *  @param iconName <#iconName description#>
 *
 *  @since <#2.0.0#>
 */
- (UIImageView *)setLeftViewWithImageName:(NSString *)iconName;
@end
