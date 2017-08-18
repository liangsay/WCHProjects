//
//  BaseModel.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "BaseModel.h"
#import "HttpResponse.h"

@implementation BaseModel
MJCodingImplementation


//+ (NSDictionary *)replacedKeyFromPropertyName{
//    return @{
//             @"ID" : @"id",
//             @"desc" : @"desciption",
//             @"oldName" : @"name.oldName",
//             @"nowName" : @"name.newName",
//             @"mdriverinfoVo" :@"driverinfoVo"
//             };
//}

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
+ (void)sendRequestWithAPI:(NSString *)api params:(NSMutableDictionary *)params successBlock:(RequestCompletedBlock)successBlock failedBlock:(RequestCompletedBlock)failedBlock{
    DLog(@"params:%@",params);
    
    if ([UserInfoObj model]
        && ![api isEqualToString:kAPI_OrderdoInsert()]
        && ![api isEqualToString:kAPI_OrdertoTip()]
        && ![api isEqualToString:kAPI_OrdertoReLoad()]
        && ![api isEqualToString:kAPI_GoodpointtoMarks()]
        && ![api isEqualToString:kAPI_OrderdoEnd()]
        && ![api isEqualToString:kAPI_OrderdoCancel()]
        && ![api isEqualToString:kAPI_OrdertoRoute()]
        && ![api isEqualToString:kAPI_DriverinfobyMobile()]
        && ![api isEqualToString:kAPI_DriverinfodoInsert()]
        && ![api isEqualToString:kAPI_OrdertoIncome()]
        && ![api isEqualToString:kAPI_DriverinfotoUpload()]
        && ![api isEqualToString:kAPI_AssessdoInsert()]
        && ![api isEqualToString:kAPI_OrdertoPay()]
        && ![api isEqualToString:kAPI_RechargetoNumber()]
        && ![api isEqualToString:kAPI_RechargedoInsert()]
        && ![api isEqualToString:kAPI_userdoInsert()]
        && ![api isEqualToString:kAPI_DiscoupontoUser()]
        && ![api isEqualToString:kAPI_DiscoupontoUse()]
        && ![api isEqualToString:kAPI_DutydoInWork()]
        && ![api isEqualToString:kAPI_DutytoDecide()]
        && ![api isEqualToString:kAPI_DutydoOutWork()]) {
        if (![UserInfoObj model].idf.isEmpty) {
            [params addUnEmptyString:[UserInfoObj model].idf forKey:@"vo.idf"];
        }
        if (![UserInfoObj model].mobilePhonef.isEmpty && ![api isEqualToString:kAPI_DutydoInWork()]
            && ![api isEqualToString:kAPI_DutytoDecide()]
            && ![api isEqualToString:kAPI_DutydoOutWork()]) {
            [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.mobilePhonef"];
        }
    }
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    [[HttpClient sharedClient] getObjectWithDic:params apiName:api successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (response.isSuccess) {
            id data = response.result;
            if (kISKIND_OF_CLASS_NSARRAY(data)) {
                NSArray *dataArr = data;
                if (dataArr.count) {
                    NSMutableArray *datas = [NSMutableArray array];
                    @try {
                        for (NSDictionary *dict in dataArr) {
                            
                            BaseModel *model = [self mj_objectWithKeyValues:dict];
                            if ([[dict valueForKey:@"id"] integerValue]>0) {
                                model.myID = [dict valueForKey:@"id"];
                            }
                            [datas addObject:model];
                        }
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                    
                    response.responseModel = datas;
                }
            }else if (kISKIND_OF_CLASS_NSDICTIONARY(data)){
                NSDictionary *dataDic = data;
                if (dataDic.count) {
                    @try {
                        BaseModel *model = [self mj_objectWithKeyValues:dataDic];
                        if ([[dataDic valueForKey:@"id"] integerValue]>0) {
                            model.myID = [dataDic valueForKey:@"id"];
                        }
                        response.responseModel = model;
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                    
                }
            }else{
                response.responseModel = data;
            }
            successBlock(request,response);
        }else{
//            [response.responseMsg toast];
        }
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        if (response.responseCode==6) {
            
            [kAppDelegate showLoginVCWithLoginAction:^(NSInteger index) {
                
            }];
//            [NSString toast:response.responseMsg];
            return;
        }
        failedBlock(request,response);
    }];
}

+ (void)sendRequestWithAPI:(NSString *)api isApp:(BOOL)isApp params:(NSMutableDictionary *)params successBlock:(RequestCompletedBlock)successBlock failedBlock:(RequestCompletedBlock)failedBlock{
    
    if (isApp) {
        [params addUnEmptyString:@"app" forKey:@"requestType"];
    }
    DLog(@"params:%@",params);
    [[HttpClient sharedClient] getObjectWithDic:params apiName:api successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (response.isSuccess) {
            id data = response.result;
            if (kISKIND_OF_CLASS_NSARRAY(data)) {
                NSArray *dataArr = data;
                if (dataArr.count) {
                    NSMutableArray *datas = [NSMutableArray array];
                    @try {
                        for (NSDictionary *dict in dataArr) {
                            
                            BaseModel *model = [self mj_objectWithKeyValues:dict];
                            if ([[dict valueForKey:@"id"] integerValue]>0) {
                                model.myID = [dict valueForKey:@"id"];
                            }
                            [datas addObject:model];
                        }
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                    
                    response.responseModel = datas;
                }
            }else if (kISKIND_OF_CLASS_NSDICTIONARY(data)){
                NSDictionary *dataDic = data;
                if (dataDic.count) {
                    @try {
                        BaseModel *model = [self mj_objectWithKeyValues:dataDic];
                        if ([[dataDic valueForKey:@"id"] integerValue]>0) {
                            model.myID = [dataDic valueForKey:@"id"];
                        }
                        response.responseModel = model;
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                    
                }
            }else{
                response.responseModel = data;
            }
            successBlock(request,response);
        }else{
            //            [response.responseMsg toast];
        }
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
        if (response.responseCode==6) {
            
            [kAppDelegate showLoginVCWithLoginAction:^(NSInteger index) {
                
            }];
            return;
        }
        failedBlock(request,response);
    }];
}

+ (NSString *)paramsStringWithParams:(NSDictionary *)params
{
    NSMutableString *paramsString = [NSMutableString string];
    if (params.allKeys.count > 0)
    {
        for (NSString *key in params.allKeys)
        {
            NSString *value = [params objectForKey:key];
            [paramsString appendFormat:@"&%@=%@", key, value];
        }
        [paramsString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return paramsString;
}

#pragma mark - 属性相关

- (void)setNilValueForKey:(NSString *)key {
    
    if ([key isEqualToString:@"price"])
        [self setValue:[NSNumber numberWithInt:0] forKey:@"price"];
    else
        [super setNilValueForKey:key];
}

#pragma mark - 归档
+ (NSString *)filePathForArchive
{
    NSString *fileName = NSStringFromClass([self class]);
    NSString *dir = [NSString documentPath];
    return [dir stringByAppendingPathComponent:fileName];
}

+ (instancetype)unarchive
{
    NSString *filePath = [self filePathForArchive];//[[self class] filePathForArchive];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        id unarchObj = [self new];
        @try {
            unarchObj = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        } @catch (NSException *exception) {
            NSAssert(unarchObj, @"filePath does not exist");
        } @finally {
            
        }
        
        return unarchObj;
    }
    return nil;
}

- (void)archive
{
    NSString *filePath = [[self class] filePathForArchive];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    DLog(@"归档%@到%@", NSStringFromClass([self class]), filePath);
}

- (void)archiveWithName:(NSString *)fileName
{
    NSString *filePath = [[self class] filePathForArchive];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
    DLog(@"归档%@到%@", NSStringFromClass([self class]), filePath);
}

+ (void)deleteArchivedFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[[self class] filePathForArchive] error:nil];
}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    NSArray *properties = [[self class] propertyKeys];
//    for (NSString *key in properties)
//    {
//        [aCoder encodeObject:[self valueForKey:key] forKey:key];
//    }
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init])
//    {
//        NSArray *properties = [[self class] propertyKeys];
//        for (NSString *key in properties)
//        {
//            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
//        }
//    }
//    return self;
//}

