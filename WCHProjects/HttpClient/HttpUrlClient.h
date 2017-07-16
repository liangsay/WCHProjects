//
//  HttpUrlClient.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/4.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HttpUrlClient : AFURLSessionManager
+ (HttpUrlClient *)sharedUrlClient;

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
@end
