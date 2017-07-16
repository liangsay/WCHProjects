//
//  AboutUsTableCell.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/4.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseTableCell.h"
FOUNDATION_EXPORT NSString * const kAboutUsTableCellID;
FOUNDATION_EXPORT CGFloat const kAboutUsTableCellHeight;

@interface AboutUsModel : BaseModel
@property (nonatomic, strong) NSString *keyString;
@property (nonatomic, strong) NSString *valueString;
@end

@interface AboutUsTableCell : BaseTableCell
@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;

- (void)setupCellInfoWith:(AboutUsModel *)model;
@end
