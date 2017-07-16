//
// Created by liujinliang on 16/5/27.
// Copyright (c) 2016 liujinliang. All rights reserved.
//
/**!
 * AppMacro.h 里放app相关的宏定义，如:
// 表情相关
#define EMOTION_CACHE_PATH @"cachedemotions"
#define EMOTION_RECENT_USED @"recentusedemotions"
#define EMOTION_CATEGORIES @"categoryemotions"
#define EMOTION_TOPICS @"emotiontopics"

// 收藏相关
#define COLLECT_CACHE_PATH @"collected"

// 配图相关
#define WATERFALL_ITEM_HEIGHT_MAX 300
#define WATERFALL_ITEM_WIDTH 146
 */

#pragma mark --------------------------------AppStore相关-----------------------------------
#define kAppleID @"1022276251"
//AppStore
#define kAppStoreURL [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",kAppleID]
//App评分
#define kOpenURL_UserReviews [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", kAppleID]]]
//当前系统已更新
#define kAPPHADUPDATE @"kAPPHADUPDATE"

@interface AppMacro : NSObject
@end