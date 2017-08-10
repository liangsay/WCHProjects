//
//  HttpUrlClient.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/4.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "HttpUrlClient.h"
#import "MJExtension.h"
#import "UIImage+GIF.h"
#import "SVProgressHUD.h"
@implementation HttpUrlClient
- (void)initActivity{
    //数据初始化
    //    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}
+ (instancetype)sharedUrlClient {
    static HttpUrlClient *_sharedURLClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        NSURL *baseURL = [NSURL URLWithString:apiBaseURLString()];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //        [config setHTTPAdditionalHeaders:@{@"User-Agent":@"TuneStore iOS 1.0"}];
        
        //设置我们的缓存大小  其中内存缓存大小设置10M 磁盘缓存5m
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 diskCapacity:50 * 1024 diskPath:nil];
        [config setURLCache:cache];
        
        _sharedURLClient = [[HttpUrlClient alloc] initWithSessionConfiguration:config];
        //        _sharedURLClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // 设置请求格式
        //        _sharedURLClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        // 设置返回格式
        //        _sharedURLClient.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _sharedURLClient.responseSerializer = [AFJSONResponseSerializer serializer];
        //        _sharedURLClient.requestSerializer = [AFJSONRequestSerializer serializer];
        //        _sharedURLClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain" , nil];//text/json、application/json
        
        //        [_sharedURLClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //设置请求内容的类型
        //        [_sharedURLClient.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        //        [_sharedURLClient.requestSerializer setTimeoutInterval:kRequestTimeOut];
        //        _sharedURLClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
        //        //设置请求的编码类型
        //        [_sharedURLClient.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        //        [_sharedURLClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //        [_sharedURLClient.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        /*
         对应的 Content-Type 有两种：
         1、application/x-www-form-urlencoded
         2、multipart/form-data
         */
        
        /*
         [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
         [request addRequestHeader:@"Content-Length" value:postLength];
         */
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
    
    NSString *paramStr = @"";
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }else{
        paramStr = [parameters JSONString];
    }
    //    paramStr = [paramStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //解决因特殊符号而提交异常的情况
    NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                         (CFStringRef)paramStr,
                                                                                         NULL,
                                                                                         CFSTR(":/?#[]@!$&’()*+,;="),
                                                                                         kCFStringEncodingUTF8);
    paramStr = baseString;
    NSLog(@"paramStr:%@ \n parameters:%@",paramStr,parameters);
    NSData *postData = [paramStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength;
    if (postData){
        postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    }
    NSString *reqUrl = [NSString stringWithFormat:@"%@%@",apiBaseURLString(),path];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:kURLFromString(reqUrl)];
    [req setHTTPBody:postData];
    [req setHTTPMethod:isPost?@"POST":@"GET"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    
    //普通请求
    HttpRequest *request = [[HttpRequest alloc] init];
    request.requestName = [NSString stringWithFormat:@"%@",requestName];
    request.requestPath = [NSString stringWithFormat:@"%@",path];
    request.params = parameters;
    request.urlRequest = req;
    request.baseUrlStr = apiBaseURLString();
    
    DLog(@"request:%@",request);
    if ([parameters[kIsHideLoadingView] boolValue]) {
        request.hideSVPview = YES;
        [parameters removeObjectForKey:kIsHideLoadingView];
    }
    //    [request startRequestWithSucessBlock:sucessBlock withFailedBlock:failedBlock];
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
    }];
    [dataTask resume];
    return request;
}


@end

