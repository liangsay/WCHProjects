//
//  LocationServer.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/24.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "LocationServer.h"
#import <CoreLocation/CLLocationManager.h>
#import "UIAlertController+Blocks.h"
#import <MapKit/MapKit.h>
#import "CLLocation+LSLocation.h"

@implementation LocationServer
+ (LocationServer *)shared{
    static LocationServer *_sharedLServer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLServer = [self new];
    });
    
    return _sharedLServer;
}

#pragma mark --开启定位服务
/*!
 *  @author liujinliang, 16-09-30 23:09:26
 *
 *  @brief 开启定位服务
 *
 *  @since <#1.0#>
 */
- (void)setupLocationServiceWithComplete:(LocationServerBlock)complete{
    
    //判断定位是否开启
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
            //定位功能可用
            DLog(@"定位功能可用");
            
            self.provincef = @"天津市";
            self.cityf = @"天津市";
            _locSearch = [[BMKGeoCodeSearch alloc] init];
            _locSearch.delegate = self;
            
            //初始化BMKLocationService
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate = self;
            
            
            //启动LocationService
            [_locService startUserLocationService];
            self.orderBlock = complete;
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

- (void)reload {
    [self setupLocationServiceWithComplete:nil];
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

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.userLocation = userLocation;
#if DEBUG
    OrderInfoObj *orderObj = [OrderInfoObj new];
    orderObj.provincef = @"天津市";
    orderObj.cityf = @"天津市";
    self.provincef = orderObj.provincef;
    self.cityf = orderObj.cityf;
    if (self.orderBlock) {
        self.orderBlock(orderObj);
        self.orderBlock = nil;
    }
    return;
#endif
    DLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    
    //    [_mapView updateLocationData:userLocation];
    
    if (self.userLocation.location.coordinate.longitude >0 || self.userLocation.location.coordinate.latitude>0) {
        BMKReverseGeoCodeOption *coordinate = [[BMKReverseGeoCodeOption alloc] init];
        coordinate.reverseGeoPoint = (CLLocationCoordinate2D)userLocation.location.coordinate;
        [_locSearch reverseGeoCode:coordinate];
        
        
    }
    
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    OrderInfoObj *orderObj = [OrderInfoObj new];
    orderObj.provincef = @"天津市";
    orderObj.cityf = @"天津市";
    self.provincef = orderObj.provincef;
    self.cityf = orderObj.cityf;
    if (self.orderBlock) {
        self.orderBlock(orderObj);
        self.orderBlock = nil;
    }
}

#pragma mark --BMKGeoCodeSearchDelegate
///BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (!kIsObjectEmpty(result.address)) {
        OrderInfoObj *orderObj = [OrderInfoObj new];
        orderObj.endAddrNamef = result.address;
        orderObj.provincef = result.addressDetail.province;
        orderObj.cityf = result.addressDetail.city;
        orderObj.addressf = result.address;
        self.provincef = orderObj.provincef;
        self.cityf = orderObj.cityf;
        self.locationObj = orderObj;
        orderObj.endLocation = [[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude];
        
        if (self.orderBlock) {
            _locSearch.delegate = nil;
            _locService.delegate = nil;
            self.orderBlock(orderObj);
            self.orderBlock = nil;
        }
        [_locService stopUserLocationService];
    }
    
}

#pragma mark --打开手机导航系统或web订单导航
- (IBAction)carLocationWith:(CLLocation *)location orderObj:(OrderInfoObj *)orderObj seleIndex:(NSInteger)seleIndex{
    if ([LocationServer checkBaiDuCanOpen]) {
        [self onDaoHangForBaiDuMap:location orderObj:orderObj seleIndex:2];
    }else if ([LocationServer checkGaoDeCanOpen]){
        [self onDaoHangForGaoDeMap:location orderObj:orderObj seleIndex:2];
    }else{
        [self onDaoHangForIOSMap:location orderObj:orderObj seleIndex:2];
    }
}

#pragma mark --检查是否有百度地图
/**
 检查是否有百度地图

 @return <#return value description#>
 */
+ (BOOL)checkBaiDuCanOpen {
    BOOL baiduMapCanOpen=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
    DLog(@"%d",baiduMapCanOpen);
    return baiduMapCanOpen;
}

#pragma mark --检查是否有高德地图
/**
 检查是否有高德地图

 @return <#return value description#>
 */
+ (BOOL)checkGaoDeCanOpen {
    BOOL gaoDeCanOpen=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
    DLog(@"%d",gaoDeCanOpen);
    return gaoDeCanOpen;
}

#pragma mark ------------------------------ 导航 - 百度
-(void) onDaoHangForBaiDuMap:(CLLocation *)location orderObj:(OrderInfoObj *)orderObj seleIndex:(NSInteger)seleIndex
{
    
    //    百度地图如何调起APP进行导航
    //    mode	导航模式，固定为transit、driving、walking，分别表示公交、驾车和步行
    NSString * modeBaiDu = @"driving";
    switch (seleIndex) {
        case 1:
        {
            modeBaiDu = @"transit";
        }
            break;
        case 2:
        {
            modeBaiDu = @"driving";
        }
            break;
        case 3:
        {
            modeBaiDu = @"walking";
        }
            break;
            
        default:
            break;
    }
    NSString *curAddress = @"";
    if (orderObj.starLocation) {
        curAddress = orderObj.startAddrNamef;
    }else if (orderObj.endLocation){
        curAddress = orderObj.endAddrNamef;
    }else if (orderObj.pointLocation){
        curAddress = orderObj.addressf;
    }
    NSString *url = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%lf,%lf&origin_region=%@&destination=%lf,%lf&destination_region=%@&mode=%@&src=com.wc66sc.WCHProjects",self.userLocation.location.coordinate.latitude,self.userLocation.location.coordinate.longitude,self.locationObj.addressf,location.coordinate.latitude,location.coordinate.longitude,curAddress,modeBaiDu] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])// -- 使用 canOpenURL 判断需要在info.plist 的 LSApplicationQueriesSchemes 添加 baidumap 。
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        [self onDaoHangForIOSMap:location orderObj:orderObj seleIndex:seleIndex];
//        [[[UIAlertView alloc]initWithTitle:@"没有安装百度地图" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    
}

