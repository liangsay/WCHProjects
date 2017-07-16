//
//  MainTabBarViewController.h
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/31.
//  Copyright © 2015年 WorldUnion. All rights reserved.
//

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
extern const CGFloat kMainTabBarHeight;
extern const CGFloat kMainTabBarContentHeight;

@interface MainTabBarViewController : RDVTabBarController
@property (nonatomic, strong) RDVTabBarItem *firstTabBarItem;
/**
 *  当前显示页面所在的导航controller
 */
+ (UINavigationController *)currentNavigationController;
/*!
 *  @author liujinliang, 16-04-06 15:04:05
 *
 *  @brief 用于tab底部标记滑动
 *
 *  @since <#version number#>
 */
@property (nonatomic,strong) UIView *slideView;

@end
