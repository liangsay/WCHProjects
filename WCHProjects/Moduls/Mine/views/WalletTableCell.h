//
//  WalletTableCell.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/11.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseTableCell.h"
#import "OrderInfoObj.h"

FOUNDATION_EXPORT NSString * const kWalletTableCellID;
FOUNDATION_EXPORT CGFloat const kWalletTableCellHeight;
@interface WalletTableCell : BaseTableCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeTxtF;

- (void)setupCellInfoWith:(OrderInfoObj *)model;
@end
