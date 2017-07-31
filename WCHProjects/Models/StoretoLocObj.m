//
//  StoretoLocObj.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/31.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "StoretoLocObj.h"

@implementation StoretoLocObj

#pragma mark --查询该城市里的门店
+ (void)sendStoretoLocWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                         failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_StoretoLoc() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

@end
