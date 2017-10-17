//
//  RentCarTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "RentCarTableViewCell.h"
#import "UIImageView+WebCache.h"
NSString * const kRentCarTableViewCellID = @"kRentCarTableViewCellID";
CGFloat const kRentCarTableViewCellHeight = 90;
@implementation RentCarTableViewCell

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

- (void)setupCellInfoWith:(OrderInfoObj *)oderObj {
    NSURL *imgUrl = kURLFromString(fullImageUrl(oderObj.diskFilePathf));
    [self.typeImgV sd_setImageWithURL:imgUrl placeholderImage:nil];
    self.orderObj = oderObj;
    self.nameLab.text = oderObj.namef;
    
    NSString *rentPricef = [NSString stringWithFormat:@"%.2f元",oderObj.rentPricef.doubleValue];
    NSString *price = [NSString stringWithFormat:@"￥%@日均",rentPricef];
    NSRange priceR = [price rangeOfString:rentPricef];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:price];
    [priceAtt setTextColor:[UIColor fontGray]];
    [priceAtt setTextColor:[UIColor priceColor] range:priceR];
    [priceAtt setFont:[UIFont fontAssistant]];
    [priceAtt setFont:[UIFont fontContent] range:priceR];
    self.priceLab.attributedText = priceAtt;
    
    self.tonfLab.text = [NSString stringWithFormat:@"载重:%@吨",oderObj.tonf];
    self.remarkfLab.text = [NSString stringWithFormat:@"长*宽*高:%@", oderObj.remarkf];
    
}

@end
