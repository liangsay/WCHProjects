//
//  AppraiseViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/14.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "AppraiseViewController.h"
#import "CWStarRateView.h"
#import "OrderInfoObj.h"
@interface AppraiseViewController ()<CWStarRateViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *startView;
@property (nonatomic, strong) CWStarRateView *starRateView;
@property (nonatomic, strong) NSString *scoref;

@property (weak, nonatomic) IBOutlet UILabel *driverNameLab;
@property (weak, nonatomic) IBOutlet UILabel *carNumLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *driverViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *driverView;

@end

@implementation AppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *price = _orderObj.pricef;
//    if (_orderObj.tipPricef.doubleValue>0) {
//        self.priceLabel.text = [NSString stringWithFormat:@"%.2f",price.doubleValue+_orderObj.tipPricef.doubleValue];
//    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"%.2f",price.doubleValue];
//    }
    
    [self.commitBtn setLayerCornerRadius:4];
    [self.commitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.title = @"订单评价";
    
    [self.view layoutIfNeeded];
    self.starRateView = [[CWStarRateView alloc] initWithFrame:self.startView.bounds numberOfStars:5];
    self.starRateView.delegate = self;
    self.starRateView.backgroundColor = [UIColor backgroundColor];
    self.starRateView.scorePercent = 0;
    self.starRateView.allowIncompleteStar = YES;
    self.starRateView.hasAnimation = YES;
    [self.startView addSubview:self.starRateView];
    if (self.viewType==1) {
        //货主
        self.driverViewHeightLayoutConstraint.constant = 60;
        self.driverView.alpha = 1;
        self.driverNameLab.text = @"";
        self.carNumLab.text = @"";
        self.scoreLab.text = @"";
        self.countLab.text = @"";
        [self sendDriverinfobyMobile];
    }else if (self.viewType==2){
        //司机
        self.driverViewHeightLayoutConstraint.constant = 0;
        self.driverView.alpha = 0;
    }
}

- (void)onBackButton {
//    kAppDelegate.mainViewController.orderNof = @"";
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark --联系司机
- (IBAction)callBtnAction:(id)sender {
    [self.view makeCallWithPhone:self.orderObj.driverIdf];
}


#pragma mark --CWStarRateViewDelegate
- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    self.scoref = [NSString stringWithFormat:@"%.1f",ceilf(newScorePercent*5)];
    
}

#pragma mark --提交评价事件
- (IBAction)commitBtnAction:(id)sender {
    [self sendAssessdoInsert];
}

#pragma mark --用于提交评价
- (void)sendAssessdoInsert{
    
    NSString *userTypef = [UserInfoObj model].userTypef;//如果当前用户是货主，那么评价的对象就是司机 ;1司机，0货主
    //当self.viewType==1时是货主进来，所以要对司机（1）评价；
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:_orderObj.orderNof forKey:@"vo.orderIdf"];
    [params addUnEmptyString:self.viewType==1?@"1":@"0" forKey:@"vo.objTypef"];
    [params addUnEmptyString:self.scoref forKey:@"vo.scoref"];
    [params addUnEmptyString:_orderObj.driverIdf forKey:@"vo.mobilef"];
    WEAKSELF
    [OrderInfoObj sendAssessdoInsertWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"评价成功"];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"评价成功"];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark --根据手机号查询司机的信息
- (void)sendDriverinfobyMobile {
    WEAKSELF
    [OrderInfoObj sendDriverinfobyMobileWithParameters:[NSMutableDictionary dictionaryWithObject:self.orderObj.driverIdf forKey:@"vo.linkPhonef"] successBlock:^(HttpRequest *request, HttpResponse *response) {
        OrderInfoObj *orderObj = response.responseModel;
        weakSelf.driverNameLab.text = orderObj.driverNamef;
        weakSelf.carNumLab.text = [NSString stringWithFormat:@"车牌号：%@",orderObj.carNof];
        weakSelf.scoreLab.text = [NSString stringWithFormat:@"评分：%.1f",orderObj.scoref.doubleValue];
        weakSelf.countLab.text = [NSString stringWithFormat:@"订单数：%@",orderObj.orderCountf];
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
