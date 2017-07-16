//
//  MainViewController.h
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfoObj.h"
#import "OrderViewController.h"
@interface MainViewController : BaseViewController
@property(nonatomic, strong) NSMutableArray *carTypeArray;//车型数组
@property(nonatomic, strong) NSMutableArray *huozhuCarTypeArray;//货主的所在城市车型数组

@property(nonatomic, assign) BOOL isReciveState;//是否接单状态
@property(nonatomic, strong) NSString *orderNof;//订单编号
@property(nonatomic, strong) OrderInfoObj *reciveOrder;//正在接的定单
@property (nonatomic, strong) OrderViewController *orderVC;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) dispatch_source_t disTimer;
@property (nonatomic, strong) dispatch_source_t checkTimer;
#pragma mark --用于查询运费点类别
- (void)sendApptoPointType;
#pragma mark --用于查询周边的运货点
- (void)sendkGoodpointtoMarks;
- (void)endTimer;

#pragma mark --已接单后显示
- (void)reciveOrderWithOrderObj:(OrderInfoObj *)orderObj;

#pragma mark --立即下单
- (IBAction)pCarorderBtnAction:(UIButton *)sender;
@end
