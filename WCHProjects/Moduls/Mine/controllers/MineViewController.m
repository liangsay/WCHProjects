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

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableCellDelegate>
{
    NSArray *_typesArray;
    NSArray *_iconsArray;
}
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImgV;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _userNameLab.text = [UserInfoObj model].trueNamef;
    
    if ([UserInfoObj model].userTypef.integerValue!=2) {
        _typesArray = @[@"我的行程",@"个人资料",@"车主招募",@"我的钱包",@"优惠券",@"系统通知",@"联系我们",@"周边地址",@"退出登录"];
        _iconsArray = @[@"行程",@"个人资料",@"招募",
                        @"钱包",@"优惠券",@"通知",@"联系我们",@"周边环境",@"退出登录"];
        
    }else{
        _typesArray = @[@"我的行程",@"我的订单",@"个人资料",@"我的钱包",@"优惠券",@"系统通知",@"联系我们",@"周边地址",@"退出登录"];
        _iconsArray = @[@"行程",@"收入",@"个人资料",
                        @"钱包",@"优惠券",@"通知",@"联系我们",@"周边环境",@"退出登录"];
    }
    
    [_tableView setRowHeight:kMineTableViewCellHeight];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:kMineTableViewCellID];
    
    UIView *theView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [theView setBackgroundColor:[UIColor blackColor]];
    [self.tableView setBackgroundView:theView];

//    [_userHeaderImgV setLayerCornerRadius:25/2];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return _typesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMineTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor blackColor];
    cell.backgroundView.backgroundColor = [UIColor blackColor];;
    cell.contentView.backgroundColor = [UIColor blackColor];
    MineTableViewCell *_cell = (MineTableViewCell *)cell;
    [_cell.backgroundBtnView setBackgroundColor:[UIColor blackColor]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineTableViewCellID forIndexPath:indexPath];
    cell.delegate = self;
    MineCellModel *mol = [MineCellModel new];
    mol.typeName = _typesArray[indexPath.row];
    mol.typeIcon = _iconsArray[indexPath.row];
    [cell setupCellInfoWith:mol];
    cell.backgroundColor = [UIColor blackColor];
    // Configure the cell...
//    [cell setBottomLineStyle:row< _typesArray.count-1?CellLineStyleRightLong:CellLineStyleLong];
    cell.backgroundBtnView.backgroundImageColor = [UIColor blackColor];
    return cell;
}

- (void)cell:(BaseTableCell *)cell tableView:(UITableView *)tableView didSelectAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self.mm_drawerController
     closeDrawerAnimated:YES completion:^(BOOL finished) {
         
         
     }];
    NSInteger row = indexPath.row;
    if ([UserInfoObj model].userTypef.integerValue!=2) {
        if(row>0){
            row +=1;
        }
    }else{
        if (row>2){
            row +=1;
        }
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
