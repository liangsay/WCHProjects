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
    [self.typeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.typeBtn addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn setLayerCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
    self.nameLab.text = kIsObjectEmpty(orderObj.vehicleModelTypef)?@"--":orderObj.vehicleModelTypef;
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
    if (orderObj.statusf.integerValue == -1) {
        self.typeBtnHeight.constant = 0;
        self.typeBtnBottom.constant = 0;
        self.pressView.userInteractionEnabled = NO;
    }else{
        self.pressView.userInteractionEnabled = YES;
        self.typeBtnHeight.constant = 30;
        self.typeBtnBottom.constant = 10;
    }
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    
    longPressGesture.minimumPressDuration=1.5f;//设置长按 时间
    [self.pressView addGestureRecognizer:longPressGesture];
    
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
