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
@implementation LoginModel

@end

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtF;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViewsStyle];
#if DEBUG
    self.userNameTxtF.text = @"18202536913";//@"13922163927";
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
    
    [_showBtn setImage:kIMAGE(@"不显示密码") forState:UIControlStateNormal];
    [_showBtn setImage:kIMAGE(@"显示密码") forState:UIControlStateSelected];
}

#pragma mark --显示或隐藏密码
- (IBAction)showBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _passwordTxtF.secureTextEntry = !sender.isSelected;
}


#pragma mark --登录
- (IBAction)loginBtnAction:(id)sender {
    if (self.userNameTxtF.text.isEmpty) {
        [NSString toast:@"请输入用户名"];
        return;
    }
    if (self.passwordTxtF.text.isEmpty) {
        [NSString toast:@"请输入密码"];
        return;
    }
    [self.view endEditing:YES];
    WEAKSELF
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.userNameTxtF.text,@"vo.userNamef",
                                       self.passwordTxtF.text,@"vo.userPwdf", nil];
    [UserInfoObj sendLoginRequestWithParameters:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (weakSelf.loginAction) {
            weakSelf.loginAction(1);
        }
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
            textField.text = [textField.text substringToIndex:10];
        }
        if (![textField ChenkInputNSCharacterSet:string typeInt:2]) {
            return NO;
        }
    }else if (tag==101){
        if (leg>5) {
            textField.text = [textField.text substringToIndex:5];
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
