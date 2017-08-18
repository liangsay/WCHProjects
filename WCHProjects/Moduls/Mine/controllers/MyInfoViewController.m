//
//  MyInfoViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/3.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "MyInfoViewController.h"

@interface MyInfoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtF;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人设置";
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
    [self.userNameTxtF setLayerBorderWidth:.5 color:[UIColor borderColor]];
    [self.userNameTxtF setLayerCornerRadius:4];
    [self.userNameTxtF setTextFieldLeftPaddingWidth:5];
    
    [self.emailTxtF setLayerBorderWidth:.5 color:[UIColor borderColor]];
    [self.emailTxtF setLayerCornerRadius:4];
    [self.emailTxtF setTextFieldLeftPaddingWidth:5];

    [self.submitBtn setLayerCornerRadius:4];
    
    self.userNameTxtF.text = [NSString toString:[UserInfoObj model].trueNamef];
    self.emailTxtF.text = [NSString toString:[UserInfoObj model].emailf];
    
}

#pragma mark --执行用户信息更新接口
/**
 执行用户信息更新接口

 @param sender <#sender description#>
 */
- (IBAction)submitBtnAction:(UIButton *)sender {
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
