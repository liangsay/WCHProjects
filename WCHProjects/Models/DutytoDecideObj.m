//
//  DutytoDecideObj.m
//  WCHProjects
//
//  Created by liujinliang on 2017/8/3.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "DutytoDecideObj.h"

@implementation DutytoDecideObj

#pragma mark --验证当前用户是否是系统用户
+(void)sendDutytoDecideWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_DutytoDecide() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        DutytoDecideObj *dutyObj = response.responseModel;
        if (dutyObj) {
            [dutyObj cache];
        }else{
            [DutytoDecideObj clear];
        }
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [DutytoDecideObj clear];
        failedBlock(request,response);
    }];
}
@end
