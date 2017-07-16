//
//  EndOrderLocationServer.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/20.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "OrderInfoObj.h"
typedef void (^EndOrderLocationServerBlock) (OrderInfoObj *oderObj);

@interface EndOrderLocationServer : NSObject<BMKLocationServiceDelegate,
BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) BMKGeoCodeSearch *locSearch;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKUserLocation *endUserLocation;
@property (nonatomic, strong) OrderInfoObj *endOrderObj;
+ (EndOrderLocationServer *)sharedLocationServer;
- (void)setupLocationServiceWithComplete:(EndOrderLocationServerBlock)complete;

- (void)setupLocationServiceWithOrderObj:(OrderInfoObj *)orderObj complete:(EndOrderLocationServerBlock)complete;
@property (nonatomic, copy) EndOrderLocationServerBlock orderBlock;
@end
