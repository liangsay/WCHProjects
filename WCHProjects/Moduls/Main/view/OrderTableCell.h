//
//  OrderTableCell.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/5.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseTableCell.h"
#import "OrderInfoObj.h"
#import "BaseTableView.h"
FOUNDATION_EXPORT NSString * const kOrderTableCellID;
FOUNDATION_EXPORT CGFloat const kOrderTableCellHeight;

@class OrderTableCell;
@protocol OrderTableCellDelegate <NSObject>
- (void)orderTableCell:(OrderTableCell *)orderTableCell orderObj:(OrderInfoObj *)orderObj;

@end

@interface OrderTableCell : BaseTableCell
@property (nonatomic, weak) IBOutlet UIView *bgView;//终点位置

@property (strong, nonatomic) UIImageView *startImgV;
@property (strong, nonatomic) UILabel *startLab;
@property (strong, nonatomic) UIImageView *endImgV;
@property (strong, nonatomic) UILabel *endLab;
@property (strong, nonatomic) UILabel *typeLab;

@property (nonatomic, strong) BaseTableView *tableView;

@property (strong, nonatomic) UILabel *priceLab;
@property (nonatomic, strong) UIButton *orderBtn;
@property (nonatomic, strong) OrderInfoObj *orderObj;
@property (strong, nonatomic) UIView *lineV;

@property (nonatomic, assign) id<OrderTableCellDelegate> orderDelegate;
- (void)setupCellInfoWith:(OrderInfoObj *)model;
@end
