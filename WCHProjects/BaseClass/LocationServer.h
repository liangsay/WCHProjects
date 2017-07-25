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
@end
