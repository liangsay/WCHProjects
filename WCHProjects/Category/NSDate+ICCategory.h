/*!
 @header
 @abstract    NSDate+ICCategory.h
 @discussion  NSDate常用扩展
 @updated     2013-04-30
 @author      Fox
 @version     1.0.0
 */

#import <Foundation/Foundation.h>

/*!
 @class
 @abstract      NSDate+ICCategory
 @discussion    NSDate常用扩展
 */
@interface NSDate (ICCategory)


/*!
 @method
 @abstract                      通过一定格式的字符串转换为NSDate时间对象
 @discussion
 
 @param     dateString          显示实际字符串
 @param     dateFormatterString 字符串对应的时间格式
 */
+ (NSDate*)dateWithString:(NSString*)dateString
             formatString:(NSString*)dateFormatterString;

/*!
 @method
 @abstract                      通过ISO8610格式的字符串获取NSDate时间对象
 @discussion                    ISO8610格式定义为：yyyy-MM-dd'T'HH:mm:ssZZZ
 
 @param     str                 待转换的字符串
 */
+ (NSDate*)dateWithISO8601String:(NSString*)str;

/*!
 @method
 @abstract                      通过'yyyy-MM-dd'格式的字符串获取NSDate时间对象
 @discussion                    通过'yyyy-MM-dd'格式的字符串获取NSDate时间对象
 
 @param     str                 待转换的字符串
 */
+ (NSDate*)dateWithDateString:(NSString*)str;

/*!
 @method
 @abstract                      通过'yyyy-MM-dd HH:mm:ss' 格式的字符串获取NSDate时间对象
 @discussion                    通过'yyyy-MM-dd HH:mm:ss' 格式的字符串获取NSDate时间对象
 
 @param     str                 待转换的字符串
 */
+ (NSDate*)dateWithDateTimeString:(NSString*)str;

/*!
 @method
 @abstract                      通过'dd MMM yyyy HH:mm:ss' 格式的字符串获取NSDate时间对象
 @discussion                    通过'dd MMM yyyy HH:mm:ss' 格式的字符串获取NSDate时间对象
 
 @param     str                 待转换的字符串
 */
+ (NSDate*)dateWithLongDateTimeString:(NSString*)str;

/*!
 @method
 @abstract                      通过'EEE, d MMM yyyy HH:mm:ss ZZZ' 格式的字符串获取NSDate时间对象
 @discussion                    通过'EEE, d MMM yyyy HH:mm:ss ZZZ' 格式的字符串获取NSDate时间对象
 
 @param     str                 待转换的字符串
 */
+ (NSDate*)dateWithRSSDateString:(NSString*)str;

/*!
 @method
 @abstract                      通过'd MMM yyyy HH:mm:ss ZZZ' 格式的字符串获取NSDate时间对象
 @discussion                    通过'd MMM yyyy HH:mm:ss ZZZ' 格式的字符串获取NSDate时间对象
 
 @param     str                 待转换的字符串
 */
+ (NSDate*)dateWithAltRSSDateString:(NSString*)str;


/*!
 @method
 @abstract        将时间戳转换为NSDate
 @discussion      输入的时间戳为10位，如1372166079对应的日期为2013年6月25日
 */
+ (NSString *)dateFormTimestampString:(NSString *)timestamp;

/**
 *  将秒数转换为天、小时、分和秒；例如111230转换为3天5小时42分12秒
 *
 *	@param	count
 *
 *	@return
 */
+ (NSString *)dateFormmterFormSecond:(int)count;

// just now, 2 minutes ago, 2 hours ago, 2 days ago, etc.

/*!
 @method
 @abstract                      返回类似刚刚、2分钟前、2小时前和2天前类似的字符串
 @discussion
 */
- (NSString*)formattedExactRelativeDate;

/*!
 @method
 @abstract                      通过格式化的时间字符串获得其对应的NSDateFormatter格式
 @discussion
 */
- (NSString*)formattedDateWithFormatString:(NSString*)dateFormatterString;

/*!
 @method
 @abstract           将时间转换为类似EEE, d MMM 'at' h:mma格式的字符串
 @discussion
 */
- (NSString*)formattedDate;

/*!
 @method
 @abstract        将NSDate转换为NSDateFormatterShortStyle格式
 @discussion
 */
- (NSString*)formattedTime;
/*!
 @method
 @abstract        Returns date formatted to: Weekday if within last 7 days, Yesterday/Tomorrow, or NSDateFormatterShortStyle for everything else
 @discussion
 */
- (NSString*)relativeFormattedDate;

/*!
 @method
 @abstract        Returns date formatted to: Weekday if within last 7 days, Yesterday/Today/Tomorrow, or NSDateFormatterShortStyle for everything else 
 @discussion      If date is today, returns no Date, instead returns NSDateFormatterShortStyle for time
 */
- (NSString*)relativeFormattedDateOnly;

/*!
 @method
 @abstract        Returns date formatted to: Weekday if within last 7 days, Yesterday/Today/Tomorrow, or NSDateFormatterFullStyle for everything else。Also returns NSDateFormatterShortStyle for time
 @discussion
 */
- (NSString*)relativeFormattedDateTime;

/*!
 @method
 @abstract        Returns date formatted to: Weekday if within last 7 days, Yesterday/Today/Tomorrow, or NSDateFormatterFullStyle for everything else
 @discussion
 */
- (NSString*)relativeLongFormattedDate;

/*!
 @method
 @abstract        Returns date formatted for ISO8601/ATOM: yyyy-MM-dd'T'HH:mm:ssZZZ
 @discussion
 */
- (NSString*)iso8601Formatted;

/*!
 @method
 @abstract        Checks whether current date is past date
 @discussion
 */
- (BOOL)isPastDate;

/*!
 @method
 @abstract        Checks whether the current date occured today
 @discussion
 */
- (BOOL)isDateToday;

/*!
 @method
 @abstract        Checks whether the current date occured yesterday
 @discussion
 */
- (BOOL)isDateYesterday;

/*!
 @method
 @abstract        Returns the current date, at midnight
 @discussion
 */
- (NSDate*)midnightDate;

#pragma mark - Calendar
/*!
 @method
 @abstract        几个月之后对应的NSDate
 @discussion
 
 @param numMonths   相间隔的月数
 */
-(NSDate *)offsetMonth:(int)numMonths;

/*!
 @method
 @abstract        几天之后对应的NSDate
 @discussion
 
 @param numMonths   相间隔的天数
 */
-(NSDate *)offsetDay:(int)numDays;

/*!
 @method
 @abstract        几天之后对应的NSDate
 @discussion
 
 @param numMonths   相间隔的天数
 */
-(NSDate *)offsetHours:(int)hours;

/*!
 @method
 @abstract        该月对应的天数
 @discussion
 */
-(NSInteger)numDaysInMonth;

/*!
 @method
 @abstract        该月的第一个星期对应的星期几
 @discussion
 */
-(NSInteger)firstWeekDayInMonth;

/*!
 @method
 @abstract        当前年
 @discussion
 */
-(NSInteger)year;

/*!
 @method
 @abstract        当前月
 @discussion
 */
-(NSInteger)month;

/*!
 @method
 @abstract        当前天
 @discussion
 */
-(NSInteger)day;

+(NSDate *)dateStartOfDay:(NSDate *)date;
+(NSDate *)dateStartOfWeek;
+(NSDate *)dateEndOfWeek;


@end
