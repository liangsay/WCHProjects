//
//  ServerAPI.h
//  ZiChanBao
//
//  Created by liujinliang on 15/6/11.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

//错误提示

//static NSString * const apiBaseURLString = @"http://139.224.209.235:9080/";
//static NSString *const apiBaseURLString = @"http://www.66weihuo.com/";
static NSString *const apiBaseURLString = @"http://www.66wch.com.cn/";
//static NSString *const apiBaseURLString = @"http://106.14.238.209/";
//商户系统先调用该接口在微信支付服务后台生成预支付交易单，返回正确的预支付交易回话标识后再在APP里面调起支付。
static NSString * const wxUnifiedorder = @"https://api.mch.weixin.qq.com/pay/unifiedorder";

CG_INLINE NSString *fullImageUrl(NSString * imageurl) {
    return [NSString stringWithFormat:@"%@upimages/%@",apiBaseURLString,imageurl];
}
///登陆接口
#define kAPI_Login          [NSString stringWithFormat:@"Login.shtml"]
#pragma mark    --发送短信的接口
CG_INLINE NSString *kAPI_SmstoSend() {
    return [NSString stringWithFormat:@"SmstoSend.shtml"];
}

#pragma mark    --/注册接口
CG_INLINE NSString *kAPI_userdoInsert() {
    return [NSString stringWithFormat:@"userdoInsert.shtml"];
}

#pragma mark    --/用户信息更新接口
CG_INLINE NSString *kAPI_UsertoUpdateInfo() {
    return [NSString stringWithFormat:@"UsertoUpdateInfo.shtml"];
}

#pragma mark    --/订单添加接口
CG_INLINE NSString *kAPI_OrderdoInsert() {
    return [NSString stringWithFormat:@"OrderdoInsert.shtml"];
}

#pragma mark    --/运价查询接口
CG_INLINE NSString *kAPI_FreighttoPrice() {
    return [NSString stringWithFormat:@"FreighttoModel.shtml"];
}

#pragma mark    --/取消订单接口
CG_INLINE NSString *kAPI_OrderdoCancel() {
    return [NSString stringWithFormat:@"OrderdoCancel.shtml"];
}

#pragma mark    --用于接单
CG_INLINE NSString *kAPI_OrderdoTake() {
    return @"OrderdoTake.shtml";
}

#pragma mark    --用于结束订单
CG_INLINE NSString *kAPI_OrderdoEnd() {
    return @"OrderdoEnd.shtml";
}

#pragma mark    --/系统消息查询接口
CG_INLINE NSString *kAPI_MessagetoCustom() {
    return [NSString stringWithFormat:@"MessagetoCustom.shtml"];
}

#pragma mark    --/优惠劵查询接口
CG_INLINE NSString *kAPI_DiscoupontoUser() {
    return [NSString stringWithFormat:@"DiscoupontoUser.shtml"];
}

#pragma mark    --/用于提交司机信息
CG_INLINE NSString *kAPI_DriverinfodoInsert() {
    return [NSString stringWithFormat:@"DriverinfodoInsert.shtml"];
}

#pragma mark    --/用于查询我的行程
CG_INLINE NSString *kAPI_OrdertoRoute() {
    return @"OrdertoRoute.shtml";
}

#pragma mark    --/用于查询司机的收入
CG_INLINE NSString *kAPI_OrdertoIncome() {
    return @"OrdertoIncome.shtml";
}

#pragma mark    --/用于提交评价
CG_INLINE NSString *kAPI_AssessdoInsert() {
    return @"AssessdoInsert.shtml";
}

#pragma mark    --/用于查询最新的广告图
CG_INLINE NSString *kAPI_AdgetLatest() {
    return @"AdgetLatest.shtml";
}

#pragma mark    --/根据手机号查询司机的信息
CG_INLINE NSString *kAPI_DriverinfobyMobile() {
    return @"DriverinfobyMobile.shtml";
}

#pragma mark    --/添加充值记录
CG_INLINE NSString *kAPI_RechargedoInsert() {
    return @"RechargedoInsert.shtml";
}

#pragma mark    --/充值记录查询
CG_INLINE NSString *kAPI_RechargetoCustom() {
    return @"RechargetoCustom.shtml";
}

#pragma mark    --/图片上传接口
CG_INLINE NSString *kAPI_DriverinfotoUpload() {
    return @"DriverinfotoUpload.shtml";
}

#pragma mark    --/阿里接口用于获得签名
CG_INLINE NSString *kAPI_OrdertoAliPay() {
    return @"OrdertoAliPay.shtml";
}

#pragma mark    --用于修改密码
CG_INLINE NSString *kAPI_SmsdoUpdatePwd() {
    return @"SmsdoUpdatePwd.shtml";
}

#pragma mark    --用于获得充值的主键
CG_INLINE NSString *kAPI_RechargetoNumber() {
    return @"RechargetoNumber.shtml";
}

#pragma mark    --用于加小费
CG_INLINE NSString *kAPI_OrdertoTip() {
    return @"OrdertoTip.shtml";
}

#pragma mark    --用于查询用户的余额
CG_INLINE NSString *kAPI_RechargetoBalanced() {
    return @"RechargetoBalance.shtml";
}

#pragma mark    --用于查询周边的运货点
CG_INLINE NSString *kAPI_GoodpointtoMarks() {
    return @"GoodpointtoMarks.shtml";
}

#pragma mark    --用于获得待接订单
CG_INLINE NSString *kAPI_OrdertoDone() {
    return @"OrdertoDone.shtml";
}

