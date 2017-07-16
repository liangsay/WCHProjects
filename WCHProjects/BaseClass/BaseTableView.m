//
//  BaseTableView.m
//  YunZhangGui
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 worldunion.com.cn. All rights reserved.
//

#import "BaseTableView.h"
#import "MJRefresh.h"
@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *empty = [[UIView alloc] init];
        empty.backgroundColor = [UIColor backgroundColor];
        self.tableFooterView = empty;
        self.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //索引相关
        self.sectionIndexTrackingBackgroundColor=[UIColor clearColor];
        self.sectionIndexBackgroundColor = [UIColor clearColor];
        self.sectionIndexColor = [UIColor mainColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}



#pragma mark - 刷新
#pragma mark 顶部刷新
- (void)addHeaderRefreshTarget:(id)target action:(SEL)action
{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i=1; i<19; i++) {
        NSString *loadStr = [NSString stringWithFormat:@"loading-gray-%d",i];
        UIImage *loadImg = kIMAGE(loadStr);
        [idleImages addObject:[loadImg imageByScalingToSize:(CGSize){loadImg.size.width/2,loadImg.size.height/2}]];
    }
    // 设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle|MJRefreshStatePulling|MJRefreshStateRefreshing];
    header.backgroundColor = [UIColor backgroundColor];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    
//    [header setImages:pullingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    
//    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    self.mj_header = header;
//        if (self.mj_header && [self.mj_header isKindOfClass:[MJRefreshHeader class]]) return;
    //
//        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    
    
}

/**
 *  主动进入刷新状态
 */
- (void)beginHeaderRefresh
{
    [self.mj_header beginRefreshing];
}

- (void)endHeaderRefreshing
{
    if (self.mj_header)
    {
        [self.mj_header endRefreshing];
    }
}

- (void)removeHeaderRefresh
{
    [self removeHeader];
}

#pragma mark 底部刷新
- (void)addFooterRefreshTarget:(id)target action:(SEL)action
{
    if (self.mj_footer && [self.mj_footer isKindOfClass:[MJRefreshAutoNormalFooter class]]) return;
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    
    
    //    MJRefreshLegendFooter *footer = [self addLegendFooterWithRefreshingTarget:target refreshingAction:action];
    //    footer.textColor = [UIColor fontGray];
    //    footer.font = [UIFont fontContent];
}

- (void)endFooterRefreshing
{
    if (self.mj_footer)
    {
        [self.mj_footer endRefreshing];
    }
}

- (void)removeFooterRefresh
{
    [self removeFooter];
}

- (void)placeholderViewShow:(BOOL)isShow
{
    if (isShow) {
        [self setTableFooterView:self.placeView];
    }else{
        [self setTableFooterView:nil];
    }
}

- (UIView *)placeView{
    if (!_placeView) {
        _placeView = [[UIView alloc] initWithFrame:self.bounds];
        [_placeView setBackgroundColor:[UIColor clearColor]];
    }
    //    if (!_placeControl) {
    [_placeView addSubview:self.placeControl];
    //    }
    //    if (!_placeLabel) {
    [_placeView addSubview:self.placeLabel];
    //    }
    //    if (!_placeImageView) {
    [_placeView addSubview:self.placeImageView];
    //    }
    return _placeView;
}

- (UIImageView *)placeImageView{
    if (!_placeImageView) {
        _placeImageView = [[UIImageView alloc] init];
        _placeImageView.image = _placeImage==nil?kIMAGE(@"icon_nodata"):_placeImage;
        [_placeImageView setContentMode:UIViewContentModeCenter];
    }
    CGSize imgSize = _placeImageView.image.size;
    CGFloat viewY = (self.height-_placeLabel.height-imgSize.height)/2;
    [_placeImageView setFrame:(CGRect){(self.width-imgSize.width)/2,viewY,imgSize}];
    if ([NSString notEmptyOrNull:_placeLabel.text]) {
        _placeLabel.top = CGRectGetMaxY(_placeImageView.frame)+kMargin;
    }
    return _placeImageView;
}

- (UILabel *)placeLabel{
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] initWithFrame:(CGRect){kMargin,0,self.width-2*kMargin,0}];
        [_placeLabel setBackgroundColor:[UIColor clearColor]];
        [_placeLabel setFont:kFont(36)];
        _placeLabel.text = @"暂无数据";
        [_placeLabel setFrame:(CGRect){kMargin,0,self.width-2*kMargin,0}];
        [_placeLabel sizeOfStringWithMaxHeight:60];
        _placeLabel.font = kFont(30.0);
        [_placeLabel setTextColor:[UIColor fontGray]];
        [_placeLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _placeLabel;
}

- (UIActivityIndicatorView *)lodingView{
    if (!_lodingView) {
        _lodingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_lodingView setFrame:(CGRect){0,0,20,20}];
    }
    return _lodingView;
}

- (UIControl *)placeControl{
    if (!_placeControl) {
        _placeControl = [[UIControl alloc] initWithFrame:self.bounds];
        [_placeControl setBackgroundColor:[UIColor clearColor]];
    }
    return _placeControl;
}
@end
