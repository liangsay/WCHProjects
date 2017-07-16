//
//  UpdateVersion.h
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/8.
//  Copyright © 2015年 liujinliang All rights reserved.
//


#import "BaseModel.h"
#define kH5VersionCode @"kH5VersionCode"
/*!
 *  @author liujinliang, 16-06-12 16:06:37
 *
 *  @brief 
 版本编号
 版本名称
 描述
 版本类型(IOS/Andorid)
 发布时间
 更新地址
 是否强制更新
 备注
 
 *
 *  @since <#1.0#>
 */
@interface UpdateVersion : BaseModel
@property(nonatomic, strong) NSString *versionName;
@property(nonatomic, strong) NSString *describe;
@property(nonatomic, strong) NSString *appType;
@property(nonatomic, strong) NSString *remark;
@property(nonatomic, strong) NSString *appName;// = manager;
@property(nonatomic, strong) NSString *isForecdUpdate;// = N;
@property(nonatomic, strong) NSString *publishTime;// = 1467043200000;
@property(nonatomic, strong) NSString *updateUrl;// = "http://image.fanglb.com/mobile/dev/dist.zip";
@property(nonatomic, strong) NSString *versionNum;// = 1;

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
+ (void)sendSelectAppVersionVoListRequestWithSuccessBlock:(RequestSessionCompletedBlock)successBlock
                                              failedBlock:(RequestSessionCompletedBlock)failedBlock;

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
+ (void)sendSelectH5AppVersionVoRequestWithSuccessBlock:(RequestSessionCompletedBlock)successBlock
                                            failedBlock:(RequestSessionCompletedBlock)failedBlock;

@end
