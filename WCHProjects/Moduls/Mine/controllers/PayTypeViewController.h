//
//  PayTypeViewController.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/12.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseViewController.h"

@class PayTypeViewController;
@protocol PayTypeViewControllerDelegate <NSObject>

- (void)payTypeViewController:(PayTypeViewController *)payTypeViewController payType:(NSInteger)payType;

@end

@interface PayTypeViewController : BaseViewController
@property (nonatomic, assign) id<PayTypeViewControllerDelegate> delegate;
#pragma mark --显示view
- (void)showPayView;
#pragma mark --隐藏view
- (void)hidePayView;
@end
