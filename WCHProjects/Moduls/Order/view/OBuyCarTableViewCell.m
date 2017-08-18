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
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    
    longPressGesture.minimumPressDuration=0.5f;//设置长按 时间
    [self.pressView addGestureRecognizer:longPressGesture];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若点击了tableViewCell，则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)setupCellInfoWith:(OrderInfoObj *)orderObj {
    NSURL *imgUrl = kURLFromString(fullImageUrl(orderObj.diskFilePathf));
    [self.typeImgV sd_setImageWithURL:imgUrl placeholderImage:nil];
    self.orderObj = orderObj;
    self.nameLab.text = orderObj.carNamef;
    
    NSString *pricef = [NSString stringWithFormat:@"%.2f元",orderObj.pricef.doubleValue];
    NSString *price = [NSString stringWithFormat:@"单价:￥%@",pricef];
    NSRange priceR = [price rangeOfString:pricef];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:price];
    [priceAtt setTextColor:[UIColor fontGray]];
    [priceAtt setTextColor:[UIColor priceColor] range:priceR];
    [priceAtt setFont:[UIFont fontAssistant]];
    [priceAtt setFont:[UIFont fontContent] range:priceR];
    self.priceLab.attributedText = priceAtt;
    
    self.numLab.text = [NSString stringWithFormat:@"购买数量:%@辆",orderObj.numf];
    // 0=未支付 1=已支付 2=已交付 (isAssess=0 未评价  1=已评价) -1=已取消
    NSInteger statusf = orderObj.statusf.integerValue;
    NSInteger isAssess = orderObj.isAssess.integerValue;
    self.typeLab.text = orderObj.statusTextf;
    if (statusf==2) {
        if (isAssess==1) {
            //已评价
            self.typeLab.text = @"已评价";
            
        }else{
            self.typeLab.text = @"待评价";
        }
    }
    
    if (statusf==0) {//
        //可以加入长按取消订单
        self.pressView.alpha = 1;
    }else{
        self.pressView.alpha = 0;
        
    }
}

- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender {
    if ([self.oDelegate respondsToSelector:@selector(oBuyCarTableViewCell:longPress:orderObj:)]) {
        [self.oDelegate oBuyCarTableViewCell:self longPress:YES orderObj:self.orderObj];
    }
}


@end
