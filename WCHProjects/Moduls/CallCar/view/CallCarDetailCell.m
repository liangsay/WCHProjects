//
//  CallCarDetailCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/8/1.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "CallCarDetailCell.h"
NSString * const kCallCarDetailCellID = @"kCallCarDetailCellID";
CGFloat const kCallCarDetailCellHeight = 44;
@implementation CallCarDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.descLab.preferredMaxLayoutWidth = kScreenWidth - 80;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//删除途径点
- (IBAction)closeBtnAction:(UIButton *)sender {
    if ([self.cDelegate respondsToSelector:@selector(callCarDetailCell:closeBtn:)]) {
        [self.cDelegate callCarDetailCell:self closeBtn:self.closeBtn];
    }
}

- (void)setupCellInfoWith:(OrderInfoObj *)orderObj {
    if (orderObj.isMust) {
        self.closeBtn.alpha = 0;
    }else{
        self.closeBtn.alpha = 1;
    }
    [self.closeBtn setTag:self.cellIndexPath.row];
    
    self.typeImgV.image = kIMAGE(orderObj.iconName);
    self.contentLab.placeholder = orderObj.placeholder;
    self.descLab.text = orderObj.content;
    if (kIsObjectEmpty(orderObj.content)) {
        self.descLab.alpha = 0;
        self.contentLab.alpha = 1;
    }else{
        self.descLab.alpha = 1;
        self.contentLab.alpha = 0;
    }
}

@end
