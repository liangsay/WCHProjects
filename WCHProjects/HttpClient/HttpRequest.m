//
// Created by liujinliang on 16/5/27.
// Copyright (c) 2016 liujinliang. All rights reserved.
//

#import "HttpRequest.h"
#import "HttpResponse.h"
#import "HttpLoadServer.h"

static BOOL isFirst = NO;
static BOOL canCheckNetwork = NO;
@implementation HttpRequest

#pragma mark -

#pragma mark - Init
-(id)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize{
    
    //数据初始化
    self.params = [[NSMutableDictionary alloc] init];
    self.isManualCancel = NO;
}

- (void)startRequestWithSucessBlock:(RequestSessionCompletedBlock)success withFailedBlock:(RequestSessionCompletedBlock)failure {
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    if (!isFirst) {
        //网络只有在stratMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            canCheckNetwork = YES;
        }];
        isFirst = YES;
    }
    
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    //网络有问题
    if (!isOK && canCheckNetwork) {
        NSError *error = [NSError errorWithDomain:NETWORK_UNABLE code:100 userInfo:nil];
        HttpResponse *response = [[HttpResponse alloc] initWithResponseDic:nil];
        response.responseName = [NSString stringWithFormat:@"%@响应",self.requestName];
        
        if (error.code==-988) {
            response.responseMsg = kCFURLErrorUnknown;
        }else if(error.code == -1004)
            response.responseMsg = kCFURLErrorCannotConnectToHost;
        else if (error.code == -1001||error.code == -2102)
            response.responseMsg = kCFURLErrorTimedOut;
        else
            response.responseMsg = REQUEST_FAILE;
        
        DLog(@"%@",error);
        //手动取消的不弹出错误
        if (self.isManualCancel == NO) {
            [SVProgressHUD showErrorWithStatus:response.responseMsg]; //REQUEST_FAILE
        }else{
            [SVProgressHUD dismiss];
        }
        
        failure(self,response);
        return;
    }
    
    
    
    // 不显示加载状态的接口
    if(!_hideSVPview)
    {
        //        [SVProgressHUD showImage:[UIImage imageNamed:@"loading_0"] status:@"请稍等..."];
        [[HttpLoadServer sharedHttpLoadServer] show];
        //        UIImage *gifImg = [UIImage sd_animatedGIFNamed:@"loading"];
        //        UIImageView *loadingV = [[UIImageView alloc] initWithImage:gifImg];
        //        [loadingV setContentMode:UIViewContentModeCenter];
        //        loadingV.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
        //        [loadingV setFrame:(CGRect){0,0,60,60}];
        //        [SVProgressHUD showImage:gifImg status:@""];
        ////        [SVProgressHUD show];
    }
    NSString *restUrl = self.baseUrlStr;//[ShoveGeneralRestGateway buildUrl:URLString key:MD5key parameters:parameters];
    //解决因特殊符号而提交异常的情况
    /*NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
     (CFStringRef)restUrl,
     NULL,
     CFSTR(":/?#[]@!$&’()*+,;="),
     kCFStringEncodingUTF8);
     
     restUrl = baseString;*/
    
    //    __block HttpRequest *bHttpRequest = self;
    
    WEAKSELF
    if (!self.isAsyncDownload.boolValue) {
        //普通数据请求
        
        [[HttpClient sharedClient] POST:_requestPath parameters:_params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[HttpLoadServer sharedHttpLoadServer] hide];
            if (kISKIND_OF_CLASS_NSDICTIONARY(responseObject)) {
                //处理成功时的请求
                NSMutableDictionary *responseDic = responseObject;
                DLog(@"responseObject:%@  :%@",weakSelf.requestPath,[responseObject description]);
                HttpResponse *response = [[HttpResponse alloc] initWithResponseDic:responseDic];
                response.responseName = [NSString stringWithFormat:@"%@响应",self.requestName];
                response.responseObject = responseObject;
                if (!kISKIND_OF_CLASS_NSDICTIONARY(responseObject)) {
                    response.resultJsonStr =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                }
                
                if (response.isSuccess == YES) {
                    //请求成功
                    success(self,response);
                    
                }else{
                    if (response.responseCode ==15) {
                        response.responseMsg = DATA_FORMAT_ERROR;
                    }
//                    [response.responseMsg toast];
                    failure(self,response);
                }
                DLog(@"response%@",[response description]);
            }else if(kIsObjectEmpty(responseObject)){
                HttpResponse *response = [[HttpResponse alloc] init];
                response.responseName = [NSString stringWithFormat:@"%@响应",self.requestName];
                response.responseObject = responseObject;
                response.responseCode = -1;
                response.responseMsg = DATA_FORMAT_ERROR;
                failure(self,response);
//                [NSString toast:DATA_FORMAT_ERROR];
            }
            DLog(@"responseObject:%@",[responseObject description]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"error.localizedDescription:%@",error.localizedDescription);
            [[HttpLoadServer sharedHttpLoadServer] hide];
            HttpResponse *response = [[HttpResponse alloc] init];
            response.responseName = [NSString stringWithFormat:@"%@响应",self.requestName];
            response.responseCode = -1;
            response.responseMsg = DATA_FORMAT_ERROR;
            failure(self,response);
//            [NSString toast:DATA_FORMAT_ERROR];
        }];
    }else{
        //文件下载
        
        WEAKSELF
        //默认配置
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //AFN3.0+基于封住URLSession的句柄
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _downloadTask = [manager downloadTaskWithRequest:self.urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
            // @property int64_t totalUnitCount;     需要下载文件的总大小
            // @property int64_t completedUnitCount; 当前已经下载的大小
            //            DLog(@"totalUnitCount:%f \ncompletedUnitCount:%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount)
            if (weakSelf.downLoadProgress) {
                weakSelf.downLoadProgress(downloadProgress);
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
            
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:path];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            HttpRequest *req = [HttpRequest new];
            req.filePath = [filePath path];// 将NSURL转成NSString
            success(req,nil);
        }];
        [self startDownloadBtnClick:nil];
    }
    
    DLog(@"request:%@",[NSString stringWithFormat:@"%@/%@",apiBaseURLString(),restUrl]);
}


- (IBAction)stopDownloadBtnClick:(id)sender {
    //暂停下载
    [_downloadTask suspend];
}
- (IBAction)startDownloadBtnClick:(id)sender {
    //开始下载
    [_downloadTask resume];
}
#pragma mark --取消数据请求处理
/*!
 *  @author liujinliang, 16-02-17 09:02:17
 *
 *  @brief 取消数据请求处理
 *
 *  @since <#version number#>
 */
- (void)cancelRequest{
    
    self.isManualCancel = YES;
    if (_sessionTask) {
        [_sessionTask cancel];
    }
}


-(NSString *)description{
    
    NSMutableString *descripString = [NSMutableString stringWithFormat:@""];
    [descripString appendString:@"\n========================Request Info start==========================\n"];
    [descripString appendFormat:@"HttpRequest Name:%@\n",self.requestName];
    [descripString appendFormat:@"HttpRequest Url:%@\n",self.requestPath];
    [descripString appendFormat:@"HttpRequest Methods:%@\n",[self.urlRequest HTTPMethod]];
    [descripString appendFormat:@"HttpRequest params:\n%@\n",[self.params description]];
    [descripString appendString:@"\n=========================Request Info end===========================\n"];
    return descripString;
}
@end
