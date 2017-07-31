//
//  RentCarDetailOtherCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/30.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "RentCarDetailOtherCell.h"
NSString * const kRentCarDetailOtherCellID = @"kRentCarDetailOtherCellID";

@implementation RentCarDetailOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLab.preferredMaxLayoutWidth = kScreenWidth - 40;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWith:(OrderInfoObj *)orderObj {
    NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc] initWithString:orderObj.content];
    [contentAtt setTextColor:[UIColor fontGray]];
    [contentAtt setTextAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingTail lineSpacing:1.2 lineHeightMultiple:0];
    self.contentLab.attributedText = contentAtt;
}

@end
