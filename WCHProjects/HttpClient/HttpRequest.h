//
// Created by liujinliang on 16/5/27.
// Copyright (c) 2016 liujinliang. All rights reserved.
//

#import <Foundation/Foundation.h>



/**!
 * 网络请求超时时间 30秒
 */
#define kRequestTimeOut 30

@class HttpResponse;
@class HttpRequest;

#if NS_BLOCKS_AVAILABLE
typedef void(^RequestSessionCompletedBlock)(HttpRequest *request, HttpResponse *response);
typedef void (^DownLoadProgress )(NSProgress *progress);
#endif

@interface HttpRequest : NSObject
{
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
}
@property (nonatomic, assign) BOOL hideSVPview; //隐藏选加载框
@property (nonatomic, strong) NSString *baseUrlStr;
@property (nonatomic, strong) NSString *requestName;
@property (nonatomic, strong) NSString *requestPath;

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;
//是否执行下载
@property (nonatomic, strong) NSNumber *isAsyncDownload;
//下载进度
@property (nonatomic, copy) DownLoadProgress downLoadProgress;
//文件路径
@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, assign) BOOL isManualCancel;      //是否为手动取消，默认为NO
- (void)startRequestWithSucessBlock:(RequestSessionCompletedBlock)success
                    withFailedBlock:(RequestSessionCompletedBlock)failure;

- (void)cancelRequest;

@end

#define DATA_FORMAT_ERROR   @"数据格式错误"
#define NETWORK_UNABLE      @"网络状况异常"
#define REQUEST_FAILE       @"网络请求失败"
#define NETCONNECT_FAILE       @"无网络连接！"
#define NETCONNECTTIME_FAILE       @"网络连接超时，请稍后再试！"


#define kCFURLErrorUnknown @"网络请求未知异常"//= -998,
#define kCFURLErrorCancelled @"网络连接取消"//= -999,
#define kCFURLErrorBadURL @"网络链接已丢失"//= -1000,
#define kCFURLErrorTimedOut @"网络请求超时，请稍后再试"//= -1001,
#define kCFURLErrorUnsupportedURL @"无法支持该服务请求"// = -1002,
#define kCFURLErrorCannotFindHost @"网络端口已丢失"//= -1003,
#define kCFURLErrorCannotConnectToHost @"未能连接该网络端口"//= -1004,
#define kCFURLErrorNetworkConnectionLost @"网络已连接丢失"// = -1005,
#define kCFURLErrorDNSLookupFailed @"DNSLookupFailed"//  = -1006,
#define kCFURLErrorHTTPTooManyRedirects @"HTTPTooManyRedirects"// = -1007,
#define kCFURLErrorResourceUnavailable @"ResourceUnavailable"// = -1008,
#define kCFURLErrorNotConnectedToInternet @"NotConnectedToInternet"// = -1009,
#define kCFURLErrorRedirectToNonExistentLocation @"RedirectToNonExistentLocation"// = -1010,
#define kCFURLErrorBadServerResponse @"BadServerResponse"//    = -1011,
#define kCFURLErrorUserCancelledAuthentication @"UserCancelledAuthentication"// = -1012,
#define kCFURLErrorUserAuthenticationRequired @"UserAuthenticationRequired"// = -1013,
#define kCFURLErrorZeroByteResource @"ZeroByteResource"//  = -1014,
#define kCFURLErrorCannotDecodeRawData @"CannotDecodeRawData"//  = -1015,
#define kCFURLErrorCannotDecodeContentData @"CannotDecodeContentData"// = -1016,
#define kCFURLErrorCannotParseResponse @"CannotParseResponse"//  = -1017,
#define kCFURLErrorInternationalRoamingOff @"InternationalRoamingOff"// = -1018,
#define kCFURLErrorCallIsActive @"CallIsActive"//    = -1019,
#define kCFURLErrorDataNotAllowed @"DataNotAllowed"    = -1020,
#define kCFURLErrorRequestBodyStreamExhausted @"RequestBodyStreamExhausted"// = -1021,
#define kCFURLErrorFileDoesNotExist @"FileDoesNotExist"//  = -1100,
#define kCFURLErrorFileIsDirectory @"FileIsDirectory"   = -1101,
#define kCFURLErrorNoPermissionsToReadFile @"NoPermissionsToReadFile" = -1102,
#define kCFURLErrorDataLengthExceedsMaximum @"DataLengthExceedsMaximum" = -1103,