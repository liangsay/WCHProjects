//
//  MyIncomeViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/3.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "MyIncomeViewController.h"
#import "MyRouteTableCell.h"
#import "BaseTableView.h"
#import "OrderInfoObj.h"
#import "AppraiseViewController.h"//评价
#import "UIViewController+MMDrawerController.h"
@interface MyIncomeViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableCellDelegate,MyRouteTableCellDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@end

@implementation MyIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupBackButton];
    [self setupTableViewSet];
    if (self.viewType==2) {
        [self sendOrdertoIncome];
    }
}

- (void)setupTableViewSet {
    
    [_totalView setLayerCornerRadius:35];
    [_totalView setLayerBorderWidth:5 color:[UIColor colorWithWhite:1 alpha:0.5]];
    _totalLabel.text = @"0.0";
    
    _tableView.backgroundColor = [UIColor backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[MyRouteTableCell class] forCellReuseIdentifier:kMyRouteTableCellID];
    [_tableView setRowHeight:kMyRouteTableCellHeight];
    
    UIView *theView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [theView setBackgroundColor:[UIColor backgroundColor]];
    [self.tableView setBackgroundView:theView];
//    [self.tableView addHeaderRefreshTarget:self action:@selector(headerRefresh)];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor backgroundColor];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kPadding;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    MyRouteTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyRouteTableCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.inComeDelegate = self;
    [cell setCellType:MyRouteTableCellTypeInCome];
    // Configure the cell...
    OrderInfoObj *model = self.dataArray[section];
    [cell setupCellInfoWith:model];
    return cell;
}

- (void)cell:(BaseTableCell *)cell tableView:(UITableView *)tableView didSelectAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    OrderInfoObj *orderObj = self.dataArray[section];
    //司机对货主评价
    BOOL assessOwerf = orderObj.assessOwerf.boolValue;
    if (orderObj.statusf.integerValue==3 && !assessOwerf) {
        //已完成支付才可以评价
        AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
        appraiseVC.orderObj =orderObj;
        appraiseVC.viewType=2;
        kPushNav(appraiseVC, YES);
    }else if (orderObj.statusf.integerValue==1){
        WEAKSELF
        [self.mm_drawerController
         closeDrawerAnimated:YES completion:^(BOOL finished) {
             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
         }];
        [kAppDelegate.mainViewController reciveOrderWithOrderObj:orderObj];
    }
    
}

#pragma mark --MyRouteTableCellDelegate
- (void)myRouteTableCell:(MyRouteTableCell *)myRouteTableCell orderObj:(OrderInfoObj *)orderObj cancelOrder:(BOOL)cancelOrder {
    [self sendOrderdoCancelWithOrderNof:orderObj.orderNof cancelManf:@""];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)headerRefresh {
    [self sendOrdertoIncome];
}

#pragma mark --用于查询司机的收入
- (void)sendOrdertoIncome {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].userNamef forKey:@"queryMap.driverIdf"];
    [OrderInfoObj sendOrdertoIncomeWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.dataArray = [NSMutableArray arrayWithArray:response.responseModel];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
        [weakSelf sendCalculateInCome];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
    }];
}

#pragma mark --取消订单接口
/**
 取消订单接口
 
 @param orderNof   订单号
 @param cancelManf 取消方  0货主 1司机
 */
- (void)sendOrderdoCancelWithOrderNof:(NSString *)orderNof cancelManf:(NSString *)cancelManf{
    WEAKSELF
    //vo.cancelManf 取消方  0货主 1司机
    cancelManf = @"1";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:cancelManf forKey:@"vo.cancelManf"];
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    
    [OrderInfoObj sendOrderdoCancelWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        kAppDelegate.mainViewController.isReciveState = NO;
        if ([kAppDelegate.mainViewController.reciveOrder.orderNof isEqual:orderNof]) {
            [kAppDelegate.mainViewController pCarorderBtnAction:nil];
        }
        [weakSelf sendOrdertoIncome];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        kAppDelegate.mainViewController.isReciveState = NO;
        if ([kAppDelegate.mainViewController.reciveOrder.orderNof isEqual:orderNof]) {
            [kAppDelegate.mainViewController pCarorderBtnAction:nil];
        }
        [weakSelf sendOrdertoIncome];
    }];
}

- (void)sendCalculateInCome {
    WEAKSELF
    __block double price = 0.0;
    [self.dataArray enumerateObjectsUsingBlock:^(OrderInfoObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.statusf.integerValue==3) {
            price += obj.pricef.doubleValue;
        }
        weakSelf.totalLabel.text = kDoubleToString(price);
    }];
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
