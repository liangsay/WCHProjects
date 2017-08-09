//
//  OrderInfoObj.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/9.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseModel.h"
#import <CoreLocation/CLLocation.h>
@interface OrderInfoObj : BaseModel
@property (nonatomic, strong) NSString *isColdf;
@property (nonatomic, strong) NSString *rentMoneyf;
@property (nonatomic, strong) NSString *maxCountf;
@property (nonatomic, assign) CGFloat cellheight;
@property (nonatomic, strong) NSMutableArray *orderPointList;
@property (nonatomic, strong) NSString *positionf;
@property (nonatomic, strong) NSString *addressf;// = "育梁路4号";
@property (nonatomic, strong) NSString *createTimef;// = "2017-07-30 00:32:12";
@property (nonatomic, strong) NSString *dataSortNumf;// = 0;
@property (nonatomic, strong) NSString *deptIdf;// = "2_38";
@property (nonatomic, strong) NSString *idf;// = "3e83c414-9347-4d00-91b5-5fd33fbc29ae";
@property (nonatomic, strong) NSString *logisticsIdf;// = 1501345932368310;
@property (nonatomic, strong) NSString *orderf;// = 0;

@property (nonatomic, strong) NSString *days;
@property (nonatomic, strong) NSString *numf;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL isMust;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isTxt;
@property (nonatomic, assign) BOOL isSelDate;
@property (nonatomic, strong) NSString *cabPeopleNumf;
@property (nonatomic, strong) OrderInfoObj *driverinfoVo;
@property (nonatomic, strong) OrderInfoObj *order;
@property (nonatomic, strong) CLLocation *starLocation;
@property (nonatomic, strong) CLLocation *endLocation;
@property (nonatomic, strong) NSString *amountf;
@property (nonatomic, strong) NSString *kmPricef;//;// "2.8";
@property (nonatomic, strong) NSString *namef;//;// "\U5c0f\U9762";

@property (nonatomic, strong) NSString *startKmf;//;// 6;
@property (nonatomic, strong) NSString *startPricef;//;// 39;
@property (nonatomic, strong) NSString *accountSignf;// 0;
@property (nonatomic, strong) NSString *assessDriverf;// 0;
@property (nonatomic, strong) NSString *assessOwerf;// 0;
@property (nonatomic, strong) NSString *cancelManf;// 0;
@property (nonatomic, strong) NSString *cancelReasonf;// 0;
@property (nonatomic, strong) NSString *cityf;// "天津市";
@property (nonatomic, strong) NSString *count;// 0;
@property (nonatomic, strong) NSString *createIdf;// 0;

@property (nonatomic, strong) NSString *driverIdf;// 13922163927;
@property (nonatomic, strong) NSString *endAddrNamef;// "中国兰州牛肉面(律纬路店)";
@property (nonatomic, strong) NSString *endLocationf;// "39.171149,117.212097";

@property (nonatomic, strong) NSString *couponIdf;
@property (nonatomic, strong) NSString *isInvoicef;// 0;

@property (nonatomic, strong) NSString *kmCountf;// 9;
@property (nonatomic, strong) NSString *modelNamef;// "金杯";
@property (nonatomic, strong) NSString *orderNof;// 14759423932680;
@property (nonatomic, strong) NSString *ownerIdf;// 13711161241;
@property (nonatomic, strong) NSString *payTypef;// 0;
@property (nonatomic, strong) NSString *pricef;// "76.40000000000001";
@property (nonatomic, strong) NSString *provincef;// "天津市";
@property (nonatomic, strong) NSString *isAssess;
@property (nonatomic, strong) NSString *startAddrNamef;// "天津市东丽区仁和路";
@property (nonatomic, strong) NSString *startLocationf;// "39.21031,117.2643";
@property (nonatomic, strong) NSString *statusTextf;// "已接单";
@property (nonatomic, strong) NSString *statusf;// 1;
@property (nonatomic, strong) NSString *tipPricef;// 0;
@property (nonatomic, strong) NSString *transNof;// 0;
@property (nonatomic, strong) NSString *trueNamef;// 0;
@property (nonatomic, strong) NSString *weekIndexf;// 0;

