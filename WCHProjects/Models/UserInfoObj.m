//
//  UserInfoObj.m
//  WUFrameWork
//
//  Created by liujinliang on 15/12/17.
//  Copyright © 2015年 liujinliangcom.cn. All rights reserved.
//

#import "UserInfoObj.h"



@implementation UserInfoObj


+ (void)sendAppToAccess{
    WEAKSELF
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:@"http://www.66weihuo.com/ApptoAccess.shtml?requestType=app" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = responseObject;
            NSString *result = dic[@"result"];
            if (dic && !kIsObjectEmpty(result)) {
//                apiBaseURLString() = result;
                kSetObjectForKey(result, @"apiBaseURLString");
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark --发起用户登录请求
/*!
 *  @author liujinliang, 16-04-12 17:04:11
 *
 *  @brief 发起用户登录请求
 *
 *  @param params       <#params description#>
 *  @param successBlock <#successBlock description#>
 *  @param failedBlock  <#failedBlock description#>
 *
 *  @since <#1.0#>
 */
+ (void)sendLoginRequestWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_UsertoLogin4App() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        UserInfoObj *model =  response.responseModel;
        if (kIsObjectEmpty(model.mobilePhonef)) {
            model.mobilePhonef = model.userNamef;
        }
        [model cache];
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用户信息更新接口
/**
 用户信息更新接口

 @param parameters   <#parameters description#>
 @param successBlock <#successBlock description#>
 @param failedBlock  <#failedBlock description#>
 */
+(void)sendUsertoUpdateInfoWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                              failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_UsertoUpdateInfo() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --注册接口
+ (void)sendUserdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_userdoInsert() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --//用于修改密码
+ (void)sendSmsdoUpdateWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_SmsdoUpdatePwd() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --发送短信的接口
+ (void)sendSmstoSendWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_SmstoSend() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --阿里接口用于获得签名
+(void)sendOrdertoAliPayWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                           failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_UsertoUpdateInfo() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --验证当前用户是否是系统用户
+(void)sendDutytoDecideWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_DutytoDecide() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}


#pragma mark --上班打卡
+(void)sendDutydoInWorkWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_DutydoInWork() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --下班打卡
+(void)sendDutydoOutWorkWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                           failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_DutydoOutWork() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}
//#pragma mark --用户头像上传
///*!
// *  @author liujinliang, 16-06-14 16:06:01
// *
// *  @brief 用户头像上传
// *
// *  @param parameters   <#parameters description#>
// *  @param successBlock <#successBlock description#>
// *  @param failedBlock  <#failedBlock description#>
// *
// *  @since <#1.0#>
// */
//+ (void)sendUploadImageRequestWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
//                                 failedBlock:(RequestSessionCompletedBlock)failedBlock {
//    [self sendRequestWithAPI:KAPI_uploadImage params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
//        successBlock(request,response);
//        
//    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
//        failedBlock(request,response);
//    }];
//}


#pragma mark --查询个人打卡信息
/**
 查询个人打卡信息
 
 @param parameters <#parameters description#>
 @param successBlock <#successBlock description#>
 @param failedBlock <#failedBlock description#>
 */
+ (void)sendDutytoMobileWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                           failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_DutytoMobile() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
        failedBlock(request,response);
    }];
}
@end
