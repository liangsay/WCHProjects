//
//  MyWalletViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/3.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "MyWalletViewController.h"
#import "BaseTableView.h"
#import "OrderInfoObj.h"
#import "WalletTableCell.h"
#import "PayTypeViewController.h"
#import "JSONKit.h"
#import "NSString+ICCategory.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>
//微信
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

#pragma mark --利用 NSSortDescriptor 对 NSMutableArray 排序
/*!
 *  @author liujinliang, 16-04-08 09:04:58
 *
 *  @brief 利用 NSSortDescriptor 对 NSMutableArray 排序
 *
 *  @param array     <#array description#>
 *  @param dic       <#dic description#>
 *  @param orderKey  <#orderKey description#>
 *  @param ascending <#ascending description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#1.0#>
 */
static inline NSMutableArray *kSortArray(NSMutableArray *array,NSMutableDictionary *dic,NSString *orderKey,BOOL ascending){
    if (!kIsObjectEmpty(orderKey)) {
        NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:orderKey ascending:ascending];
        NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
        array = [NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:descriptors]];
        //    NSLog(@"dicArray:%@",dicArray);
        return array;
    }else{
        NSArray *keys = [dic allKeys];
        NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        return [NSMutableArray arrayWithArray:sortedArray];
    }
}

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PayTypeViewControllerDelegate>
{
    BOOL isHaveDian;
    PayTypeViewController *_payTypeVC;
}
@property (nonatomic, strong) NSString *payKey;
@property (nonatomic, strong) NSString *idf;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UITextField *moneyTxtF;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation MyWalletViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupBackButton];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupTableViewSet];
    [self sendRechargetoNumber];
    [self addNotic];
    kAppDelegate.payType = 1;
    
}
- (void)onBackButton{
    [super onBackButton];
    [kNotificationCenter() removeObserver:self];
}

- (void)addNotic {
    [kNotificationCenter() addObserver:self selector:@selector(wxPayAction:) name:kNotificationWXPayStatus() object:nil];
    [kNotificationCenter() addObserver:self selector:@selector(aliPayAction:) name:kNotificationALiPayStatus() object:nil];
}

- (void)wxPayAction:(NSNotification *)sender {
    
    if ([sender.object isEqual:@"1"]) {
        [self headerRefresh];
    }
}

- (void)aliPayAction:(NSNotification *)sender {
    [self headerRefresh];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.subBtn setLayerCornerRadius:4];
}

- (void)setupTableViewSet {
    
    [self.totalLabel setLayerCornerRadius:30];
    [self.totalLabel setLayerBorderWidth:2 color:[UIColor redColor]];
    _totalLabel.text = kDoubleToString([UserInfoObj model].balancef.doubleValue);
    [self.subBtn setLayerCornerRadius:4];
    
    _tableView.backgroundColor = [UIColor backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WalletTableCell class]) bundle:nil] forCellReuseIdentifier:kWalletTableCellID];
    [_tableView setRowHeight:kWalletTableCellHeight];
    
    UIView *theView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [theView setBackgroundColor:[UIColor backgroundColor]];
    [self.tableView setBackgroundView:theView];
    [self.tableView addHeaderRefreshTarget:self action:@selector(headerRefresh)];
    [self.tableView beginHeaderRefresh];
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
    WalletTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kWalletTableCellID forIndexPath:indexPath];
    
    // Configure the cell...
    OrderInfoObj *model = self.dataArray[section];
    [cell setupCellInfoWith:model];
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITextField delegate
//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
//                    [self showError:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                /*
                if (single == '0') {
//                    [self showError:@"亲，第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }*/
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
//                    [self showError:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
//                        [self showError:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
//            [self showError:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (void)headerRefresh {
    [self sendRechargetoCustom];
    [self sendRechargetoBalance];
}

