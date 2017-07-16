//
//  PersonSetViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/4/28.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "PersonSetViewController.h"
#import "UIAlertController+Blocks.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface PersonSetViewController ()<UITextFieldDelegate,BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtF;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtF;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIButton *goWorkBtn;
@property (weak, nonatomic) IBOutlet UIButton *offWorkBtn;

@property (nonatomic, strong) NSString *startLocationf;
@property (nonatomic, strong) NSString *endLocationf;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, assign) NSInteger workType;//打卡类型：1上班，2下班
@end

@implementation PersonSetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _locService.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _locService.delegate = nil;
}

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
    [self.goWorkBtn setLayerCornerRadius:4];
    [self.offWorkBtn setLayerCornerRadius:4];
    
    
    [self.subBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.goWorkBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.offWorkBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
}

- (void)startLocationSet {
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        //开始定位用户的位置
        //初始化BMKLocationService
        if (!_locService) {
            _locService = [[BMKLocationService alloc] init];
        }
        _locService.delegate = self;
        _locService.distanceFilter = 100.0;
        _locService.allowsBackgroundLocationUpdates = NO;
        [_locService startUserLocationService];
    }else{
        //不能定位用户的位置
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
        [NSString toast:@"请打开手机:设置-》隐私-》定位服务-》六六微货选择定位信息"];
    }
    
}

#pragma mark --BMKLocationServiceDelegate------------------
//实现相关delegate 处理位置信息更新
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    if (userLocation.location.coordinate.latitude !=0) {
        [_locService stopUserLocationService];
        if (_workType==1) {
            _startLocationf = [NSString stringWithFormat:@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
            [self sendDutydoInWork];
        }else{
            _endLocationf = [NSString stringWithFormat:@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
            [self sendDutydoOutWork];
        }
        
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    [NSString toast:@"获取位置失败"];
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
        
    }];
}

#pragma mark --上班打卡
- (IBAction)goWorkBtnAction:(id)sender {
    WEAKSELF
    _workType = 1;
    [UIAlertController showAlertInViewController:self withTitle:@"上班打卡提示" message:@"您是否要上班打卡了？" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex==2) {
            [weakSelf startLocationSet];
        }
    }];
}

#pragma mark --下班打卡
- (IBAction)offWorkBtnAction:(id)sender {
    WEAKSELF
    _workType = 2;
    [UIAlertController showAlertInViewController:self withTitle:@"下班打卡提示" message:@"您是否要下班打卡了？" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex==2) {
            [weakSelf startLocationSet];
        }
    }];
}

//上班打卡
- (void)sendDutydoInWork {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.mobilef"];
    [params addUnEmptyString:self.startLocationf forKey:@"vo.startLocationf"];
    [params addUnEmptyString:[UserInfoObj model].idf forKey:@"vo.createIdf"];
    [params addUnEmptyString:[UserInfoObj model].trueNamef forKey:@"vo.trueNamef"];
    [UserInfoObj sendDutydoInWorkWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        id dict = response.responseObject;
        if (kISKIND_OF_CLASS_NSDICTIONARY(dict)) {
            NSDictionary *dic = dict;
            if ([[NSString toString:dic[@"status"]] isEqual:@"1"]) {
                [NSString toast:@"上班打卡成功!"];
                return;
            }
        }
        [NSString toast:@"上班打卡失败!"];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
    }];
}

//下班打卡
- (void)sendDutydoOutWork {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.mobilef"];
    [params addUnEmptyString:self.endLocationf forKey:@"vo.endLocationf"];
    [params addUnEmptyString:[UserInfoObj model].idf forKey:@"vo.createIdf"];
    [params addUnEmptyString:[UserInfoObj model].trueNamef forKey:@"vo.trueNamef"];
    [UserInfoObj sendDutydoOutWorkWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        id dict = response.responseObject;
        if (kISKIND_OF_CLASS_NSDICTIONARY(dict)) {
            NSDictionary *dic = dict;
            if ([[NSString toString:dic[@"status"]] isEqual:@"1"]) {
                [NSString toast:@"下班打卡成功!"];
                return;
            }
        }
        [NSString toast:@"下班打卡失败!"];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
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
