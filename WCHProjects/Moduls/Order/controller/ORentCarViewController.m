//
//  ORentCarViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ORentCarViewController.h"
#import "BaseTableView.h"
#import "ORentCarTableViewCell.h"
#import "UIAlertController+Blocks.h"
@interface ORentCarViewController ()<UITableViewDelegate,UITableViewDataSource,ORentCarTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation ORentCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
    [self refreshHeaderData];
}

- (void)setupTableViewSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"ORentCarTableViewCell" bundle:nil] forCellReuseIdentifier:kORentCarTableViewCellID];
    self.tableView.rowHeight = kORentCarTableViewCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView addHeaderRefreshTarget:self action:@selector(refreshHeaderData)];
}

- (void)refreshHeaderData {
    [self sendRentordertoCustom_API];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderInfoObj *orderObj = _dataArray[indexPath.row];
    if (orderObj.statusf.integerValue == -1) {
        return 105;
    }else{
        return kORentCarTableViewCellHeight;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORentCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kORentCarTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    OrderInfoObj *orderObj = _dataArray[indexPath.row];
    cell.cellIndexPath = indexPath;
    [cell setupCellInfoWithObj:orderObj];
    cell.oDelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
}


#pragma mark --ORentCarTableViewCellDelegate--------
- (void)oRentCarTableViewCell:(ORentCarTableViewCell *)oRentCarTableViewCell longPress:(BOOL)longPress orderObj:(OrderInfoObj *)orderObj {
    WEAKSELF
    [UIAlertController showAlertInViewController:self withTitle:@"取消订单" message:@"您确定要取消订单吗？" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex==2) {
            //取消订单
            [weakSelf sendRentorderdoCancel_API:orderObj indexPath:oRentCarTableViewCell.cellIndexPath];
        }
    }];
}

#pragma mark --订单租车
/**
 订单租车
 */
- (void)sendRentordertoCustom_API{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"queryMap.mobilef"];
    [OrderInfoObj sendRentordertoCustomWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.dataArray = [NSMutableArray arrayWithArray:response.responseModel];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
    }];
}

#pragma mark --取消订单租车
/**
 取消订单租车
 */
- (void)sendRentorderdoCancel_API:(OrderInfoObj *)orderObj indexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:orderObj.idf forKey:@"vo.idf"];
    [OrderInfoObj sendRentorderdoCancelWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (response.isSuccess) {
            orderObj.statusf = @"-1";
            orderObj.statusTextf = @"订单取消";
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:orderObj];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [NSString toast:@"取消失败"];
        }
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"取消失败"];
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
