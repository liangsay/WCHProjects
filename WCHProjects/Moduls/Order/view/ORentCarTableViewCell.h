//
//  ORentCarTableViewCell.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
FOUNDATION_EXPORT NSString * const kORentCarTableViewCellID;
FOUNDATION_EXPORT CGFloat const kORentCarTableViewCellHeight;
@interface ORentCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *startLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (nonatomic, strong) OrderInfoObj *orderObj;
- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj;
@end
