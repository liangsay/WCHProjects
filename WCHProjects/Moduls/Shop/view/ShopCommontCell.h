//
//  ShopCommontCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/10.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableCell.h"
FOUNDATION_EXPORT NSString * const kShopCommontCellID;
FOUNDATION_EXPORT CGFloat const kShopCommontCellHeight;

@interface ShopCommontCell : BaseTableCell
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic, strong) OrderInfoObj *orderObj;
- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj;
@end