#pragma mark --充值记录查询
- (void)sendRechargetoCustom {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"queryMap.ownerIdf"];
    [OrderInfoObj sendRechargetoCustomWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.dataArray = response.responseModel;
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --用于查询用户的余额
- (void)sendRechargetoBalance{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.mobilef"];
    [OrderInfoObj sendRechargetoBalanceWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.totalLabel.text = kDoubleToString([response.result doubleValue]);
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --添加充值记录
- (void)sendRechargedoInsert{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *orderNum = [NSString stringWithFormat:@"%@",self.idf];
    [params addUnEmptyString:[NSString stringWithFormat:@"%@",orderNum] forKey:@"vo.idf"];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.mobilef"];
    [params addUnEmptyString:self.moneyTxtF.text forKey:@"vo.amountf"];
    [OrderInfoObj sendRechargedoInsertWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        [weakSelf headerRefresh];
        weakSelf.moneyTxtF.text = @"";
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [weakSelf headerRefresh];
        weakSelf.moneyTxtF.text = @"";
    }];
}


#pragma mark --用于获得充值的主键
- (void)sendRechargetoNumber{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [OrderInfoObj sendRechargetoNumberWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.payKey = response.result;
        weakSelf.idf = [NSString stringWithFormat:@"%@_%@",response.result,[UserInfoObj model].mobilePhonef];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --进入充值类型选择并充值
- (IBAction)subBtnAction:(UIButton *)sender {
    if (self.moneyTxtF.text.isEmpty) {
        [NSString toast:@"请输入充值金额"];
        return;
    }
    if (self.moneyTxtF.text.doubleValue==0) {
        [NSString toast:@"充值金额不能为0"];
        return;
    }
    [self.view endEditing:YES];
    
    if (!_payTypeVC) {
        _payTypeVC = [[PayTypeViewController alloc] initWithNibName:@"PayTypeViewController" bundle:nil];
        _payTypeVC.delegate = self;
        [self.view.window addSubview:_payTypeVC.view];
        WEAKSELF
        _payTypeVC.view.alpha = 0;
        [_payTypeVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    [_payTypeVC showPayView];
    
}

#pragma mark --PayTypeViewControllerDelegate
- (void)payTypeViewController:(PayTypeViewController *)payTypeViewController payType:(NSInteger)payType {
    if (payType==0) {
        //微信充值
        [self sendOrdertoPay];
        
    }else{
        //支付宝充值
        [self doAlipayAuth];
    }
}

#pragma mark -

#pragma mark --用于查询微信支付
- (void)sendOrdertoPay {
    
    NSString *nowdatetime = [NSDate timeIntervalWithNow:@""];
    NSString *timeStr = [NSDate timeIntervalToDataString:nowdatetime.doubleValue formate:@"yyyyMMddHHmmssS"];
    NSString *reUrlf = [NSString stringWithFormat:@"%@OrdertoPayReturn.shtml",apiBaseURLString()];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *orderNum = [NSString stringWithFormat:@"%@",self.idf];
    [params addUnEmptyString:orderNum forKey:@"vo.orderNof"];
    [params addUnEmptyString:@"充值" forKey:@"vo.titlef"];
    [params addUnEmptyString:self.moneyTxtF.text forKey:@"vo.pricef"];
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    [params addUnEmptyString:@"4" forKey:@"vo.tradeTypef"];
    [params addUnEmptyString:reUrlf forKey:@"vo.reUrlf"];
    [self weixinpayAction:params];;
}
#pragma mark -
#pragma mark   ==============点击模拟授权行为==============

- (void)doAlipayAuth
{
    NSString *nowdatetime = [NSDate timeIntervalWithNow:@""];
    NSString *timeStr = [NSDate timeIntervalToDataString:nowdatetime.doubleValue formate:@"yyyyMMddHHmmssS"];
    NSString *reUrlf = [NSString stringWithFormat:@"%@OrdertoAliPayReturn.shtml",apiBaseURLString()];
    NSString *paraStr = [NSString stringWithFormat:@"vo.titlef=%@&vo.orderNof=%@&vo.pricef=%@&requestType=app&vo.reUrlf=%@&vo.tradeTypef=4&vo.userNamef=%@",@"充值",self.idf,self.moneyTxtF.text,reUrlf,[UserInfoObj model].mobilePhonef];
    paraStr=[paraStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *postData = [paraStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%zd", [postData length]];
    NSString *url = [NSString stringWithFormat:@"%@/OrdertoAliPay.shtml",apiBaseURLString()];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//请求头
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    NSLog(@"dic:%@",dic);
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *pid = @"2088421855586336";
    NSString *appID = @"2016092001930265";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANZI8seusojkE0cyPUq/ZcKnYBAMQJ91CFNyM5J/a1Sq8qRgHvRP44CXDxqxE2dBmbLSgptNnPOslfeovPhmFvxaOgeC55auD6x7kNR0eMeXjEdrbTdJn7W7iGM/SETQp4ZA5lG8znAKXdeUnrwHEzo9L3FhMNpV404kXlszzwVFAgMBAAECgYBShFLhbDeaGWIHF6ScpSm1lKicZWt5PCMRpzeO4XxeZVn8zHr/D8iG2yTY3XmgWJWsU/4xeejHuR0i+pqSeRW+MSXnwmlsepfsT3K0S4Jl1Doeek+6nK85IO2X/YCncgo0LpJGxEoL1VENwDfyMoe9tnMhfLxeoih/oksoefOaoQJBAPOcxw6PKNEFoOSS8uqkezCiv2CkldKUqRFrJK6e0sWVVpGQsA5Yz8/IA21UdKdink6f+/GZ9qgv92VO1Kno+tkCQQDhLmafXRN96ADnkv99sLNGQn7wUPwljzSMbRErogVN7sBox4sdqHnHr+sBOTE+yK2PV37uj6751r4x/g9oiOJNAkBPO0dWieMpkF4S2WReQl66o8QAp6b+1VDjlGhaztcYYgjE0T0hfWshVhkfPt+t7Ro10jy8CGo7q1YYQfpSxK6JAkAmxyzZCNhQeGGff4sMBB/7W3wsumWRukWcYTPxxacQMqtj3+kvJFJEdyELRuQaIcjxxGmRf6DsWXTLeysAH4KJAkEAirsPXQlppJ2YQEkC6UdVMlmNWHu2PMZDQia9WhwlCE/YREK0+v/6EI4nC6Gy6gEcKhDEW7LlMEjdFjwBczPtlw==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //pid和appID获取失败,提示
    if ([pid length] == 0 ||
        [appID length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少pid或者appID或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"com.wc66sc.WCHProjects";
    
    // 将授权信息拼接成字符串
    NSString *authInfoStr =@"";
    NSLog(@"authInfoStr = %@",authInfoStr);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = dic[@"sign"];//[signer signString:dic[@"sign"]];
    NSLog(@"signedString:%@",signedString);
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString.length > 0) {
        authInfoStr = dic[@"sign"];//[NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, @"RSA"];
       /* [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic) {
                                               NSLog(@"result = %@",resultDic);
                                               // 解析 auth code
                                               NSString *result = resultDic[@"result"];
                                               NSString *authCode = nil;
                                               if (result.length>0) {
                                                   NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                                                   for (NSString *subResult in resultArr) {
                                                       if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                                                           authCode = [subResult substringFromIndex:10];
                                                           break;
                                                       }
                                                   }
                                               }
                                               NSLog(@"授权结果 authCode = %@", authCode?:@"");
                                           }];*/
        WEAKSELF
        [[AlipaySDK defaultService] payOrder:authInfoStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"6001"]) {
                [NSString toast:@"您取消了支付操作"];
            }else if ([resultStatus isEqualToString:@"9000"]){
                [weakSelf sendRechargedoInsert];
                [NSString toast:@"支付成功"];
            }
        }];
    }
}

- (IBAction)weixinpayAction:(NSDictionary *)orderDic
{
    
    [OrderInfoObj sendOrdertoPayWithParameters:[NSMutableDictionary dictionaryWithDictionary:orderDic] successBlock:^(HttpRequest *request, HttpResponse *response) {
        NSDictionary *dict = response.responseObject;
        if (!kISKIND_OF_CLASS_NSDICTIONARY(dict) && !dict.count) {
            [NSString toast:@"支付失败"];
            return;
        }
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"packageValue"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        NSDictionary *dict = response.responseObject;
        if (!kISKIND_OF_CLASS_NSDICTIONARY(dict) && !dict.count) {
            [NSString toast:@"支付失败"];
            return;
        }
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"packageValue"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }];
//    NSString *res = [WXApiRequestHandler jumpToBizPayWithOrder:orderDic];
//    if( ![@"" isEqual:res] ){
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//        [alter show];
//        
//    }
}

@end
