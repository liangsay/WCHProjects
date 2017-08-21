//
//  UserInfoObj.h
//  WUFrameWork
//
//  Created by liujinliang on 15/12/17.
//  Copyright © 2015年 liujinliang All rights reserved.
//

#import "BaseModel.h"
#import "HttpResponse.h"
#pragma mark --用户对象----------------------------------------------------------------------


@interface UserInfoObj : BaseModel
@property(nonatomic, strong)NSString *storeTrueNamef;
@property(nonatomic, strong)NSString *startTimef;
@property(nonatomic, strong)NSString *endTimef;
@property(nonatomic, strong)NSString *storeIdf;
@property(nonatomic, strong)NSString *userIdf;
@property(nonatomic, strong)NSString *balancef;//0,
@property(nonatomic, strong)NSString *checked;//false,
@property(nonatomic, strong)NSString *dataSortNumf;//0,
@property(nonatomic, strong)NSString *orderNof;
@property(nonatomic, strong)NSString *emailf;//"",
@property(nonatomic, strong)NSString *idf;//"667ce6bf-7501-4872-8c63-e01a4bbe8306",
@property(nonatomic, strong)NSString *mobilePhonef;//"13922163927",
@property(nonatomic, strong)NSString *sex;//"1",
@property(nonatomic, strong)NSString *sortNumf;//0,
@property(nonatomic, strong)NSString *statusf;//0,
@property(nonatomic, strong)NSString *trueNamef;//"系统管理员",
@property(nonatomic, strong)NSString *userNamef;//"admin",
@property(nonatomic, strong)NSString *userNof;//0,
@property(nonatomic, strong)NSString *userTypef;

@property(nonatomic, strong)NSString *provincef;
@property(nonatomic, strong)NSString *cityf;

@property(nonatomic, strong)NSString *amDistf;//"1876.98";
@property(nonatomic, strong)NSString *amFinef;//40;
@property(nonatomic, strong)NSString *amTimeDif;//152;
@property(nonatomic, strong)NSString *amTimef;//"2017-08-07 08:30:00";
//@property(nonatomic, strong)NSString *cityf;//"天津市";
@property(nonatomic, strong)NSString *createIdf;//"d24845ab-4662-4ba7-9a18-009fdfa2139f";
@property(nonatomic, strong)NSString *createTimef;//"2017-08-07";
//@property(nonatomic, strong)NSString *dataSortNumf;//1502074943122;
@property(nonatomic, strong)NSString *deptIdf;//"2_38";
@property(nonatomic, strong)NSString *endLocationf;//"";
@property(nonatomic, strong)NSString *endPicf;//"";
//@property(nonatomic, strong)NSString *endTimef;//"2017-08-07 11:11:31";
@property(nonatomic, strong)NSString *idNumf;//120105195908051535;
//@property(nonatomic, strong)NSString *idf;//"aa06487a-1241-4940-af32-c52f02bd3fda";
@property(nonatomic, strong)NSString *mobilef;//13820633188;
@property(nonatomic, strong)NSString *pmDistf;//"1876.98";
@property(nonatomic, strong)NSString *pmFinef;//40;
@property(nonatomic, strong)NSString *pmTimeDif;//378;
//@property(nonatomic, strong)NSString *provincef;//"天津市";
@property(nonatomic, strong)NSString *startLocationf;//"";
@property(nonatomic, strong)NSString *startPicf;//"";
//@property(nonatomic, strong)NSString *startTimef;//"2017-08-07 11:02:23";
@property(nonatomic, strong)NSString *storeNamef;//"天津韩家墅店";
//@property(nonatomic, strong)NSString *trueNamef;//"安志伟";
//@property(nonatomic, strong)NSString *userIdf;//"d24845ab-4662-4ba7-9a18-009fdfa2139f";



+ (void)sendAppToAccess;
#pragma mark --3.2登陆接口
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
+ (void)sendLoginRequestWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                           failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用户头像上传
/*!
 *  @author liujinliang, 16-06-14 16:06:01
 *
 *  @brief 用户头像上传
 *
 *  @param parameters   <#parameters description#>
 *  @param successBlock <#successBlock description#>
 *  @param failedBlock  <#failedBlock description#>
 *
 *  @since <#1.0#>
 */
+ (void)sendUploadImageRequestWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                 failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用户信息更新接口
+(void)sendUsertoUpdateInfoWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                              failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --发送短信的接口
+ (void)sendSmstoSendWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --注册接口
+ (void)sendUserdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于修改密码
+ (void)sendSmsdoUpdateWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --阿里接口用于获得签名
+(void)sendOrdertoAliPayWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                           failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --验证当前用户是否是系统用户
+(void)sendDutytoDecideWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                           failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --上班打卡
+(void)sendDutydoInWorkWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --下班打卡
+(void)sendDutydoOutWorkWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --查询个人打卡信息
/**
 查询个人打卡信息
 
 @param parameters <#parameters description#>
 @param successBlock <#successBlock description#>
 @param failedBlock <#failedBlock description#>
 */
+ (void)sendDutytoMobileWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                           failedBlock:(RequestSessionCompletedBlock)failedBlock;
@end

#pragma mark --楼盘对象----------------------------------------------------------------------
@interface BuildInfoObj : BaseModel

@end
