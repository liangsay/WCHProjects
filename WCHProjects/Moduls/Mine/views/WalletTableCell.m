//
//  WalletTableCell.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/11.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "WalletTableCell.h"
NSString * const kWalletTableCellID = @"kWalletTableCellID";
CGFloat const kWalletTableCellHeight = 31;
@implementation WalletTableCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupCellInfoWith:(OrderInfoObj *)model {
    self.priceLabel.text = kDoubleToString(model.amountf.doubleValue);
    NSString *createTimef =[NSString stringWithFormat:@"%@",[NSString toString:model.createTimef]];
    self.timeLabel.text = createTimef;
//    self.timeLabel.font = [UIFont systemFontOfSize:14];
//    [self.timeLabel sizeToFit];
//    self.timeLabel.adjustsFontForContentSizeCategory = YES;
//    [self.timeLabel sizeToFit];
//    NSDate *date= [NSDate dateWithString:[NSString toString:model.createTimef] formatString:@"yyyy-MM-dd HH:mm:ss"];
//    self.timeLabel.text = [date formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceLabel.textColor = [UIColor redColor];
    self.timeLabel.textColor = [UIColor grayColor];
//    self.timeLabel.adjustsFontSizeToFitWidth = YES;
//    [self.timeLabel sizeToFit];
//    self.timeLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:14];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    [super layoutIfNeeded];
}
@end
