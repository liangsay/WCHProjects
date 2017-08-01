//
//  RentCarDetailCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/30.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kRentCarDetailCellID;
FOUNDATION_EXPORT CGFloat const kRentCarDetailCellHeight;
@interface RentCarDetailCell : BaseTableCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UITextField *contentLab;
- (void)setupCellInfoWith:(OrderInfoObj *)orderObj;
@end
