//
//  LocationServer.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/24.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "LocationServer.h"

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
    
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    self.userLocation = userLocation;
    //    [_mapView updateLocationData:userLocation];
    
    if (self.userLocation.location.coordinate.longitude >0 || self.userLocation.location.coordinate.latitude>0) {
        BMKReverseGeoCodeOption *coordinate = [[BMKReverseGeoCodeOption alloc] init];
        coordinate.reverseGeoPoint = (CLLocationCoordinate2D)userLocation.location.coordinate;
        [_locSearch reverseGeoCode:coordinate];
        
        
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
