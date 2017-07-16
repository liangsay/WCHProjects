//
//  MineTableViewCell.h
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseTableCell.h"
FOUNDATION_EXPORT NSString * const kMineTableViewCellID;
FOUNDATION_EXPORT CGFloat const kMineTableViewCellHeight;

@interface MineCellModel : NSObject
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *typeIcon;
@end

@interface MineTableViewCell : BaseTableCell

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *typeLabel;

- (void)setupCellInfoWith:(MineCellModel *)model;
@end
