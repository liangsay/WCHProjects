//
//  PersonSetViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/4/28.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "PersonSetViewController.h"
#import "UIAlertController+Blocks.h"

@interface PersonSetViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtF;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtF;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;

@end

@implementation PersonSetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人设置";
    // Do any additional setup after loading the view from its nib.
    
    [self.userNameTxtF setLayerCornerRadius:4];
    [self.userNameTxtF setLayerBorderWidth:0.5 color:[UIColor borderColor]];
    
    [self.userNameTxtF setTextFieldLeftPaddingWidth:10];
    [self.emailTxtF setTextFieldLeftPaddingWidth:10];
    
    [self.emailTxtF setLayerCornerRadius:4];
    [self.emailTxtF setLayerBorderWidth:0.5 color:[UIColor borderColor]];
    
    
    self.userNameTxtF.text = [NSString toString:[UserInfoObj model].trueNamef];
    self.emailTxtF.text = [NSString toString:[UserInfoObj model].emailf];
    
    [self.subBtn setLayerCornerRadius:4];
    [self.subBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    
}

#pragma mark --提交审核
- (IBAction)subBtnAction:(id)sender {
    
    [self.view endEditing:YES];
    if (self.userNameTxtF.text.isEmpty) {
        [NSString toast:self.userNameTxtF.placeholder];
        return;
    }
    if (self.emailTxtF.text.isEmpty) {
        [NSString toast:self.emailTxtF.placeholder];
        return;
    }
    if (!kIsEmail(self.emailTxtF.text)) {
        [NSString toast:@"请输入正确的邮箱格式"];
        return;
    }
    [self sendUsertoUpdateInfo];
}

#pragma mark --用户信息更新接口
/**
 用户信息更新接口
 
 @param parameters   <#parameters description#>
 @param successBlock <#successBlock description#>
 @param failedBlock  <#failedBlock description#>
 */
- (void)sendUsertoUpdateInfo{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:self.userNameTxtF.text forKey:@"vo.trueNamef"];
    [params addUnEmptyString:[UserInfoObj model].idf forKey:@"vo.idf"];
    [params addUnEmptyString:self.emailTxtF.text forKey:@"vo.emailf"];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.mobilePhonef"];
    [UserInfoObj sendUsertoUpdateInfoWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"修改成功"];
        [UserInfoObj model].trueNamef= self.userNameTxtF.text;
        [UserInfoObj model].emailf= self.emailTxtF.text;
        [[UserInfoObj model] cache];
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
