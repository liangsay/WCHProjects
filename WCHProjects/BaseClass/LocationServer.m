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
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    self.userLocation = userLocation;
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
        self.provincef = orderObj.provincef;
        self.cityf = orderObj.cityf;
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
@end
