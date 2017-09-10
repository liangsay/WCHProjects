//
//  DutyLocationTableViewCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/9/10.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kDutyLocationTableViewCellID;
FOUNDATION_EXPORT CGFloat const kDutyLocationTableViewCellHeight;
@interface DutyLocationTableViewCell : BaseTableCell
@property (weak, nonatomic) IBOutlet UILabel *type1Lab;
@property (weak, nonatomic) IBOutlet UILabel *type2Lab;

@end
