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
CGFloat const kCouponTableCellHeight = 80;

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
        [self.backgroundBtnView setBackgroundImageColor:[UIColor whiteColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [super layoutIfNeeded];
    [self.backgroundBtnView setLayerCornerRadius:4];
    WEAKSELF
    [self.backgroundBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, kPadding, 0, kPadding));
    }];
}


- (void)initUIViews {
    WEAKSELF
    UIImage *iconImg = kIMAGE(@"形状-1-拷贝-2");
    
    _iconImgV = [BaseViewServer addImageViewInView:self.backgroundBtnView image:[iconImg stretchableImageWithLeftCapWidth:20 topCapHeight:0] contentMode:UIViewContentModeScaleAspectFit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kMargin);
        make.centerY.equalTo(weakSelf.backgroundBtnView);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    
    _moneyLab = [BaseViewServer addLabelInView:self.backgroundBtnView font:kFont(32) text:@"" textColor:[UIColor whiteColor] textAilgnment:NSTextAlignmentCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakSelf.iconImgV);
        make.edges.equalTo(_iconImgV).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _typeLab = [BaseViewServer addLabelInView:self.backgroundBtnView font:kFont(32) text:@"" textColor:[UIColor fontGray] textAilgnment:NSTextAlignmentRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kMargin);
//        make.left.equalTo(weakSelf.iconImgV.mas_right).offset(kPadding);
        make.top.mas_equalTo(kPadding);
    }];
    
    _timeLab = [BaseViewServer addLabelInView:self.backgroundBtnView font:kFont(28) text:@"" textColor:[UIColor fontBlack] textAilgnment:NSTextAlignmentRight mas_makeConstraints:^(MASConstraintMaker *make) {
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
    if (model.isUsef.integerValue==1) {
        self.typeLab.text = [NSString stringWithFormat:@"%@[已使用]",model.titlef];
        self.typeLab.textColor = [UIColor fontGray];
    }else{
        self.typeLab.textColor = [UIColor fontBlack];
        self.typeLab.text = model.titlef;
    }
    self.moneyLab.text = [NSString stringWithFormat:@"%.2f元",model.couponCountf];
    self.timeLab.text = [NSString stringWithFormat:@"有效期:%@",model.expiryDatef];
}

@end
