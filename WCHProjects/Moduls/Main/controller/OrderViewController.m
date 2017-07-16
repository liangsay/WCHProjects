//
//  OrderViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableCell.h"
#import "OrderInfoObj.h"
#import "BaseTableView.h"
@interface OrderViewController ()
<UITableViewDelegate,UITableViewDataSource,OrderTableCellDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单";
    
    [self setupTableViewSet];
    
    [self headerRefresh];
}

- (void)onBackButton {
    kAppDelegate.mainViewController.orderVC = nil;
    [super onBackButton];
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
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderTableCell class]) bundle:nil] forCellReuseIdentifier:kOrderTableCellID];
    [_tableView setRowHeight:kOrderTableCellHeight];
    [self.tableView addHeaderRefreshTarget:self action:@selector(headerRefresh)];
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
    OrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrderTableCellID forIndexPath:indexPath];
    cell.orderDelegate = self;
    OrderInfoObj *model = self.dataArray[section];
    [cell setupCellInfoWith:model];
    return cell;
}

#pragma mark --OrderTableCellDelegate
- (void)orderTableCell:(OrderTableCell *)orderTableCell orderObj:(OrderInfoObj *)orderObj {
    if (self.isReceive) {
        [NSString toast:@"您正在接单中"];
        return;
    }
    self.orderObj = orderObj;
    [self sendOrderdoTakeWithOrderObj:orderObj];
}

- (void)headerRefresh {
    [self sendOrdertoDone];
}

#pragma mark --用于获得待接订单
- (void)sendOrdertoDone {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.ownerIdf"];
    [params addUnEmptyString:[UserInfoObj model].provincef forKey:@"vo.provincef"];
    [params addUnEmptyString:[UserInfoObj model].cityf forKey:@"vo.cityf"];
    [params addUnEmptyString:self.startLocationf forKey:@"vo.startLocationf"];
    [params addUnEmptyString:@"YES" forKey:kIsHideLoadingView];
    [OrderInfoObj sendOrdertoDoneWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.dataArray = response.responseModel;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
        [weakSelf.tableView endFooterRefreshing];
    }];
}

#pragma mark --用于接单
- (void)sendOrderdoTakeWithOrderObj:(OrderInfoObj *)orderObj{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.driverIdf"];
    [params addUnEmptyString:orderObj.orderNof forKey:@"vo.orderNof"];
    [OrderInfoObj sendOrderdoTakeWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        NSInteger result = [response.responseObject[@"result"] integerValue];
        if (result==0 && response.responseCode) {
            [NSString stringWithFormat:@"订单已被货主取消"];
            return ;
        }
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(orderViewController:orderObj:isOrderRecive:)]) {
            [weakSelf.delegate orderViewController:weakSelf orderObj:weakSelf.orderObj isOrderRecive:YES];
        }
        [weakSelf onBackButton];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
         [NSString toast:@"网络请求异常"];
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
