//
//  NSString+Category.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
#pragma mark --视图大小--------
- (CGRect)getSizeStringWithBoundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context;

#pragma mark --Toast--------
/**
 *  弹出提示
 */
- (void)toast;

/**
 *  弹出提示
 */
+ (void)toast:(NSString *)message;

#pragma mark - JSON
- (id)JSONObject;

#pragma mark - 取值
/**
 *  取UDID
 */
+ (instancetype)UDIDString;

/**
 *  发布版本号
 */
+ (instancetype)publishVersion;

/**
 *  开发版本号
 */
+ (instancetype)buildVersion;

/**
 *  BundleID
 */
+ (instancetype)bundleIdentifier;

/**
 *  用作缓存数据的目录
 */
+ (instancetype)documentPath;

#pragma mark - 字符串处理
/**
 *  格式化成字符串。空值转为空串
 */
+ (instancetype)toString:(NSObject *)object;

/**
 *  去掉空格
 */
- (NSString *)trimString:(NSString *)str;

#pragma mark - 值检测
/**
 *  是否纯数字
 */
+ (BOOL)isNumber:(NSString *)str;

/**
 *  是否中文。
 */
+ (BOOL)isChinese:(NSString *)str;

+ (BOOL)isEmptyOrNull:(NSString *)str;

+ (BOOL)notEmptyOrNull:(NSString *)str;

+ (NSString*) makeNode:(NSString *)str;


//字符串是否为空
- (BOOL)isEmpty;
/**
 *  @author King, 15-06-16 15:06:20
 *
 *  给字符传指定区间替换成*号
 *
 *  @param range <#range description#>
 */
- (NSString *)changeStringToStar;

/**
 *  @author King, 15-06-17 10:06:50
 *
 *  清除联系方式的特殊符号
 *
 *  @param phoneNumber <#phoneNumber description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)cleanPhoneNumber:(NSString *)str;

#pragma mark --限制性输入
/**
 *  @author King, 15-06-17 16:06:20
 *
 *  限制性输入
 *
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)chenkInputNSCharacterSetWithType:(int)type;

#pragma mark --过滤html文本
/**
 *  过滤html文本
 *
 *  @param html <#html description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)filterHTML:(NSString *)str;

+(NSString *)findNumFromStr:(NSString *)text;

#pragma mark --删除反斜杠
+ (NSString *)removeXieGangWithJsonStr:(NSString *)jsonStr;


// 显示万单位的价格
+(NSMutableAttributedString *)AttributePrice:(NSString *)string;



+(NSString*)urlEncode:(id<NSObject>)value;

#pragma mark --解决因特殊符号而提交异常的情况
/*!
 *  @author liujinliang, 16-02-16 15:02:22
 *
 *  @brief 解决因特殊符号而提交异常的情况
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (NSString *)urlEncodeWith:(NSString *)string;

#pragma mark --控制小数最多小数点后两位
/*!
 *  @author liujinliang, 16-02-16 15:02:07
 *
 *  @brief 控制小数最多小数点后两位
 *
 *  @param areaValue <#areaValue description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (NSString *)areaStringWithFromat:(NSString *)areaValue;

#pragma mark --格式化银行卡号
/*!
 *  @author liujinliang, 16-12-27 21:12:25
 *
 *  @brief 格式化银行卡号
 *
 *  @param cardNum <#cardNum description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#1.1.0#>
 */
+ (NSString *)formatBankCardNumber:(NSString *)cardNum;

#pragma mark --金额千分位显示
/*!
 *  @author liujinliang, 16-02-16 15:02:17
 *
 *  @brief 金额千分位显示
 *
 *  @param num <#num description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
+ (NSString *)formatMoneyWithNum:(double)num;

#pragma mark --计算文本内容占据的Size
/*!
 *  @author liujinliang, 16-03-01 14:03:48
 *
 *  @brief 计算文本内容占据的Size
 *
 *  @param size       <#size description#>
 *  @param font       <#font description#>
 *  @param attributes <#attributes description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font attributes:(NSDictionary *)attributes;
@end
