//
//  MyOrderDetailViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/9/10.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "BaseTableView.h"
#import "OrderInComeTableCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
@interface MyOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,OrderInComeTableCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@end

@implementation MyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self setupTableViewSet];
    
}
- (void)setupTableViewSet {
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[OrderInComeTableCell class] forCellReuseIdentifier:kOrderInComeTableCellID];
    
}

#pragma mark --完成订单
- (IBAction)submitBtnAction:(UIButton *)sender {
    //完成订单
    [self sendOrderdoEnd_API:self.dataArray[0] indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark --取消订单
/**
 取消订单接口
 
 @param orderNof   订单号
 @param cancelManf 取消方  0货主 1司机
 */
- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self sendOrderdoCancelWithOrderNof:@"" cancelManf:@"1"];
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
            [NSString toast:@"该订单已完成"];
        }else{
            [NSString toast:@"该订单完成失败"];
        }
        [weakSelf onBackButton];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        [NSString toast:@"订单完成失败"];
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
    OrderInfoObj *order = self.dataArray[0];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:order.orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:cancelManf forKey:@"vo.cancelManf"];
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    
    [OrderInfoObj sendOrderdoCancelWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (response.responseCode == 1) {
            [NSString toast:@"订单取消成功"];
        }else{
            [NSString toast:@"订单取消失败"];
        }
        [weakSelf onBackButton];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"取消订单失败"];
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
