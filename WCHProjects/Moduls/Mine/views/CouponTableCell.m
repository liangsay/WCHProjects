//
//  CouponTableCell.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/5.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "CouponTableCell.h"

@implementation CouponModel

@end

NSString * const kCouponTableCellID = @"kCouponTableCellID";
CGFloat const kCouponTableCellHeight = 70;

@implementation CouponTableCell

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUIViews];
        self.backgroundColor = [UIColor backgroundColor];
        self.contentView.backgroundColor = [UIColor backgroundColor];
        self.backgroundView.backgroundColor = [UIColor backgroundColor];
        self.backgroundBtnView.userInteractionEnabled = YES;
        [self.backgroundBtnView setBackgroundImageColor:[UIColor mainColor]];
       
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [super layoutIfNeeded];
    [self.backgroundBtnView setLayerCornerRadius:10];
    WEAKSELF
    [self.backgroundBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, kPadding, 0, kPadding));
    }];
}


- (void)initUIViews {
    WEAKSELF
    
    _moneyLab = [BaseViewServer addLabelInView:self.backgroundBtnView font:kFont(32) text:@"" textColor:[UIColor whiteColor] textAilgnment:NSTextAlignmentCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(weakSelf.backgroundBtnView);
    }];
    
    _typeLab = [BaseViewServer addLabelInView:self.backgroundBtnView font:kFont(32) text:@"" textColor:[UIColor whiteColor] textAilgnment:NSTextAlignmentRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kMargin);
//        make.left.equalTo(weakSelf.iconImgV.mas_right).offset(kPadding);
        make.top.mas_equalTo(kPadding);
    }];
    
    _timeLab = [BaseViewServer addLabelInView:self.backgroundBtnView font:kFont(28) text:@"" textColor:[UIColor whiteColor] textAilgnment:NSTextAlignmentRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kMargin);
//        make.left.equalTo(weakSelf.iconImgV.mas_right).offset(kPadding);
        make.bottom.mas_equalTo(-kPadding);
    }];
    
}

#pragma mark --行数据显示
/*!
 *  @author liujinliang, 16-10-04 13:10:06
 *
 *  @brief 行数据显示
 *
 *  @param model <#model description#>
 *
 *  @since <#1.0#>
 */
- (void)setupCellInfoWith:(CoupontoUserObj *)model {
//    if (model.isUsef.integerValue==1) {
//        self.typeLab.text = [NSString stringWithFormat:@"%@[已使用]",model.titlef];
//        self.typeLab.textColor = [UIColor fontGray];
//    }else{
//        self.typeLab.textColor = [UIColor fontBlack];
        self.typeLab.text = model.titlef;
//    }
//    self.moneyLab.text = [NSString stringWithFormat:@"%.2f元",model.couponCountf];
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%.1f",model.couponCountf];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange priceRange = [priceStr rangeOfString:@"￥"];
    [priceAtt setFont:kFont(72)];
    [priceAtt setFont:[UIFont fontAssistant] range:priceRange];
    self.moneyLab.attributedText = priceAtt;
    
    self.timeLab.text = [NSString stringWithFormat:@"到期时间:%@",model.expiryDatef];
}

@end
