//
//  CitysTableCell.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/19.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "CitysTableCell.h"
NSString * const kCitysTableCellID = @"kCitysTableCellID";;
CGFloat const kCitysTableCellHeight = 71;

@implementation CitysTableCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
   
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
    self.cityLabel.text = [NSString toString:model.namef];
    self.provinceLabel.text = [NSString toString:model.provincialNamef];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [super layoutIfNeeded];
    
}
@end
