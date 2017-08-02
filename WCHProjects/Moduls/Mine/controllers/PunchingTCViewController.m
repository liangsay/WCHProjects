//
//  PunchingTCViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/8/2.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "PunchingTCViewController.h"

@interface PunchingTCViewController ()
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *onWorkBtn;
@property (weak, nonatomic) IBOutlet UIButton *offWorkBtn;

@end

@implementation PunchingTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.locationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.onWorkBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.offWorkBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
}

//重新定位
- (IBAction)locationBtnAction:(UIButton *)sender {
}

//上班打卡
- (IBAction)goWorkBtnAction:(UIButton *)sender {
}

//下班打卡
- (IBAction)offWorkBtnAction:(UIButton *)sender {
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
