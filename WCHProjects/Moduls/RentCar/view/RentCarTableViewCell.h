//
//  RentCarTableViewCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoObj.h"
FOUNDATION_EXPORT NSString * const kRentCarTableViewCellID;
FOUNDATION_EXPORT CGFloat const kRentCarTableViewCellHeight;
@interface RentCarTableViewCell : BaseTableCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *tonfLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkfLab;

@property (nonatomic, strong) OrderInfoObj *orderObj;
- (void)setupCellInfoWith:(OrderInfoObj *)oderObj;
@end