@property (nonatomic, strong) NSString *addrf;// "";
@property (nonatomic, strong) NSString *alipayNof;// "";
@property (nonatomic, strong) NSString *bankNof;// "";
@property (nonatomic, strong) NSString *carImage;// "fdceaa01-9867-4190-b8f2-bcacb5a6afae.jpg";
@property (nonatomic, strong) NSString *carNof;// b88888;
@property (nonatomic, strong) NSString *carNamef;// b88888;
@property (nonatomic, strong) NSString *checkReasonf;// "";
@property (nonatomic, strong) NSString *checkResultf;// "-1";

@property (nonatomic, strong) NSString *countf;// 0;
@property (nonatomic, strong) NSString *dealerNamef;// "";

@property (nonatomic, strong) NSString *driverCarImage;// "7e2f6953-e7f1-4d91-8f97-05bb2392e4f7.jpg";
@property (nonatomic, strong) NSString *diskFilePathf;
@property (nonatomic, strong) NSString *driverNamef;// liuliu;
@property (nonatomic, strong) NSString *idImage;// "7f07bede-255c-4ea7-8198-bfc70dd47098.jpg";
@property (nonatomic, strong) NSString *idNof;// 445222198812111212;

@property (nonatomic, strong) NSString *joinIdf;// "";
@property (nonatomic, strong) NSString *linkPhonef;// 15889798801;
@property (nonatomic, strong) NSString *modelf;// "宝马s6";
@property (nonatomic, strong) NSString *orderCountf;// 0;

@property (nonatomic, strong) NSString *routeCarImage;// "b2aa9619-842e-4dda-a3aa-07e0288d2d5e.jpg";
@property (nonatomic, strong) NSString *scoref;// 5;

@property (nonatomic, strong) NSString *userIdf;// "";
@property (nonatomic, strong) NSString *weixinNamef;// "";
@property (nonatomic, strong) NSString *weixinNof;// "";
@property (nonatomic, strong) NSString *bdValuef;// "冷库";
@property (nonatomic, strong) NSString *checkedTextf;// "否";
@property (nonatomic, strong) NSString *checkedf;// 0;
@property (nonatomic, strong) NSString *datasortNumf;// 1472194867677;

@property (nonatomic, strong) NSString *sortNumf;// 0;
@property (nonatomic, strong) NSString *typeIdf;// "de842298-c382-49fc-a34b-8f53dc4975a7";
@property (nonatomic, strong) NSString *deptidf;// 0;
@property (nonatomic, strong) NSString *pidf;// 26;
@property (nonatomic, strong) NSString *provincialNamef;// "青海省";

//@property (nonatomic, strong) NSString *provincef;// @"天津市"
@property (nonatomic, strong) NSString *pontAddrf;// @"津塘路59号名家装饰家具城3楼C368\t"
@property (nonatomic, strong) NSString *typef;// @"3dc475fd-e4e0-4a1f-ac19-f6cbba0c9812"
//@property (nonatomic, strong) NSString *deptIdf;// @"0"
//@property (nonatomic, strong) NSString *cityf;// @"天津市"
@property (nonatomic, strong) NSString *pointCoordinatef;// @"117.2487,39.124367"
//@property (nonatomic, strong) NSString *createTimef;// @"0"
@property (nonatomic, strong) NSString *pointNamef;// @"穗宝床垫(名家装饰家具城店)"
//@property (nonatomic, strong) NSString *dataSortNumf;// (long)0
//@property (nonatomic, strong) NSString *createIdf;// @"0"
@property (nonatomic, strong) NSString *phonef;// @"02224020975\t"
//@property (nonatomic, strong) NSString *trueNamef;// @"0"
@property (nonatomic, strong) NSString *typeTextf;// @"建材城"
//@property (nonatomic, strong) NSString *idf;// @"05b28376-5585-4934-990c-89841d68a467"

