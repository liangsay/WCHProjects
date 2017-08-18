//
//  MyPayTypeViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/14.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "MyPayTypeViewController.h"

//支付宝
#import <AlipaySDK/AlipaySDK.h>
//微信
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "AppraiseViewController.h"

@interface MyPayTypeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fareLabel;
@property (weak, nonatomic) IBOutlet UILabel *favorableLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, strong) CoupontoUserObj *couponObj;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (assign, nonatomic) BOOL isFinish;
@end

@implementation MyPayTypeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    kAppDelegate.mainViewController.orderNof = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupViewStyle];
    [self sendDiscoupontoUser];
    [self addNotic];
    kAppDelegate.payType = 2;
    self.typeLab.text = kIsObjectEmpty(self.payTitle)?@"运费":self.payTitle;
}

- (void)onBackButton{
    WEAKSELF
    if (!self.isFinish) {
        [UIAlertView alertViewWithTitle:@"提示：" message:@"您还的订单未完成支付哦" cancelButtonTitle:@"取消" otherButtonTitles:@[@"立即支付"] onDismiss:^(NSInteger buttonIndex) {
            
        } onCancel:^{
//            kAppDelegate.mainViewController.orderNof = @"";
            [kNotificationCenter() removeObserver:weakSelf];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            
//            [super onBackButton];
        }];
        return;
    }
    [kNotificationCenter() removeObserver:self];
//    [super onBackButton];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)addNotic {
    [kNotificationCenter() addObserver:self selector:@selector(wxPayAction:) name:kNotificationWXPayStatus() object:nil];
    [kNotificationCenter() addObserver:self selector:@selector(aliPayAction:) name:kNotificationALiPayStatus() object:nil];
}
- (IBAction)cancelBtnAction:(id)sender {
//    kAppDelegate.mainViewController.orderNof = @"";
    [self onBackButton];
//    [self sendOrderdoCancelWithOrderNof:self.orderObj.orderNof cancelManf:@""];
 
}

#pragma mark --微信支付成功后跳转评价

/**
 微信支付成功后跳转评价
 
 @param sender <#sender description#>
 */
- (void)wxPayAction:(NSNotification *)sender {
    if ([sender.object isEqualToString:@"1"]) {
//        kAppDelegate.mainViewController.orderNof = @"";
        [self sendDiscoupontoUse];
        self.isFinish = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(myPayTypeViewController:payStatus:orderObj:)]) {
            [self.delegate myPayTypeViewController:self payStatus:1 orderObj:self.orderObj];
        }
        //已完成支付才可以评价
        AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
        appraiseVC.orderObj =self.orderObj;
        appraiseVC.viewType = 1;
        appraiseVC.objTypef = self.tradeTypef;
        kPushNav(appraiseVC, YES);
    }
}

#pragma mark --支付宝支付成功后跳转评价

/**
 支付宝支付成功后跳转评价

 @param sender <#sender description#>
 */
- (void)aliPayAction:(NSNotification *)sender {
    self.isFinish = YES;
//    kAppDelegate.mainViewController.orderNof = @"";
    [self sendDiscoupontoUse];
    NSInteger statusf = self.orderObj.statusf.integerValue;
    if (self.delegate && [self.delegate respondsToSelector:@selector(myPayTypeViewController:payStatus:orderObj:)]) {
        
        if (self.viewType==3) {
            self.orderObj.statusf = @"1";
            self.orderObj.statusTextf = @"已付款";
        }else if (self.viewType==4){
            self.orderObj.statusf = @"1";
            self.orderObj.statusTextf = @"已支付";
        }else{
            self.orderObj.statusf = @"3";
            self.orderObj.statusf = @"待评价";
        }
        [self.delegate myPayTypeViewController:self payStatus:1 orderObj:self.orderObj];
    }
    //已完成支付才可以评价
    AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
    appraiseVC.orderObj =self.orderObj;
    appraiseVC.viewType = self.viewType;
    appraiseVC.objTypef = self.tradeTypef;
    kPushNav(appraiseVC, YES);
}

