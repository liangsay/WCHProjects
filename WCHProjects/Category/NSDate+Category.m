//
//  NSDate+Category.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

#pragma mark - Date Property

-(NSInteger)year{
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear fromDate:self];
    return [components year];
    
}

-(NSInteger)month{
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMonth fromDate:self];
    return [components month];
    
}

-(NSInteger)day{
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitDay fromDate:self];
    return [components day];
    
}

-(NSInteger)numDaysInMonth{
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}

#pragma mark - Format Date

+ (NSString *)currentTimeString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)currentFullTimeString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)currentDetailTimeString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm:ss"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSDate*)dateWithString:(NSString*)dateString formatString:(NSString*)dateFormatterString {
    if(!dateString) return nil;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatterString];
    
    NSDate *theDate = [formatter dateFromString:dateString];
    
    return theDate;
}

+ (NSDate*)dateWithDateString:(NSString*)str{
    return [[self class] dateWithString:str formatString:@"yyyy-MM"];
}

+ (NSDate*)dateWithDateTimeString:(NSString*)str{
    return [[self class] dateWithString:str formatString:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)formatStringWithFormat:(NSString *)formatString{
    
    if (formatString.length == 0) {
        return @"";
    }
    //@"yyyy-MM-dd"
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    
    return [dateFormatter stringFromDate:self];
}

+ (NSString *)dateFormTimestampString:(NSString *)timestamp{
    
    NSTimeInterval timeInterval = [timestamp doubleValue];
    NSDate *confromTimsp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    
    return [formatter stringFromDate:confromTimsp];
}

+ (NSString *)dateFormTimestampString:(NSString *)timestamp format:(NSString *)format
{
    NSTimeInterval timeInterval = [timestamp doubleValue]/1000;
    NSDate *confromTimsp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:confromTimsp];
}

+ (NSString *)dateFormMoreTimestampString:(NSString *)timestamp format:(NSString *)format
{
    NSTimeInterval timeInterval = [timestamp doubleValue]/1000;
    NSDate *confromTimsp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    if(format == nil)
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormatter stringFromDate:confromTimsp];
    return dateString;
}


+ (NSString *)dateFormmterFormSecond:(int)count{
    
    //先计算天数
    int laveCounts = count;
    int days = laveCounts/(60*60*12);
    laveCounts = laveCounts - days*(60*60*12);
    
    //计算小时
    int hours = laveCounts/(60*60);
    laveCounts = laveCounts - hours*(60*60);
    
    //计算分钟
    int minutes = laveCounts/60;
    laveCounts = laveCounts - minutes*60;
    
    //剩余未秒数
    int second = laveCounts;
    
    return [NSString stringWithFormat:@"%d天%d小时%d分%d秒",days,hours,minutes,second];
}

- (NSString*)formattedExactRelativeDate{
    
    NSTimeInterval time = [self timeIntervalSince1970];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diff = now - time;
    
    if(diff < 10) {
        return [NSString stringWithFormat:@"刚刚"];
    } else if(diff < 60) {
        return [NSString stringWithFormat:@"%d秒前",(int)diff];
    }
    
    diff = round(diff/60);
    if(diff < 60) {
        if(diff == 1) {
            return [NSString stringWithFormat:@"%d分钟前",(int)diff];
        } else {
            return [NSString stringWithFormat:@"%d分钟前",(int)diff];
        }
    }
    
    diff = round(diff/60);
    if(diff < 24) {
        if(diff == 1) {
            return [NSString stringWithFormat:@"%d小时前",(int)diff];
        } else {
            return [NSString stringWithFormat:@"%d小时前",(int)diff];
        }
    }
    
    if(diff < 7) {
        if(diff == 1) {
            return @"昨天";
        } else {
            return [NSString stringWithFormat:@"%d天前", (int)diff];
        }
    }
    
    return [self formattedDateWithFormatString:@"MM/dd/yy"];
}

