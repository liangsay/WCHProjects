//
//  BaseTableView.h
//  YunZhangGui
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 worldunion.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableCell.h"
@interface BaseTableView : UITableView

#pragma mark - 刷新
#pragma mark 顶部刷新
/**
 *  添加顶部刷新组件
 */
- (void)addHeaderRefreshTarget:(id)target action:(SEL)action;

/**
 *  主动进入刷新状态
 */
- (void)beginHeaderRefresh;

/**
 *  结束顶部刷新
 */
- (void)endHeaderRefreshing;

/**
 *  移除顶部刷新组件
 */
- (void)removeHeaderRefresh;

#pragma mark 底部刷新
/**
 *  添加底部刷新组件
 */
- (void)addFooterRefreshTarget:(id)target action:(SEL)action;

/**
 *  结束底部刷新
 */
- (void)endFooterRefreshing;

/**
 *  移除底部刷新组件
 */
- (void)removeFooterRefresh;

@property (nonatomic, strong) UIView *placeView;
//@property (nonatomic, strong) NSString *placeStr;
@property (nonatomic, strong) UIImage *placeImage;

@property(nonatomic, strong) UIImageView *placeImageView;
@property(nonatomic, strong) UILabel *placeLabel;
@property(nonatomic, strong) UIControl *placeControl;
@property (nonatomic, strong) UIActivityIndicatorView *lodingView;
- (void)placeholderViewShow:(BOOL)isShow;
@end
