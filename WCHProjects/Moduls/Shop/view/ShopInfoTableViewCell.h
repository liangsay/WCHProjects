//
//  ShopInfoTableViewCell.h
//  WCHProjects
//
//  Created by liu jinliang on 2017/8/5.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kShopInfoTableViewCellID;
FOUNDATION_EXPORT CGFloat const kShopInfoTableViewCellHeight;
@interface ShopInfoTableViewCell : BaseTableCell
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic, strong) OrderInfoObj *orderObj;
- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj;
@end
