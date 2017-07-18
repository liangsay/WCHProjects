//
//  RentCarTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "RentCarTableViewCell.h"
NSString * const kRentCarTableViewCellID = @"kRentCarTableViewCellID";
CGFloat const kRentCarTableViewCellHeight = 90;
@implementation RentCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor backgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
