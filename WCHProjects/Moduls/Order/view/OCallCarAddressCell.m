//
//  OCallCarAddressCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/8/2.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "OCallCarAddressCell.h"
NSString * const kOCallCarAddressCellID = @"kOCallCarAddressCellID";
CGFloat const kOCallCarAddressCellHeight = 58;
@implementation OCallCarAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addressLab.preferredMaxLayoutWidth = kScreenWidth - 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
    
    self.nameLab.text = kIsObjectEmpty(orderObj.namef)?@"--":orderObj.namef;
    self.mobileLab.text = kIsObjectEmpty(orderObj.phonef)?@"--":orderObj.phonef;
    self.addressLab.text =kIsObjectEmpty(orderObj.addressf)?@"--":orderObj.addressf;
    
}

@end
