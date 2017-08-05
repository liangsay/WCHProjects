//
//  ShopDetailBuyView.h
//  WCHProjects
//
//  Created by liu jinliang on 2017/8/5.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ShopDetailBuyComplete)(NSInteger count);

@interface ShopDetailBuyView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *shopImgV;
@property (weak, nonatomic) IBOutlet UILabel *numsLab;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (copy, nonatomic) ShopDetailBuyComplete complete;
@property (nonatomic, strong) OrderInfoObj *orderObj;
@property (nonatomic, assign) NSInteger count;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewBottom;

+ (ShopDetailBuyView *)showAlertViewInVC:(BaseViewController *)vc orderObj:(OrderInfoObj *)orderObj count:(NSInteger)count complete:(ShopDetailBuyComplete)complete;

@end