@property (nonatomic, strong) NSString *tonf;// 0;
@property (nonatomic, strong) NSString *remarkf;// 0;
@property (nonatomic, strong) NSString *vehicleModelTypef;
@property (nonatomic, strong) NSString *pickupDatef;
@property (nonatomic, strong) NSString *returnDatef;
@property (nonatomic, strong) NSString *returnLocationf;

@property (nonatomic, strong) NSString *assessContentf;//": "上篇介绍了service及其生命周期，这里scheduleAtFixedRate介绍java api中可直接查；这里写一个后台定时执行任务的例子，直接上代码",

@property (nonatomic, strong) NSString *goodIdf;//": "0a3d5b19-5ac8-4f7d-a17a-516d2b5b4991",
@property (nonatomic, strong) NSString *mobilef;//": "13922163927",
@property (nonatomic, strong) NSString *objTypef;//": 3,
@property (nonatomic, strong) NSString *orderIdf;//": "10371501320194005",
@property (nonatomic, strong) NSString *replyContentf;//": "",

@property (nonatomic, strong) NSString *brandIdf; //品牌编号
@property (nonatomic, strong) NSString *brandNamef; //品牌编号
@property (nonatomic, strong) NSString *serieIdf; //车系
@property (nonatomic, strong) NSString *serieNamef; //车系

@property (nonatomic, strong) NSString *carModelf; //车辆型号
@property (nonatomic, strong) NSString *carColorf; //车身颜色
@property (nonatomic, strong) NSString *engineModelf; //发动机型号
@property (nonatomic, strong) NSString *fuelTypef; //燃料种类
@property (nonatomic, strong) NSString *outputVolf; //排量
@property (nonatomic, strong) NSString *powerf; //功率
@property (nonatomic, strong) NSString *emissionStaf; //排放标准
@property (nonatomic, strong) NSString *oilwearf; //油耗
@property (nonatomic, strong) NSString *abroadLongf; //外轮廓长
@property (nonatomic, strong) NSString *abroadHighf; //外轮廓高
@property (nonatomic, strong) NSString *abroadWidthf; //外轮廓宽
@property (nonatomic, strong) NSString *insideLongf; //货箱内部尺寸长
@property (nonatomic, strong) NSString *insideHighf; //货箱内部尺寸高
@property (nonatomic, strong) NSString *insideWidthf; //货箱内部尺寸宽
@property (nonatomic, strong) NSString *qthNumf; //前钢板弹簧片数
@property (nonatomic, strong) NSString *hthNumf; //后钢板弹簧片数
@property (nonatomic, strong) NSString *tyreNumf; //轮胎数
@property (nonatomic, strong) NSString *tyreRulef; //轮胎规格
@property (nonatomic, strong) NSString *frontTyreDistf; //前轮距
@property (nonatomic, strong) NSString *backTyreDistf; //后轮距
@property (nonatomic, strong) NSString *wheelbasef; //轴距
@property (nonatomic, strong) NSString *frontAxleWeightf; //轴荷1
@property (nonatomic, strong) NSString *backtAxleWeightf; //轴荷2
@property (nonatomic, strong) NSString *axisNumf; //轴数
@property (nonatomic, strong) NSString *turnTypef; //转向形式
@property (nonatomic, strong) NSString *totalWeightf; //总质量
@property (nonatomic, strong) NSString *curbWeightf; //整备质量
@property (nonatomic, strong) NSString *ratedWeightf; //额定载质量
@property (nonatomic, strong) NSString *payloadFactorf; //载质量利用系数
@property (nonatomic, strong) NSString *dragWeightf; //准牵引总质量
@property (nonatomic, strong) NSString *bgcWeightf; //半挂车鞍座最大允许总质量
@property (nonatomic, strong) NSString *travellerNumf; //额定载客
@property (nonatomic, strong) NSString *maxSpeedf; //最高设计车速
@property (nonatomic, strong) NSString *madeDatef; //车辆制造日期
@property (nonatomic, strong) NSString *remarksf; //备注
@property (nonatomic, strong) NSString *complyInfof; //车辆制企业信息
@property (nonatomic, strong) NSString *isGroundingf; //是否上架
@property (nonatomic, strong) NSString *depositRatiof; //订金比例
@property (nonatomic, strong) NSString *depositf; //固定定金
@property (nonatomic, strong) NSString *paymentRatiof; //分期首款比例
@property (nonatomic, strong) NSString *paymentf; //固定分期首款
@property (nonatomic, strong) NSString *loanRatiof; //贷款比例
@property (nonatomic, strong) NSString *insurancef; //保险计算
@property (nonatomic, strong) NSString *deptNamef; //部门名称

