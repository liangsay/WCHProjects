//
//  MyRouteTableCell.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/4.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseTableCell.h"
#import "OrderInfoObj.h"
FOUNDATION_EXPORT NSString * const kMyRouteTableCellID;
FOUNDATION_EXPORT CGFloat const kMyRouteTableCellHeight;

typedef NS_ENUM(NSUInteger, MyRouteTableCellType) {
    MyRouteTableCellTypeRoute= 0 >> 1,//我的行程
    MyRouteTableCellTypeInCome,//我的收入
};

@class MyRouteTableCell;
@protocol MyRouteTableCellDelegate <NSObject>

- (void)myRouteTableCell:(MyRouteTableCell *)myRouteTableCell orderObj:(OrderInfoObj *)orderObj cancelOrder:(BOOL)cancelOrder;

@end

@interface MyRouteTableCell : BaseTableCell

@property (nonatomic, strong) UILabel *timeLab;//时间
@property (nonatomic, strong) UILabel *typeLab;//类型
@property (nonatomic, strong) UIImageView *startImgV;//
@property (nonatomic, strong) UIImageView *endImgV;//
@property (nonatomic, strong) UILabel *startLab;//起点位置
@property (nonatomic, strong) UILabel *endLab;//终点位置
@property (nonatomic, strong) UILabel *stateLab;//支付状态
@property (nonatomic, strong) UIButton *cancelBtn;//
@property (nonatomic, strong) OrderInfoObj *orderObj;
@property (nonatomic, assign) id<MyRouteTableCellDelegate> inComeDelegate;
@property (nonatomic, assign) MyRouteTableCellType cellType;

- (void)setupCellInfoWith:(OrderInfoObj *)model;
@end
