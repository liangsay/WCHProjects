//
//  CallCarDetailCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/8/1.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kCallCarDetailCellID;
FOUNDATION_EXPORT CGFloat const kCallCarDetailCellHeight;

@class CallCarDetailCell;
@protocol CallCarDetailCellDelegate <NSObject>

- (void)callCarDetailCell:(CallCarDetailCell *)callCarDetailCell closeBtn:(UIButton *)closeBtn;

@end

@interface CallCarDetailCell : BaseTableCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UITextField *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, assign) id<CallCarDetailCellDelegate> cDelegate;
- (void)setupCellInfoWith:(OrderInfoObj *)orderObj;
@end
