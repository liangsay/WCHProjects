//
//  AppDelegate.h
//  WCHProjects
//
//  Created by liujinliang on 16/9/19.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "MainTabBarViewController.h"
#import "LoginViewController.h"
#import "MainNavigationViewController.h"
#import "MainViewController.h"
#import "LocationServer.h"
#import "CallCarViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainTabBarViewController *tabBarVC;
@property (strong, nonatomic) LoginViewController *loginVC;
@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) CallCarViewController *callCarVC;
@property (nonatomic, assign) NSInteger payType;//1，充值，2，支付
+ (AppDelegate *)delegate;

#pragma mark --检查是否登陆，没有则直接进入登陆界面
/*!
 *  @author liujinliang, 16-10-02 07:10:05
 *
 *  @brief 检查是否登陆，没有则直接进入登陆界面
 *
 *  @since <#1.0#>
 */
- (void)checkLoginStateWithShowVC;
- (void)showLoginVCWithLoginAction:(LoginVCAction)loginAction;
@end

