//
//  CarRecruitViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/3.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "CarRecruitViewController.h"
#import "CarRecruitPhotoViewController.h"
#import "OrderInfoObj.h"
#import "ActionSheetStringPicker.h"
@interface CarRecruitViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTxtF;
@property (weak, nonatomic) IBOutlet UITextField *carTypeTxtF;
@property (weak, nonatomic) IBOutlet UITextField *carNumTxtF;
@property (weak, nonatomic) IBOutlet UITextField *identityTxtF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, strong) OrderInfoObj *orderObj;

@end

@implementation CarRecruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViewsStyle];
    self.title = @"司机审核";
    // Do any additional setup after loading the view from its nib.
    [self sendDriverinfobyMobile];
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
    
    
    [self.nextBtn setLayerCornerRadius:4];
    [self.nextBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    
}

#pragma mark --执行下一步事件响应
/*!
 *  @author liujinliang, 16-10-05 23:10:44
 *
 *  @brief 执行下一步事件响应
 *
 *  @param sender <#sender description#>
 *
 *  @since <#1.0#>
 */
- (IBAction)nextBtnAction:(id)sender {
    if (kIsObjectEmpty(self.userTxtF.text)) {
        [NSString toast:@"请输入姓名"];
        return;
    }
    if (kIsObjectEmpty(self.carTypeTxtF.text)) {
        [NSString toast:@"请选择车型"];
        return;
    }
    if (kIsObjectEmpty(self.carNumTxtF.text)) {
        [NSString toast:@"请输入车牌号"];
        return;
    }
    if (kIsObjectEmpty(self.identityTxtF.text)) {
        [NSString toast:@"请输入身份证号"];
        return;
    }
    if (!kIsIdentity(self.identityTxtF.text)) {
        [NSString toast:@"请输入正确的身份证号码"];
        return;
    }
    [self sendDriverinfodoInsert];
    CarRecruitPhotoViewController *carVC = [[CarRecruitPhotoViewController alloc] initWithNibName:@"CarRecruitPhotoViewController" bundle:nil];
    self.orderObj.modelf = self.carTypeTxtF.text;
    carVC.orderObj = self.orderObj;
    kPushNav(carVC, YES);
}

#pragma mark --根据手机号查询司机的信息
- (void)sendDriverinfobyMobile {
    WEAKSELF
    [OrderInfoObj sendDriverinfobyMobileWithParameters:[NSMutableDictionary dictionaryWithObject:[UserInfoObj model].mobilePhonef forKey:@"vo.linkPhonef"] successBlock:^(HttpRequest *request, HttpResponse *response) {
        OrderInfoObj *orderObj = response.responseModel;
        weakSelf.userTxtF.text = [NSString toString:orderObj.driverNamef];
        weakSelf.carTypeTxtF.text =[NSString toString:orderObj.modelf];
        weakSelf.carNumTxtF.text =[NSString toString:orderObj.carNof];
        weakSelf.identityTxtF.text =[NSString toString:orderObj.idNof];
        weakSelf.orderObj = orderObj;
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:response.responseMsg];
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    DLog(@"tag:%ld",textField.tag);
//    if (textField.tag==104) {
//        [self carTypeBtnAction:nil];
//        return NO;
//    }
    return YES;
}

#pragma mark --选择车型
- (IBAction)carTypeBtnAction:(UIButton *)sender {
    WEAKSELF
    
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:self.carTypeArray.count];
    [self.carTypeArray enumerateObjectsUsingBlock:^(OrderInfoObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [rows addObject:obj.namef];
    }];
    [ActionSheetStringPicker showPickerWithTitle:@"请选择车型" rows:rows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        weakSelf.carTypeTxtF.text = selectedValue;
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.navigationController.view];
}

#pragma mark --提交审核接口
/**
 用于提交司机信息
 */
- (void)sendDriverinfodoInsert {
    WEAKSELF
    UserInfoObj *user = [UserInfoObj model];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:self.userTxtF.text forKey:@"vo.driverNamef"];
    [params addUnEmptyString:self.carNumTxtF.text forKey:@"vo.carNof"];
    [params addUnEmptyString:self.identityTxtF.text forKey:@"vo.idNof"];
    [params addUnEmptyString:user.provincef forKey:@"vo.provincef"];
    [params addUnEmptyString:user.cityf forKey:@"vo.cityf"];
    [params addUnEmptyString:self.carTypeTxtF.text forKey:@"vo.modelf"];
    [params addUnEmptyString:user.mobilePhonef forKey:@"vo.linkPhonef"];
    [params addUnEmptyString:user.idf forKey:@"vo.idf"];
    [OrderInfoObj sendDriverinfodoInsertWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
//        [NSString toast:@"您的信息已提交，我们会尽快为您的车主招募审核作处理"];
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
