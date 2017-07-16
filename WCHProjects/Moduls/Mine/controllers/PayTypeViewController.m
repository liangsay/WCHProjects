//
//  PayTypeViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/12.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "PayTypeViewController.h"

@interface PayTypeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewLayoutConstraint;
@property (nonatomic, assign) float height;
@end

@implementation PayTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.cancelBtn setLayerCornerRadius:20];
    [self.cancelBtn setLayerBorderWidth:0.5 color:[UIColor mainColor]];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    self.view.alpha = 0;
}

#pragma mark --显示view
- (void)showPayView {
    self.height = 177;
    WEAKSELF
//    [UIView animateWithDuration:.35 animations:^{
//        weakSelf.view.alpha = 1;
//        weakSelf.menuViewLayoutConstraint.constant = 200;
//    }];
    
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - updateViewConstraints
- (void)updateViewConstraints {
    WEAKSELF
    self.menuViewLayoutConstraint.constant = self.height;
    [UIView animateWithDuration:.35 animations:^{
        weakSelf.view.alpha = weakSelf.height>0;
    }];
    [super updateViewConstraints];
}

#pragma mark --隐藏view
- (void)hidePayView {
    self.height = 0;
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
/**
 充值:微信、支付宝

 @param sender <#sender description#>
 */
- (IBAction)payTypeBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payTypeViewController:payType:)]) {
        [self.delegate payTypeViewController:self payType:sender.tag];
    }
    [self hidePayView];
}


/**
 取消

 @param sender <#sender description#>
 */
- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self hidePayView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
