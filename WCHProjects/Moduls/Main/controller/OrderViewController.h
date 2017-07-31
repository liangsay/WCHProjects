//
//  OrderViewController.h
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfoObj.h"
@class OrderViewController;

@protocol OrderViewControllerDelegate <NSObject>

- (void)orderViewController:(OrderViewController *)orderViewController orderObj:(OrderInfoObj *)orderObj isOrderRecive:(BOOL)isOrderRecive;

@end

@interface OrderViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) OrderInfoObj *orderObj;
@property (nonatomic, assign) BOOL isReceive;//司机是否在接单状态，如果是则不能继续接单
@property (nonatomic, assign) id<OrderViewControllerDelegate> delegate;
- (void)headerRefresh;
//刷新列表数据
- (void)reloadOrderData;
@end
