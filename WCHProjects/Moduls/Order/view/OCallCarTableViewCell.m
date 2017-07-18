//
//  OCallCarTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "OCallCarTableViewCell.h"
NSString * const kOCallCarTableViewCellID = @"kOCallCarTableViewCellID";
CGFloat const kOCallCarTableViewCellHeight = 110;
@implementation OCallCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor backgroundColor];
    self.typeView.backgroundColor = [UIColor mainColor];
    self.typeLab.textColor = [UIColor whiteColor];
    [self.typeView setLayerCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
    [self.typeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.typeBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.typeBtn setLayerCornerRadius:round(25/2)];
    
    self.timeLab.text = [NSString stringWithFormat:@"下单时间:%@",@"2017-09-01 12:12:12"];
    self.typeLab.text = @"箱货";
    
    self.startLab.text = @"沪松路440号(南区交警大队旁)";
    self.endLab.text = @"湘东建材市场";
    NSString *price = @"100.50";
    NSString *priceStr = [NSString stringWithFormat:@"运价：%@",price];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange priceRange = [priceStr rangeOfString:price];
    [priceAtt setTextColor:[UIColor priceColor] range:priceRange];
    self.priceLab.attributedText = priceAtt;
    
    self.statueLab.text = @"未接单";
    
}


@end
