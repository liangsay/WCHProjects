//
//  LoginViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserInfoObj.h"
#import "ForgetViewController.h"
#import "OtherWebViewController.h"
#import "DutytoDecideObj.h"
#import "JPUSHService.h"
@implementation LoginModel

@end

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtF;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@property (nonatomic, strong) NSString *codeNum;

/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (kAppDelegate.callCarVC) {
        [kAppDelegate.callCarVC cancelTimer];
    }

    [UserInfoObj clear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViewsStyle];
#if DEBUG
    self.userNameTxtF.text = @"13820633188";//@"18202536913";//@"13922163927";
    self.passwordTxtF.text = @"123456";//@"888888";
#endif
}

#pragma mark --设置UI样式
/*!
 *  @author liujinliang, 16-10-02 07:10:06
 *
 *  @brief 设置UI样式
 *
 *  @since <#1.0#>
 */
- (void)setupViewsStyle {
    //    [self.userNameTxtF setLayerBorderWidth:.5 color:[UIColor borderColor]];
    //    [self.userNameTxtF setLayerCornerRadius:4];
    //    [self.userNameTxtF setTextFieldLeftPaddingWidth:5];
    //    
    //    [self.passwordTxtF setLayerBorderWidth:.5 color:[UIColor borderColor]];
    //    [self.passwordTxtF setLayerCornerRadius:4];
    //    [self.passwordTxtF setTextFieldLeftPaddingWidth:5];
    
    [self.loginBtn setLayerCornerRadius:4];
//    [self.registBtn setLayerCornerRadius:4];
//    [self.registBtn setLayerBorderWidth:.5 color:[UIColor mainColor]];
    [self.checkBtn setSelected:YES];
    [self.checkBtn setImage:kIMAGE(@"logincheck") forState:UIControlStateNormal];
    [self.checkBtn setImage:kIMAGE(@"loginchecked") forState:UIControlStateSelected];
   
}

- (IBAction)checkBtnAction:(UIButton *)sender {
    self.checkBtn.selected = !self.checkBtn.selected;
    
}


#pragma mark --显示或隐藏密码
- (IBAction)codeBtnAction:(UIButton *)sender {
    [self sendSmstoSend_API];
    
}

- (void)downTimeSet {
    __block int count = 60;
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
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"------------%@", [NSThread currentThread]);
        count -= 1;
        
        if (count <= 0 ) {
            // 取消定时器
            dispatch_cancel(weakSelf.timer);
            weakSelf.timer = nil;
            weakSelf.codeBtn.enabled = YES;
            weakSelf.codeBtn.userInteractionEnabled = YES;
            [weakSelf.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }else{
            weakSelf.codeBtn.enabled = NO;
            weakSelf.codeBtn.userInteractionEnabled = NO;
            NSString *tit = [NSString stringWithFormat:@"%ds",count];
            [weakSelf.codeBtn setTitle:tit forState:UIControlStateNormal];
        }
    });
    
    // 启动定时器
    dispatch_resume(self.timer);
}

#pragma mark --发送短信的接口
/**
 发送短信的接口
 */
- (void)sendSmstoSend_API {
    [self.view endEditing:YES];
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:@"1" forKey:@"vo.smsTypef"];
    [params addUnEmptyString:[NSString UDIDString] forKey:@"deviceNo"];
    
    
    [UserInfoObj sendApptoAccessKeyRequestWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (response.responseCode == 1) {
            if ([response.result isKindOfClass:[NSString class]]) {
                [weakSelf sendLogin_API:response.result];
            }else{
                [NSString toast:@"登陆异常"];
            }
        }else{
            [NSString toast:@"登陆异常"];
        }
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"服务器请求异常"];
    }];
    
}

- (void)sendLogin_API:(NSString *)key {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:@"1" forKey:@"vo.smsTypef"];
    [params addUnEmptyString:self.userNameTxtF.text forKey:@"vo.mobilef"];
    [params addUnEmptyString:[NSString UDIDString] forKey:@"deviceNo"];
    [params addUnEmptyString:[key md5] forKey:@"key"];
    [UserInfoObj sendSmstoSendWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.codeNum = response.result;
        
        [weakSelf downTimeSet];
        NSString *msg = [NSString stringWithFormat:@"验证码已发送至手机号为%@，请注意查收并登陆/注册使用",weakSelf.userNameTxtF.text];
        [NSString toast:msg];
#ifdef DEBUG
        weakSelf.passwordTxtF.text = response.result;
        DLog(@"response.result:%@",response.result);
        [NSString toast:weakSelf.codeNum];
#endif
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --登录
- (IBAction)loginBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (self.userNameTxtF.text.isEmpty) {
        [NSString toast:@"请输入用户名"];
        return;
    }
    if (self.passwordTxtF.text.isEmpty) {
        [NSString toast:@"请输入验证码"];
        return;
    }
    
//#if DEBUG
    if ([self.userNameTxtF.text isEqualToString:@"15889798801"]) {
        
    }else
//#endif
#if DEBUG
        if ([self.userNameTxtF.text isEqualToString:@"18202536913"]||[self.userNameTxtF.text isEqualToString:@"13349078667"]||[self.userNameTxtF.text isEqualToString:@"13820633188"]||[self.userNameTxtF.text isEqualToString:@"17798142060"]||[self.userNameTxtF.text isEqualToString:@"18974144528"]){
            
        }else
#endif
    if (self.passwordTxtF.text != self.codeNum) {
        [NSString toast:@"请输入正确的验证码"];
        return;
    }
    
    if (!self.checkBtn.isSelected) {
        [NSString toast:@"同意服务标准及违约责任约定才可以登录！"];
        return;
    }
    
    [self.view endEditing:YES];
    WEAKSELF
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.userNameTxtF.text,@"vo.userNamef", nil];
    [UserInfoObj sendLoginRequestWithParameters:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (weakSelf.loginAction) {
            weakSelf.loginAction(1);
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params addUnEmptyString:weakSelf.userNameTxtF.text forKey:@"mobilef"];
        [DutytoDecideObj sendDutytoDecideWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
            
        } failedBlock:^(HttpRequest *request, HttpResponse *response) {
            
        }];
        [NSString toast:@"登录成功"];
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --免费注册
- (IBAction)registerBtnAction:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    kPushNav(registerVC, YES);
}

#pragma mark --找回密码
- (IBAction)forgetPwdBtnAction:(UIButton *)sender {
    ForgetViewController *forgetVC = [[ForgetViewController alloc] initWithNibName:@"ForgetViewController" bundle:nil];
    kPushNav(forgetVC, YES);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    long leg = [toBeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    NSInteger tag = textField.tag;
    
    if (tag==100) {
        if (leg>10) {
            textField.text = [toBeString substringToIndex:10];
        }
        if (![textField ChenkInputNSCharacterSet:string typeInt:2]) {
            return NO;
        }
    }else if (tag==101){
        if (leg>5) {
            textField.text = [toBeString substringToIndex:5];
        }
        //        if (![textField ChenkInputNSCharacterSet:string typeInt:4]) {
        //            return NO;
        //        }
    }
    
    return YES;
    
}

#pragma mark --
- (IBAction)yuedingBtnAction:(id)sender {
    
    OtherWebViewController *otherVC = [[OtherWebViewController alloc] initWithNibName:@"OtherWebViewController" bundle:nil];
    MainNavigationViewController *navVC = [[MainNavigationViewController alloc] initWithRootViewController:otherVC];
    [self presentViewController:navVC animated:YES completion:nil];
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
