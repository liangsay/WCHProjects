//
//  AppStoreUpdateView.h
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/8.
//  Copyright © 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateVersion.h"

@class AppStoreUpdateView;
typedef void(^UpdateVersionCompletedBlock)(NSInteger buttonIndex,AppStoreUpdateView *alertView);

@interface AppStoreUpdateView : UIView<UITextViewDelegate>
/**
 *  遮罩背景
 */
@property (nonatomic, strong) UIView *maskBackground;
@property (nonatomic, strong) UpdateVersion *versionObj;
@property (nonatomic, assign) UpdateVersionCompletedBlock alertViewCommplet;
+ (instancetype)showAlertViewWithObject:(UpdateVersion *)versionObj alertView:(UpdateVersionCompletedBlock)alertView;
@end