#pragma mark - 缓存
static NSMutableDictionary *_cahceDict;
+ (NSMutableDictionary *)cacheDict
{
    if (!_cahceDict)
    {
        _cahceDict = [NSMutableDictionary dictionary];
    }
    return _cahceDict;
}

- (void)cache
{
    NSMutableDictionary *cacheDict = [BaseModel cacheDict];
    [cacheDict setValue:self forKey:NSStringFromClass([self class])];
    
    [self archive];
}

+ (instancetype)model
{
    static BaseModel *cacheModel;
    __block NSMutableDictionary *cacheDict = [BaseModel cacheDict];
    cacheModel = cacheDict[NSStringFromClass([self class])];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      cacheModel = [self unarchive];
                      if (cacheModel)
                      {
                          cacheDict[NSStringFromClass([self class])] = cacheModel;
                      }
                  });
    return cacheModel;
}

+ (void)clear
{
    NSMutableDictionary *cacheDict = [BaseModel cacheDict];
    [cacheDict removeObjectForKey:NSStringFromClass([self class])];
    
    [self deleteArchivedFile];
}

@end

@implementation SystemMessageObj

#pragma mark --系统消息查询接口
+ (void) sendMessagetoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_MessagetoCustom() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        failedBlock(request,response);
    }];
}

@end

@implementation CoupontoUserObj

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"expiryDatef"]) {
        
        NSString *nowDate = [NSDate currentTimeString];
        if ([nowDate compare:value]==NSOrderedDescending) {
            self.isExpiryDatef = YES;
        }else{
            self.isExpiryDatef = NO;
        }
    }
    [super setValue:value forKey:key];
}
#pragma mark --优惠劵查询接口
+ (void) sendDiscoupontoUserWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_DiscoupontoUser() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        [NSString toast:response.responseMsg];
        failedBlock(request,response);
    }];
}

#pragma mark --优惠劵使用接口
+ (void) sendDiscoupontoUseWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                              failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_DiscoupontoUse() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        failedBlock(request,response);
    }];
}
@end

@implementation BannerInfoObj

#pragma mark --用于查询最新的广告图
+ (void)sendAdgetLatestWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_AdgetLatest() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        failedBlock(request,response);
    }];
}

@end