#pragma mark ------------------------------ 导航 - 高德
-(void) onDaoHangForGaoDeMap:(CLLocation *)location orderObj:(OrderInfoObj *)orderObj seleIndex:(NSInteger)seleIndex
{
    //    m	驾车：0：速度最快，1：费用最少，2：距离最短，3：不走高速，4：躲避拥堵，5：不走高速且避免收费，6：不走高速且躲避拥堵，7：躲避收费和拥堵，8：不走高速躲避收费和拥堵 公交：0：最快捷，2：最少换乘，3：最少步行，5：不乘地铁 ，7：只坐地铁 ，8：时间短	是
    //    t = 0：驾车 =1：公交 =2：步行
    
    NSString * t = @"0";
    switch (seleIndex) {
        case 1:
        {
            t = @"1";
        }
            break;
        case 2:
        {
            t = @"0";
        }
            break;
        case 3:
        {
            t = @"2";
        }
            break;
            
        default:
            break;
    }
    //起点
    CLLocation * curlocation = self.userLocation.location;
    curlocation = [location locationMarsFromBaidu];
    
    CLLocationCoordinate2D coor =curlocation.coordinate;
    
    //目的地的位置
    CLLocation * location2 = [[CLLocation alloc]initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    location2 = [location2 locationMarsFromBaidu];
    
    CLLocationCoordinate2D coor2 =location2.coordinate;
    //    导航 URL：iosamap://navi?sourceApplication=%@&poiname=%@&lat=%lf&lon=%lf&dev=0&style=0",@"ABC"
    //    路径规划 URL：iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=39.92848272&slon=116.39560823&sname=A&did=BGVIS2&dlat=39.98848272&dlon=116.47560823&dname=B&dev=0&m=0&t=0
    // -- 不能直接让用户进入导航，应该给用户更多的选择，所以先进行路径规划
    NSString *mainTitle = @"六六微货导航";
    if (orderObj.starLocation) {
        mainTitle = orderObj.startAddrNamef;
    }else if (orderObj.endLocation){
        mainTitle = orderObj.endAddrNamef;
    }else if(orderObj.pointLocation){
        mainTitle = orderObj.addressf;
    }else{
        mainTitle = @"未知位置";
    }
    NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=%@",coor.latitude,coor.longitude, coor2.latitude,coor2.longitude,mainTitle,t] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
//        <span style="font-family: Arial, Helvetica, sans-serif;">// -- 使用 canOpenURL 判断需要在info.plist 的 LSApplicationQueriesSchemes 添加 iosamap 。</span>
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }else{
        [self onDaoHangForIOSMap:location orderObj:orderObj seleIndex:seleIndex];
//        [[[UIAlertView alloc]initWithTitle:@"没有安装高德地图" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    
    
}

#pragma mark ------------------------------ 导航 - iosMap
-(void) onDaoHangForIOSMap:(CLLocation *)location orderObj:(OrderInfoObj *)orderObj seleIndex:(NSInteger)seleIndex
{
    //起点
    CLLocation * curlocation = [[CLLocation alloc]initWithLatitude:self.userLocation.location.coordinate.latitude longitude:self.userLocation.location.coordinate.longitude];
    curlocation = [curlocation locationMarsFromBaidu];
    
    CLLocationCoordinate2D coor =curlocation.coordinate;
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc]                         initWithCoordinate:coor  addressDictionary:nil]];
    currentLocation.name =@"我的位置";
    
    //目的地的位置
    CLLocation * location2 = [[CLLocation alloc]initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    location2 = [location2 locationMarsFromBaidu];
    
    CLLocationCoordinate2D coor2 =location2.coordinate;
    //    CLLocationCoordinate2D coords = self.location;
    
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor2 addressDictionary:nil]];
    if (orderObj.starLocation) {
        toLocation.name = orderObj.startAddrNamef;
    }else if (orderObj.endLocation){
        toLocation.name = orderObj.endAddrNamef;
    }else if(orderObj.pointLocation){
        toLocation.name = orderObj.addressf;
    }else{
        toLocation.name = @"未知位置";
    }
    //self.mainTitle;
    
    NSArray *items = @[currentLocation,toLocation];//[NSArray arrayWithObjects:currentLocation, toLocation, nil nil];
    NSString * mode = MKLaunchOptionsDirectionsModeDriving;
    switch (seleIndex) {
        case 1:
        {
            mode = MKLaunchOptionsDirectionsModeTransit;
        }
            break;
        case 2:
        {
            mode = MKLaunchOptionsDirectionsModeDriving;
        }
            break;
        case 3:
        {
            mode = MKLaunchOptionsDirectionsModeWalking;
        }
            break;
            
        default:
            break;
    }
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:mode, MKLaunchOptionsMapTypeKey: [NSNumber                                 numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

@end
