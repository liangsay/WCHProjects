//
//  JiKeTableViewCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/8/2.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kJiKeTableViewCellID;
FOUNDATION_EXPORT CGFloat const kJiKeTableViewCellHeight;
@interface JiKeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *contentTxtF;
- (void)setupCellInfoWith:(OrderInfoObj *)orderObj;
@end
