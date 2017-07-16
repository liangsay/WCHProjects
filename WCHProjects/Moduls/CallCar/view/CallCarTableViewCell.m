//
//  CallCarTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/13.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "CallCarTableViewCell.h"
NSString * const kCallCarTableViewCellID = @"kCallCarTableViewCellID";
CGFloat const kCallCarTableViewCellHeight = 110;
@implementation CallCarTableViewCell

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
