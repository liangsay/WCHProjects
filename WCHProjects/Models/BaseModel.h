//
//  BaseModel.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"
#import "MJExtension.h"

#if NS_BLOCKS_AVAILABLE
typedef void(^RequestCompletedBlock)(HttpRequest *request, HttpResponse *response);

#endif

@interface BaseModel : NSObject
@property(nonatomic,strong) NSString *myID;

#pragma mark --网络请求
/*!
 *  @author liujinliang, 16-04-12 17:04:09
 *
 *  @brief 网络请求
 *
 *  @param api          <#api description#>
 *  @param params       <#params description#>
 *  @param successBlock <#successBlock description#>
 *  @param failedBlock  <#failedBlock description#>
 *
 *  @since <#1.0#>
 */
+ (void)sendRequestWithAPI:(NSString *)api params:(NSMutableDictionary *)params successBlock:(RequestCompletedBlock)successBlock failedBlock:(RequestCompletedBlock)failedBlock;

#pragma mark - 归档
/**
 *  单个对象归档目录
 */
+ (NSString *)filePathForArchive;

/**
 * 读取归档文件
 */
+ (instancetype)unarchive;

/**
 *  归档到文件
 */
- (void)archive;

/**
 *  归档到文件。指定归档文件名
 */
- (void)archiveWithName:(NSString *)fileName;

/**
 *  删除归档文件
 */
+ (void)deleteArchivedFile;

#pragma mark - 缓存
/**
 *  缓存
 */
- (void)cache;

/**
 *  取出缓存model
 */
+ (instancetype)model;

/**
 *  删除缓存
 */
+ (void)clear;
@end

@interface SystemMessageObj : BaseModel

@property(nonatomic,strong) NSString *contentf;//;// "\U6d4b\U8bd5\Uff01\Uff01\Uff01";
@property(nonatomic,strong) NSString *createIdf;//;// 0;
@property(nonatomic,strong) NSString *createTimef;//;// "2016-09-23 16:13:34";
@property(nonatomic,strong) NSString *dataSortNumf;//;// 0;
@property(nonatomic,strong) NSString *deptIdf;//;// 0;
@property(nonatomic,strong) NSString *idf;//;// "01071189-fa5b-4984-8121-0ab332078ac6";
@property(nonatomic,strong) NSString *trueNamef;//;// 0;
#pragma mark --系统消息查询接口
+ (void) sendMessagetoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock;
@end

@interface CoupontoUserObj : BaseModel
@property(nonatomic,strong) NSString *titlef;// 标题
@property(nonatomic,assign) double couponCountf;// 金额
@property(nonatomic,strong) NSString *idf;
@property(nonatomic,assign) BOOL isExpiryDatef;// 是否过期
@property(nonatomic,strong) NSString *expiryDatef;// 有效期
@property(nonatomic,strong) NSString *isUsef;// 是否使用  0未使用 1已使用
@property(nonatomic,strong) NSString *phonef;// 手机号
@property(nonatomic,strong) NSString *createIdf;// 0;
@property(nonatomic,strong) NSString *createTimef;// 0;
@property(nonatomic,strong) NSString *dataSortNumf;// 0;
@property(nonatomic,strong) NSString *deptIdf;// 0;
@property(nonatomic,strong) NSString *orderNof;// "";
@property(nonatomic,strong) NSString *trueNamef;// 0;
#pragma mark --优惠劵查询接口
+ (void) sendDiscoupontoUserWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --优惠劵使用接口
+ (void) sendDiscoupontoUseWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock;

@end


@interface BannerInfoObj : BaseModel
#pragma mark --用于查询最新的广告图
+ (void)sendAdgetLatestWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock;
@end
