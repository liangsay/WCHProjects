//
//  AppraiseViewController.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/14.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfoObj.h"

@class AppraiseViewController;
@protocol AppraiseViewControllerDelegate <NSObject>

- (void)appraiseViewController:(AppraiseViewController *)appraiseViewController orderObj:( OrderInfoObj *)orderObj;

@end

@interface AppraiseViewController : BaseViewController
@property (nonatomic, strong) OrderInfoObj *orderObj;
@property (nonatomic, assign) NSInteger viewType;//1行程（货主），2订单（司机）3、租车；4、购车
//(1=叫车  2=租车 3=售车 4=充值)
@property (nonatomic, assign) NSInteger objTypef;
@property (nonatomic, assign) id<AppraiseViewControllerDelegate> delegate;
@end
