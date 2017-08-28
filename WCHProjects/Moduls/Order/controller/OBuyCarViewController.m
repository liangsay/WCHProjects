//
//  OBuyCarViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "OBuyCarViewController.h"
#import "BaseTableView.h"
#import "OBuyCarTableViewCell.h"
#import "MyPayTypeViewController.h"
#import "AppraiseViewController.h"
@interface OBuyCarViewController ()<UITableViewDelegate,UITableViewDataSource,MyPayTypeViewDelegate,AppraiseViewControllerDelegate,OBuyCarTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation OBuyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
    [self refreshHeaderData];
}

- (void)setupTableViewSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"OBuyCarTableViewCell" bundle:nil] forCellReuseIdentifier:kOBuyCarTableViewCellID];
    self.tableView.rowHeight = kOBuyCarTableViewCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView addHeaderRefreshTarget:self action:@selector(refreshHeaderData)];
}

- (void)refreshHeaderData {
    [self sendMallordertoMember_API];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OBuyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOBuyCarTableViewCellID forIndexPath:indexPath];
    
    // Configure the cell...
    OrderInfoObj *orderObj = _dataArray[indexPath.row];
    cell.cellIndexPath = indexPath;
    cell.oDelegate = self;
    [cell setupCellInfoWith:orderObj];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 0=未支付 1=已支付 2=已交付 (isAssess=0 未评价  1=已评价) -1=已取消
    OrderInfoObj *orderObj = self.dataArray[indexPath.row];
    NSInteger statusf = orderObj.statusf.integerValue;
    //    0 未评价 1 已评价
    NSInteger isAssess = orderObj.isAssess.integerValue;
    if (statusf==2) {
        if (isAssess==0) {
            //待评价
            AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
            appraiseVC.orderObj =orderObj;
            appraiseVC.viewType = 4;
            appraiseVC.delegate = self;
            appraiseVC.cellIndexPath = indexPath;
            appraiseVC.objTypef = 3;
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
        payVC.orderObj = orderObj;
        payVC.payTitle = @"订金";
        payVC.tradeTypef = 3;
        payVC.isCoupon = YES;
        
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

#pragma mark --OBuyCarTableViewCellDelegate-----
- (void)oBuyCarTableViewCell:(OBuyCarTableViewCell *)oBuyCarTableViewCell longPress:(BOOL)longPress orderObj:(OrderInfoObj *)orderObj {
    WEAKSELF
    [UIAlertController showAlertInViewController:self withTitle:@"取消订单" message:@"您确定要取消订单吗？" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex==2) {
            //取消订单
            [weakSelf sendRentorderdoCancel_API:orderObj indexPath:oBuyCarTableViewCell.cellIndexPath];
        }
    }];
}

#pragma mark --查询品牌、车系下的数据
/**
 查询品牌、车系下的数据
 */
- (void)sendMallordertoMember_API{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"memberId"];
    [OrderInfoObj sendMallordertoMemberWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
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
    [params addUnEmptyString:orderObj.idf forKey:@"idfs"];
    [OrderInfoObj sendMallorderdoCancelBuyWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
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
