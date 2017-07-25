//
//  ORentCarTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ORentCarTableViewCell.h"
NSString * const kORentCarTableViewCellID = @"kORentCarTableViewCellID";
CGFloat const kORentCarTableViewCellHeight = 145;
@implementation ORentCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor backgroundColor];
    self.nameLab.textColor = [UIColor mainColor];
    [self.typeBtn setBackgroundImageColor:[UIColor mainColor]];
    [self.typeBtn setLayerCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
    self.nameLab.text = orderObj.vehicleModelTypef;
    self.startLab.text = orderObj.pickupDatef;
    self.endLab.text = orderObj.returnDatef;
    self.typeLab.text = orderObj.statusTextf;
    NSString *address = orderObj.returnLocationf;
    NSString *addressStr = [NSString stringWithFormat:@"取/还车地址:%@",address];
    NSMutableAttributedString *addrAtt = [[NSMutableAttributedString alloc] initWithString:addressStr];
    NSRange addressRange = [addressStr rangeOfString:address];
    [addrAtt setTextColor:[UIColor fontGray]];
    [addrAtt setTextColor:[UIColor fontBlack] range:addressRange];
    [addrAtt setFont:[UIFont fontAssistant]];
    self.addressLab.attributedText = addrAtt;
    
}

- (IBAction)typeBtnAction:(UIButton *)sender {
}
@end
