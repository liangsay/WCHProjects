//
//  PunchingTCViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/8/2.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "PunchingTCViewController.h"
#import "UIAlertController+Blocks.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "DutytoDecideObj.h"
#import "BaseTableView.h"

#import "DutyDoTableViewCell.h"
#import "DutyLocationTableViewCell.h"

@interface PunchingTCViewController ()<BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *onWorkBtn;
@property (weak, nonatomic) IBOutlet UIButton *offWorkBtn;

@property (nonatomic, strong) NSString *startLocationf;
@property (nonatomic, strong) NSString *endLocationf;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, assign) NSInteger workType;//打卡类型：1上班，2下班
@property (nonatomic, strong) UserInfoObj *workObj;

@property (nonatomic, assign) CLLocationDistance distance;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation PunchingTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTableViewSet];
    [self.locationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.onWorkBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.offWorkBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    _workType = 0;
    [self startLocationSet];
    
    self.onWorkBtn.enabled = NO;
    self.offWorkBtn.enabled = NO;
    [self sendDutytoMobile_API];
}

- (void)setupTableViewSet {
    [self.tableView registerNib:[UINib nibWithNibName:kDutyDoTableViewCellID bundle:nil] forCellReuseIdentifier:kDutyDoTableViewCellID];
    [self.tableView registerNib:[UINib nibWithNibName:kDutyLocationTableViewCellID bundle:nil] forCellReuseIdentifier:kDutyLocationTableViewCellID];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:[DutytoDecideObj new]];
        [_dataArray addObject:[DutytoDecideObj new]];
        [_dataArray addObject:[DutytoDecideObj new]];
    }
    return _dataArray;
}

//重新定位
- (IBAction)locationBtnAction:(UIButton *)sender {
    _workType = 0;
    [self startLocationSet];
    
}

//上班打卡
- (IBAction)goWorkBtnAction:(UIButton *)sender {
    WEAKSELF
    _workType = 1;
    [UIAlertController showAlertInViewController:self withTitle:@"上班打卡提示" message:@"您是否要上班打卡了？" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex==2) {
            [weakSelf startLocationSet];
        }
    }];
}

//下班打卡
- (IBAction)offWorkBtnAction:(UIButton *)sender {
    WEAKSELF
    _workType = 2;
    [UIAlertController showAlertInViewController:self withTitle:@"下班打卡提示" message:@"您是否要下班打卡了？" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex==2) {
            [weakSelf startLocationSet];
        }
    }];
}



- (void)startLocationSet {
 
    //判断定位是否开启
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
            //定位功能可用
            DLog(@"定位功能可用");
            
            //开始定位用户的位置
            //初始化BMKLocationService
            if (!_locService) {
                _locService = [[BMKLocationService alloc] init];
            }
            _locService.delegate = self;
            //_locService.distanceFilter = 100.0;
            //_locService.allowsBackgroundLocationUpdates = NO;
            [_locService startUserLocationService];
        }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
            
            //定位不能用
            DLog(@"定位不能用");
            //用户拒绝开启用户权限
            [UIAlertController showAlertInViewController:kAppDelegate.tabBarVC withTitle:@"定位提示" message:@"打开[定位服务权限]来允许[六六微货]确定您的位置" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"去设置"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if (buttonIndex==2) {
                    //跳转到定位权限页面
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    
                }
            }];
            
            
        }
        
    }else{
        [UIAlertController showAlertInViewController:kAppDelegate.tabBarVC withTitle:@"打开[定位服务]来允许[六六微货]确定您的位置" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>六六微货>始终)" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"去设置"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex==2) {
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.000000) {
                    //跳转到定位权限页面
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }else {
                    //跳转到定位开关界面
                    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
                    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
                
            }
        }];
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
UIKIT_EXTERN CLLocationDistance BMKMetersBetweenMapPoints(BMKMapPoint a, BMKMapPoint b);
UIKIT_EXTERN BMKMapPoint BMKMapPointForCoordinate(CLLocationCoordinate2D coordinate);
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    if (_workType==0) {
        
        NSString *locationf = [DutytoDecideObj model].locationf;
        NSArray *locations = [locationf componentsSeparatedByString:@","];
        if (locations && locations.count>1) {
            NSString *latitude = locations[0];
            NSString *longitude = locations[1];
            BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue));
            BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude));
            CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
            self.distance = distance;
            DutytoDecideObj *dutyObj = [[DutytoDecideObj alloc] init];
            if (distance>=1000) {
                
                dutyObj.otherLocationf = [NSString stringWithFormat:@"偏离门店距离:%.2f公里",distance/1000];
            }else{
                
                dutyObj.otherLocationf = [NSString stringWithFormat:@"偏离门店距离:%.2f米",distance];
            }
            
            dutyObj.locationf = [NSString stringWithFormat:@"您的当前位置是：%.6f,%.6f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude];
            
            [self.dataArray replaceObjectAtIndex:0 withObject:dutyObj];
            
            [self.tableView reloadData];
            NSLog(@"距离: %0.2f米", distance);
   
        }
    }else{
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
}


