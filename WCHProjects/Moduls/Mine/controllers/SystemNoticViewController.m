//
//  SystemNoticViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/3.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "SystemNoticViewController.h"
#import "SystemMessageTableCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "BaseTableView.h"
typedef NS_ENUM(NSInteger, FDSimulatedCacheMode) {
    FDSimulatedCacheModeNone = 0,
    FDSimulatedCacheModeCacheByIndexPath,
    FDSimulatedCacheModeCacheByKey
};

@interface SystemNoticViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet  BaseTableView*tableView;
@end

@implementation SystemNoticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
    [self sendMessagetoCustom];
    
    
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
    [_tableView registerClass:[SystemMessageTableCell class] forCellReuseIdentifier:kSystemMessageTableCellID];
    [self.tableView addHeaderRefreshTarget:self action:@selector(headerRefresh)];
    
#if DEBUG
    self.tableView.fd_debugLogEnabled = YES;
#endif
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    SystemMessageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kSystemMessageTableCellID forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setupCellInfoWith:_dataArray[section]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    return [tableView fd_heightForCellWithIdentifier:kSystemMessageTableCellID configuration:^(SystemMessageTableCell *cell) {
        [weakSelf configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell:(SystemMessageTableCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    cell.fd_enforceFrameLayout = YES; // Enable to use "-sizeThatFits:"
//    if (indexPath.row % 2 == 0) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
    [cell setupCellInfoWith:_dataArray[indexPath.section]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor backgroundColor];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kPadding;
}

- (void)headerRefresh {
    [self sendMessagetoCustom];
}

#pragma mark --系统消息查询接口
- (void)sendMessagetoCustom {
    WEAKSELF
    [SystemMessageObj sendMessagetoCustomWithParameters:[NSMutableDictionary dictionary] successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.dataArray = response.responseModel;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
        [weakSelf.tableView endHeaderRefreshing];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:response.responseMsg];
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
