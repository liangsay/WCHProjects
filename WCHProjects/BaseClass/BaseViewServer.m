//
//  BaseViewServer.m
//  WorldUnionBrokerPlatform
//
//  Created by liujinliang on 16/5/5.
//  Copyright © 2016年 www.liujinliang All rights reserved.
//

#import "BaseViewServer.h"
#import "UITextField+Category.h"


@implementation BaseViewServer

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
+ (UIView *)addViewInView:(UIView *)inView mas_makeConstraints:(void(^)(MASConstraintMaker *make))block{
    return [self addLineViewInView:inView color:[UIColor whiteColor] mas_makeConstraints:block];
}

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
+ (UIView *)addLineViewInView:(UIView *)inView mas_makeConstraints:(void(^)(MASConstraintMaker *make))block{
    return [self addLineViewInView:inView color:[UIColor borderColor] mas_makeConstraints:block];
}

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
                mas_makeConstraints:(void(^)(MASConstraintMaker *make))block{
    UIView *lineV = [UIView new];
    lineV.backgroundColor = color;
    [inView addSubview:lineV];
    [lineV mas_makeConstraints:block];
    return lineV;
}

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
        mas_makeConstraints:(void(^)(MASConstraintMaker *make))block{
    UILabel *lable = [UILabel new];
    lable.textAlignment = textAlignment ? textAlignment:NSTextAlignmentLeft;
    lable.text = text;
    lable.font = font;
    lable.textColor = textColor ? textColor:[UIColor blackColor];
    [inView addSubview:lable];
    [lable mas_makeConstraints:block];
    return lable;
}

#pragma mark --创建Button
+ (UIButton *)addButtonInView:(UIView *)inView
                         font:(UIFont *)font
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    addTarget:(id)addTarget
                       action:(SEL)action
          mas_makeConstraints:(void(^)(MASConstraintMaker *make))block
{
    return [self addButtonInView:inView font:font title:title titleColor:titleColor normalImage:nil highlightedImage:nil selectedImage:nil addTarget:addTarget action:action mas_makeConstraints:block];
}
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
          mas_makeConstraints:(void(^)(MASConstraintMaker *make))block{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button addTarget:addTarget action:action forControlEvents:UIControlEventTouchUpInside];
    [inView addSubview:button];
    [button mas_makeConstraints:block];
    return button;
}

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
                mas_makeConstraints:(void(^)(MASConstraintMaker *make))block {
    UIImageView *imageView = [UIImageView new];
    imageView.image = image;
    imageView.contentMode = contentMode;
    [inView addSubview:imageView];
    [imageView mas_makeConstraints:block];
    return imageView;
}

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
                mas_makeConstraints:(void(^)(MASConstraintMaker *make))block {
    UITextField *textfield = [UITextField new];
    textfield.backgroundColor = [UIColor clearColor];
    textfield.placeholder = placeholder;
    textfield.textColor = textColor;
    textfield.font = font;
    [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
    textfield.delegate = delegate;
    [textfield setTextFieldLeftPaddingWidth:5];
    if (placeholderColor) {
        [textfield setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    [inView addSubview:textfield];
    [textfield mas_makeConstraints:block];
    return textfield;
}

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
              mas_makeConstraints:(void(^)(MASConstraintMaker *make))block {
    UITextView *textfield = [UITextView new];
    textfield.backgroundColor = [UIColor clearColor];
    textfield.textColor = textColor;
    textfield.font = font;
    textfield.delegate = delegate;
    [textfield mas_makeConstraints:block];
    return textfield;
}

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
            mas_makeConstraints:(void(^)(MASConstraintMaker *make))block {
    UIControl *col = [[UIControl alloc] init];
    [col addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    col.backgroundColor = backgroundColor;
    [inView addSubview:col];
    [inView bringSubviewToFront:col];
    [col mas_makeConstraints:block];
    
    return col;
}

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
            mas_makeConstraints:(void(^)(MASConstraintMaker *make))block {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = delegate;
    [inView addSubview:scrollView];
    [scrollView mas_makeConstraints:block];
    return scrollView;
}

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
              mas_makeConstraints:(void(^)(MASConstraintMaker *make))block {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:delegate name:@"AppModel"];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [inView addSubview:webView];
    [webView mas_makeConstraints:block];
    return webView;
}
@end