- (void)setupViewStyle {
    
    if (self.tradeTypef==3) {
        self.fareLabel.text = kDoubleToString(_orderObj.depositf.doubleValue);
    }else{
        self.fareLabel.text = kDoubleToString(_orderObj.pricef.doubleValue);
    }
    self.payLabel.text = kDoubleToString(_fareLabel.text.doubleValue-_favorableLabel.text.doubleValue);
    [self.cancelBtn setLayerCornerRadius:35/2];
    self.fareLabel.textColor = self.favorableLabel.textColor = self.payLabel.textColor = [UIColor mainColor];
    [self.zhifubaoBtn.imageView setSize:(CGSize){25,25}];
    [self.weixinBtn.imageView setSize:(CGSize){25,25}];
    [self.cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
}

#pragma mark --用于查询微信支付
/*
 vo.tradeTypef	2
 requestType	app
 vo.orderNof	3101502377239146
 vo.couponIdf
 vo.pricef	198.0
 vo.titlef	租金
 vo.userNamef	13820633188
 vo.reUrlf	http://www.66wch.com.cn/OrdertoPayReturn.shtml
 */
- (void)sendOrdertoPay {
    
    if (kIsObjectEmpty(self.orderObj.orderNof)) {
        self.orderObj.orderNof = self.orderObj.dataSortNumf;
    }
    NSString *nowdatetime = [NSDate timeIntervalWithNow:@""];
    NSString *timeStr = [NSDate timeIntervalToDataString:nowdatetime.doubleValue formate:@"yyyyMMddHHmmssS"];
    NSString *reUrlf = [NSString stringWithFormat:@"%@/OrdertoPayReturn.shtml",apiBaseURLString()];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *orderNum = [NSString stringWithFormat:@"%@",self.orderObj.orderNof];
    if (self.couponObj && !kIsObjectEmpty(self.couponObj.idf)) {
        orderNum = [NSString stringWithFormat:@"%@-%@",self.orderObj.orderNof,self.couponObj.idf];
        [params addUnEmptyString:self.couponObj.idf forKey:@"vo.couponIdf"];
    }else{
        [params addUnEmptyString:@"" forKey:@"vo.couponIdf"];
    }
    
    [params addUnEmptyString:orderNum forKey:@"vo.orderNof"];
    [params addUnEmptyString:self.payTitle forKey:@"vo.titlef"];
    [params addUnEmptyString:self.payLabel.text forKey:@"vo.pricef"];
    [params addUnEmptyString:kIntegerToString(self.tradeTypef) forKey:@"vo.tradeTypef"];
    [params addUnEmptyString:reUrlf forKey:@"vo.reUrlf"];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.userNamef"];
#if DEBUG
    [params addUnEmptyString:@"0.01" forKey:@"vo.pricef"];
#endif
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    [self weixinpayAction:params];;
}
#pragma mark -
#pragma mark   ==============点击模拟授权行为==============

- (void)doAlipayAuth
{
    if (kIsObjectEmpty(self.orderObj.orderNof)) {
        self.orderObj.orderNof = self.orderObj.dataSortNumf;
    }
    NSString *orderNum = [NSString stringWithFormat:@"%@",self.orderObj.orderNof];
    if (self.couponObj && !kIsObjectEmpty(self.couponObj.idf)) {
        orderNum = [NSString stringWithFormat:@"%@-%@",self.orderObj.orderNof,self.couponObj.idf];
    }
#if DEBUG
    self.payLabel.text = @"0.01";
#endif
    NSString *reUrlf = [NSString stringWithFormat:@"%@/OrdertoAliPayReturn.shtml",apiBaseURLString()];
    NSString *paraStr = [NSString stringWithFormat:@"vo.titlef=%@&vo.orderNof=%@&vo.pricef=%@&requestType=app&vo.tradeTypef=%ld&vo.reUrlf=%@&vo.userNamef=%@",self.payTitle,orderNum,self.payLabel.text,self.tradeTypef,reUrlf,[UserInfoObj model].mobilePhonef];
    if (self.couponObj) {
        paraStr = [paraStr stringByAppendingFormat:@"&vo.couponIdf=%@",self.couponObj.idf];
    }else{
        paraStr = [paraStr stringByAppendingString:@"&vo.couponIdf="""];
    }

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
//        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
//                                         fromScheme:appScheme
//                                           callback:^(NSDictionary *resultDic) {
//                                               NSLog(@"result = %@",resultDic);
//                                               // 解析 auth code
//                                               NSString *result = resultDic[@"result"];
//                                               NSString *authCode = nil;
//                                               if (result.length>0) {
//                                                   NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                                                   for (NSString *subResult in resultArr) {
//                                                       if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                                                           authCode = [subResult substringFromIndex:10];
//                                                           break;
//                                                       }
//                                                   }
//                                                   
//                                               }
//                                               
//                                               NSLog(@"授权结果 authCode = %@", authCode?:@"");
//                                           }];
        [[AlipaySDK defaultService] payOrder:authInfoStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSString *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"6001"]) {
                [NSString toast:@"您取消了支付操作"];
            }else if ([resultStatus isEqualToString:@"9000"]){
                [self aliPayAction:nil];
                
                [NSString toast:@"支付成功"];
            }
        }];
    }
}

