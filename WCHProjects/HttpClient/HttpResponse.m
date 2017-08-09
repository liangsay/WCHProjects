//
// Created by liujinliang on 16/5/27.
// Copyright (c) 2016 liujinliang. All rights reserved.
//

#import "HttpResponse.h"


@implementation HttpResponse

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (![value isKindOfClass:[NSArray class]] && ![value isKindOfClass:[NSDictionary class]] && [value isKindOfClass:[NSObject class]])
    {
        value = [NSString toString:value];
    }
    if ([key isEqualToString:@"code"]) {
        key = @"responseCode";
    }
    if ([key isEqualToString:@"desc"]) {
        key = @"responseMsg";
    }
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"%@缺少属性：%@", NSStringFromClass([self class]), key);
}

- (void)setNilValueForKey:(NSString *)key{
    [super setNilValueForKey:key];
}

-(id)initWithResponseDic:(NSDictionary *)response{
    self = [super init];
    
    if (self) {
        [self initializeWithDic:response];
    }
    
    return self;
}

#pragma mark --数据解封
/*!
 *  @author liujinliang, 16-02-17 14:02:51
 *
 *  @brief 数据解封
 *
 *  @param response <#response description#>
 *
 *  @since <#version number#>
 */
- (void)initializeWithDic:(NSDictionary *)response{
    self.responseCode = [response[@"status"] integerValue];
    self.responseMsg = response[@"desc"];
    self.income = [response[@"income"] doubleValue];
    if (!self.responseMsg || self.responseMsg.isEmpty) {
        self.responseMsg = response[@"message"];
    }
    
    self.responseMsg = [self.responseMsg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //数据初始化
    self.isSuccess = self.responseCode==1?YES:NO;
    
    self.totalCount = response[@"totalCount"] == nil ? 0 : [response[@"totalCount"] integerValue];
    id res = [response objectForKey:@"result"];
    if (kISKIND_OF_CLASS_NSSTRING(res) || [res isKindOfClass:[NSNumber class]]) {
        self.result = res;
        self.isSuccess = YES;
        return;
    }
    id rows = [response objectForKey:@"rows"];
    if (kISKIND_OF_CLASS_NSARRAY(rows)) {
        self.result = rows;
        self.isSuccess = YES;
        return;
    }
    NSDictionary *result = [response objectForKey:@"result"];
    
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        self.isSuccess = YES;
        self.result = result;
        
    }else if ([result isKindOfClass:[NSArray class]]){
        self.isSuccess = YES;
        self.result = result;
        
    }else if(result != nil){
        self.isSuccess = YES;
        self.result = [NSDictionary dictionaryWithObject:result forKey:@"result"];
    }
    else{
        if (!self.isSuccess) {
            if (!self.responseMsg ||self.responseMsg.isEmpty) {
                self.responseMsg = DATA_FORMAT_ERROR;
            }
        }
    }
}

#pragma mark - Detail action
-(NSString *)description{
    
    NSMutableString *descripString = [NSMutableString stringWithFormat:@""];
    [descripString appendString:@"\n========================Response Info start=========================\n"];
    [descripString appendFormat:@"HttpResponse Name:%@\n",self.responseName];
    [descripString appendFormat:@"HttpResponse Content json:\n%@\n",self.resultJsonStr];
    [descripString appendFormat:@"HttpResponse Content:\n%@\n",[self.result description]];
    [descripString appendFormat:@"HttpResponse Error:\n%@\n",self.responseMsg];
    [descripString appendFormat:@"HttpResponse Error Code:\n%ld\n",self.responseCode];
    if(self.result == nil && self.isSuccess == NO)
    
    [descripString appendString:@"\n==========================Response Info end=========================\n"];
    return descripString;
}
@end
