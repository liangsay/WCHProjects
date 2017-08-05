//
//  OrderTableCell.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/5.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "OrderTableCell.h"
#import "UIAlertView+ICBlockAdditions.h"
NSString * const kOrderTableCellID = @"kOrderTableCellID";
CGFloat const kOrderTableCellHeight = 91;
@implementation OrderTableCell

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
        
        self.backgroundColor = [UIColor backgroundColor];
        self.contentView.backgroundColor = [UIColor backgroundColor];
        self.backgroundView.backgroundColor = [UIColor backgroundColor];
        
        [self.backgroundBtnView setBackgroundImageColor:[UIColor whiteColor]];
        [self.backgroundBtnView setTitleColor:[UIColor fontGray] forState:UIControlStateHighlighted];
    }
    return self;
}



#pragma mark --抢单事件响应
/*!
 *  @author liujinliang, 16-10-05 22:10:13
 *
 *  @brief 抢单事件响应
 *
 *  @param sender <#sender description#>
 *
 *  @since <#1.0#>
 */
- (IBAction)orderBtnAction:(UIButton *)sender{
    WEAKSELF
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定抢单吗?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger buttonIndex) {
        if (weakSelf.orderDelegate && [weakSelf.orderDelegate respondsToSelector:@selector(orderTableCell:orderObj:)]) {
            [weakSelf.orderDelegate orderTableCell:weakSelf orderObj:weakSelf.orderObj];
        }
    } onCancel:^{
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.orderBtn setLayerCornerRadius:4];
    [self.orderBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.bgView setLayerCornerRadius:8];
    self.backgroundColor = [UIColor backgroundColor];
    self.contentView.backgroundColor = [UIColor backgroundColor];
    self.backgroundView.backgroundColor = [UIColor backgroundColor];
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
- (void)setupCellInfoWith:(OrderInfoObj *)model {
    self.orderObj = model;
    self.startLab.text = [NSString toString:model.startAddrNamef];
    self.endLab.text = [NSString toString:model.endAddrNamef];
    self.carLab.text = [NSString toString:model.modelNamef];
    self.priceLab.text = kDoubleToString([[NSString toString:model.tipPricef] doubleValue]+[[NSString toString:model.pricef] doubleValue]);
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
@end
