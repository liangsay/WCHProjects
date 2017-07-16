//
//  BaseTableCell.h
//  YunZhangGui
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 worldunion.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kBaseTableCellID;
FOUNDATION_EXPORT CGFloat const kBaseTableCellHeight;


typedef NS_ENUM(NSUInteger, CellLineStyle)
{
    CellLineStyleNone = 0,
    CellLineStyleShort,
    CellLineStyleLong,
    CellLineStyleRightLong,
    CellLineStyleAuto
};

@class BaseTableCell;

@protocol BaseTableCellDelegate <NSObject>

@optional
- (void)cell:(BaseTableCell *)cell tableView:(UITableView *)tableView didSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BaseTableCell : UITableViewCell

/**
 *  代理
 */
@property (nonatomic, weak) id<BaseTableCellDelegate> delegate;

@property (nonatomic, copy) NSIndexPath *cellIndexPath;


/**
 *  修改backgroundView为Button。
 *  去掉选中高亮效果方法：设backgroundView.enable = NO或removeFromSuperVie
 *  TableView的回调方法didSelectRowAtIndexPath将无效
 */
@property (nonatomic, strong) UIButton *backgroundBtnView;

/**
 *  底部分割线，初始长为整个cell。
 */
@property (nonatomic, strong) UIView *bottomLine;

/**
 *  底部分割线样式
 */
@property (nonatomic, assign) CellLineStyle bottomLineStyle;

/**
 *  顶部横线，初始长为整个cell。根据需要设hidden值为YES或NO
 */
@property (nonatomic, strong) UIView *topLine;

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
- (void)setupCellInfoWith:(id)model;

@end
