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
    self.addressLab.preferredMaxLayoutWidth = kScreenWidth - 15 - 15;

    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    
    longPressGesture.minimumPressDuration=0.5f;//设置长按 时间
    [self.pressView addGestureRecognizer:longPressGesture];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若点击了tableViewCell，则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
    self.nameLab.text = [NSString stringWithFormat:@"%@[￥:%.2f元]",kIsObjectEmpty(orderObj.vehicleModelTypef)?@"--":orderObj.vehicleModelTypef,orderObj.rentMoneyf.doubleValue];
    self.startLab.text = orderObj.pickupDatef;
    self.endLab.text = orderObj.returnDatef;
    
    NSString *address = orderObj.returnLocationf;
    NSString *addressStr = [NSString stringWithFormat:@"取/还车地址:%@",address];
    NSMutableAttributedString *addrAtt = [[NSMutableAttributedString alloc] initWithString:addressStr];
    NSRange addressRange = [addressStr rangeOfString:address];
    [addrAtt setTextColor:[UIColor fontGray]];
    [addrAtt setTextColor:[UIColor fontBlack] range:addressRange];
    [addrAtt setFont:[UIFont fontAssistant]];
    self.addressLab.attributedText = addrAtt;
    //    0=待支付 1=已付款 2=订单结束  (isAssess=0 未评价  1=已评价) -1=订单作废
    NSInteger statusf = orderObj.statusf.integerValue;
//    if (statusf==0) {
//        self.typeLab.text = [NSString stringWithFormat:@"待支付金额:%@元",orderObj.rentMoneyf];
//    }else{
        self.typeLab.text = orderObj.statusTextf;
//    }
    if (statusf == 0) {

        self.pressView.alpha = 1;
    }else{
        self.pressView.alpha = 0;
    }
    
    
}
- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender {
    if ([self.oDelegate respondsToSelector:@selector(oRentCarTableViewCell:longPress:orderObj:)]) {
        [self.oDelegate oRentCarTableViewCell:self longPress:YES orderObj:self.orderObj];
    }
}

- (IBAction)typeBtnAction:(UIButton *)sender {
    [self longPressAction:nil];
}
@end
