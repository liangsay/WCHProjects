//
//  BaseViewController.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableCell.h"
@class BaseViewController;
#define kNotificationCenter_LOGINSUCCESS @"kNotificationCenter_LOGINSUCCESS"

FOUNDATION_EXPORT NSString * const kNotificationCenter_CancelOrder;



//url缓存策略
#define kNSURLRequestCachePolicy NSURLRequestUseProtocolCachePolicy//NSURLRequestReturnCacheDataElseLoad/NSURLRequestReloadIgnoringLocalCacheData

//支付/充值
CG_INLINE NSString *kNotificationWXPayStatus() {
    return @"kNotificationWXPayStatus";
}
CG_INLINE NSString *kNotificationALiPayStatus() {
    return @"kNotificationALiPayStatus";
}

CG_INLINE NSNotificationCenter *kNotificationCenter() {
    return [NSNotificationCenter defaultCenter];
}
typedef void (^ResponseDatablock)(id responseData);
typedef void(^LoginVCAction)(NSInteger index);
//typedef NS_ENUM(NSUInteger, <#MyEnum#>) {
//    <#MyEnumValueA#>,
//    <#MyEnumValueB#>,
//    <#MyEnumValueC#>,
//};


@protocol BaseViewControllerDelegate <NSObject>

- (void)baseViewController:(BaseViewController *)baseViewController isBack:(BOOL)isBack;

@end

@interface BaseViewController : UIViewController

/**
 *  push前是否需要先登录。需要在init方法中赋值
 */
//@property (nonatomic, assign) BOOL loginRequiredBeforePush;
/**
 *  在被push之前，是否需要登录。
 *  需要在init方法中赋值
 */
@property (nonatomic, assign) BOOL needLoginBeforePush;
@property (nonatomic, strong) BaseTableCell *prototypeCell;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, copy) ResponseDatablock responseAction;
@property (nonatomic, strong) NSDictionary *param;
@property (nonatomic, strong) UIWebView *bWebView;

@property (nonatomic, strong) NSMutableArray *carTypeArray;
@property (nonatomic, assign) id<BaseViewControllerDelegate> baseDelegate;
#pragma mark - 返回按钮
/**
 *  添加返回按钮
 */
- (void)setupBackButton;
#pragma mark - JS调用app方法进行页面跳转

-(id)loadPage:(id)data;
/**
 *  添加返回按钮
 */
- (void)setupBackButtonTarget:(id)target action:(SEL)action;

/**
 *  返回按钮点击时回调
 */
- (void)onBackButton;

- (CGFloat)statusHeight;
- (CGFloat)navHeight;
- (CGFloat)navStatusHeight;
- (CGFloat)navViewHeight;


#define kInitNavBarStyle(imageName,title) [self initNavigationBarWithLogoName:imageName navTitle:title]

#define kInitNavBarTitleWithRightStyle(imageName,title,right,action) [self initNavigationBarWithLogoName:imageName navTitle:title navRight:right navRightAction:action]


#pragma mark --设置导航栏的标题、右边的对象,
/*!
 *  @author liujinliang, 16-01-08 10:01:00
 *
 *  @brief 设置导航栏的标题、右边的对象
 *
 *  @param logoName    <#logoName description#>
 *  @param navTitle    <#navTitle description#>
 *  @param right       <#right description#>
 *  @param rightAction <#rightAction description#>
 *
 *  @since <#2.0#>
 */
- (void)initNavigationBarWithLogoName:(NSString *)logoName navTitle:(NSString *)navTitle navRight:(NSString *)navRight navRightAction:(SEL)navRightAction;

#pragma mark --导航栏左边icon或标题
/*!
 *  @author liujinliang, 16-02-18 15:02:50
 *
 *  @brief 导航栏左边icon或标题
 *
 *  @param iconName      <#iconName description#>
 *  @param navLeft       <#navLeft description#>
 *  @param navLeftAction <#navLeftAction description#>
 *
 *  @since <#version number#>
 */
- (void)initNavigationBarWithIconName:(NSString *)iconName navLeft:(NSString *)navLeft  navLeftAction:(SEL)navLeftAction;

#pragma mark --绘制导航栏样式
/*!
 *  @author liujinliang, 16-12-31 17:12:34
 *
 *  @brief 绘制导航栏样式
 *
 *  @param logoName <#logoName description#>
 *  @param navTitle <#navTitle description#>
 *
 *  @since <#1.1.0#>
 */
- (void)initNavigationBarWithLogoName:(NSString *)logoName navTitle:(NSString *)navTitle;

#pragma mark --绘制ui界面
/*!
 *  @author liujinliang, 16-01-08 09:01:27
 *
 *  @brief 绘制ui界面
 *
 *  @since <#2.0#>
 */
- (void)initUIViews;

#pragma mark --刷新ui数据
/*!
 *  @author liujinliang, 16-01-08 10:01:51
 *
 *  @brief 刷新ui数据
 *
 *  @since <#2.0#>
 */
- (void)reloadViewData;

#pragma mark --请求服务器数据
/*!
 *  @author liujinliang, 15-12-24 10:12:50
 *
 *  @brief 请求服务器数据
 *
 *  @since <#1.1.0#>
 */
- (void)loadServletData;

- (NSDictionary *)getAttributes:(BOOL)isOpen;

#pragma mark --登录成功回调处理
/*!
 *  @author liujinliang, 16-01-18 17:01:21
 *
 *  @brief 登录成功回调处理
 *
 *  @param successBlock <#successBlock description#>
 *
 *  @since <#2.0#>
 */
- (void)loginVCWithSuccessBlock:(LoginVCAction)successBlock;
- (void)loginVCWithSuccessBlockWithIsForget:(BOOL)isForget successBlock:(LoginVCAction)successBlock;

- (BaseViewController *)getViewControllerWithIdentifier:(NSString *)identifier;
@end
