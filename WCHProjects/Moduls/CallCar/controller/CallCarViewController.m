//
//  CallCarViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/5.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "CallCarViewController.h"
#import "CallCarTableViewCell.h"
#import "BaseTableView.h"
#import "LocationServer.h"
@interface CallCarViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation CallCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
    [self sendFreighttoCall_API];
    [self setupOrderCountSet];
    kNAV_INIT_TITLEWIHTRIGHT(self, @"叫车", @"0", @selector(orderBtnAction:));
}

- (void)setupTableViewSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"CallCarTableViewCell" bundle:nil] forCellReuseIdentifier:kCallCarTableViewCellID];
    self.tableView.rowHeight = kCallCarTableViewCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView addHeaderRefreshTarget:self action:@selector(refreshHeaderData)];
}



#pragma mark    --查看未接订单列表
- (void)orderBtnAction:(UIButton *)sender{
    
}

#pragma mark    --定时请求当前订单
- (void)setupOrderCountSet{
    WEAKSELF
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        [weakSelf sendOrdertoDone_API];
        
        // 取消定时器
//        dispatch_cancel(self.timer);
//        self.timer = nil;
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
    
}

- (void)refreshHeaderData {
    [self sendFreighttoCall_API];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count) {
        UIView *headV = [UIView new];
        headV.backgroundColor = [UIColor backgroundColor];
        return headV;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CallCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCallCarTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    OrderInfoObj *orderObj = self.dataArray[indexPath.row];
    [cell setupCellInfoWith:orderObj];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight =10;// 25;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark --物流车源
/**
 物流车源
 */
- (void)sendFreighttoCall_API{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[LocationServer shared].cityf forKey:@"vo.cityf"];
    [params addUnEmptyString:[LocationServer shared].provincef forKey:@"vo.provincef"];
    [OrderInfoObj sendFreighttoCallWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.dataArray = [NSMutableArray arrayWithArray:response.responseModel];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [weakSelf.tableView endHeaderRefreshing];
    }];
}

#pragma mark --用于获得待接订单
/**
 用于获得待接订单
 */
-(void)sendOrdertoDone_API{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[LocationServer shared].provincef forKey:@"vo.provincef"];
    [params addUnEmptyString:[LocationServer shared].cityf forKey:@"vo.cityf"];
    [params addUnEmptyString:@"YES" forKey:kIsHideLoadingView];
    [OrderInfoObj sendOrdertoDoneWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        kNAV_INIT_TITLEWIHTRIGHT(self, @"叫车", kIntToString(response.totalCount), @selector(orderBtnAction:));
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
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
