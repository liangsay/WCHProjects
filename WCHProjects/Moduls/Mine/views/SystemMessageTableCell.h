//
//  SystemMessageTableCell.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/4.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseTableCell.h"
#import "BaseModel.h"


FOUNDATION_EXPORT NSString * const kSystemMessageTableCellID;

@interface SystemMessageTableCell : BaseTableCell
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (void)setupCellInfoWith:(SystemMessageObj *)model;
@end