//上班打卡
- (void)sendDutydoInWork {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.mobilef"];
    [params addUnEmptyString:self.startLocationf forKey:@"vo.startLocationf"];
    [params addUnEmptyString:[DutytoDecideObj model].userIdf forKey:@"vo.createIdf"];
    [params addUnEmptyString:[DutytoDecideObj model].storeTrueNamef forKey:@"vo.trueNamef"];
    [params addUnEmptyString:[DutytoDecideObj model].userIdf forKey:@"vo.userIdf"];
    [params addUnEmptyString:[DutytoDecideObj model].storeIdf forKey:@"vo.deptIdf"];
    [params addUnEmptyString:[DutytoDecideObj model].locationf forKey:@"vo.storeLocf"];
    [params addUnEmptyString:kDoubleToString(self.distance/1000) forKey:@"vo.amDistf"];
    
    [UserInfoObj sendDutydoInWorkWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        id dict = response.responseObject;
        if (kISKIND_OF_CLASS_NSDICTIONARY(dict)) {
            NSDictionary *dic = dict;
            if ([[NSString toString:dic[@"status"]] isEqual:@"1"]) {
                [weakSelf sendDutytoMobile_API];
                [NSString toast:@"上班打卡成功!"];
                return;
            }
        }
        [NSString toast:@"上班打卡失败!"];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        [NSString toast:response.responseMsg];
    }];
}

