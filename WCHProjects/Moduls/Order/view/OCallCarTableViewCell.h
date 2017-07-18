//
//  OCallCarTableViewCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * const kOCallCarTableViewCellID;
FOUNDATION_EXPORT CGFloat const kOCallCarTableViewCellHeight;

@interface OCallCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *startLab;

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *statueLab;

@property (nonatomic, strong) OrderInfoObj *orderObj;
- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj;
@end
