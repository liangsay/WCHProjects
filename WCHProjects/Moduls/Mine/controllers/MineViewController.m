//
//  MineViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "BaseTableView.h"
#import "UIViewController+MMDrawerController.h"
#import "MainNavigationViewController.h"
#import "MyRouteViewController.h"
#import "MyIncomeViewController.h"
#import "MyInfoViewController.h"
#import "CarRecruitViewController.h"
#import "MyWalletViewController.h"
#import "SystemNoticViewController.h"
#import "LinkmanUsViewController.h"
#import "CouponViewController.h"
#import "UserInfoObj.h"
#import "UIAlertController+Blocks.h"
#import "MainViewController.h"
#import "PersonSetViewController.h"
#import "UIAlertController+Blocks.h"
#import <UShareUI/UShareUI.h>
#import "JiKeViewController.h"
#import "PunchingTCViewController.h"
#import "DutytoDecideObj.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableCellDelegate>
{
    NSArray *_typesArray;
    NSArray *_othersArray;
    NSArray *_iconsArray;
}
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImgV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;


@end

@implementation MineViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.outBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.outBtn setLayerCornerRadius:5];
    _userNameLab.text = [UserInfoObj model].trueNamef;
    _mobileLab.text = [UserInfoObj model].mobilePhonef;
    
//    if ([UserInfoObj model].userTypef.integerValue!=2) {
//        _typesArray = @[@"我的行程",@"个人资料",@"车主招募",@"我的钱包",@"优惠券",@"系统通知",@"联系我们",@"周边地址",@"退出登录"];
//        _iconsArray = @[@"行程",@"个人资料",@"招募",
//                        @"钱包",@"优惠券",@"通知",@"联系我们",@"周边环境",@"退出登录"];
//        
//    }else{
//        _typesArray = @[@"我的行程",@"我的订单",@"个人资料",@"我的钱包",@"优惠券",@"系统通知",@"联系我们",@"周边地址",@"退出登录"];
//        _iconsArray = @[@"行程",@"收入",@"个人资料",
//                        @"钱包",@"优惠券",@"通知",@"联系我们",@"周边环境",@"退出登录"];
//    }
    
    _typesArray = @[@"优惠券",@"分享",@"司机招募",@"已接订单",@"个人设置",@"关于我们",@"客服中心4000-8000-966"];
    _othersArray = @[@"考勤打卡",@"集客"];
    
    [_tableView setRowHeight:kMineTableViewCellHeight];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:kMineTableViewCellID];
    
    UIView *theView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [theView setBackgroundColor:[UIColor backgroundColor]];
    [self.tableView setBackgroundView:theView];

//    [_userHeaderImgV setLayerCornerRadius:25/2];

}

#pragma mark    --退出登陆
- (IBAction)loginOutBtnAction:(UIButton *)sender {
    WEAKSELF
    [UIAlertController showAlertInViewController:self withTitle:@"退出提示" message:@"您是否要退出登陆?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 2) {
            [kAppDelegate showLoginVCWithLoginAction:^(NSInteger index) {
                
            }];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    if ([DutytoDecideObj model]==nil) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if (section==1) {
        return _othersArray.count;
    }
    return _typesArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([UserInfoObj model].userTypef.integerValue == 2) {
        if (indexPath.section==0 && indexPath.row==2) {
            return 0;
        }
        if (indexPath.section==0 && indexPath.row==3) {
            return kMineTableViewCellHeight;
        }
    }
    if ([UserInfoObj model].userTypef.integerValue == 1) {
        if (indexPath.section==0 && indexPath.row==2) {
            return kMineTableViewCellHeight;
        }
        if (indexPath.section==0 && indexPath.row==3) {
            return 0;
        }
    }
    return kMineTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headV = [UIView new];
    headV.backgroundColor = [UIColor backgroundColor];
    return headV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineTableViewCellID forIndexPath:indexPath];
    
    MineCellModel *mol = [MineCellModel new];
    if (section==0) {
        mol.typeName = _typesArray[indexPath.row];
    }else{
        mol.typeName = _othersArray[indexPath.row];
    }
    [cell setupCellInfoWith:mol];
    [cell setBottomLineStyle:CellLineStyleShort];
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (row==0) {
            //优惠券
            CouponViewController *vc = [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil];
            vc.navigationItem.title = @"优惠券";
            kPushNav(vc, YES);
        }else if (row==1){
            //分享
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession)]];
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作
                
            }];
        }else if (row==2){
            //司机招募
            CarRecruitViewController *vc = [[CarRecruitViewController alloc] initWithNibName:@"CarRecruitViewController" bundle:nil];
            vc.navigationItem.title = @"司机招募";
            kPushNav(vc, YES);
        }else if (row==3){
            //我的收入
            MyIncomeViewController *vc = [[MyIncomeViewController alloc] initWithNibName:@"MyIncomeViewController" bundle:nil];
            vc.navigationItem.title = @"已接订单";
            kPushNav(vc, YES);
        }else if (row==4){
            //个人设置
            PersonSetViewController *vc = [[PersonSetViewController alloc] initWithNibName:@"PersonSetViewController" bundle:nil];
            vc.navigationItem.title = @"个人设置";
            kPushNav(vc, YES);
        }else if (row==5){
            //关于我们
            LinkmanUsViewController *vc = [[LinkmanUsViewController alloc] initWithNibName:@"LinkmanUsViewController" bundle:nil];
            vc.navigationItem.title = @"关于我们";
            kPushNav(vc, YES);
        }else if (row==6){
            //客服中心
            [self.view makeCallWithPhone:@"4000800966"];
        }
    }else{
        if (row==0){
            //考勤打卡
            PunchingTCViewController *tcVC = [[PunchingTCViewController alloc] initWithNibName:@"PunchingTCViewController" bundle:nil];
            tcVC.navigationItem.title = @"考勤打卡";
            kPushNav(tcVC, YES);
        }else if(row==1){
            //集客
            JiKeViewController *jikeVC = [[JiKeViewController alloc] initWithNibName:@"JiKeViewController" bundle:nil];
            jikeVC.navigationItem.title = @"集客";
            kPushNav(jikeVC, YES);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight =10;// 25;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
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
