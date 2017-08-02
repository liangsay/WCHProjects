//
//  JiKeTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/8/2.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "JiKeTableViewCell.h"
NSString * const kJiKeTableViewCellID = @"kJiKeTableViewCellID";
CGFloat const kJiKeTableViewCellHeight = 44;
@implementation JiKeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWith:(OrderInfoObj *)orderObj {
    self.contentTxtF.placeholder =  orderObj.placeholder;
    self.contentTxtF.text = orderObj.content;
}
@end
