//
//  ShopDetailViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/8.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "ShopInfoViewController.h"
#import "ShopDetailWebViewController.h"
#import "ShopCommentViewController.h"
#import "ShopDetailBuyView.h"
#import "MyPayTypeViewController.h"
@interface ShopDetailViewController ()<MyPayTypeViewDelegate>
{
    NSArray *list;
}

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupViewSet];
}

- (void)setupViewSet {
    NSInteger segStyle = _layout*4 + _style;
    
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"segmentStyle%ld",(long)segStyle]);
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel];
    }
    
    list = @[@"商品",@"参数",@"评价"];
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, 200, 30) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.headColor = [UIColor clearColor];
    _segHead.selectColor = [UIColor mainColor];
    _segHead.lineColor = [UIColor mainColor];
    _segHead.fontScale = 1.0;
    _segHead.fontSize = 14;
    _segHead.lineScale = .5;
    _segHead.equalSize = YES;
    _segHead.bottomLineHeight = 0;
    
    
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kNavVCViewAndStatusHeight-48) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        self.navigationItem.titleView = _segHead;
        [self.view addSubview:_segScroll];
    }];
    
    
    
}
#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    ShopDetailWebViewController *one = [[ShopDetailWebViewController alloc]initWithNibName:@"ShopDetailWebViewController" bundle:nil];
    one.title = @"商品";
    one.orderObj = self.orderObj;
    one.webUrlString = [NSString stringWithFormat:@"%@/MallgoodstoDetail.shtml?fk=%@",apiBaseURLString,self.orderObj.idf];//@"https://item.m.jd.com/product/2342601.html?sid=2b9de11ccb92d808eb2e1a39460f585d";
    one.index = 0;
    [arr addObject:one];
    
    ShopInfoViewController *two = [[ShopInfoViewController alloc]initWithNibName:@"ShopInfoViewController" bundle:nil];
    two.title = @"详情";
    two.index = 1;
    two.orderObj = self.orderObj;
    [arr addObject:two];
    
    ShopCommentViewController *three = [[ShopCommentViewController alloc]initWithNibName:@"ShopCommentViewController" bundle:nil];
    three.title = @"评价";
    three.orderObj = self.orderObj;
    three.index = 2;
    [arr addObject:three];
//    for (NSInteger i = 0; i < count; i ++) {
//        ViewController *vc = [ViewController new];
//        vc.index = i;
//        [arr addObject:vc];
//    }
    return arr;
}


- (NSArray *)viewArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        UIView *view = [NSClassFromString(@"View") new];
        [arr addObject:view];
    }
    return arr;
}

- (NSArray *)viewNameArr {
    return @[@"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View"
             ];
}

- (NSArray *)vcnameArr {
    return @[@"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController"
             ];
}

- (IBAction)buyBtnAction:(id)sender {
    WEAKSELF
    [ShopDetailBuyView showAlertViewInVC:self orderObj:self.orderObj count:1 complete:^(NSInteger count) {
        [weakSelf sendMallorderdoInsert:count];
    }];
}

- (void)sendMallorderdoInsert:(NSInteger)count {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:kIntegerToString(count) forKey:@"vo.numf"];
    [params addUnEmptyString:@"0" forKey:@"vo.statusf"];
    [params addUnEmptyString:self.orderObj.orderIdf forKey:@"vo.orderIdf"];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.userIdf"];
    [params addUnEmptyString:self.orderObj.idf forKey:@"vo.goodsIdf"];
    [OrderInfoObj sendMallorderdoInsertWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (response.responseCode) {
            //添加购物车成功
            [weakSelf goPayAction];
        }else{
            [NSString toast:@"添加到购物车失败"];
        }
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"网络请求异常"];
    }];
}

- (void)goPayAction {
    //未支付
    MyPayTypeViewController *payVC = [[MyPayTypeViewController alloc] initWithNibName:@"MyPayTypeViewController" bundle:nil];
    payVC.title = @"支付方式";
    payVC.delegate = self;
    payVC.orderObj = self.orderObj;
    payVC.payTitle = @"售车";
    payVC.tradeTypef = 3;
    kPushNav(payVC, YES);
}

#pragma mark --MyPayTypeViewDelegate----------
- (void)myPayTypeViewController:(MyPayTypeViewController *)myPayTypeViewController payStatus:(NSInteger)payStatus orderObj:(OrderInfoObj *)orderObj {
    
}
//下单
/*
 http://www.66wch.com.cn/MallorderdoInsert.shtml
 vo.numf	1
 requestType	app
 vo.statusf	0
 vo.orderIdf	3101501931455437
 vo.userIdf	13820633188
 vo.goodsIdf	0a3d5b19-5ac8-4f7d-a17a-516d2b5b4991
 */

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
