//
//  BaseTableCell.m
//  YunZhangGui
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 worldunion.com.cn. All rights reserved.
//

#import "BaseTableCell.h"
NSString * const kBaseTableCellID = @"kBaseTableCellID";
CGFloat const kBaseTableCellHeight = 44;

@implementation BaseTableCell
{
    UIButton *_backgroundBtnView;
}

#pragma mark --cell数据
/*!
 *  @author liujinliang, 16-09-13 11:09:54
 *
 *  @brief cell数据
 *
 *  @param model <#model description#>
 *
 *  @since <#1.0#>
 */
- (void)setupCellInfoWith:(id)model {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled = YES;
        
        // 背景
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.userInteractionEnabled = YES;
        
//        [self backgroundView];
        
        [self topLine];
        // 分割线
        [self bottomLine];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (CellLineStyleNone == self.bottomLineStyle)
    {
        self.bottomLine.hidden = YES;
    }
    else if (CellLineStyleShort == self.bottomLineStyle)
    {
        self.bottomLine.hidden = NO;
        self.bottomLine.frame = CGRectMake(kMargin, self.height - 0.5, self.width - kMargin * 2, 0.5);
        [self bringSubviewToFront:self.bottomLine];
    }
    else if (CellLineStyleLong == self.bottomLineStyle)
    {
        self.bottomLine.hidden = NO;
        self.bottomLine.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
        [self bringSubviewToFront:self.bottomLine];
    }else if (CellLineStyleRightLong==self.bottomLineStyle)
    {
        self.bottomLine.hidden = NO;
        self.bottomLine.frame = (CGRect){kMargin,self.height - 0.5,self.width-kMargin,.5};
        
    }
}

#pragma mark - 背景
- (void)onBackgroundView
{
    NSIndexPath *indexPath = nil;
    
    id view = [self superview];
    while (view && ![view isKindOfClass:[UITableView class]])
    {
        view = [view superview];
    }
    if (!view || ![view isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    UITableView *tableView = view;
    indexPath = [tableView indexPathForCell:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:tableView:didSelectAtIndexPath:)])
    {
        [self.delegate cell:self tableView:tableView didSelectAtIndexPath:indexPath];
    }
}

- (UIButton *)backgroundView
{
    if (!_backgroundBtnView)
    {
        _backgroundBtnView = [[UIButton alloc] initWithFrame:self.bounds];
        [_backgroundBtnView setBackgroundColor:[UIColor clearColor]];
        [_backgroundBtnView setBackgroundImageColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backgroundBtnView setBackgroundImageColor:[UIColor backgroundColor] forState:UIControlStateHighlighted];
        [_backgroundBtnView setBackgroundImageColor:[UIColor backgroundColor] forState:UIControlStateSelected];
        _backgroundBtnView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [_backgroundBtnView addTarget:self action:@selector(onBackgroundView) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.contentView.subviews.count > 0)
        {
            [self.contentView insertSubview:_backgroundBtnView atIndex:0];
        }
        else
        {
            [self.contentView addSubview:_backgroundBtnView];
        }
    }
    return _backgroundBtnView;
}

- (void)setBackgroundView:(UIButton *)backgroundView
{
    _backgroundBtnView = backgroundView;
}

#pragma mark - 分割线
- (UIView *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor borderColor];
        _bottomLine.hidden = YES;
        
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (void)setBottomLineStyle:(CellLineStyle)bottomLineStyle
{
    _bottomLineStyle = bottomLineStyle;
    [self setNeedsLayout];
}

- (UIView *)topLine
{
    if (!_topLine)
    {
        _topLine = [[UIView alloc] init];
        _topLine.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _topLine.backgroundColor = [UIColor borderColor];
        [_topLine setHidden:YES];
        [self addSubview:_topLine];
    }
    [self bringSubviewToFront:_topLine];
    return _topLine;
}
@end
