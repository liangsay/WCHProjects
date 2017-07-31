//
//  StoretoLocObj.h
//  WCHProjects
//
//  Created by liujinliang on 2017/7/31.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "BaseModel.h"

@interface StoretoLocObj : BaseModel

@property (nonatomic, strong) NSString *idf; //编号
@property (nonatomic, strong) NSString *storeNamef; //门店名称
@property (nonatomic, strong) NSString *provincef; //省份
@property (nonatomic, strong) NSString *cityf; //城市
@property (nonatomic, strong) NSString *oilCardf;//油卡编号
@property (nonatomic, strong) NSString *addrf; //具体地址
@property (nonatomic, strong) NSString *locationf; //坐标
@property (nonatomic, strong) NSString *linkPhonef; //手机号
@property (nonatomic, strong) NSString *areaPersonf;//区域负责人
@property (nonatomic, strong) NSString *areaLeaderf;//区域总监
@property (nonatomic, strong) NSString *dataSortNumf; //排序号
@property (nonatomic, strong) NSString *deptIdf; //部门编号
@property (nonatomic, strong) NSString *createIdf; //请假人编号
@property (nonatomic, strong) NSString *trueNamef; //请假人姓名
@property (nonatomic, strong) NSString *createTimef; //填表时间
@property (nonatomic, strong) NSString *linkNamef;//门店联系人


#pragma mark --查询该城市里的门店
+ (void)sendStoretoLocWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                         failedBlock:(RequestSessionCompletedBlock)failedBlock;
@end
