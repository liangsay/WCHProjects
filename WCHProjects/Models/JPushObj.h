//
//  JPushObj.h
//  WCHProjects
//
//  Created by liujinliang on 2017/12/2.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "BaseModel.h"

@interface JPushObj : BaseModel
@property (nonatomic, strong) JPushObj *aps;
@property (nonatomic, strong) NSString *alert;
@property (nonatomic, strong) NSString *msgType;//  0 0代表是下单的通知
@property (nonatomic, strong) NSString *province;//  省份
@property (nonatomic, strong) NSString *city;// 城市
@property (nonatomic, strong) NSString *orderTime;// 下单时间
@property (nonatomic, strong) NSString *mobile;
/*
msgType  0 0代表是下单的通知
province  省份
city 城市
orderTime 下单时间

接收订单 根据手机号接收通知
msgType  1代表是的通知
mobile 接收通知的手机号

完成订单 根据手机号接收通知
msgType  2代表是的通知
mobile 接收通知的手机号*/
@end