- (NSString*)formattedDateWithFormatString:(NSString*)dateFormatterString {
    if(!dateFormatterString) return nil;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatterString];
    [formatter setAMSymbol:@"am"];
    [formatter setPMSymbol:@"pm"];
    return [formatter stringFromDate:self];
}

+ (NSString *)pastDateString:(int )pageDays{
    
    NSDate *lastDate = [[NSDate date] dateByAddingTimeInterval:pageDays*86400*-1];
    NSMutableString *currentString = [NSMutableString stringWithFormat:@"%@",lastDate];
    return [currentString substringToIndex:10];
}

+ (NSString *)addDateString:(int )pageDays{
    
    NSDate *lastDate = [[NSDate date] dateByAddingTimeInterval:pageDays*86400];
    NSMutableString *currentString = [NSMutableString stringWithFormat:@"%@",lastDate];
    return [currentString substringToIndex:10];
}

+ (NSString *)pastMonthDateString:(int )pastMonth{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1 * pastMonth];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:[NSDate date] options:0];
    NSMutableString *currentString = [NSMutableString stringWithFormat:@"%@",mDate];
    return [currentString substringToIndex:10];
}

#pragma mark - Time comparison

- (BOOL)isPastDate{
    NSDate* now = [NSDate date];
    if([[now earlierDate:self] isEqualToDate:self]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isDateToday{
    return [[[NSDate date] midnightDate] isEqual:[self midnightDate]];
}

- (BOOL)isDateYesterday{
    return [[[NSDate dateWithTimeIntervalSinceNow:-86400] midnightDate]
            isEqual:[self midnightDate]];
}

- (NSDate*)midnightDate {
    return [[NSCalendar currentCalendar] dateFromComponents:
            [[NSCalendar currentCalendar] components:
             (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self]];
}

//后加
+ (NSString *)ymmdateFormTimestampString:(NSString *)timestamp{
    
    NSTimeInterval timeInterval = [timestamp doubleValue];
    NSDate *confromTimsp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:confromTimsp];
}

//后加
+ (NSString *)homeNewsdateFormTimestampString:(NSString *)timestamp{
    
    NSTimeInterval timeInterval = [timestamp doubleValue];
    NSDate *confromTimsp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    return [formatter stringFromDate:confromTimsp];
}

static NSDateFormatter *outputFormatter = nil;


+(NSDateFormatter *)getOutputFormatter
{
    
    if (outputFormatter==nil) {
        outputFormatter = [NSDateFormatter new];
    }
    return outputFormatter;
}

//时间格式化 date时间 style样式
//type == 1: 根据时区改变
//type == 2: 固定样式
- (NSString *)formatterDatestyle:(NSString *)style type:(NSInteger)type
{
    if(type == 1)
        [[NSDate getOutputFormatter] setDateFormat:[NSDateFormatter dateFormatFromTemplate:style options:0 locale:[NSLocale currentLocale]]];
    else if(type == 2)
        [[NSDate getOutputFormatter] setDateFormat:style];
    
    return [[NSDate getOutputFormatter] stringFromDate:self];
}

-(NSString*)getDateFormateWithDateShow:(BOOL)dateShow  withTimeShow:(BOOL)timeShow
{
    
    if (dateShow==YES) {
        [[NSDate getOutputFormatter] setDateStyle:NSDateFormatterMediumStyle];
    }
    if (timeShow==YES) {
        [[NSDate getOutputFormatter] setTimeStyle:NSDateFormatterShortStyle];
    }
    
    NSString* time = [[NSDate getOutputFormatter] stringFromDate:self];
    //[outputFormatter release];
    return time;
}

//字符串转日期
+(NSDate*)formatterDate:(NSString *)style withDate:(NSString*)dateStr
{
    //    if(type == 1)
    //        [[NSDate getOutputFormatter] setDateFormat:[NSDateFormatter dateFormatFromTemplate:style options:0 locale:[NSLocale currentLocale]]];
    //    else if(type == 2)
    [[NSDate getOutputFormatter] setDateFormat:style];
    
    return [[NSDate getOutputFormatter] dateFromString:dateStr];
}

+ (NSDate * )NSStringToNSDate: (NSString * )dateStr withFormat:(NSString*)format
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: format];
    NSDate *date = [formatter dateFromString :dateStr];
    return date;
}


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
+(NSString *)timeIntervalToDataString:(NSTimeInterval)timeInterval  formate:(NSString *)formate
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formate];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

