//
//  ShopCommentViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/8.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopCommentViewController.h"
#import "BaseTableView.h"
#import "ShopCommontCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface ShopCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ShopCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
    [self refreshHeaderData];
}

- (void)setupTableViewSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopCommontCell" bundle:nil] forCellReuseIdentifier:kShopCommontCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView addHeaderRefreshTarget:self action:@selector(refreshHeaderData)];
}

- (void)refreshHeaderData {
    [self sendAssesstoCustom_API];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block OrderInfoObj *orderObj = self.dataArray[indexPath.row];
    CGFloat height = [self.tableView fd_heightForCellWithIdentifier:kShopCommontCellID configuration:^(id cell) {
        ShopCommontCell *_cell = (ShopCommontCell *)cell;
        [_cell setupCellInfoWithObj:orderObj];
    }];
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopCommontCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopCommontCellID forIndexPath:indexPath];
    // Configure the cell...
    OrderInfoObj *orderObj = _dataArray[indexPath.row];
    cell.cellIndexPath = indexPath;
    
    [cell setupCellInfoWithObj:orderObj];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
}

#pragma mark --查询商品评价
/**
 查询商品评价
 queryMap.goodIdf	0a3d5b19-5ac8-4f7d-a17a-516d2b5b4991
 */
- (void)sendAssesstoCustom_API{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:self.orderObj.idf forKey:@"queryMap.goodIdf"];
    [OrderInfoObj sendAssesstoCustomWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.dataArray = [NSMutableArray arrayWithArray:response.responseModel];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
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
