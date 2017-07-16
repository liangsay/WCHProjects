//
//  ShopCollectionViewLayout.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/7.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopCollectionViewLayout.h"

@implementation ShopCollectionViewLayout
#pragma mark --CollectionView
- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        // 创建UICollectionViewLayoutAttributes
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        // 设置布局属性
        CGFloat width = self.collectionView.frame.size.width * 0.5;
        if (i == 0) {
            CGFloat height = width;
            CGFloat x = 0;
            CGFloat y = 0;
            attrs.frame = CGRectMake(x, y, width, height);
        } else if (i == 1) {
            CGFloat height = width * 0.5;
            CGFloat x = width;
            CGFloat y = 0;
            attrs.frame = CGRectMake(x, y, width, height);
        } else if (i == 2) {
            CGFloat height = width * 0.5;
            CGFloat x = width;
            CGFloat y = height;
            attrs.frame = CGRectMake(x, y, width, height);
        } else if (i == 3) {
            CGFloat height = width * 0.5;
            CGFloat x = 0;
            CGFloat y = width;
            attrs.frame = CGRectMake(x, y, width, height);
        } else if (i == 4) {
            CGFloat height = width * 0.5;
            CGFloat x = 0;
            CGFloat y = width + height;
            attrs.frame = CGRectMake(x, y, width, height);
        } else if (i == 5) {
            CGFloat height = width;
            CGFloat x = width;
            CGFloat y = width;
            attrs.frame = CGRectMake(x, y, width, height);
        } else {
            UICollectionViewLayoutAttributes *lastAttrs = self.attrsArray[i - 6];
            CGRect lastFrame = lastAttrs.frame;
            lastFrame.origin.y += 2 * width;
            attrs.frame = lastFrame;
        }
        
        // 添加UICollectionViewLayoutAttributes
        [self.attrsArray addObject:attrs];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

- (CGSize)collectionViewContentSize
{
    int count = (int)[self.collectionView numberOfItemsInSection:0];
    int rows = (count + 3 - 1) / 3;
    CGFloat rowH = self.collectionView.frame.size.width * 0.5;
    return CGSizeMake(0, rows * rowH);
}
@end
