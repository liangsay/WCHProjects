//
//  LocationServer.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/24.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "OrderInfoObj.h"

typedef void (^LocationServerBlock) (OrderInfoObj *oderObj);

@interface LocationServer : NSObject<BMKLocationServiceDelegate,
BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) NSString *provincef;
@property (nonatomic, strong) NSString *cityf;

@property (nonatomic, strong) BMKGeoCodeSearch *locSearch;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, strong) OrderInfoObj *locationObj;
@property (nonatomic, copy) LocationServerBlock orderBlock;

+ (LocationServer *)shared;

- (void)setupLocationServiceWithComplete:(LocationServerBlock)complete;

- (void)reload;


#pragma mark --检查是否有高德地图
/**
 检查是否有高德地图
 
 @return <#return value description#>
 */
+ (BOOL)checkGaoDeCanOpen;

#pragma mark --检查是否有百度地图
/**
 检查是否有百度地图
 
 @return <#return value description#>
 */
+ (BOOL)checkBaiDuCanOpen;

#pragma mark --打开手机导航系统或web订单导航
- (IBAction)carLocationWith:(CLLocation *)location orderObj:(OrderInfoObj *)orderObj seleIndex:(NSInteger)seleIndex;
@end
