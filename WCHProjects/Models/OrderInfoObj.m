//
//  OrderInfoObj.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/9.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "OrderInfoObj.h"


@implementation OrderInfoObj

// 实现这个方法的目的：告诉MJExtension框架appInfo数组里面装的是什么模型
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orderPointList":[OrderInfoObj class]};
    
}
#pragma mark --订单添加接口



+ (void)sendOrderdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_OrderdoInsert() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --取消订单接口
+ (void)sendOrderdoCancelWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_OrderdoCancel() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于接单
+ (void)sendOrderdoTakeWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_OrderdoTake() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];

}

#pragma mark --用于结束订单
+ (void)sendOrderdoEndWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                         failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_OrderdoEnd() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];

}

#pragma mark --运价查询接口
+ (void)sendFreighttoPriceWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                             failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_FreighttoPrice() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于提交司机信息
+ (void)sendDriverinfodoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                 failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_DriverinfodoInsert() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于查询我的行程
+ (void)sendOrdertoRouteWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                           failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_OrdertoRoute() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于查询司机的收入
+ (void)sendOrdertoIncomeWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_OrdertoIncome() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于提交评价
+ (void)sendAssessdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                             failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_AssessdoInsert() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --根据手机号查询司机的信息
+ (void)sendDriverinfobyMobileWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                 failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_DriverinfobyMobile() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --添加充值记录
+ (void)sendRechargedoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_RechargedoInsert() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --充值记录查询
+ (void)sendRechargetoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_RechargetoCustom() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --图片上传接口
+ (void)sendDriverinfotoUploadWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                 failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_DriverinfotoUpload() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --阿里接口用于获得签名
+ (void)sendOrdertoAliPayWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                 failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_OrdertoAliPay() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于查询用户的余额
+ (void)sendRechargetoBalanceWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_RechargetoBalanced() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于修改密码
+ (void)sendSmsdoUpdatePwdWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                             failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_SmsdoUpdatePwd() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于获得充值的主键
+ (void)sendRechargetoNumberWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_RechargetoNumber() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于加小费
+ (void)sendOrdertoTipWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                         failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_OrdertoTip() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于查询周边的运货点
+ (void)sendGoodpointtoMarksWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_GoodpointtoMarks() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于获得待接订单
+ (void)sendOrdertoDoneWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_OrdertoDone() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于查询运费点类别
+ (void)sendApptoPointTypeWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_ApptoPointType() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于查询城市
+ (void)sendCitystoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_CitystoCustom() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于查询微信支付
+ (void)sendOrdertoPayWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_OrdertoPay() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于查询评价文本
+ (void)sendApptoAssessWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_ApptoAssess() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --用于定时查询订单
+ (void)sendOrdertoReLoadWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_OrdertoReLoad() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --优惠劵查询接口
+ (void) sendDiscoupontoUserWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_DiscoupontoUser() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --优惠劵用于结算订单
+ (void)sendCoupontoPayWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_CoupontoPay() params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --V3.0版本-----------------------
#pragma mark --物流车源
+ (void)sendFreighttoCallWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_FreighttoCall() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --租车车源
+ (void)sendFreighttoRentWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_FreighttoRent() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --品牌
+ (void)sendBrandtoCustomListWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_BrandtoCustomList() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --车系
+ (void)sendSerietoCustomListWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_SerietoCustomList() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --添加购物车
+ (void)sendMallorderdoAddCarWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_MallorderdoAddCar() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --查询商品信息
+ (void)sendMallordertoViewWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_MallordertoView() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --查询品牌、车系下的数据
+ (void)sendMallgoodstoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_MallgoodstoCustom() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --查询购车的个人订单
+ (void)sendMallordertoMemberWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_MallordertoMember() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --添加收藏
+ (void)sendCollectdoCollectWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_CollectdoCollect() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --删除收藏
+ (void)sendCollectdoDeleteWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_CollectdoDelete() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --查询个人收藏
+ (void)sendCollecttoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_CollecttoCustom() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --订单租车
+ (void)sendRentordertoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                              failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_RentordertoCustom() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --取消订单租车
+ (void)sendRentorderdoCancelWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock {
    [self sendRequestWithAPI:kAPI_RentorderdoCancel() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        failedBlock(request,response);
    }];
}

#pragma mark --添加租车订单
+ (void)sendRentorderdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_RentorderdoInsert() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"数据请求异常"];
        failedBlock(request,response);
    }];
}


#pragma mark --查询商品评价
+ (void)sendAssesstoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                             failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_AssesstoCustom() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"数据请求异常"];
        failedBlock(request,response);
    }];
}

#pragma mark --集客
+ (void)sendCustomerdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                             failedBlock:(RequestSessionCompletedBlock)failedBlock{
    [self sendRequestWithAPI:kAPI_CustomerdoInsert() isApp:YES params:parameters successBlock:^(HttpRequest *request, HttpResponse *response) {
        successBlock(request,response);
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"数据请求异常"];
        failedBlock(request,response);
    }];
}
@end
