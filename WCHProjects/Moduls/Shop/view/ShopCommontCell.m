//
//  ShopCommontCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/10.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopCommontCell.h"


NSString * const kShopCommontCellID = @"kShopCommontCellID";
CGFloat const kShopCommontCellHeight = 120;
@implementation ShopCommontCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLab.preferredMaxLayoutWidth = kScreenWidth - 30;
    self.phoneLab.textColor = [UIColor mainColor];
    self.scoreLab.textColor = [UIColor priceColor];
    self.timeLab.textColor = [UIColor fontGray];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
    if (kIsObjectEmpty(orderObj.mobilef)) {
        orderObj.mobilef = @"--";
    }
    if (orderObj.mobilef.length>=11) {
        self.phoneLab.text = [orderObj.mobilef stringByReplacingOccurrencesOfString:[orderObj.mobilef substringWithRange:NSMakeRange(3,4)]withString:@"****"];
    }
    
    self.scoreLab.text = [NSString stringWithFormat:@"%.1f",orderObj.scoref.doubleValue];
    NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc] initWithString:orderObj.assessContentf];
    [contentAtt setTextColor:[UIColor fontBlack]];
    [contentAtt setTextAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingTail lineSpacing:1.2 lineHeightMultiple:0];
    self.contentLab.attributedText = contentAtt;
    
    self.timeLab.text = orderObj.createTimef;
}


@end