#pragma mark    --用于查询运费点类别
CG_INLINE NSString *kAPI_ApptoPointType() {
    return @"ApptoPointType.shtml";
}

#pragma mark    --用于查询城市
CG_INLINE NSString *kAPI_CitystoCustom() {
    return @"CitystoCustom.shtml";
}

#pragma mark    --用于查询微信支付
CG_INLINE NSString *kAPI_OrdertoPay() {
    return @"OrdertoPay.shtml";
}

#pragma mark    --用于查询评价文本
CG_INLINE NSString *kAPI_ApptoAssess() {
    return @"ApptoAssess.shtml";
}

#pragma mark    --用于定时查询订单
CG_INLINE NSString *kAPI_OrdertoReLoad() {
    return @"OrdertoReLoad.shtml";
}

#pragma mark    --优惠劵使用接口
CG_INLINE NSString *kAPI_DiscoupontoUse() {
    return @"DiscoupontoUse.shtml";
}

#pragma mark    --优惠劵用于结算订单
CG_INLINE NSString *kAPI_CoupontoPay() {
    return @"CoupontoPay.shtml";
}

#pragma mark    --验证当前用户是否是系统用户
CG_INLINE NSString *kAPI_DutytoDecide() {
    return @"DutytoDecide.shtml";
}

#pragma mark    --上班打卡
CG_INLINE NSString *kAPI_DutydoInWork() {
    return @"DutydoInWork.shtml";
}

#pragma mark    --下班打卡
CG_INLINE NSString *kAPI_DutydoOutWork() {
    return @"DutydoOutWork.shtml";
}

#pragma mark    --V3.0版本---------------------------------------------------
#pragma mark    --物流车源
CG_INLINE NSString *kAPI_FreighttoCall() {
    return @"FreighttoCall.shtml";
}

#pragma mark    --租车车源
CG_INLINE NSString *kAPI_FreighttoRent() {
    return @"FreighttoRent.shtml";
}

#pragma mark    --品牌
CG_INLINE NSString *kAPI_BrandtoCustomList() {
    return @"BrandtoCustomList.shtml";
}

#pragma mark    --车系
CG_INLINE NSString *kAPI_SerietoCustomList() {
    return @"SerietoCustomList.shtml";
}

#pragma mark    --添加购物车
CG_INLINE NSString *kAPI_MallorderdoAddCar () {
    return @"MallorderdoAddCar.shtml";
}

#pragma mark    --查询商品信息
CG_INLINE NSString *kAPI_MallordertoView() {
    return @"MallordertoView.shtml";
}

#pragma mark    --查询品牌、车系下的数据
CG_INLINE NSString *kAPI_MallgoodstoCustom() {
    return @"MallgoodstoCustom.shtml";
}

#pragma mark    --查询购车的个人订单
CG_INLINE NSString *kAPI_MallordertoMember() {
    return @"MallordertoMember.shtml";
}

#pragma mark    --添加收藏
CG_INLINE NSString *kAPI_CollectdoCollect() {
    return @"CollectdoCollect.shtml";
}

#pragma mark    --删除收藏
CG_INLINE NSString *kAPI_CollectdoDelete() {
    return @"CollectdoDelete.shtml";
}

#pragma mark    --查询个人收藏
CG_INLINE NSString *kAPI_CollecttoCustom() {
    return @"CollecttoCustom.shtml";
}

#pragma mark --
CG_INLINE NSString *kAPI_UsertoLogin4App() {
    return @"UsertoLogin4App.shtml";
}

#pragma mark --订单租车
CG_INLINE NSString *kAPI_RentordertoCustom() {
    return @"RentordertoCustom.shtml";
}

#pragma mark --查询该城市里的门店
CG_INLINE NSString *kAPI_StoretoLoc() {
    return @"StoretoLoc.shtml";
}

#pragma mark --添加租车订单
CG_INLINE NSString *kAPI_RentorderdoInsert() {
    return @"RentorderdoInsert.shtml";
}

#pragma mark --取消租车订单
CG_INLINE NSString *kAPI_RentorderdoCancel() {
    return @"RentorderdoCancel.shtml";
}

#pragma mark --查询商品评价
CG_INLINE NSString *kAPI_AssesstoCustom() {
    return @"AssesstoCustom.shtml";
}

#pragma mark --集客
/*
 vo.deptIdf	2_38
 vo.storeNamef	啦咯啦咯啦咯
 requestType	app
 vo.customerNamef	阿KKK
 vo.trueNamef	安志伟
 vo.categoryf	啦咯啦咯啦咯
 vo.createIdf	d24845ab-4662-4ba7-9a18-009fdfa2139f
 vo.intentionf	家里哈啊
 vo.telephonef	558555
 vo.tradingAreaf	空军建军节
 */
CG_INLINE NSString *kAPI_CustomerdoInsert(){
    return @"CustomerdoInsert.shtml";
}

#pragma mark --商品参数
CG_INLINE NSString *kAPI_MallgoodstoView() {
    return @"MallgoodstoView.shtml";
}

#pragma mark --添加到购物车
CG_INLINE NSString *kAPI_MallorderdoInsert() {
    return @"MallorderdoInsert.shtml";
}

#pragma mark --查询个人打卡信息
CG_INLINE NSString *kAPI_DutytoMobile() {
    return @"DutytoMobile.shtml";
}

#pragma mark --查询车型的节点价
CG_INLINE NSString *kAPI_BdtoApp() {
    return @"BdtoApp.shtml";
}
