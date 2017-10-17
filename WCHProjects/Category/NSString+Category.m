//
//  NSString+Category.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "NSString+Category.h"
#import <SAMKeychain/SAMKeychain.h>
//#import "SAMKeychain.h"
#import "ToastView.h"
#import "UIView+Toast.h"

//定义宏（限制输入内容）
#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."
#define kNumberX  @"0123456789xX"
#define kNumbersheng  @"0123456789-"

@implementation NSString (Category)

#pragma mark --文本视图大小
/*!
 *  @author King, 15-09-06 10:09:54
 *
 *  @brief  获取文本在所在视图展示大小
 *
 *  @param size       <#size description#>
 *  @param options    <#options description#>
 *  @param attributes <#attributes description#>
 *  @param context    <#context description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (CGRect)getSizeStringWithBoundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context{
    NSStringDrawingOptions _options = options;
    if (!options) {
        _options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    }
    if (self.length) {
        return [self boundingRectWithSize:size options:_options attributes:attributes context:context];
    }
    return CGRectZero;
}


#pragma mark - Toast
/**
 *  弹出提示
 */
- (void)toast
{
    if (self.length == 0) return;
    //    [SVProgressHUD dismiss];
    //    [SVProgressHUD setFont:kFont(28.f)];
    //    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    //
    //    kshowInfoWithStatus(@"sdfjkkjlsdjf lsdkf sdkfj lsdkjf lskdjf lksdjfl ksjdfl ksjdklf jsdkl fjlskd jflskdj sdjlsj ksdj lskj flsj fsjd ljsd ljdl fjs dlj");
    [ToastView toast:self];
}

+ (void)toast:(NSString *)message
{
    
    [kAppDelegate.window makeToast:message];
    //[message toast];
}

#pragma mark - JSON
- (id)JSONObject
{
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
}

#pragma mark - 取值
/**
 *  取UDID
 */
