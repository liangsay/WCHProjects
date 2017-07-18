//
//  ORentCarTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ORentCarTableViewCell.h"
NSString * const kORentCarTableViewCellID = @"kORentCarTableViewCellID";
CGFloat const kORentCarTableViewCellHeight = 85;
@implementation ORentCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor backgroundColor];
    self.nameLab.textColor = [UIColor mainColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
    self.nameLab.text = @"六六微货";
    self.startLab.text = @"2016-12-10";
    self.endLab.text = @"2017-10-11";
    NSString *address = @"天津市北辰区韩家墅海吉星农产品批发市场";
    NSString *addressStr = [NSString stringWithFormat:@"取/还车地址 %@",address];
    NSMutableAttributedString *addrAtt = [[NSMutableAttributedString alloc] initWithString:addressStr];
    NSRange addressRange = [addressStr rangeOfString:address];
    [addrAtt setTextColor:[UIColor fontGray]];
    [addrAtt setTextColor:[UIColor fontBlack] range:addressRange];
    self.addressLab.attributedText = addrAtt;
    
}
@end
