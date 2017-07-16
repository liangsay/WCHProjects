//
//  ShopCollectionViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/7.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopCollectionViewCell.h"
#import "CommodityModel.h"
#import "UIImageView+WebCache.h"

NSString * const kShopCollectionViewCellID = @"kShopCollectionViewCellID";

@interface ShopCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation ShopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
        
    }
    return self;
}

- (void)configureUI
{
    _imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageV setContentMode:UIViewContentModeScaleAspectFill];
    _imageV.clipsToBounds = YES;
    [self.contentView addSubview:_imageV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = kFont(28);
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.font = kFont(32);
    [self.contentView addSubview:_priceLabel];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor borderColor];
    [self.contentView addSubview:_bottomLine];
    
}

- (void)setIsGrid:(BOOL)isGrid
{
    _isGrid = isGrid;
    
    if (isGrid) {
        _imageV.frame = CGRectMake(30, 15, self.bounds.size.width - 60, self.bounds.size.width - 60);
        _titleLabel.frame = CGRectMake(15, self.bounds.size.width - 35, kScreenWidth/2-30, 20);
        _priceLabel.frame = CGRectMake(15, self.bounds.size.width - 10, kScreenWidth/2-30, 20);
        self.bottomLine.alpha = 0;
    } else {
        _imageV.frame = CGRectMake(15, 5, self.bounds.size.height - 10, self.bounds.size.height - 10);
        _titleLabel.frame = CGRectMake(self.bounds.size.height + 10, 0, kScreenWidth-self.bounds.size.height - 10 -20, self.bounds.size.height - 30);
        _priceLabel.frame = CGRectMake(self.bounds.size.height + 10, self.bounds.size.height - 30, kScreenWidth-self.bounds.size.height - 10 -30, 20);
        _bottomLine.frame = (CGRect){_titleLabel.x,self.height-0.5,self.width-_titleLabel.x,0.5};
        self.bottomLine.alpha = 1;
    }
}

- (void)setModel:(GridListModel *)model
{
    _model = model;
    
    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:nil];
    _titleLabel.text = model.wname;
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.jdPrice];
}

@end
