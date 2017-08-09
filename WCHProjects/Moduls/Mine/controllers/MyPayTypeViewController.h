//
//  MyPayTypeViewController.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/14.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfoObj.h"
@class MyPayTypeViewController;
@protocol MyPayTypeViewDelegate <NSObject>

- (void)myPayTypeViewController:(MyPayTypeViewController *)myPayTypeViewController payStatus:(NSInteger)payStatus orderObj:(OrderInfoObj *)orderObj;

@end

@interface MyPayTypeViewController : BaseViewController
@property (nonatomic, assign) NSInteger viewType;//3、租车；4、购车
@property (nonatomic, strong) OrderInfoObj *orderObj;
@property (nonatomic, assign) id<MyPayTypeViewDelegate> delegate;
// (1=叫车  2=租车 3=售车 4=充值)
@property (nonatomic, assign) NSInteger tradeTypef;
@property (nonatomic, assign) NSString *payTitle;//(运费、租金、订金)
@property (nonatomic, assign) BOOL isCoupon;//是否有优惠券使用
@end
