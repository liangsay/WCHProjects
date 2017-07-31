//
//  NSDate+Category.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateTools.h"
@interface NSDate (Category)

#pragma mark - Date Property

/**
 *  当前日期的年
 *
 *  @return 年
 */
-(NSInteger)year;

/**
 *  当前月
 *
 *  @return 月
 */
-(NSInteger)month;

/**
 *  当前天
 *
 *  @return 天
 */
-(NSInteger)day;

/**
 *  当月对应的天数
 *
 *  @return 天数
 */
-(NSInteger)numDaysInMonth;

#pragma mark - Format Date

/**
 *  当前时间字符串，年、月、日
 *
 *  @return 时间字符串
 */
+ (NSString *)currentTimeString;

/**
 *  当前时间字符串，除了年、月和日，还包含小时、分钟和秒
 *
 *  @return 时间字符串
 */
+ (NSString *)currentFullTimeString;

/**
 *  当前时间字符串，只包含小时、分钟和秒
 *
 *  @return 时间字符串
 */
+ (NSString *)currentDetailTimeString;

/**
 *  通过一定格式的字符串转换为NSDate时间对象
 *
 *  @param dateString          时间字符串
 *  @param dateFormatterString 时间格式字符串
 *
 *  @return 时间对象
 */
+ (NSDate*)dateWithString:(NSString*)dateString
             formatString:(NSString*)dateFormatterString;

/**
 *  通过'yyyy-MM-dd HH:mm:ss' 格式的字符串获取NSDate时间对象
 *
 *  @param str 时间字符串
 *
 *  @return 时间对象
 */
+ (NSDate*)dateWithDateString:(NSString*)str;

/**
 *  通过'yyyy-MM-dd HH:mm:ss' 格式的字符串获取NSDate时间对象
 *
 *  @param str 时间字符串
 *
 *  @return 时间对象
 */
+ (NSDate*)dateWithDateTimeString:(NSString*)str;

/**
 *  按照一定的格式返回时间对象的字符串，如"yyyy-MM-dd",则只返回年月日
 *
 *  @param formatString 格式字符串
 *
 *  @return 时间对应格式的字符串
 */
- (NSString *)formatStringWithFormat:(NSString *)formatString;

/**
 *  将时间戳修改为时间对象
 *
 *  @param timestamp 时间戳
 *
 *  @return 时间对象
 */
+ (NSString *)dateFormTimestampString:(NSString *)timestamp;

+ (NSString *)dateFormTimestampString:(NSString *)timestamp format:(NSString *)format;

/**
 *  将时间戳修改为时间对象
 *
 *  @param timestamp 时间戳[需要除以1000]
 *
 *  @return 时间对象
 */
+ (NSString *)dateFormMoreTimestampString:(NSString *)timestamp format:(NSString *)format;


/**
 *  将秒数转换为天、小时、分和秒；例如111230转换为3天5小时42分12秒
 *
 *  @param count 秒
 *
 *  @return 描述文字
 */
+ (NSString *)dateFormmterFormSecond:(int)count;

/**
 *  将时间修改为刚刚、2分钟前、2小时前和2天前描述的字符串
 *
 *  @return 结果字符串
 */
- (NSString*)formattedExactRelativeDate;

/**
 *  过去多少天对应的时间
 *
 *  @param pageDays 天数
 *
 *  @return 时间描述字符串
 */
+ (NSString *)pastDateString:(int )pageDays;

/**
 *  未来的多少天
 *
 *  @param pageDays 天数
 *
 *  @return 时间描述字符串
 */
+ (NSString *)addDateString:(int )pageDays;

/**
 *  未来的多少月
 *
 *  @param pastMonth 过去月数
 *
 *  @return 时间描述字符串
 */
+ (NSString *)pastMonthDateString:(int )pastMonth;
+ (NSString *)ymmdateFormTimestampString:(NSString *)timestamp;
+ (NSString *)homeNewsdateFormTimestampString:(NSString *)timestamp;
#pragma mark - Time comparison

/**
 *  是否早于现在
 *
 *  @return 计较结果
 */
- (BOOL)isPastDate;