//下班打卡
- (void)sendDutydoOutWork {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.mobilef"];
    [params addUnEmptyString:self.endLocationf forKey:@"vo.endLocationf"];
    [params addUnEmptyString:[DutytoDecideObj model].userIdf forKey:@"vo.createIdf"];
    [params addUnEmptyString:[UserInfoObj model].trueNamef forKey:@"vo.trueNamef"];
    [params addUnEmptyString:[DutytoDecideObj model].userIdf forKey:@"vo.userIdf"];
    [params addUnEmptyString:[DutytoDecideObj model].storeIdf forKey:@"vo.deptIdf"];
    [params addUnEmptyString:[DutytoDecideObj model].locationf forKey:@"vo.storeLocf"];
    [params addUnEmptyString:kDoubleToString(self.distance/1000) forKey:@"vo.pmDistf"];
    [UserInfoObj sendDutydoOutWorkWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        id dict = response.responseObject;
        if (kISKIND_OF_CLASS_NSDICTIONARY(dict)) {
            NSDictionary *dic = dict;
            if ([[NSString toString:dic[@"status"]] isEqual:@"1"]) {
                [weakSelf sendDutytoMobile_API];
                [NSString toast:@"下班打卡成功!"];
                return;
            }
        }
        [NSString toast:@"下班打卡失败!"];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --查询个人打卡信息
/**
 查询个人打卡信息
 */
- (void)sendDutytoMobile_API {
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"mobile"];
    [UserInfoObj sendDutytoMobileWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        UserInfoObj *workObj = response.responseModel;
        weakSelf.workObj = workObj;
        if (weakSelf.workObj) {
            if (!kIsObjectEmpty(workObj.amTimef)) {
//                weakSelf.ontTimeLab.text = [NSString stringWithFormat:@"上班时间：%@",weakSelf.workObj.startTimef];
//                weakSelf.onTimeTopLayoutConstraint.constant = 10;
                DutytoDecideObj *dutyObj = [DutytoDecideObj new];
                dutyObj.dutyTime = [NSString stringWithFormat:@"上班时间：%@",weakSelf.workObj.amTimef];
                dutyObj.chargeMoney = [NSString stringWithFormat:@"扣款:%.2f",workObj.amFinef.doubleValue];
                dutyObj.dutyOtherLocationf = [NSString stringWithFormat:@"上班偏离:%.2fkm",workObj.amDistf.doubleValue];
                dutyObj.lateTime = [NSString stringWithFormat:@"迟到:%ld分钟",(long)workObj.amTimeDif.integerValue];
                [weakSelf.dataArray replaceObjectAtIndex:1 withObject:dutyObj];
                
                weakSelf.onWorkBtn.enabled = NO;
                
            }else{
                weakSelf.onWorkBtn.enabled = YES;
            }
            if (!kIsObjectEmpty(weakSelf.workObj.endTimef)) {
//                weakSelf.offTimeTopLayoutConstraint.constant = 10;
//                weakSelf.offTimeLab.text = [NSString stringWithFormat:@"下班时间：%@",weakSelf.workObj.pmTimef];
                weakSelf.offWorkBtn.enabled = NO;
                DutytoDecideObj *dutyObj = [DutytoDecideObj new];
                dutyObj.dutyTime = [NSString stringWithFormat:@"下班时间：%@",weakSelf.workObj.endTimef];
                dutyObj.chargeMoney = [NSString stringWithFormat:@"扣款:%.2f",workObj.pmFinef.doubleValue];
                dutyObj.dutyOtherLocationf = [NSString stringWithFormat:@"下班偏离:%.2fkm",workObj.pmDistf.doubleValue];
                dutyObj.lateTime = [NSString stringWithFormat:@"早退:%ld分钟",(long)workObj.pmTimeDif.integerValue];
                [weakSelf.dataArray replaceObjectAtIndex:2 withObject:dutyObj];
            }else{
                weakSelf.offWorkBtn.enabled = YES;
            }
        }
        [weakSelf.tableView reloadData];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
        if (response.responseCode==0) {
            weakSelf.onWorkBtn.enabled = YES;
            
            return ;
        }else{
            [NSString toast:response.responseMsg];
        }
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        return kDutyLocationTableViewCellHeight;
    }else{
        DutytoDecideObj *model = self.dataArray[row];
        if (model.dutyTime.length > 10) {
            return kDutyDoTableViewCellHeight;
        }else{
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    DutytoDecideObj *model = self.dataArray[row];
    if (row == 0) {
        DutyLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDutyLocationTableViewCellID forIndexPath:indexPath];
        // Configure the cell...
        cell.type1Lab.text = model.otherLocationf;
        cell.type2Lab.text = model.locationf;
        return cell;
    }else{
        DutyDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDutyDoTableViewCellID forIndexPath:indexPath];
        // Configure the cell...
        cell.type1Lab.text = model.dutyTime;
        cell.type2Lab.text = model.chargeMoney;
        cell.type3Lab.text = model.dutyOtherLocationf;
        cell.type4Lab.text = model.lateTime;
        return cell;
    }
    
}


- (void)didFailToLocateUserWithError:(NSError *)error {
    [NSString toast:@"获取位置失败"];
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
