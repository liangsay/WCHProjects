//
//  UpdateVersion.m
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/8.
//  Copyright © 2015年 liujinliang All rights reserved.
//

#import "UpdateVersion.h"

@implementation UpdateVersion

#pragma mark --2.5.3版本检查(杨军)
/*!
 *  @author liujinliang, 16-06-12 16:06:38
 *
 *  @brief 2.5.3版本检查(杨军)
 *
 *  @param parameters   <#parameters description#>
 *  @param successBlock <#successBlock description#>
 *  @param failedBlock  <#failedBlock description#>
 *
 *  @since <#1.0#>
 */
/*
+ (void)sendSelectAppVersionVoListRequestWithSuccessBlock:(RequestSessionCompletedBlock)successBlock
                                              failedBlock:(RequestSessionCompletedBlock)failedBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters addUnEmptyString:@"manager" forKey:@"appName"];
    [parameters addUnEmptyString:BUILD forKey:@"versionNum"];
    [parameters addUnEmptyString:@"IOS" forKey:@"appType"];
    [self sendRequestWithAPI:kAPI_selectAppVersionVoList params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}


*/
#pragma mark --html5版本检测
/*!
 *  @author liujinliang, 16-06-29 18:06:42
 *
 *  @brief html5版本检测
 *
 *  @param successBlock <#successBlock description#>
 *  @param failedBlock  <#failedBlock description#>
 *
 *  @since <#1.0#>
 */
/*
+ (void)sendSelectH5AppVersionVoRequestWithSuccessBlock:(RequestSessionCompletedBlock)successBlock
                                            failedBlock:(RequestSessionCompletedBlock)failedBlock {
    NSInteger versionCode = [kGetObjectForKey(kH5VersionCode) integerValue];
#if DEBUG
//    versionCode = 9;
    versionCode = 1;
#endif
    if (versionCode==0) {
        versionCode = 1;
        kSetObjectForKey(@(versionCode), kH5VersionCode);
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters addUnEmptyString:@"manager" forKey:@"appName"];
    [parameters addUnEmptyString:@(versionCode) forKey:@"versionNum"];
    [self sendRequestWithAPI:kAPI_selectH5AppVersionVo params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}*/
@end
