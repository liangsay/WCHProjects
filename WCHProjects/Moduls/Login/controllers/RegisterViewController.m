//
//  RegisterViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/2.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIButton+Category.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTxtF;
@property (weak, nonatomic) IBOutlet UITextField *setPwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *surePwdTxtF;
@property (weak, nonatomic) IBOutlet UITextField *codeTxtF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) NSString *codeNum;
@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免费注册";
    [self setupBackButton];
    // Do any additional setup after loading the view from its nib.
    [self setupViewsStyle];
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
    [self.mobileTxtF setLayerBorderWidth:.5 color:[UIColor borderColor]];
    [self.mobileTxtF setLayerCornerRadius:4];
    [self.mobileTxtF setTextFieldLeftPaddingWidth:5];
    
    [self.setPwdTextF setLayerBorderWidth:.5 color:[UIColor borderColor]];
    [self.setPwdTextF setLayerCornerRadius:4];
    [self.setPwdTextF setTextFieldLeftPaddingWidth:5];
    
    [self.surePwdTxtF setLayerBorderWidth:.5 color:[UIColor borderColor]];
    [self.surePwdTxtF setLayerCornerRadius:4];
    [self.surePwdTxtF setTextFieldLeftPaddingWidth:5];
    
    [self.codeTxtF setLayerBorderWidth:.5 color:[UIColor borderColor]];
    [self.codeTxtF setLayerCornerRadius:4];
    [self.codeTxtF setTextFieldLeftPaddingWidth:5];
    
    [self.getCodeBtn setLayerCornerRadius:4];
    [self.submitBtn setLayerCornerRadius:4];
    
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
        if (![textField ChenkInputNSCharacterSet:string typeInt:2]) {
            return NO;
        }
        //        if (![textField ChenkInputNSCharacterSet:string typeInt:4]) {
        //            return NO;
        //        }
    }else if (tag==102){
        if (leg>5) {
            textField.text = [toBeString substringToIndex:5];
        }
        if (![textField ChenkInputNSCharacterSet:string typeInt:2]) {
            return NO;
        }
        //        if (![textField ChenkInputNSCharacterSet:string typeInt:4]) {
        //            return NO;
        //        }
    }else if (tag==103){
        if (leg>7) {
            textField.text = [toBeString substringToIndex:7];
        }
        if (![textField ChenkInputNSCharacterSet:string typeInt:2]) {
            return NO;
        }
        //        if (![textField ChenkInputNSCharacterSet:string typeInt:4]) {
        //            return NO;
        //        }
    }
    
    return YES;
    
}

#pragma mark --获取验证码
- (IBAction)getCodeBtnAction:(UIButton *)sender {
    if (self.mobileTxtF.text.isEmpty) {
        [NSString toast:@"请输入手机号码"];
        return;
    }
    if (!kIsMobilePhone(self.mobileTxtF.text)) {
        [NSString toast:@"请输入正确的手机号码"];
        return;
    }
    if (self.setPwdTextF.text.isEmpty) {
        [NSString toast:@"请输入设置密码"];
        return;
    }
    if (self.setPwdTextF.text.isEmpty) {
        [NSString toast:@"请输入确认密码"];
        return;
    }
    [self sendSmstoSend];
}


#pragma mark --提交
- (IBAction)submitBtnAction:(UIButton *)sender {
    if (self.mobileTxtF.text.isEmpty) {
        [NSString toast:@"请输入手机好么"];
        return;
    }
    if (!kIsMobilePhone(self.mobileTxtF.text)) {
        [NSString toast:@"请输入正确的手机号码"];
        return;
    }
    if (self.setPwdTextF.text.isEmpty) {
        [NSString toast:@"请输入设置密码"];
        return;
    }
    if (self.setPwdTextF.text.isEmpty) {
        [NSString toast:@"请输入确认密码"];
        return;
    }
    if (self.codeTxtF.text.isEmpty) {
        [NSString toast:@"请输入验证码"];
        return;
    }
    if (![self.codeTxtF.text isEqualToString:self.codeNum]) {
        [NSString toast:@"请输入您收刚到的正确验证码"];
        return;
    }
    [self sendUserdoInsert];
}

#pragma mark --发送短信的接口
/**
 发送短信的接口
 */
- (void)sendSmstoSend {
    [self.view endEditing:YES];
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:@"1" forKey:@"vo.smsTypef"];
    [params addUnEmptyString:self.mobileTxtF.text forKey:@"vo.mobilef"];
    [UserInfoObj sendSmstoSendWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.codeNum = response.result;
        NSString *msg = [NSString stringWithFormat:@"验证码已发送至手机号为%@，请注意查收并注册使用",weakSelf.mobileTxtF.text];
        [NSString toast:msg];
        [weakSelf.getCodeBtn setTheCountdownButton:weakSelf.getCodeBtn startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:[UIColor mainColor] countColor:[UIColor backgroundColor]];
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --注册接口
- (void)sendUserdoInsert {
    [self.view endEditing:YES];
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:self.surePwdTxtF.text forKey:@"vo.userCheckPwdf"];
    [params addUnEmptyString:self.setPwdTextF.text forKey:@"vo.userPwdf"];
    [params addUnEmptyString:self.mobileTxtF.text forKey:@"vo.userNamef"];
    [params addUnEmptyString:@"1" forKey:@"vo.userTypef"];
    [UserInfoObj sendUserdoInsertWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"注册成功"];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        [NSString toast:@"注册成功"];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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
