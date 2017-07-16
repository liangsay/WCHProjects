//
//  CouponTableCell.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/5.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseTableCell.h"

FOUNDATION_EXPORT NSString * const kCouponTableCellID;
FOUNDATION_EXPORT CGFloat const kCouponTableCellHeight;

@interface CouponModel : BaseModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *time;
@end

@interface CouponTableCell : BaseTableCell
@property (nonatomic, strong) UIImageView *iconImgV;
@property (nonatomic, strong) UILabel *typeLab;//类型
@property (nonatomic, strong) UILabel *moneyLab;//优惠金额
@property (nonatomic, strong) UILabel *timeLab;//时间

- (void)setupCellInfoWith:(CouponModel *)model;
@end