//以下是NSDate中的常用方法:
/**
 
 - (id)initWithTimeInterval:(NSTimeInterval)secs sinceDate:(NSDate *)refDate;
 初始化为以refDate为基准，然后过了secs秒的时间
 
 - (id)initWithTimeIntervalSinceNow:(NSTimeInterval)secs;
 初始化为以当前时间为基准，然后过了secs秒的时间
 
 
 - (NSTimeInterval)timeIntervalSinceDate:(NSDate *)refDate;
 以refDate为基准时间，返回实例保存的时间与refDate的时间间隔
 
 - (NSTimeInterval)timeIntervalSinceNow;
 以当前时间(Now)为基准时间，返回实例保存的时间与当前时间(Now)的时间间隔
 
 - (NSTimeInterval)timeIntervalSince1970;
 以1970/01/01 GMT为基准时间，返回实例保存的时间与1970/01/01 GMT的时间间隔
 
 - (NSTimeInterval)timeIntervalSinceReferenceDate;
 以2001/01/01 GMT为基准时间，返回实例保存的时间与2001/01/01 GMT的时间间隔
 
 
 + (NSTimeInterval)timeIntervalSinceReferenceDate;
 
 */


//秒
// - (NSTimeInterval)timeIntervalSinceNow;
//    以当前时间(Now)为基准时间，返回实例保存的时间与当前时间(Now)的时间间隔

