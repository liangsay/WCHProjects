//
//  MyRouteViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/3.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "MyRouteViewController.h"
#import "MyRouteTableCell.h"
#import "OrderInfoObj.h"
#import "BaseTableView.h"
#import "MyPayTypeViewController.h"
#import "AppraiseViewController.h"
@interface MyRouteViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableCellDelegate,MyPayTypeViewDelegate,MyRouteTableCellDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@end

@implementation MyRouteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupBackButton];
    [self setupTableViewSet];
    if (self.viewType==1) {
      [self sendOrdertoRoute];
    }

}

- (void)setupTableViewSet {
    
    UIView *theView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [theView setBackgroundColor:[UIColor backgroundColor]];
    [self.tableView setBackgroundView:theView];
    UIView *headerV = [UIView new];
    headerV.backgroundColor = [UIColor backgroundColor];
    headerV.frame = (CGRect){0,0,kScreenWidth,kPadding};
    self.tableView.tableHeaderView = headerV;
    
    _tableView.backgroundColor = [UIColor backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[MyRouteTableCell class] forCellReuseIdentifier:kMyRouteTableCellID];
    [_tableView setRowHeight:kMyRouteTableCellHeight];
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
    // Configure the cell...
    OrderInfoObj *model = self.dataArray[section];
    [cell setupCellInfoWith:model];
    
    return cell;
}

- (void)cell:(BaseTableCell *)cell tableView:(UITableView *)tableView didSelectAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    OrderInfoObj *obj = self.dataArray[section];
    
    //对司机评价
    BOOL assessDriverf = obj.assessDriverf.boolValue;
    //对货主评价
    BOOL assessOwerf = obj.assessOwerf.boolValue;
    //0:未接单 1：已接单 2：未支付  3:已支付 4：已取消
    NSInteger statusf = obj.statusf.integerValue;
    
    if (obj.statusf.integerValue==2) {
        [self sendDiscoupontoUserWithOrderObj:obj];
//        MyPayTypeViewController *payVC = [[MyPayTypeViewController alloc] initWithNibName:@"MyPayTypeViewController" bundle:nil];
//        payVC.title = @"支付方式";
//        payVC.delegate = self;
//        payVC.orderObj = obj;
//        kPushNav(payVC, YES);
    }else{
        if (!assessDriverf && statusf==3) {
            AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
            appraiseVC.orderObj =obj;
            appraiseVC.viewType=1;
            kPushNav(appraiseVC, YES);
        }
//        [NSString toast:obj.statusTextf];
    }
    
}

#pragma mark --MyRouteTableCellDelegate
- (void)myRouteTableCell:(MyRouteTableCell *)myRouteTableCell orderObj:(OrderInfoObj *)orderObj cancelOrder:(BOOL)cancelOrder {
    [self sendOrderdoCancelWithOrderNof:orderObj.orderNof cancelManf:@""];
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
    cancelManf = @"0";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:cancelManf forKey:@"vo.cancelManf"];
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    
    [OrderInfoObj sendOrderdoCancelWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        NSInteger result = [response.responseObject[@"result"] integerValue];
        if (response.responseCode && result==0) {
            [NSString toast:@"订单取消失败或因司机已接单了"];
            return ;
        }
//        kAppDelegate.mainViewController.isReciveState = NO;
//        if ([kAppDelegate.mainViewController.reciveOrder.orderNof isEqual:orderNof]) {
//            [kAppDelegate.mainViewController pCarorderBtnAction:nil];
//        }
        [weakSelf sendOrdertoRoute];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"网络请求异常"];
    }];
}

#pragma mark --优惠劵查询接口
- (void)sendDiscoupontoUserWithOrderObj:(OrderInfoObj *)orderObj{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[UserInfoObj model].mobilePhonef forKey:@"queryMap.phonef"];
    [params addUnEmptyString:@"0" forKey:@"isUsef"];
    [CoupontoUserObj sendDiscoupontoUserWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        NSArray *datas = response.responseModel;
        if (kISKIND_OF_CLASS_NSARRAY(datas) && datas.count) {
            __block CoupontoUserObj *coupontoObj = nil;
            [datas enumerateObjectsUsingBlock:^(CoupontoUserObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if(obj.couponCountf>=orderObj.pricef.doubleValue && obj.isUsef.integerValue==0 && !obj.isExpiryDatef){
                    coupontoObj = obj;
                    *stop = YES;
                }
            }];
            //如果优惠券金额>=订单金额，可以直接抵扣
            if (coupontoObj) {
                orderObj.couponIdf = coupontoObj.idf;
                [weakSelf sendDiscoupontoUseWithOrderObj:orderObj];
            }else{
                MyPayTypeViewController *payVC = [[MyPayTypeViewController alloc] initWithNibName:@"MyPayTypeViewController" bundle:nil];
                payVC.title = @"支付方式";
                payVC.delegate = self;
                payVC.orderObj = orderObj;
                kPushNav(payVC, YES);
                //                    [weakSelf.timer invalidate];
            }
        }else{
            MyPayTypeViewController *payVC = [[MyPayTypeViewController alloc] initWithNibName:@"MyPayTypeViewController" bundle:nil];
            payVC.title = @"支付方式";
            payVC.delegate = self;
            payVC.orderObj = orderObj;
            kPushNav(payVC, YES);
            //            [weakSelf.timer invalidate];
        }
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        MyPayTypeViewController *payVC = [[MyPayTypeViewController alloc] initWithNibName:@"MyPayTypeViewController" bundle:nil];
        payVC.title = @"支付方式";
        payVC.delegate = self;
        payVC.orderObj = orderObj;
        kPushNav(payVC, YES);
        //        [weakSelf.timer invalidate];
    }];
}

#pragma mark --优惠劵使用接口
- (void)sendDiscoupontoUseWithOrderObj:(OrderInfoObj *)orderObj{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:orderObj.orderNof forKey:@"orderNof"];
    [params addUnEmptyString:orderObj.couponIdf forKey:@"couponIdf"];
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    [OrderInfoObj sendCoupontoPayWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        //已完成支付才可以评价
        AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
        appraiseVC.orderObj =orderObj;
        appraiseVC.viewType = 1;
        kPushNav(appraiseVC, YES);
        [NSString toast:@"您的订单已用优惠券抵扣"];
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        //已完成支付才可以评价
        AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
        appraiseVC.orderObj =orderObj;
        appraiseVC.viewType = 1;
        kPushNav(appraiseVC, YES);
        [NSString toast:@"您的订单已用优惠券抵扣"];
    }];
}

#pragma mark --MyPayTypeViewDelegate
- (void)myPayTypeViewController:(MyPayTypeViewController *)myPayTypeViewController payStatus:(NSInteger)payStatus {
//    if (payStatus==1) {
        [self headerRefresh];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)headerRefresh {
    [self sendOrdertoRoute];
}

#pragma mark --用于查询我的行程
- (void)sendOrdertoRoute {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"queryMap.ownerIdf"];
    [OrderInfoObj sendOrdertoRouteWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.dataArray = [NSMutableArray arrayWithArray:response.responseModel];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [weakSelf.tableView endFooterRefreshing];
    }];
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
