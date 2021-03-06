//
//  OBuyCarTableViewCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kOBuyCarTableViewCellID;
FOUNDATION_EXPORT CGFloat const kOBuyCarTableViewCellHeight;

@class OBuyCarTableViewCell;
@protocol OBuyCarTableViewCellDelegate <NSObject>

- (void)oBuyCarTableViewCell:(OBuyCarTableViewCell *)oBuyCarTableViewCell longPress:(BOOL)longPress orderObj:(OrderInfoObj *)orderObj;

@end
@interface OBuyCarTableViewCell : BaseTableCell
@property (nonatomic, assign) id<OBuyCarTableViewCellDelegate> oDelegate;
@property (weak, nonatomic) IBOutlet UIView *pressView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (nonatomic, strong) OrderInfoObj *orderObj;

- (void)setupCellInfoWith:(OrderInfoObj *)orderObj;
@end
