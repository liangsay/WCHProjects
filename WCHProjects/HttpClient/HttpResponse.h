//
// Created by liujinliang on 16/5/27.
// Copyright (c) 2016 liujinliang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpResponse : NSObject

-(id)initWithResponseDic:(NSDictionary *)responseDic;

@property (nonatomic, strong) NSString *responseMsg;       //错误信息
@property (nonatomic, assign) NSInteger responseCode;//错误编号

@property (nonatomic, strong) NSString *responseName;   //响应请求名字
@property (nonatomic, assign) BOOL isSuccess;           //是否成功

@property (nonatomic, strong) id result;     //结果数据
@property (nonatomic, strong) id responseObject;     //结果数据
@property (nonatomic, strong) NSString *resultJsonStr;     //结果数据
@property (nonatomic, strong) NSString *status;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSMutableArray *rows;

@property (nonatomic, strong)id responseModel; //

/**
 *  描述当前对象
 *
 *  @return 当前对象的字符串
 */
-(NSString *)description;

@end
