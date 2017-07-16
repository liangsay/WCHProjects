//
//  EndOrderLocationServer.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/20.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "EndOrderLocationServer.h"
#import <CoreLocation/CLLocation.h>
@implementation EndOrderLocationServer

+ (EndOrderLocationServer *)sharedLocationServer{
    static EndOrderLocationServer *_sharedLServer = nil;
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
- (void)setupLocationServiceWithComplete:(EndOrderLocationServerBlock)complete{
    
    _locSearch = [[BMKGeoCodeSearch alloc] init];
    _locSearch.delegate = self;
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    
    //启动LocationService
    [_locService startUserLocationService];
    self.orderBlock = complete;
}

- (void)setupLocationServiceWithOrderObj:(OrderInfoObj *)orderObj complete:(EndOrderLocationServerBlock)complete {
    self.endOrderObj = orderObj;
    [self setupLocationServiceWithComplete:complete];
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
    
    self.endUserLocation = userLocation;
    //    [_mapView updateLocationData:userLocation];
    
    if (self.endUserLocation.location.coordinate.longitude >0||self.endUserLocation.location.coordinate.latitude>0) {
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
        orderObj.endLocation = [[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude];
        
        if (self.endOrderObj && self.orderBlock) {
            self.endOrderObj.endAddrNamef = orderObj.endAddrNamef;
            self.endOrderObj.provincef = orderObj.provincef;
            self.endOrderObj.cityf = orderObj.cityf;
            self.endOrderObj.endLocation =orderObj.endLocation;
            self.orderBlock(self.endOrderObj);
            _locSearch.delegate = nil;
            _locService.delegate = nil;
            self.orderBlock = nil;
        }else
        if (self.orderBlock) {
            self.orderBlock(orderObj);
            _locSearch.delegate = nil;
            _locService.delegate = nil;
            self.orderBlock = nil;
        }
        [_locService stopUserLocationService];
    }
    
}
@end