+ (instancetype)UDIDString
{
    NSString *service = @"udid";
    NSString *account = @"WCHProjects";
    NSString *udid = [SAMKeychain passwordForService:service account:account];
    
    if (!udid)
    {
        udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        if (NO == [SAMKeychain setPassword:udid forService:service account:account])
        {
            DLog(@"保存udid失败");
        }
    }
    return [udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

/**
 *  发布版本号
 */
+ (instancetype)publishVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 *  开发版本号
 */
+ (instancetype)buildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

/**
 *  BundleID
 */
+ (instancetype)bundleIdentifier
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
}

/**
 *  用作缓存数据的目录
 */
+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark - 字符串处理
/**
 *  格式化成字符串。空值转为空串
 */
+ (instancetype)toString:(NSObject *)object
{
    return [NSString stringWithFormat:@"%@", object == nil || object == [NSNull null] ? @"" : object];
}

/**
 *  去掉空格
 */
+ (NSString *)trimString:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - 值检测
/**
 *  是否纯数字
 */
+ (BOOL)isNumber:(NSString *)str
{
    for (NSInteger index = 0; index < str.length; ++index)
    {
        unichar ch = [str characterAtIndex:index];
        if (!isnumber(ch))
        {
            return NO;
        }
    }
    return YES;
}

//字符串是否为空
- (BOOL)isEmpty {
    if (!kIsObjectEmpty(self)) {
        return NO;
    }
    return YES;
}

+ (BOOL)isChinese:(NSString *)str
{
    for (NSInteger index = 0; index < str.length; ++index)
    {
        unichar ch = [str characterAtIndex:index];
        if (ch < 0x4E00 || ch > 0x9FFF)
        {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isEmptyOrNull:(NSString *)str
{
    return ![self notEmptyOrNull:str];
    
}

+ (BOOL)notEmptyOrNull:(NSString *)str
{
    NSString *string = str;
    if([string isKindOfClass:[NSNull class]])
        return NO;
    if ([string isKindOfClass:[NSNumber class]]) {
        if (str != nil) {
            return  YES;
        }
        return NO;
    } else {
        string=[self trimString:str];
        if (string != nil && string.length > 0 && ![string isEqualToString:@"null"]&&![string isEqualToString:@"(null)"]&&![string isEqualToString:@" "]) {
            return  YES;
        }
        return NO;
    }
}


+ (NSString*) makeNode:(NSString *)str{
    return [[NSString alloc] initWithFormat:@"<node>%@</node>", str];
}

- (NSString *)trimString:(NSString *) str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

UIColor* colorFromHexRGB(NSString *inColorString){
    
    if ([NSString isEmptyOrNull:inColorString]) {
        return nil;
    }
    
    inColorString = [inColorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if ([NSString isEmptyOrNull:inColorString]) {
        return nil;
    }
    
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

/**
 *  @author King, 15-06-16 15:06:20
 *
 *  给字符传指定区间替换成*号
 *
 *  @param range <#range description#>
 */
- (NSString *)changeStringToStar{
    if (self.length<11) {
        return self;
    }
    NSString *string = self;
    for (int i = 0; i<[self length]; i++) {
        //截取字符串中的每一个字符
        NSRange range=NSMakeRange(i, 1);
        NSString *s = [string substringWithRange:range];
        DLog(@"string is %@",s);
        if (i>2 && i<=2+4) {
            string = [string stringByReplacingCharactersInRange:range withString:@"*"];
        }
        //        if ([s isEqualToString:@"m"]) {
        //            NSRange range = NSMakeRange(i, 1);
        //            //将字符串中的“m”转化为“w”
        //            string =   [string stringByReplacingCharactersInRange:range withString:@"w"];
        //
        //        }
    }
    DLog(@"%@",self);
    return string;//[self stringByReplacingCharactersInRange:range withString:@"*"];
}

///被makeCall:执行
- (NSString*) cleanPhoneNumber:(NSString *)str
{
    NSString* number = @"";
    for (int i=0; i<str.length; i++) {
        NSString *s=[str substringWithRange:NSMakeRange(i, 1)];
        if ([s isEqualToString:@"-"]||[s isEqualToString:@"("]||[s isEqualToString:@")"]||[s isEqualToString:@" "]) {
            s = @"";
        }
        number = [number stringByAppendingString:s];
    }
    
    
    return number;
}

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
- (BOOL)chenkInputNSCharacterSetWithType:(int)type{
    NSString *typeString;
    if (type==0) {
        typeString = kAlphaNum;
    }else if (type==1){
        typeString = kAlpha;
    }else if (type==2){
        typeString = kNumbers;
    }else if(type==3){
        typeString = kNumbersPeriod;
    }else if (type==4){
        typeString = kNumbersheng;
    }
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:typeString] invertedSet];
    NSString *filtered =
    [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [self isEqualToString:filtered];
    return basic;
}

#pragma mark --过滤html文本
/**
 *  过滤html文本
 *
 *  @param html <#html description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)filterHTML:(NSString *)str
{
    NSString *html = str;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    html = [html stringByReplacingOccurrencesOfString:@"/&nbsp;/" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    //    NSString *regEx_script = @"<[\\s]*?script[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?script[\\s]*?>"; // 定义script的正则表达式{或<script[^>]*?>[\\s\\S]*?<\\/script>
    //    // }
    //    NSString *regEx_style = @"<[\\s]*?style[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?style[\\s]*?>"; // 定义style的正则表达式{或<style[^>]*?>[\\s\\S]*?<\\/style>
    //    // }
    //    NSString *regEx_html = @"<[^>]+>"; // 定义HTML标签的正则表达式
    //    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:regEx_script
    //                                                                                    options:0
    //                                                                                      error:nil];
    //    html=[regularExpretion stringByReplacingMatchesInString:html options:NSMatchingReportProgress range:NSMakeRange(0, html.length) withTemplate:@"-"];//替换所有html和换行匹配元素为"-"
    //    regularExpretion=[NSRegularExpression regularExpressionWithPattern:regEx_style
    //                                                              options:0
    //                                                                error:nil];
    //    html=[regularExpretion stringByReplacingMatchesInString:html options:NSMatchingReportProgress range:NSMakeRange(0, html.length) withTemplate:@"-"];
    //    regularExpretion=[NSRegularExpression regularExpressionWithPattern:regEx_html
    //                                                               options:0
    //                                                                 error:nil];
    //    html=[regularExpretion stringByReplacingMatchesInString:html options:NSMatchingReportProgress range:NSMakeRange(0, html.length) withTemplate:@"-"];
    //    regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"-{1,}" options:0 error:nil] ;
    //    html=[regularExpretion stringByReplacingMatchesInString:html options:NSMatchingReportProgress range:NSMakeRange(0, html.length) withTemplate:@"-"];//把多个"-"匹配为一个"-"
    
    
    return html;
}

+(NSString *)findNumFromStr:(NSString *)text
{
    
    if ([self isEmptyOrNull:text]) {
        return @"";
    }
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:text];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        if ([NSString isEmptyOrNull:tempStr]) {
            tempStr= @"";
        }
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    //     Result.
    //    int number = [numberString integerValue];
    
    return numberString;
}

+ (NSString *)removeXieGangWithJsonStr:(NSString *)jsonStr{
    NSMutableString *responseString = [NSMutableString stringWithString:jsonStr];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    [responseString stringByReplacingOccurrencesOfString:@"\'" withString:@""];
    return responseString;
}




// 显示万单位的价格
+(NSMutableAttributedString *)AttributePrice:(NSString *)string;
{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString: string];
    [AttributedStr addAttribute:NSFontAttributeName  value:[UIFont boldSystemFontOfSize:14.0]  range:NSMakeRange(string.length-1, 1)];
    return AttributedStr;
}




+(NSString*)urlEncode:(id<NSObject>)value
{
    //make sure param is a string
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [(NSNumber*)value stringValue];
    }
    
    NSAssert([value isKindOfClass:[NSString class]], @"request parameters can be only of NSString or NSNumber classes. '%@' is of class %@.", value, [value class]);
    
    return [(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (__bridge CFStringRef) value,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8)) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

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
+ (NSString *)urlEncodeWith:(NSString *)string {
    //解决因特殊符号而提交异常的情况
    return (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                         (CFStringRef)string,
                                                                         NULL,
                                                                         CFSTR(":/?#[]@!$&’()*+,;="),
                                                                         kCFStringEncodingUTF8);
}

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
+ (NSString *)areaStringWithFromat:(NSString *)areaValue{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithDouble:[areaValue doubleValue]]];
    DLog(@"Formattednumber string:%@",string);
    return string;
}

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
+ (NSString *)formatBankCardNumber:(NSString *)cardNum {
    if (cardNum.length<16) {
        return cardNum;
    }
    NSNumber *number = @([cardNum longLongValue]);
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setGroupingSize:4];
    [formatter setGroupingSeparator:@" "];
    return [formatter stringFromNumber:number];
}

#pragma mark --格式化金额，千分位
/*!
 *  @author liujinliang, 16-12-28 14:12:49
 *
 *  @brief 格式化金额，千分位
 *
 enum{
 
 NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle,123456789
 
 NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle, 123,456,789
 
 NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle, ￥123,456,789.00
 
 NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle, -539,222,988%
 
 NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle, 1.23456789E8
 
 NSNumberFormatterSpellOutStyle = kCFNumberFormatterSpellOutStyle, 一亿二千三百四十五万六千七百八十九
 
 };
 
 *
 *  @param num <#num description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#1.1.0#>
 */
+ (NSString *)formatMoneyWithNum:(double)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00;"];
    formatter.numberStyle =NSNumberFormatterDecimalStyle;
    
    NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithDouble:num]];
    return newAmount;
}

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
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font attributes:(NSDictionary *)attributes {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        if (!attributes || attributes.count<1) {
            attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        }
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        expectedLabelSize = [self sizeWithFont:font
                             constrainedToSize:size
                                 lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

@end
