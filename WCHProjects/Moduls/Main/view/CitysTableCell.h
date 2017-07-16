//
//  CitysTableCell.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/19.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseTableCell.h"
#import "OrderInfoObj.h"
FOUNDATION_EXPORT NSString * const kCitysTableCellID;
FOUNDATION_EXPORT CGFloat const kCitysTableCellHeight;
@interface CitysTableCell : BaseTableCell
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
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
- (void)setupCellInfoWith:(OrderInfoObj *)model;
@end
