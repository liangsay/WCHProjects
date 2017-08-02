//
//  OBuyCarTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "OBuyCarTableViewCell.h"
#import "UIImageView+WebCache.h"
NSString * const kOBuyCarTableViewCellID = @"kOBuyCarTableViewCellID";
CGFloat const kOBuyCarTableViewCellHeight = 90;
@implementation OBuyCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLab.textColor = [UIColor mainColor];
    self.numLab.textColor = [UIColor fontGray];
    self.typeLab.textColor = [UIColor priceColor];
    self.contentView.backgroundColor = [UIColor backgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWith:(OrderInfoObj *)orderObj {
    NSURL *imgUrl = kURLFromString(fullImageUrl(orderObj.diskFilePathf));
    [self.typeImgV sd_setImageWithURL:imgUrl placeholderImage:nil];
    self.orderObj = orderObj;
    self.nameLab.text = orderObj.carNamef;
    
    NSString *pricef = orderObj.pricef;
    NSString *price = [NSString stringWithFormat:@"单价:￥%@元",pricef];
    NSRange priceR = [price rangeOfString:pricef];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:price];
    [priceAtt setTextColor:[UIColor fontGray]];
    [priceAtt setTextColor:[UIColor priceColor] range:priceR];
    [priceAtt setFont:[UIFont fontAssistant]];
    [priceAtt setFont:[UIFont fontContent] range:priceR];
    self.priceLab.attributedText = priceAtt;
    
    self.numLab.text = [NSString stringWithFormat:@"购买数量:%@辆",orderObj.numf];
    //0:未接单 1：已接单 2：未支付  3:已支付 4：已取消
    NSInteger statusf = orderObj.statusf.integerValue;
    self.typeLab.text = orderObj.statusTextf.length ? orderObj.statusTextf : @"";
    if (statusf==1 || statusf==0) {//在已接单状态，司机或货主可取消订单
        //可以加入长按取消订单
        
    }else{
        
        
    }
}

@end
