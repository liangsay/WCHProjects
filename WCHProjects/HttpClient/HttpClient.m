//
//  HttpClient.m
//  JiKePlus
//
//  Created by liujinliang on 16/5/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "HttpClient.h"

#import "UIImage+GIF.h"
//#import "JSONKit.h"
#import "SVProgressHUD.h"

@class HttpRequest;
@implementation HttpClient


- (void)initActivity{
    //数据初始化
//    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}
+ (instancetype)sharedClient {
    static HttpClient *_sharedURLClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:apiBaseURLString];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //                [config setHTTPAdditionalHeaders:@{@"User-Agent":@"TuneStore iOS 1.0"}];
        
        //设置我们的缓存大小  其中内存缓存大小设置10M 磁盘缓存5m
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 diskCapacity:50 * 1024 diskPath:nil];
        [config setURLCache:cache];
        
        _sharedURLClient = [[HttpClient alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        
        
        _sharedURLClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedURLClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [_sharedURLClient.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
       _sharedURLClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [_sharedURLClient initActivity];
        
        UIImage *gifImg = [UIImage sd_animatedGIFNamed:@"loading"];
        //        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setOffsetFromCenter:(UIOffset){0,0}];
        [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:.7]];
        [SVProgressHUD setInfoImage:gifImg];
    });
    
    return _sharedURLClient;
}


#pragma mark --执行数据请求并获取请求处理后的结果
/*!
 *  @author liujinliang, 16-02-17 13:02:19
 *
 *  @brief 执行数据请求并获取请求处理后的结果
 *
 *  @param requestName 请求方法的对应方法名称
 *  @param path        请求方法路径
 *  @param parameters  请求参数
 *  @param isPost      是否为post请求
 *  @param sucessBlock 成功结果
 *  @param failedBlock 失败结果
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (HttpRequest *)requsetSessionWithName:(NSString *)requestName withPath:(NSString *)path withParameters:(NSMutableDictionary *)parameters withisPost:(BOOL)isPost withSucessBlock:(RequestSessionCompletedBlock)sucessBlock withFailedBlock:(RequestSessionCompletedBlock)failedBlock {
    
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    //普通请求
    HttpRequest *request = [[HttpRequest alloc] init];
    request.requestName = [NSString stringWithFormat:@"%@",requestName];
    request.requestPath = [NSString stringWithFormat:@"%@",path];
    if ([parameters[kIsHideLoadingView] boolValue]) {
        request.hideSVPview = YES;
        [parameters removeObjectForKey:kIsHideLoadingView];
    }
    request.params = parameters;
    request.baseUrlStr = apiBaseURLString;
    DLog(@"request:%@",request);
    
    [request startRequestWithSucessBlock:sucessBlock withFailedBlock:failedBlock];
    return request;
}


#pragma mark --请求入口
/*!
 *  @author liujinliang, 16-02-16 17:02:22
 *
 *  @brief 请求入口
 *
 *  @param dic          <#dic description#>
 *  @param successBlock <#successBlock description#>
 *  @param failedBlock  <#failedBlock description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (HttpRequest *)getObjectWithDic:(NSMutableDictionary *)dic
                          apiName:(NSString *)apiName
                     successBlock:(RequestSessionCompletedBlock)successBlock
                      failedBlock:(RequestSessionCompletedBlock)failedBlock
{
    
    NSString *requestName = @"--";
    BOOL isPost = YES;
    HttpRequest *request = [self requsetSessionWithName:requestName withPath:apiName withParameters:dic withisPost:isPost withSucessBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request, response);
    } withFailedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request, response);
    }];
    return request;
}


@end
