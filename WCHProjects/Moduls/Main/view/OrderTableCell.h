//
//  OrderTableCell.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/5.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseTableCell.h"
#import "OrderInfoObj.h"
FOUNDATION_EXPORT NSString * const kOrderTableCellID;
FOUNDATION_EXPORT CGFloat const kOrderTableCellHeight;

@class OrderTableCell;
@protocol OrderTableCellDelegate <NSObject>
- (void)orderTableCell:(OrderTableCell *)orderTableCell orderObj:(OrderInfoObj *)orderObj;

@end

@interface OrderTableCell : BaseTableCell
@property (nonatomic, weak) IBOutlet UIView *bgView;//终点位置
@property (nonatomic, weak) IBOutlet UILabel *startLab;//起点位置
@property (nonatomic, weak) IBOutlet UILabel *endLab;//终点位置
@property (nonatomic, weak) IBOutlet UILabel *carLab;//起点位置
@property (nonatomic, weak) IBOutlet UILabel *priceLab;//终点位置
@property (nonatomic, weak) IBOutlet UIButton *orderBtn;
@property (nonatomic, strong) OrderInfoObj *orderObj;

@property (nonatomic, assign) id<OrderTableCellDelegate> orderDelegate;
- (void)setupCellInfoWith:(OrderInfoObj *)model;
@end
