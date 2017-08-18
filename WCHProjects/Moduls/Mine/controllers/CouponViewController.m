//
//  CouponViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/3.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponTableCell.h"
#import "BaseTableView.h"
@interface CouponViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
    [self headerRefresh];
}

- (void)setupTableViewSet {
    
    UIView *theView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [theView setBackgroundColor:[UIColor backgroundColor]];
    [self.tableView setBackgroundView:theView];
    
    _tableView.backgroundColor = [UIColor backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[CouponTableCell class] forCellReuseIdentifier:kCouponTableCellID];
    [_tableView setRowHeight:kCouponTableCellHeight];
    
    UIView *headerV = [UIView new];
    headerV.backgroundColor = [UIColor backgroundColor];
    headerV.frame = (CGRect){0,0,kScreenWidth,kPadding};
    self.tableView.tableHeaderView = headerV;
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
    CouponTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCouponTableCellID forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setupCellInfoWith:_dataArray[section]];
    return cell;
}

- (void)headerRefresh {
    [self sendDiscoupontoUser];
}

#pragma mark --优惠劵查询接口
- (void)sendDiscoupontoUser {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[UserInfoObj model].mobilePhonef forKey:@"queryMap.phonef"];
    [params addUnEmptyString:@"0" forKey:@"queryMap.isUsef"];
    [CoupontoUserObj sendDiscoupontoUserWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        
        weakSelf.dataArray = response.responseModel;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
        [weakSelf.tableView endHeaderRefreshing];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
        [weakSelf.tableView endHeaderRefreshing];
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
