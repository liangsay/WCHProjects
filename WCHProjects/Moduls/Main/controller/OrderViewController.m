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
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
@interface OrderViewController ()
<UITableViewDelegate,UITableViewDataSource,OrderTableCellDelegate>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单";
    
    [self setupTableViewSet];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)reloadOrderData {
    [self.tableView reloadData];
    [self.tableView placeholderViewShow:!self.dataArray.count];
}

- (void)onBackButton {
//    kAppDelegate.mainViewController.orderVC = nil;
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
    [_tableView registerClass:[OrderTableCell class] forCellReuseIdentifier:kOrderTableCellID];
    [self.tableView addHeaderRefreshTarget:self action:@selector(headerRefresh)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block OrderInfoObj *orderObj = self.dataArray[indexPath.row];
    CGFloat height = [OrderTableCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
        OrderTableCell *_cell = (OrderTableCell *)sourceCell;
        [_cell setupCellInfoWith:orderObj];
    }];
    
    return height;
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
//    if (self.isReceive) {
//        [NSString toast:@"您正在接单中"];
//        return;
//    }
    self.orderObj = orderObj;
    [self sendOrderdoTakeWithOrderObj:orderObj];
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
        [NSString toast:@"接单成功"];
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