#pragma mark --订单添加接口
+ (void)sendOrderdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --取消订单接口
+ (void)sendOrderdoCancelWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于接单
+ (void)sendOrderdoTakeWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于结束订单
+ (void)sendOrderdoEndWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --运价查询接口
+ (void)sendFreighttoPriceWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                             failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于提交司机信息
+ (void)sendDriverinfodoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                 failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于查询我的行程
+ (void)sendOrdertoRouteWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                           failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于查询司机的收入
+ (void)sendOrdertoIncomeWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于提交评价
+ (void)sendAssessdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                             failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --根据手机号查询司机的信息
+ (void)sendDriverinfobyMobileWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                 failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --添加充值记录
+ (void)sendRechargedoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --充值记录查询
+ (void)sendRechargetoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --图片上传接口
+ (void)sendDriverinfotoUploadWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                 failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于查询用户的余额
+ (void)sendRechargetoBalanceWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于修改密码
+ (void)sendSmsdoUpdatePwdWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                             failedBlock:(RequestSessionCompletedBlock)failedBlock;
#pragma mark --用于获得充值的主键
+ (void)sendRechargetoNumberWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于加小费
+ (void)sendOrdertoTipWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                         failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于查询周边的运货点
+ (void)sendGoodpointtoMarksWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于获得待接订单
+ (void)sendOrdertoDoneWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于查询运费点类别
+ (void)sendApptoPointTypeWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                             failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于查询城市
+ (void)sendCitystoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于查询微信支付
+ (void)sendOrdertoPayWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                         failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于查询评价文本
+ (void)sendApptoAssessWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                         failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --用于定时查询订单
+ (void)sendOrdertoReLoadWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                         failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --优惠劵用于结算订单
+ (void)sendCoupontoPayWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                          failedBlock:(RequestSessionCompletedBlock)failedBlock;


#pragma mark --V3.0版本-----------------------
#pragma mark --物流车源
+ (void)sendFreighttoCallWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --租车车源
+ (void)sendFreighttoRentWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                            failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --品牌
+ (void)sendBrandtoCustomListWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --车系
+ (void)sendSerietoCustomListWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --添加购物车
+ (void)sendMallorderdoAddCarWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --查询商品信息
+ (void)sendMallordertoViewWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                              failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --查询品牌、车系下的数据
+ (void)sendMallgoodstoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --查询购车的个人订单
+ (void)sendMallordertoMemberWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --添加收藏
+ (void)sendCollectdoCollectWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --删除收藏
+ (void)sendCollectdoDeleteWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                              failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --查询个人收藏
+ (void)sendCollecttoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                              failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --订单租车
+ (void)sendRentordertoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --添加租车订单
+ (void)sendRentorderdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --取消订单租车
+ (void)sendRentorderdoCancelWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --查询商品评价
+ (void)sendAssesstoCustomWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;


#pragma mark --集客
+ (void)sendCustomerdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                               failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --商品参数
+ (void)sendMallgoodstoViewWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                              failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --添加到购物车
+ (void)sendMallorderdoInsertWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                                failedBlock:(RequestSessionCompletedBlock)failedBlock;

#pragma mark --查询车型的节点价
+ (void)sendBdtoAppWithParameters:(NSMutableDictionary *)parameters successBlock:(RequestSessionCompletedBlock)successBlock
                      failedBlock:(RequestSessionCompletedBlock)failedBlock;
@end
