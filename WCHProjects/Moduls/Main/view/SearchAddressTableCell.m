//
//  SearchAddressTableCell.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/8.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "SearchAddressTableCell.h"
NSString * const kSearchAddressTableCellID = @"kSearchAddressTableCellID";
CGFloat const kSearchAddressTableCellHeight = 60;
@implementation SearchAddressTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUIViews];
    }
    return self;
}

- (void)initUIViews {
    
    _titleLab = [BaseViewServer addLabelInView:self.contentView font:kFont(28) text:@"" textColor:[UIColor fontBlack] textAilgnment:NSTextAlignmentLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kMargin);
        make.right.offset(-kMargin);
        make.top.offset(kPadding);
    }];
    
    _detailLab = [BaseViewServer addLabelInView:self.contentView font:kFont(28) text:@"" textColor:[UIColor fontGray] textAilgnment:NSTextAlignmentLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kMargin);
        make.right.offset(-kMargin);
        make.bottom.offset(-kPadding);
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
- (void)setupCellInfoWith:(SearchAddressObj *)model {
    self.titleLab.text = model.title;
    self.detailLab.text = model.detail;
}

@end

@implementation SearchAddressObj

@end