- (IBAction)weixinpayAction:(NSDictionary *)orderDic
{
    [OrderInfoObj sendOrdertoPayWithParameters:[NSMutableDictionary dictionaryWithDictionary:orderDic] successBlock:^(HttpRequest *request, HttpResponse *response) {
        NSDictionary *dict = response.responseObject;
        NSString *error = @"支付失败";
        if(dict) {
            error = [dict[@"msg"] length]?dict[@"msg"]:@"支付失败";
            if ([error isEqualToString:@"error"]) {
                [NSString toast:error];
                return;
            }
        }
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
        NSString *error = @"支付失败";
        if(dict) {
            error = [dict[@"msg"] length]?dict[@"msg"]:@"支付失败";
            if ([error isEqualToString:@"error"]) {
                [NSString toast:error];
                return;
            }
        }
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

- (IBAction)payTypeBtnAction:(UIButton *)sender {
    NSInteger payType= sender.tag;
    if (payType==1) {
        //微信充值
        [self sendOrdertoPay];
        
    }else{
        //支付宝充值
        [self doAlipayAuth];
    }
}

#pragma mark --优惠劵查询接口
- (void)sendDiscoupontoUser {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[UserInfoObj model].mobilePhonef forKey:@"queryMap.phonef"];
    [params addUnEmptyString:@"0" forKey:@"isUsef"];
    [CoupontoUserObj sendDiscoupontoUserWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        NSArray *datas = response.responseModel;
        if (kISKIND_OF_CLASS_NSARRAY(datas) && datas.count) {
            [datas enumerateObjectsUsingBlock:^(CoupontoUserObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.isUsef.integerValue==0 && !obj.isExpiryDatef){
                    weakSelf.couponObj = obj;
                    weakSelf.favorableLabel.text = kDoubleToString(obj.couponCountf);
                    double pay = weakSelf.fareLabel.text.doubleValue-obj.couponCountf;
                    weakSelf.payLabel.text = kDoubleToString(pay<0?0:pay);
                    *stop = YES;
                }
            }];
        }
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --优惠券使用接口
- (void)sendDiscoupontoUse {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:self.orderObj.orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:@"1" forKey:@"vo.isUsef"];
    [params addUnEmptyString:self.couponObj.idf forKey:@"vo.idf"];
    [CoupontoUserObj sendDiscoupontoUseWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
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
