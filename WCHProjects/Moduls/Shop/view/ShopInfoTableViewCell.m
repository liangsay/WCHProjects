//
//  ShopInfoTableViewCell.m
//  WCHProjects
//
//  Created by liu jinliang on 2017/8/5.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopInfoTableViewCell.h"
NSString * const kShopInfoTableViewCellID = @"kShopInfoTableViewCellID";
CGFloat const kShopInfoTableViewCellHeight = 38;
@implementation ShopInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLab.preferredMaxLayoutWidth = kScreenWidth - 90 - 15 - 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
}
@end
