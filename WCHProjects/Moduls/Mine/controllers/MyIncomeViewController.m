//
//  MyIncomeViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/3.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "MyIncomeViewController.h"
#import "OrderInComeTableCell.h"
#import "BaseTableView.h"
#import "OrderInfoObj.h"
#import "AppraiseViewController.h"//评价
#import "UIViewController+MMDrawerController.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

@interface MyIncomeViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableCellDelegate,OrderInComeTableCellDelegate>
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
//    if (self.viewType==2) {
        [self sendOrdertoIncome];
//    }
}

- (void)setupTableViewSet {
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [_totalView setLayerCornerRadius:35];
    [_totalView setLayerBorderWidth:5 color:[UIColor colorWithWhite:1 alpha:0.5]];
    _totalLabel.text = @"0.0";
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[OrderInComeTableCell class] forCellReuseIdentifier:kOrderInComeTableCellID];
    [self.tableView addHeaderRefreshTarget:self action:@selector(refreshHeaderData)];
}

- (void)refreshHeaderData {
    [self sendOrdertoIncome];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block OrderInfoObj *orderObj = self.dataArray[indexPath.row];
    CGFloat height = [OrderInComeTableCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
        OrderInComeTableCell *_cell = (OrderInComeTableCell *)sourceCell;
        [_cell setupCellInfoWithObj:orderObj];
    }];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    OrderInComeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderInComeTableCellID forIndexPath:indexPath];
    cell.oDelegate = self;
    cell.cellIndexPath= indexPath;
    // Configure the cell...
    OrderInfoObj *model = self.dataArray[row];
    [cell setupCellInfoWithObj:model];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    OrderInfoObj *orderObj = self.dataArray[row];
    //司机对货主评价
//    BOOL assessOwerf = orderObj.assessOwerf.boolValue;
//    if (orderObj.statusf.integerValue==3 && !assessOwerf) {
//        //已完成支付才可以评价
//        AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
//        appraiseVC.orderObj =orderObj;
//        appraiseVC.viewType=2;
//        appraiseVC.objTypef = 1;
//        kPushNav(appraiseVC, YES);
//    }else if (orderObj.statusf.integerValue==1){
//        WEAKSELF
//        [self.mm_drawerController
//         closeDrawerAnimated:YES completion:^(BOOL finished) {
//             [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//         }];
//        //        [kAppDelegate.mainViewController reciveOrderWithOrderObj:orderObj];
//    }
}

#pragma mark --OrderInComeTableCellDelegate ----------
/*
 vo.ownerIdf	15889798801
 requestType	app
 vo.orderNof	15021969248834
 vo.driverIdf	13820633188
 */
- (void)orderInComeTableCell:(OrderInComeTableCell *)orderInComeTableCell isFinish:(BOOL)isFinish orderObj:(OrderInfoObj *)orderObj {
    
}

- (void)orderInComeTableCell:(OrderInComeTableCell *)orderInComeTableCell longPress:(BOOL)longPress orderObj:(OrderInfoObj *)orderObj {
    WEAKSELF
    [UIAlertController showAlertInViewController:self withTitle:@"完成订单" message:@"您确定要完成订单吗？" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex==2) {
            //完成订单
            [weakSelf sendOrderdoEnd_API:orderObj indexPath:orderInComeTableCell.cellIndexPath];
        }
    }];
    
}

#pragma mark --完成订单
- (void)sendOrderdoEnd_API:(OrderInfoObj *)orderObj indexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:orderObj.ownerIdf forKey:@"vo.ownerIdf"];
    [params addUnEmptyString:orderObj.orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:orderObj.driverIdf forKey:@"vo.driverIdf"];
    [OrderInfoObj sendOrderdoEndWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (response.responseCode==1) {
            orderObj.statusf = @"2";
            orderObj.statusTextf = @"未支付";
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:orderObj];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView endUpdates];
            [NSString toast:@"该订单已完成"];
        }
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"订单完成失败"];
    }];
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
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"queryMap.driverIdf"];
    [OrderInfoObj sendOrdertoIncomeWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.dataArray = [NSMutableArray arrayWithArray:response.responseModel];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
        [weakSelf sendCalculateInCome];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
        [NSString toast:response.responseMsg];
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
