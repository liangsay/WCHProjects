//
//  AboutUsTableCell.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/4.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "AboutUsTableCell.h"
NSString * const kAboutUsTableCellID = @"kAboutUsTableCellID";
CGFloat const kAboutUsTableCellHeight = 44;

@implementation AboutUsModel

@end

@implementation AboutUsTableCell

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
    }
    return self;
}

- (void)initUIViews {
    WEAKSELF
    
    _keyLabel = [BaseViewServer addLabelInView:self.contentView font:kFont(28) text:@"" textColor:[UIColor fontGray] textAilgnment:NSTextAlignmentLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kMargin);
        make.top.bottom.offset(0);
        make.width.mas_equalTo(72);
    }];
    
    _valueLabel = [BaseViewServer addLabelInView:self.contentView font:kFont(28) text:@"" textColor:[UIColor fontBlack] textAilgnment:NSTextAlignmentRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kMargin);
        make.centerY.equalTo(weakSelf.keyLabel);
        make.left.equalTo(weakSelf.keyLabel.mas_right);
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
- (void)setupCellInfoWith:(AboutUsModel *)model {
    self.keyLabel.text = model.keyString;
    self.valueLabel.text = model.valueString;
}
@end
