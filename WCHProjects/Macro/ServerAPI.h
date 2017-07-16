//
//  ServerAPI.h
//  ZiChanBao
//
//  Created by liujinliang on 15/6/11.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

//错误提示

//static NSString * const apiBaseURLString = @"http://139.196.200.221/";
//static NSString *const apiBaseURLString = @"http://www.66weihuo.com/";
static NSString *const apiBaseURLString = @"http://106.14.238.209/";
//商户系统先调用该接口在微信支付服务后台生成预支付交易单，返回正确的预支付交易回话标识后再在APP里面调起支付。
static NSString * const wxUnifiedorder = @"https://api.mch.weixin.qq.com/pay/unifiedorder";

///登陆接口
#define kAPI_Login          [NSString stringWithFormat:@"Login.shtml"]
///发送短信的接口
CG_INLINE NSString *kAPI_SmstoSend() {
    return [NSString stringWithFormat:@"SmstoSend.shtml"];
}

///注册接口
CG_INLINE NSString *kAPI_userdoInsert() {
    return [NSString stringWithFormat:@"userdoInsert.shtml"];
}

///用户信息更新接口
CG_INLINE NSString *kAPI_UsertoUpdateInfo() {
    return [NSString stringWithFormat:@"UsertoUpdateInfo.shtml"];
}

///订单添加接口
CG_INLINE NSString *kAPI_OrderdoInsert() {
    return [NSString stringWithFormat:@"OrderdoInsert.shtml"];
}

///运价查询接口
CG_INLINE NSString *kAPI_FreighttoPrice() {
    return [NSString stringWithFormat:@"FreighttoModel.shtml"];
}

///取消订单接口
CG_INLINE NSString *kAPI_OrderdoCancel() {
    return [NSString stringWithFormat:@"OrderdoCancel.shtml"];
}

//用于接单
CG_INLINE NSString *kAPI_OrderdoTake() {
    return @"OrderdoTake.shtml";
}

//用于结束订单
CG_INLINE NSString *kAPI_OrderdoEnd() {
    return @"OrderdoEnd.shtml";
}

///系统消息查询接口
CG_INLINE NSString *kAPI_MessagetoCustom() {
    return [NSString stringWithFormat:@"MessagetoCustom.shtml"];
}

///优惠劵查询接口
CG_INLINE NSString *kAPI_DiscoupontoUser() {
    return [NSString stringWithFormat:@"DiscoupontoUser.shtml"];
}

///用于提交司机信息
CG_INLINE NSString *kAPI_DriverinfodoInsert() {
    return [NSString stringWithFormat:@"DriverinfodoInsert.shtml"];
}

///用于查询我的行程
CG_INLINE NSString *kAPI_OrdertoRoute() {
    return @"OrdertoRoute.shtml";
}

///用于查询司机的收入
CG_INLINE NSString *kAPI_OrdertoIncome() {
    return @"OrdertoIncome.shtml";
}

///用于提交评价
CG_INLINE NSString *kAPI_AssessdoInsert() {
    return @"AssessdoInsert.shtml";
}

///用于查询最新的广告图
CG_INLINE NSString *kAPI_AdgetLatest() {
    return @"AdgetLatest.shtml";
}

///根据手机号查询司机的信息
CG_INLINE NSString *kAPI_DriverinfobyMobile() {
    return @"DriverinfobyMobile.shtml";
}

///添加充值记录
CG_INLINE NSString *kAPI_RechargedoInsert() {
    return @"RechargedoInsert.shtml";
}

///充值记录查询
CG_INLINE NSString *kAPI_RechargetoCustom() {
    return @"RechargetoCustom.shtml";
}

///图片上传接口
CG_INLINE NSString *kAPI_DriverinfotoUpload() {
    return @"DriverinfotoUpload.shtml";
}

///阿里接口用于获得签名
CG_INLINE NSString *kAPI_OrdertoAliPay() {
    return @"OrdertoAliPay.shtml";
}

//用于修改密码
CG_INLINE NSString *kAPI_SmsdoUpdatePwd() {
    return @"SmsdoUpdatePwd.shtml";
}

//用于获得充值的主键
CG_INLINE NSString *kAPI_RechargetoNumber() {
    return @"RechargetoNumber.shtml";
}

//用于加小费
CG_INLINE NSString *kAPI_OrdertoTip() {
    return @"OrdertoTip.shtml";
}

//用于查询用户的余额
CG_INLINE NSString *kAPI_RechargetoBalanced() {
    return @"RechargetoBalance.shtml";
}

//用于查询周边的运货点
CG_INLINE NSString *kAPI_GoodpointtoMarks() {
    return @"GoodpointtoMarks.shtml";
}

//用于获得待接订单
CG_INLINE NSString *kAPI_OrdertoDone() {
    return @"OrdertoDone.shtml";
}

//用于查询运费点类别
CG_INLINE NSString *kAPI_ApptoPointType() {
    return @"ApptoPointType.shtml";
}

//用于查询城市
CG_INLINE NSString *kAPI_CitystoCustom() {
    return @"CitystoCustom.shtml";
}

//用于查询微信支付
CG_INLINE NSString *kAPI_OrdertoPay() {
    return @"OrdertoPay.shtml";
}

//用于查询评价文本
CG_INLINE NSString *kAPI_ApptoAssess() {
    return @"ApptoAssess.shtml";
}

//用于定时查询订单
CG_INLINE NSString *kAPI_OrdertoReLoad() {
    return @"OrdertoReLoad.shtml";
}

//优惠劵使用接口
CG_INLINE NSString *kAPI_DiscoupontoUse() {
    return @"DiscoupontoUse.shtml";
}

//优惠劵用于结算订单
CG_INLINE NSString *kAPI_CoupontoPay() {
    return @"CoupontoPay.shtml";
}

//验证当前用户是否是系统用户
CG_INLINE NSString *kAPI_DutytoDecide() {
    return @"DutytoDecide.shtml";
}

//上班打卡
CG_INLINE NSString *kAPI_DutydoInWork() {
    return @"DutydoInWork.shtml";
}

//下班打卡
CG_INLINE NSString *kAPI_DutydoOutWork() {
    return @"DutydoOutWork.shtml";
}
