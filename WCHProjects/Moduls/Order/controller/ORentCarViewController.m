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
#import "MyPayTypeViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "AppraiseViewController.h"

@interface ORentCarViewController ()<UITableViewDelegate,UITableViewDataSource,ORentCarTableViewCellDelegate,MyPayTypeViewDelegate,AppraiseViewControllerDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation ORentCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
    [self refreshHeaderData];
    [kNotificationCenter() addObserver:self selector:@selector(refreshHeaderData) name:kNotificationCenter_CancelOrder object:nil];
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
    __block OrderInfoObj *orderObj = _dataArray[indexPath.row];
    CGFloat height = [self.tableView fd_heightForCellWithIdentifier:kORentCarTableViewCellID configuration:^(id cell) {
        ORentCarTableViewCell *_cell = cell;
        [_cell setupCellInfoWithObj:orderObj];
    }];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORentCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kORentCarTableViewCellID forIndexPath:indexPath];
    // Configure the cell...
    OrderInfoObj *orderObj = _dataArray[indexPath.row];
    cell.cellIndexPath = indexPath;
    [cell setupCellInfoWithObj:orderObj];
    cell.oDelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    OrderInfoObj *orderObj = self.dataArray[row];
    //    0=待支付 1=已付款 2=订单结束  (isAssess=0 未评价  1=已评价) -1=订单作废
    NSInteger statusf = orderObj.statusf.integerValue;
    
    //    0 未评价 1 已评价
    NSInteger isAssess = orderObj.isAssess.integerValue;
    if (statusf==2) {
        if (isAssess==0) {
            //已支付
            AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
            appraiseVC.orderObj =orderObj;
            appraiseVC.viewType = 3;
            appraiseVC.delegate = self;
            appraiseVC.objTypef = 2;
            appraiseVC.cellIndexPath = indexPath;
            kPushNav(appraiseVC, YES);
            
        }else{
            [NSString toast:@"您已评价"];
        }
    }else if (statusf == 0) {
        //未支付
        MyPayTypeViewController *payVC = [[MyPayTypeViewController alloc] initWithNibName:@"MyPayTypeViewController" bundle:nil];
        payVC.title = @"支付方式";
        payVC.cellIndexPath = indexPath;
        payVC.delegate = self;
        orderObj.pricef = orderObj.rentMoneyf;
        payVC.orderObj = orderObj;
        payVC.payTitle = @"租金";
        payVC.tradeTypef = 2;
        kPushNav(payVC, YES);
    }
}


#pragma mark --AppraiseViewControllerDelegate-----------
- (void)appraiseViewController:(AppraiseViewController *)appraiseViewController orderObj:(OrderInfoObj *)orderObj {
    [self.dataArray replaceObjectAtIndex:appraiseViewController.cellIndexPath.row withObject:orderObj];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[appraiseViewController.cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark --MyPayTypeViewDelegate----------
- (void)myPayTypeViewController:(MyPayTypeViewController *)myPayTypeViewController payStatus:(NSInteger)payStatus orderObj:(OrderInfoObj *)orderObj {
    [self.dataArray replaceObjectAtIndex:myPayTypeViewController.cellIndexPath.row withObject:orderObj];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[myPayTypeViewController.cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
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
 vo.idf	26617b40324144878b594a8cb99a1c62
 requestType	app
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
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
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
