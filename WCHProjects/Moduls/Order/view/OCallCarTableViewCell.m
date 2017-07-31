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
    
    self.timeLab.text = [NSString stringWithFormat:@"下单时间:%@",orderObj.createTimef];
    if (!kIsObjectEmpty(orderObj.modelNamef)) {
        self.typeLab.text = orderObj.modelNamef;
        self.typeView.alpha = 1;
    }else{
        self.typeView.alpha = 0;
    }
    
    self.startLab.text = orderObj.startAddrNamef;
    self.endLab.text = orderObj.endAddrNamef;
    NSString *price = orderObj.pricef;
    NSString *priceStr = [NSString stringWithFormat:@"运价：%@",price];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange priceRange = [priceStr rangeOfString:price];
    [priceAtt setTextColor:[UIColor priceColor] range:priceRange];
    self.priceLab.attributedText = priceAtt;
    
    self.statueLab.text = orderObj.statusTextf;
    //0:未接单 1：已接单 2：未支付  3:已支付 4：已取消
    NSInteger statusf = orderObj.statusf.integerValue;
    if (statusf==1 || statusf==0) {//在已接单状态，司机或货主可取消订单
        self.typeBtn.alpha = 1;
        [self.typeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
        }];
    }else{
        self.typeBtn.alpha = 0;
        [self.typeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}


@end
