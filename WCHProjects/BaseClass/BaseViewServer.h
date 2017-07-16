//
//  BaseViewServer.h
//  WorldUnionBrokerPlatform
//
//  Created by liujinliang on 16/5/5.
//  Copyright © 2016年 www.liujinliang All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface BaseViewServer : NSObject
#pragma mark --创建View
/*!
 *  @author liujinliang, 16-05-05 17:05:49
 *
 *  @brief 创建View
 *
 *  @param inView <#inView description#>
 *  @param block  <#block description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UIView *)addViewInView:(UIView *)inView mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

#pragma mark --创建TextView
/*!
 *  @author liujinliang, 16-05-05 14:05:53
 *
 *  @brief 创建TextView
 *
 *  @param inView    <#inView description#>
 *  @param font      <#font description#>
 *  @param textColor <#textColor description#>
 *  @param delegate  <#delegate description#>
 *  @param block     <#block description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UITextView *)addTextViewInView:(UIView *)inView
                             font:(UIFont *)font
                        textColor:(UIColor *)textColor
                         delegate:(id<UITextViewDelegate>)delegate
              mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

#pragma mark --创建TextField
/*!
 *  @author liujinliang, 16-05-05 14:05:00
 *
 *  @brief 创建TextField
 *
 *  @param inView           <#inView description#>
 *  @param font             <#font description#>
 *  @param textColor        <#textColor description#>
 *  @param placeholder      <#placeholder description#>
 *  @param placeholderColor <#placeholderColor description#>
 *  @param delegate         <#delegate description#>
 *  @param block            <#block description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UITextField *)addTextFieldInView:(UIView *)inView
                               font:(UIFont *)font
                          textColor:(UIColor *)textColor
                        placeholder:(NSString *)placeholder
                   placeholderColor:(UIColor *)placeholderColor
                           delegate:(id)delegate
                mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

#pragma mark --创建ImageView
/*!
 *  @author liujinliang, 16-05-05 14:05:57
 *
 *  @brief 创建ImageView
 *
 *  @param inView      <#inView description#>
 *  @param image       <#image description#>
 *  @param contentMode <#contentMode description#>
 *  @param block       <#block description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UIImageView *)addImageViewInView:(UIView *)inView
                              image:(UIImage *)image
                        contentMode:(UIViewContentMode)contentMode
                mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

#pragma mark --创建Button
/*!
 *  @author liujinliang, 16-05-05 14:05:04
 *
 *  @brief 创建Button
 *
 *  @param inView           <#inView description#>
 *  @param font             <#font description#>
 *  @param title            <#title description#>
 *  @param titleColor       <#titleColor description#>
 *  @param normalImage      <#normalImage description#>
 *  @param highlightedImage <#highlightedImage description#>
 *  @param selectedImage    <#selectedImage description#>
 *  @param addTarget        <#addTarget description#>
 *  @param action           <#action description#>
 *  @param block            <#block description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UIButton *)addButtonInView:(UIView *)inView
                         font:(UIFont *)font
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                  normalImage:(UIImage *)normalImage
             highlightedImage:(UIImage *)highlightedImage
                selectedImage:(UIImage *)selectedImage
                    addTarget:(id)addTarget
                       action:(SEL)action
          mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

#pragma mark --创建Button
+ (UIButton *)addButtonInView:(UIView *)inView
                         font:(UIFont *)font
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    addTarget:(id)addTarget
                       action:(SEL)action
          mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

#pragma mark --创建Label
/*!
 *  @author liujinliang, 16-05-05 14:05:37
 *
 *  @brief 创建Label
 *
 *  @param inView        <#inView description#>
 *  @param font          <#font description#>
 *  @param text          <#text description#>
 *  @param textColor     <#textColor description#>
 *  @param textAlignment <#textAlignment description#>
 *  @param block         <#block description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UILabel *)addLabelInView:(UIView *)inView
                       font:(UIFont *)font
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
              textAilgnment:(NSTextAlignment)textAlignment
        mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

#pragma mark --添加指定颜色的线
/*!
 *  @author liujinliang, 16-05-05 14:05:23
 *
 *  @brief 添加指定颜色的线
 *
 *  @param inView 被添加的view
 *  @param color  指定颜色值
 *  @param block  自动化设置
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UIView *)addLineViewInView:(UIView *)inView
                        color:(UIColor *)color
          mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

#pragma mark --添加默认颜色的线
/*!
 *  @author liujinliang, 16-05-05 14:05:41
 *
 *  @brief 添加默认颜色的线
 *
 *  @param inView <#inView description#>
 *  @param block  <#block description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UIView *)addLineViewInView:(UIView *)inView mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

#pragma mark --创建Control
/*!
 *  @author liujinliang, 16-05-09 11:05:28
 *
 *  @brief 创建Control
 *
 *  @param inView          <#inView description#>
 *  @param target          <#target description#>
 *  @param action          <#action description#>
 *  @param backgroundColor <#backgroundColor description#>
 *  @param block           <#block description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UIControl *)addControlInView:(UIView *)inView
                         target:(id)target
                         action:(SEL)action
                backgroundColor:(UIColor *)backgroundColor
            mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

#pragma mark --创建UIScrollView
/*!
 *  @author liujinliang, 16-05-09 11:05:28
 *
 *  @brief 创建UIScrollView
 *
 *  @param inView          <#inView description#>
 *  @param delegate
 *  @param block           <#block description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (UIScrollView *)addScrollViewInView:(UIView *)inView
                             delegate:(id)delegate
                  mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;


#pragma mark --创建WKWebView
/*!
 *  @author liujinliang, 16-06-12 14:06:50
 *
 *  @brief 创建WKWebView
 *
 *  @param inView <#inView description#>
 *  @param vc     <#vc description#>
 *  @param block  <#block description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#1.0#>
 */
+ (WKWebView *)addWKWebViewInView:(UIView *)inView
                               delegate:(id)delegate
              mas_makeConstraints:(void(^)(MASConstraintMaker *make))block;

@end