+(NSString *)converDate:(NSString *)value withFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: [value doubleValue]/1000];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate: date];
}

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
+(NSTimeInterval)getSurplusTimerIntervalWith:(NSTimeInterval)timerInterval{
    __block NSTimeInterval timeout=timerInterval; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=1000){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                DLog(@"剩余timerInterval:%@",[self converTimeIntervalToDatetimeWith:timeout format:@""]);
            });
        }else{
            //            int minutes = timeout / 60;
            //            int seconds = timeout % 60;
            //            NSString *strTime = [NSString stringWithFormat:@"%d分%.2d秒后重新获取验证码",minutes, seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                DLog(@"timerInterval:%.0f",timerInterval);
                DLog(@"剩余timerInterval:%@",[self converTimeIntervalToDatetimeWith:timeout format:@""]);
            });
            timeout-=1000;
            
            
        }
        
    });
    dispatch_resume(_timer);
    
    return timeout;
}

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
+ (NSString *)converDatetimeToTimeIntervalWith:(NSString *)dateTime format:(NSString *)format {
    //    设置时间显示格式:
    NSString* timeStr = dateTime;//@"2016-01-09 17:40:50";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (kIsObjectEmpty(format)) {
        format =@"yyyy-MM-dd HH:mm:ss";
    }
    [formatter setDateFormat:format]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    DLog(@"nowtimeStr:%@",nowtimeStr);
    //    时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
    
}

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
+ (NSString *)converTimeIntervalToDatetimeWith:(NSTimeInterval)timeInterval format:(NSString *)format{
    //    设置时间显示格式:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (kIsObjectEmpty(format)) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    [formatter setDateFormat:format]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    //    时间戳转时间的方法
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    DLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    DLog(@"confromTimespStr =  %@",confromTimespStr);
    //    时间戳转时间的方法:
    NSDate *date = [formatter dateFromString:kDoubleToString(timeInterval)];
    DLog(@"date1:%@",date);
    //    NSString *dateStr = [formatter stringFromDate:date];
    return confromTimespStr;
}

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
+(NSDate *)converTimeIntervalToDateWith:(NSTimeInterval)timeInterval format:(NSString *)format{
    //    设置时间显示格式:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (kIsObjectEmpty(format)) {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    [formatter setDateFormat:format]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    //    时间戳转时间的方法
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000];
    DLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    DLog(@"confromTimespStr =  %@",confromTimespStr);
    //    时间戳转时间的方法:
    //    NSDate *date = [formatter dateFromString:kDoubleToString(timeInterval/1000)];
    NSDate *date = [formatter dateFromString:confromTimespStr];
    DLog(@"date1:%@",date);
    //    NSString *dateStr = [formatter stringFromDate:date];
    return date;
}

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
+ (NSString *)timeIntervalWithNow:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (kIsObjectEmpty(format)) {
        format =@"yyyy-MM-dd HH:mm:ss";
    }
    [formatter setDateFormat:format]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    //获取的NSDate date时间与实际相差8个小时解决方案
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSInteger interval = [timeZone secondsFromGMTForDate: datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSLog(@"enddate=%@",localeDate);
    NSString *nowtimeStr = [formatter stringFromDate:localeDate];//----------将nsdate按formatter格式转成nsstring
    NSString *nowtimeIntervalStr = [self converDatetimeToTimeIntervalWith:nowtimeStr format:@""];
    DLog(@"nowtimeStr:%@",nowtimeStr);
    DLog(@"nowtimeIntervalStr:%@",nowtimeIntervalStr);
    
    return nowtimeIntervalStr;
}


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
+ (NSString *)timerFireMethodWithDateTime:(NSString *)dateTime timer:(NSTimer *)timer
{
    //    BOOL timeStart = YES;
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    //    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...
    NSDate *today = [NSDate date];    //得到当前时间
    
    //    NSDate *date = [NSDate dateWithTimeInterval:60 sinceDate:today];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    today = [dateFormatter dateFromString:[dateFormatter stringFromDate:today]];
    NSDate *todate = [dateFormatter dateFromString:dateTime];
    
    //用来得到具体的时差，是为了统一成北京时间，年月日时分秒
    //    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //用来得到具体的时差 天时分秒
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:todate options:0];
    
    NSString *shi = [NSString stringWithFormat:@"%ld", (long)[d hour]];
    if([d hour] < 10) {
        shi = [NSString stringWithFormat:@"0%ld",(long)[d hour]];
    }
    
    NSString *fen = [NSString stringWithFormat:@"%ld", (long)[d minute]];
    if([d minute] < 10) {
        fen = [NSString stringWithFormat:@"0%ld",(long)[d minute]];
    }
    NSString *miao = [NSString stringWithFormat:@"%ld", (long)[d second]];
    if([d second] < 10) {
        miao = [NSString stringWithFormat:@"0%ld",(long)[d second]];
    }
    NSString *hadTime = @"";
    hadTime = [NSString stringWithFormat:@"%ld天%@小时%@分%@秒", (long)[d day], shi, fen, miao];
    //    hadTime = [NSString stringWithFormat:@"%d年%d月%d日%d时%d分%d秒",[d year],[d month], [d day], [d hour], [d minute], [d second]];
    DLog(@"hadTime:%@",hadTime);
    if([d second] > 0) {
        
        //计时尚未结束，do_something
        
    } else if([d second] == 0) {
        
        //计时1分钟结束，do_something
        
    } else{
        //        hadTime = @"活动已截止";
        hadTime = [NSString stringWithFormat:@"%d天%@小时%@分%@秒", 0, @"0", @"0", @"0"];
        [timer invalidate];
    }
    
    
    return hadTime;
}

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
- (NSString *)converDateTimeWith:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (kIsObjectEmpty(format)) {
        format =@"yyyy-MM-dd HH:mm:ss";
    }
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:self];
}
@end
