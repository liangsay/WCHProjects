//
//  OrderInComeTableCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/8/9.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "BaseTableCell.h"
#import "BaseTableView.h"
FOUNDATION_EXPORT NSString * const kOrderInComeTableCellID;
FOUNDATION_EXPORT CGFloat const kOrderInComeTableCellHeight;

@class OrderInComeTableCell;
@protocol OrderInComeTableCellDelegate <NSObject>

- (void)orderInComeTableCell:(OrderInComeTableCell *)orderInComeTableCell isFinish:(BOOL)isFinish orderObj:(OrderInfoObj *)orderObj;
- (void)orderInComeTableCell:(OrderInComeTableCell *)orderInComeTableCell longPress:(BOOL)longPress orderObj:(OrderInfoObj *)orderObj;

@end
@interface OrderInComeTableCell : BaseTableCell
@property (nonatomic, assign) id<OrderInComeTableCellDelegate> oDelegate;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *touchView;
@property (nonatomic, strong) UILongPressGestureRecognizer * longPressGesture;
@property (strong, nonatomic) UIView *lineV;
@property (nonatomic, strong) BaseTableView *tableView;

@property (strong, nonatomic) UIButton *callBtn;
@property (strong, nonatomic) UILabel *numLab;

@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *typeLab;
@property (strong, nonatomic) UIView *typeView;

@property (strong, nonatomic) UIImageView *startImgV;
@property (strong, nonatomic) UILabel *startLab;

@property (strong, nonatomic) UIImageView *endImgV;
@property (strong, nonatomic) UILabel *endLab;
@property (strong, nonatomic) UILabel *priceLab;
@property (strong, nonatomic) UILabel *statueLab;

@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) OrderInfoObj *orderObj;


- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj;
@end
