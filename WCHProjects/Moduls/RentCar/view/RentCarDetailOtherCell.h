//
//  RentCarDetailOtherCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/30.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kRentCarDetailOtherCellID;

@interface RentCarDetailOtherCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *contentLab;
- (void)setupCellInfoWith:(OrderInfoObj *)orderObj;
@end
