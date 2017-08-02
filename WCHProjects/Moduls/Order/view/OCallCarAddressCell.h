//
//  OCallCarAddressCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/8/2.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kOCallCarAddressCellID;
FOUNDATION_EXPORT CGFloat const kOCallCarAddressCellHeight;

@interface OCallCarAddressCell : BaseTableCell
@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UILabel *mobileLab;
@property (strong, nonatomic) UILabel *addressLab;
@property (strong, nonatomic) UIView *lineV;

@property (nonatomic, strong) OrderInfoObj *orderObj;
- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj;

@end
