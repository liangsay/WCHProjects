//
//  ORentCarTableViewCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kORentCarTableViewCellID;
FOUNDATION_EXPORT CGFloat const kORentCarTableViewCellHeight;
@class ORentCarTableViewCell;
@protocol ORentCarTableViewCellDelegate <NSObject>

- (void)oRentCarTableViewCell:(ORentCarTableViewCell *)oRentCarTableViewCell longPress:(BOOL)longPress orderObj:(OrderInfoObj *)orderObj;

@end

@interface ORentCarTableViewCell : BaseTableCell<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *pressView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *startLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (nonatomic, strong) UILongPressGestureRecognizer * longPressGesture;

@property (nonatomic, assign) id<ORentCarTableViewCellDelegate> oDelegate;
@property (nonatomic, strong) OrderInfoObj *orderObj;
- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj;
@end
