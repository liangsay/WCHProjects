//
//  SystemMessageTableCell.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/4.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "SystemMessageTableCell.h"


NSString * const kSystemMessageTableCellID = @"kSystemMessageTableCellID";
@implementation SystemMessageTableCell

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

- (void)initUIViews {
    WEAKSELF
    
    _contentLabel = [BaseViewServer addLabelInView:self.backgroundBtnView font:kFont(28) text:@"" textColor:[UIColor fontBlack] textAilgnment:NSTextAlignmentLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kPadding);
        make.top.offset(kPadding);
        make.right.offset(-kPadding);
    }];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    _timeLabel = [BaseViewServer addLabelInView:self.backgroundBtnView font:kFont(28) text:@"" textColor:[UIColor fontGray] textAilgnment:NSTextAlignmentRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-kPadding);
        make.left.offset(kPadding);
        make.bottom.offset(-kPadding);
        make.top.equalTo(weakSelf.contentLabel.mas_bottom).offset(kPadding);
    }];
//    [self.contentView layoutIfNeeded];
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

- (NSMutableAttributedString *)getAttributesWithString1:(NSString *)str1 str2:(NSString *)str2 lab:(UILabel *)lab isOpen:(BOOL)isOpen{
    NSString *strDisplayText = [NSString stringWithFormat:@"%@%@",str1,str2];
    
    NSMutableAttributedString *attributedText = [[ NSMutableAttributedString alloc ] initWithString :strDisplayText];
    [attributedText setFont:kFont(28)];
    [attributedText setTextColor:[UIColor fontBlack]];
    [attributedText setTextAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping lineSpacing:1 lineHeightMultiple:1.2];
    
    lab.attributedText = attributedText;
    return attributedText;
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
- (void)setupCellInfoWith:(SystemMessageObj *)model {
    [self getAttributesWithString1:[NSString toString:model.contentf] str2:@"" lab:self.contentLabel isOpen:YES];
//    self.contentLabel.text = model.content;
    self.timeLabel.text = model.createTimef;
}

///当你是使用计算frame模式的时候，需要在cell里面实现sizeThatFits这个方法
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    size = (CGSize){self.backgroundBtnView.width-4*kPadding,size.height};
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    totalHeight += [self.timeLabel sizeThatFits:size].height;
    totalHeight += kPadding*2+5; // margins
    return CGSizeMake(size.width, totalHeight);
}
@end
