//
//  DutytoDecideObj.h
//  WCHProjects
//
//  Created by liujinliang on 2017/8/3.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "UserInfoObj.h"

@interface DutytoDecideObj : UserInfoObj
@property (nonatomic, strong) NSString *locationf;
#pragma mark --验证当前用户是否是系统用户
+(void)sendDutytoDecideWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock;
@end
