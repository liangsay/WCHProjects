//
//  CallCarTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/13.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "CallCarTableViewCell.h"
#import "UIImageView+WebCache.h"
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

- (void)setupCellInfoWith:(OrderInfoObj *)oderObj {
    self.orderObj = oderObj;
    self.nameLab.text = oderObj.namef;
    
    NSString *startPricef = [NSString stringWithFormat:@"%.2f元",oderObj.startPricef.doubleValue];
    NSString *price = [NSString stringWithFormat:@"￥%@(%@公里)",startPricef,oderObj.startKmf];
    NSRange priceR = [price rangeOfString:startPricef];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:price];
    [priceAtt setTextColor:[UIColor fontGray]];
    [priceAtt setTextColor:[UIColor priceColor] range:priceR];
    [priceAtt setFont:[UIFont fontAssistant]];
    [priceAtt setFont:[UIFont fontContent] range:priceR];
    self.priceLab.attributedText = priceAtt;
    
    self.tonfLab.text = [NSString stringWithFormat:@"载重:%@吨",oderObj.tonf];
    self.remarkfLab.text = [NSString stringWithFormat:@"长*宽*高:%@", oderObj.remarkf];
    self.kmPricefLab.text = [NSString stringWithFormat:@"超公里费:%.2f元/公里",oderObj.kmPricef.doubleValue];
    
    NSURL *imgUrl = kURLFromString(fullImageUrl(oderObj.diskFilePathf));
    [self.typeImgV sd_setImageWithURL:imgUrl placeholderImage:nil];
}
@end
