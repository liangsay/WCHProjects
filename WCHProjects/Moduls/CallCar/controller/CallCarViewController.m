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
#import "OrderViewController.h"
#import "UIButton+EnlargeTouchArea.h"
@interface CallCarViewController () <UITableViewDelegate,UITableViewDataSource,OrderViewControllerDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isReciveState;

@property (nonatomic, strong) OrderViewController *orderVC;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, strong) UIButton *orderBtn;
@end

@implementation CallCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kAppDelegate.callCarVC = self;
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
    [self sendFreighttoCall_API];
    [self setupOrderCountSet];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.orderBtn];
    [self.orderBtn setTitle:@"0" forState:UIControlStateNormal];
}

- (void)setupTableViewSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"CallCarTableViewCell" bundle:nil] forCellReuseIdentifier:kCallCarTableViewCellID];
    self.tableView.rowHeight = kCallCarTableViewCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView addHeaderRefreshTarget:self action:@selector(refreshHeaderData)];
}

- (UIButton *)orderBtn {
    if (!_orderBtn) {
        _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        [_orderBtn.titleLabel setFont:kFont(28)];
        [_orderBtn setFrame:(CGRect){0,0,20,20}];
        [_orderBtn setLayerCornerRadius:10];
        [_orderBtn addTarget:self action:@selector(orderBtnAction:) forControlEvents:UIControlEventTouchUpOutside];
        [_orderBtn setLayerBorderWidth:0.5 color:[UIColor mainColor]];
        [_orderBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        
    }
    return _orderBtn;
}

#pragma mark    --查看未接订单列表
- (void)orderBtnAction:(UIButton *)sender{
    if (self.isReciveState) {
        [NSString toast:@"您的订单正在进行中，不能继续接单哦"];
        return;
    }
    if (self.orderVC != nil) {
        self.orderVC.dataArray = self.orders;
        kPushNav(self.orderVC, YES);
        return;
    }
    OrderViewController *orderVC = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
    orderVC.delegate = self;
    orderVC.dataArray = self.orders;
    self.orderVC = orderVC;
    kPushNav(orderVC, YES);
}

#pragma mark    --定时请求当前订单
- (void)setupOrderCountSet{
    [self cancelTimer];
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

//去掉定时器
- (void)cancelTimer {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
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

#pragma mark --OrderViewControllerDelegate抢单成功后的回调处理----
- (void)orderViewController:(OrderViewController *)orderViewController orderObj:(OrderInfoObj *)orderObj isOrderRecive:(BOOL)isOrderRecive {
    self.isReciveState = YES;
    if (isOrderRecive) {
        
    }
    
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
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
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
        weakSelf.orders = [NSMutableArray arrayWithArray:response.rows];
        if (weakSelf.orderVC) {
            [weakSelf.orderVC reloadOrderData];
        }
        [weakSelf.orderBtn setTitle:kIntegerToString(response.totalCount) forState:UIControlStateNormal];
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
