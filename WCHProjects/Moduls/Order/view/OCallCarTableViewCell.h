//
//  OCallCarTableViewCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
FOUNDATION_EXPORT NSString * const kOCallCarTableViewCellID;
FOUNDATION_EXPORT CGFloat const kOCallCarTableViewCellHeight;

@class OCallCarTableViewCell;
@protocol OCallCarTableViewCellDelegate <NSObject>

- (void)oCallCarTableViewCell:(OCallCarTableViewCell *)oCallCarTableViewCell longPress:(BOOL)longPress orderObj:(OrderInfoObj *)orderObj;
- (void)oCallCarTableViewCell:(OCallCarTableViewCell *)oCallCarTableViewCell tapGesture:(BOOL)tapGesture orderObj:(OrderInfoObj *)orderObj;

@end

@interface OCallCarTableViewCell : BaseTableCell
@property (nonatomic, assign) id<OCallCarTableViewCellDelegate> oDelegate;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *touchView;
@property (strong, nonatomic) UIView *lineV;
@property (nonatomic, strong) BaseTableView *tableView;

@property (strong, nonatomic) UILabel *numLab;
@property (strong, nonatomic) UIButton *callBtn;

@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *typeLab;
@property (strong, nonatomic) UIView *typeView;

@property (strong, nonatomic) UIImageView *startImgV;
@property (strong, nonatomic) UILabel *startLab;

@property (strong, nonatomic) UIImageView *endImgV;
@property (strong, nonatomic) UILabel *endLab;

@property (strong, nonatomic) UILabel *priceLab;
@property (strong, nonatomic) UILabel *statueLab;

@property (nonatomic, strong) OrderInfoObj *orderObj;

@property (nonatomic, strong) UILongPressGestureRecognizer * longPressGesture;

- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj;
@end
