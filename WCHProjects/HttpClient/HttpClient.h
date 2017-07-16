//
//  HttpClient.h
//  JiKePlus
//
//  Created by liujinliang on 16/5/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "AFNetworking.h"
#import "HttpRequest.h"

#define kIsHideLoadingView @"kIsHideLoadingView"
#define  kWkZIPNAME @"dist.zip"

typedef void (^UnArchiveBlock) (id unarchive);
@interface HttpClient : AFHTTPSessionManager
+ (HttpClient *)sharedClient;
//解压回调
@property (nonatomic, copy) UnArchiveBlock unarchiveAction;
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
                      failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --执行文件下载
/*!
 *  @author liujinliang, 16-06-23 18:06:43
 *
 *  @brief 执行文件下载
 *
 *  @param fileUrl   <#fileUrl description#>
 *  @param filedPath <#filedPath description#>
 *  @param progress  <#progress description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#1.0#>
 */
- (HttpRequest *)asyncDownloadWithFileURL:(NSString *)fileUrl
                                filedPath:(NSString *)filedPath
                                 progress:(DownLoadProgress)progress;
@end
