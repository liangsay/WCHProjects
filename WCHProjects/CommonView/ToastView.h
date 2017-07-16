//
//  ToastView.h
//  Jiwu
//
//  Created liujinliang leon on 15/5/12.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ToastViewAlignment) {
    ToastView_PAlignmentCenter,
    ToastView_PAlignmentTop,
    ToastView_PAlignmentBottom
};

@interface ToastView : UILabel

/**
 *  遮罩背景
 */
@property (nonatomic, strong) UIView *maskBackground;

+ (instancetype)toast:(NSString *)message;

#pragma mark --指定位置显示消息
/*!
 *  @author liujinliang, 16-12-30 13:12:25
 *
 *  @brief 指定位置显示消息
 *
 *  @param message        <#message description#>
 *  @param toastAlignment <#toastAlignment description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#1.1.0#>
 */
+ (instancetype)toast:(NSString *)message toastAlignment:(ToastViewAlignment)toastAlignment;
@end
