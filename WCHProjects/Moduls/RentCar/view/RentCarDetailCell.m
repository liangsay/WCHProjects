//
//  RentCarDetailCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/30.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "RentCarDetailCell.h"
NSString * const kRentCarDetailCellID = @"kRentCarDetailCellID";
CGFloat const kRentCarDetailCellHeight = 45;
@implementation RentCarDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWith:(OrderInfoObj *)orderObj {
    self.typeImgV.image = kIMAGE(orderObj.iconName);
    self.contentLab.placeholder = orderObj.placeholder;
    self.contentLab.text = orderObj.content;
}
@end
