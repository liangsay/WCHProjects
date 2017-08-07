//
//  ShopDetailBuyView.m
//  WCHProjects
//
//  Created by liu jinliang on 2017/8/5.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopDetailBuyView.h"
#import "UIImageView+WebCache.h"
@implementation ShopDetailBuyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (ShopDetailBuyView *)showAlertViewInVC:(BaseViewController *)vc orderObj:(OrderInfoObj *)orderObj count:(NSInteger)count complete:(ShopDetailBuyComplete)complete {
    for (UIView *view in kWindow.subviews) {
        if ([view isKindOfClass:[ShopDetailBuyView class]]) {
            [view removeFromSuperview];
        }
    }
    ShopDetailBuyView *showView = [[NSBundle mainBundle] loadNibNamed:@"ShopDetailBuyView" owner:nil options:nil].firstObject;
    showView.count = count;
    showView.complete = complete;
    showView.orderObj = orderObj;
    showView.alpha = 0;
    NSURL *imgUrl = kURLFromString(fullImageUrl(orderObj.diskFilePathf));
    [showView.shopImgV sd_setImageWithURL:imgUrl placeholderImage:nil];
    [showView setupViewSet];
    [kWindow addSubview:showView];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [showView layoutIfNeeded];
    [showView show];
    
    return showView;
}

- (void)setupViewSet {
    [self.shopImgV setLayerCornerRadius:5];
    [self.shopImgV setLayerBorderWidth:0.5 color:[UIColor borderColor]];
    self.numsLab.text = kIntegerToString(self.count);
    
    [self.downBtn setBackgroundImage:[UIImage imageWithColor:[UIColor fontLightGray]] forState:UIControlStateNormal];
    [self.downBtn setLayerCornerRadius:1];
    [self.upBtn setBackgroundImage:[UIImage imageWithColor:[UIColor fontLightGray]] forState:UIControlStateNormal];
    [self.upBtn setLayerCornerRadius:1];
    [self.numsLab setLayerCornerRadius:1];
    self.numsLab.backgroundColor = [UIColor lightTextColor];
    
    [self.submitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.submitBtn setLayerCornerRadius:5];
    self.alertViewBottom.constant = - 120;
}

- (void)setCount:(NSInteger)count {
    if (count>1) {
        _count = 1;
    }else{
    }
    _count = count;
    
}

//立即购买
- (IBAction)submitBtn:(id)sender {
    if (self.complete) {
        self.complete(self.count);
    }
    [self hide];
}

- (IBAction)closeGestureAction:(id)sender {
    [self hide];
}

- (IBAction)downBtnAction:(id)sender {
    if (self.count>1) {
        self.count -= 1;
    }
    self.numsLab.text = kIntegerToString(self.count);
}

- (IBAction)upBtnAction:(id)sender {
    if (self.orderObj.maxCountf.integerValue>0) {
        if (self.count<10) {
            self.count += 1;
        }else{
            [NSString toast:@"已超过最大购买数量"];
        }
    }else{
        self.count += 1;
    }
    self.numsLab.text = kIntegerToString(self.count);
}


- (void)show {
    
    WEAKSELF
    weakSelf.alertViewBottom.constant = 0;
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.alpha = 1;
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide{
    WEAKSELF
    weakSelf.alertViewBottom.constant = -120;
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.alpha = 1;
        [weakSelf layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
    
}

@end
