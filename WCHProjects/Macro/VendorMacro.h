//
// Created by liujinliang on 16/5/27.
// Copyright (c) 2016 liujinliang. All rights reserved.
//

/**!
 * VendorMacro.h 里放一些第三方常量，如：
#define UMENG_KEY @"xxxxx"
#define UMENG_CHANNEL_ID @"xxx"

如果有新的类型的宏定义，可以再新建一个相关的Macro.h。
 */

/*友盟数据统计*/
static inline NSString *kUmengAnalyticsKey(void){
    return @"57dff57e67e58e2a52003099";
}

/*百度地图*/
static inline NSString *kBaiDuMapKey(){
    return @"qQyG0zKYNNW949z1vlB3gLivN1hohaHK";
}

static inline NSString *kWXAppId(){
    return @"wx338797496c8b4111";//@"wx338797496c8b4111";
}
