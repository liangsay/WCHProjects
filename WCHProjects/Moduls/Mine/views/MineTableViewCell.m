//
//  MineTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "MineTableViewCell.h"
#import "BaseViewServer.h"
NSString * const kMineTableViewCellID = @"kMineTableViewCellID";
CGFloat const kMineTableViewCellHeight = 44;

@implementation MineCellModel

@end
@implementation MineTableViewCell

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
        [self setupUIViews];
        
    }
    return self;
}

- (void)setupUIViews {
    WEAKSELF
    _typeImageView = [BaseViewServer addImageViewInView:self.contentView image:kIMAGE(@"icon_work_notice") contentMode:UIViewContentModeScaleAspectFit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kMargin);
        make.centerY.equalTo(weakSelf);
        make.width.height.mas_equalTo(0);
    }];
    _typeImageView.backgroundColor = [UIColor clearColor];
    
    _typeLabel = [BaseViewServer addLabelInView:self.contentView font:[UIFont fontContent] text:@"" textColor:[UIColor fontGray] textAilgnment:NSTextAlignmentLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.typeImageView.mas_right).offset(kPadding);
        make.top.bottom.right.offset(0);
    }];
    _typeLabel.backgroundColor = [UIColor clearColor];
}

- (void)setupCellInfoWith:(MineCellModel *)model {
    self.typeImageView.image = kIMAGE(model.typeIcon);
    self.typeLabel.text = model.typeName;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}
@end