/**
 *  是否为今天
 *
 *  @return 比较结果
 */
- (BOOL)isDateToday;

/**
 *  是否为昨天
 *
 *  @return 比较结果
 */
- (BOOL)isDateYesterday;

/*!
 *  @author King, 15-09-06 10:09:10
 *
 *  @brief  字符串转日期
 *
 *  @param style   <#style description#>
 *  @param dateStr <#dateStr description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+(NSDate*)formatterDate:(NSString *)style withDate:(NSString*)dateStr;


- (NSString *)formatterDatestyle:(NSString *)style type:(NSInteger)type;

-(NSString*)getDateFormateWithDateShow:(BOOL)dateShow  withTimeShow:(BOOL)timeShow;

#pragma mark --时间戳转时间
/*!
 *  @author liujinliang, 16-02-16 14:02:31
 *
 *  @brief 时间戳转时间
 *
 *  @param timeInterval <#timeInterval description#>
 *  @param formate      <#formate description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+(NSString *)timeIntervalToDataString:(NSTimeInterval)timeInterval  formate:(NSString *)formate;

// 时间转换 @"yyyy-MM-dd hh:mm:ss"
+(NSString *)converDate:(NSString *)value withFormat:(NSString *)format;

#pragma mark --时间戳倒计时
/*!
 *  @author liujinliang, 16-01-08 11:01:02
 *
 *  @brief 时间戳倒计时
 *
 *  @param timerInterval <#timerInterval description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#2.0#>
 */
+(NSTimeInterval)getSurplusTimerIntervalWith:(NSTimeInterval)timerInterval;

#pragma mark --时间戳转时间
/*!
 *  @author liujinliang, 16-01-08 11:01:15
 *
 *  @brief 时间戳转时间
 *
 *  @param timeInterval <#timeInterval description#>
 *  @param format       <#format description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#2.0#>
 */
+ (NSString *)converTimeIntervalToDatetimeWith:(NSTimeInterval)timeInterval format:(NSString *)format;

#pragma mark --时间转时间戳
/*!
 *  @author liujinliang, 16-01-08 11:01:58
 *
 *  @brief 时间转时间戳
 *
 *  @param dateTime <#dateTime description#>
 *  @param format   <#format description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#2.0#>
 */
+ (NSString *)converDatetimeToTimeIntervalWith:(NSString *)dateTime format:(NSString *)format;

#pragma mark --获取当前时间戳
/*!
 *  @author liujinliang, 16-01-08 11:01:39
 *
 *  @brief 获取当前时间戳
 *
 *  @param format <#format description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#2.0#>
 */
+ (NSString *)timeIntervalWithNow:(NSString *)format;

#pragma mark --倒计时剩余时间 天/时/分/秒
/*!
 *  @author liujinliang, 16-01-08 13:01:33
 *
 *  @brief 倒计时剩余时间 天/时/分/秒
 *
 *  @param dateTime <#dateTime description#>
 *
 *  @since <#2.0#>
 */
+ (NSString *)timerFireMethodWithDateTime:(NSString *)dateTime timer:(NSTimer *)timer;

#pragma mark --时间戳转时间NSDate类型
/*!
 *  @author liujinliang, 16-01-28 15:01:36
 *
 *  @brief 时间戳转时间NSDate类型
 *
 *  @param timeInterval <#timeInterval description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#2.0.0#>
 */
+(NSDate *)converTimeIntervalToDateWith:(NSTimeInterval)timeInterval format:(NSString *)format;

#pragma mark --NSDate 转字符串类型
/*!
 *  @author liujinliang, 16-03-01 11:03:32
 *
 *  @brief NSDate 转字符串类型
 *
 *  @param format <#format description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (NSString *)converDateTimeWith:(NSString *)format;

//获取当前的时间

+(NSString*)getCurrentTimes;
//获取当前时间戳有两种方法(以秒为单位)

+(NSString *)getNowTimeTimestamp;
+(NSString *)getNowTimeTimestamp2;
//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3;
#pragma mark --/**任意两天相差天数*/
/**任意两天相差天数*/
+ (NSInteger)getTheCountOfTwoDaysWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate;
@end
