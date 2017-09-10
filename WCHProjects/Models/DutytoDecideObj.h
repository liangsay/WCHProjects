//
//  DutytoDecideObj.h
//  WCHProjects
//
//  Created by liujinliang on 2017/8/3.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "UserInfoObj.h"

@interface DutytoDecideObj : UserInfoObj

@property (nonatomic, strong) NSString *locationf;//当前位置
@property (nonatomic, strong) NSString *otherLocationf;//偏离位置
@property (nonatomic, strong) NSString *dutyTime;//上班时间
@property (nonatomic, strong) NSString *chargeMoney;//扣款
@property (nonatomic, strong) NSString *dutyOtherLocationf;//上班偏离
@property (nonatomic, strong) NSString *lateTime;//迟到时间
#pragma mark --验证当前用户是否是系统用户
+(void)sendDutytoDecideWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock;
@end
