//
//  ShopCollectionViewCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/7.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridListModel.h"

FOUNDATION_EXPORT NSString * const kShopCollectionViewCellID;
@interface ShopCollectionViewCell : UICollectionViewCell
/**
 0：列表视图，1：格子视图
 */
@property (nonatomic, assign) BOOL isGrid;
@property (nonatomic, strong) GridListModel *model;
@end
