//
//  Macro.h
//  ZiChanBao
//
//  Created by liujinliang on 15/6/11.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <arpa/inet.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"

#import "AFNetworkReachabilityManager.h"


// 指向自身的弱指针
#define kWEAKSELF __weak typeof(self) weakSelf = self;
// 应用程序托管
#define kAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#pragma mark - 打印到控制台
#if DEBUG
#define DLog(FORMAT, ...) fprintf(stderr,"\%s [第%d行] %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(FORMAT, ...)
#endif

// 全局通知
#define kNotificationDidSwitchCity @"kNotificationDidSwitchCity"

#pragma mark ------------------------------其他简化操作------------------------------

#define kURLFromString(url) [NSURL URLWithString:url]
#define kIntegerToString(value) [NSString stringWithFormat:@"%ld",(long)value]
#define kURLFromString(url) [NSURL URLWithString:url]
#define kDoubleToString(double) [NSString stringWithFormat:@"%.2f",double]
#define kIntToString(int) [NSString stringWithFormat:@"%@",@(int)]
#define kFloatToString(float) [NSString stringWithFormat:@"%.0f",float]
#define kObjToString(obj) [NSString stringWithFormat:@"%@",obj]


#define kOpenURL(url) [[UIApplication sharedApplication] openURL:kURLFromString(url)]

//判断是否 Retina屏
#define kScaleValue [UIScreen mainScreen].scale//大于1时为retina屏幕
#define kIS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale >1.0))//(kScaleValue>1)//

//导航栏各个高度
#define kStatusHeight [MainNavigationController statusHeight]//状态栏高度
#define kNavHeight [MainNavigationController navHeight]//导航栏高度
#define kNavStatusHeight [MainNavigationController navStatusHeight]//导航栏和状态栏高度
#define kNavViewHeight self.navigationController.view.bottom// [MainNavigationController navViewHeight]//全高度

#define kKeyWindow [[UIApplication sharedApplication] keyWindow]
#define kViewWithTag(view,tag) [view viewWithTag:tag]

#pragma mark ----------------------视图Frame----------------------
#define kSize(w,h) (CGSize)(w,h)
#define kPoint(x,y) (Point)(x,y)
#define kViewWidth(v)                        v.frame.size.width
#define kViewHeight(v)                       v.frame.size.height
#define kViewX(v)                            v.frame.origin.x
#define kViewY(v)                            v.frame.origin.y
#define kSelfViewHeight                      self.view.bounds.size.height
#define kRectX(f)                            f.origin.x
#define kRectY(f)                            f.origin.y
#define kRectWidth(f)                        f.size.width
#define kRectHeight(f)                       f.size.height
#define kRectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define kRectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define kRectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define kRectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define kRectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define kRectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define kRect(x, y, w, h)                    CGRectMake(x, y, w, h)
//status栏高度
#define kWindowStatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
//ToolBar高度
#define kNavVCBarHeight            self.navigationController.navigationBar.frame.size.height
//status栏和ToolBar高度
#define kNavVCViewAndStatusHeight CGRectGetMaxY(self.navigationController.navigationBar.frame)
//NavVC的整体高度
#define kNavVCViewMaxY CGRectGetMaxY(self.navigationController.view.frame)

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)



#define kWindow [UIApplication sharedApplication].keyWindow

#define kPushNav(pushView,bool) [self.navigationController pushViewController:pushView animated:bool]
#define kPresentNav(pushView,bool) [self.navigationController presentViewController:pushView animated:bool completion:nil]


#pragma mark ---------------------字体设置-------------

#define kFont(px) [UIFont systemFontOfSize:(px) / 2.0]
#define kFontB(px) [UIFont boldSystemFontOfSize:(px) / 2.0]

#pragma mark ----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define kCOLOR_RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define kCOLOR_RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define kBACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

//清除背景色
#define kCOLOR_CLEARCOLOR [UIColor clearColor]
#define kCOLOR_WHITE [UIColor whiteColor]
#define kCOLOR_BLACK [UIColor blackColor]


#pragma mark ----------------------文件目录-------------------------
//程序运行临时文件目录
#define APP_TMPPATH NSTemporaryDirectory()
//app文件根目录
#define APP_DOCPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]

#pragma mark ----------------------图片----------------------------

//默认图
//定义UIImage对象
#define kIMAGE(pic) [UIImage imageNamed:pic]//[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:type]]
//读取本地图片
#define kLOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]

//定义UIImage对象
//#define kIMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define kImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,性能高于后者
/**
 *  @author King, 15-05-07 15:05:09
 *
 *  显示图片:
 *  UIImage 加载图片使用“[UIImage imageNamed:@"xxx.png"]时，系统会把图像Cache到内存。如果图像比较大，或者图像比较多，用这种方式会消耗很大的内存，而且释放图像的内存是一件相对来说比较麻烦的事情。例如：如果利用imageNamed的方式加载图像到一个动态数组，然后将将数组赋予一个UIView的对象的进行逐帧动画
 *
 *  @param imageName <#imageName description#>
 *
 *  @return <#return value description#>
 */
#define kImageName(imageName) [UIImage imageNamed:imageName]//kIS_RETINA?[UIImage imageWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@@%@x.png",imageName,@(kScaleValue)]]] CGImage] scale:kScaleValue orientation:UIImageOrientationUp]:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@.png",imageName]]

#pragma mark --UIColor 转UIImage
/**
 *  UIColor 转UIImage
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
static inline UIImage* kChangeUIColorToUIImage(UIColor *color){
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark --UIImage 转 UIColor
/**
 *  UIImage 转 UIColor
 *
 *  @param image image description
 *
 *  @return <#return value description#>
 */
static inline UIColor* kChangeUIImageToUIColor(UIImage *image){
    return [UIColor colorWithPatternImage:image];
}

#pragma mark --UIView转UIImage
/**
 *  UIView转UIImage
 *
 *  @param v <#v description#>
 *
 *  @return <#return value description#>
 */
static inline UIImage* kChangeUIViewToUIImage(UIView *view){

    //    UIGraphicsBeginImageContext(v.bounds.size);
    //
    //    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    //
    //    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    //
    //    UIGraphicsEndImageContext();
    //
    //    return image;
    CGSize size = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma  mark --设置正圆图像
/*!
 *  @author LiuJinliang, 15-12-01 09:12:54
 *
 *  @brief  设置正圆图像
 *
 *  @param imgView     <#imgView description#>
 *  @param borderWidth <#borderWidth description#>
 *  @param borderColor <#borderColor description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline UIImageView *setCircleImageView(UIImageView *imgView, NSInteger borderWidth, UIColor *borderColor) {
    [imgView.layer setCornerRadius:CGRectGetHeight([imgView bounds]) / 2];
    imgView.layer.masksToBounds = YES;
    imgView.layer.borderWidth = borderWidth;
    imgView.layer.borderColor = [borderColor CGColor];
    return imgView;
}

#pragma mark --是否为图片
/*!
 *  @author liujinliang, 16-04-13 16:04:35
 *
 *  @brief 是否为图片
 *
 *  @param imageName <#imageName description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#1.0#>
 */
CG_INLINE  bool kIsImage(NSString *imageName){
    if ([imageName rangeOfString:@"png"].location!=NSNotFound||[imageName rangeOfString:@"jpg"].location!=NSNotFound)
        return YES;
    return NO;
}

#pragma mark ---------------------系统方法
///被makeCall:执行
static inline NSString* kCleanPhoneNumber(NSString *phoneNumber)
{
    NSString* number = [NSString stringWithString:phoneNumber];
    NSString* number1 = [[[[number stringByReplacingOccurrencesOfString:@" " withString:@""]
            //                        stringByReplacingOccurrencesOfString:@"-" withString:@""]
            stringByReplacingOccurrencesOfString:@"(" withString:@""]
            stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];

    return number1;
}

static inline void kMakeCallWithPhone(NSString *phone, UIView *view)
{
//    NSString* numberAfterClear = kCleanPhoneNumber(phone);
    NSString* numberAfterClear = kCleanPhoneNumber(phone);
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",numberAfterClear];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numberAfterClear]];
//    //NSLog(@"make call, URL=%@", phoneNumberURL);
//
//    UIWebView*callWebview =[[UIWebView alloc] init];
//
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    //记得添加到view上
//    [view addSubview:callWebview];
}

#pragma mark----------------------App版本Version--------------------------
#define BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BUILD_COUNT [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleGetInfoString"]
#define APPNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define ChANNELID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"ChannelID"]

//版本类型
#define APPIDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

//是否是AppStore版
#define isAppStore [APPIDENTIFIER isEqual:@"com.liujinliangZiChanBao"]
#define kIsIOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)


/*-------判断对象相应的类型--------*/
#define kISKIND_OF_CLASS_NSDICTIONARY(VALUE) [VALUE isKindOfClass:[NSDictionary class]]
#define kISKIND_OF_CLASS_NSARRAY(VALUE) [VALUE isKindOfClass:[NSArray class]]
#define kISKIND_OF_CLASS_NSSTRING(VALUE) [VALUE isKindOfClass:[NSString class]]
#define kISKIND_OF_CLASS_NSNUMBER(VALUE) [VALUE isKindOfClass:[NSNumber class]]

//NSUserDefaults 实例化
#define kUSER_DEFAULT  [NSUserDefaults standardUserDefaults]
//根据VALUE、KEY存取对象
#define kSetObjectForKey(VALUE,KEY) [kUSER_DEFAULT addUnEmptyString:VALUE forKey:KEY]
#define kGetObjectForKey(KEY) ([[NSUserDefaults standardUserDefaults] objectForKey:(KEY)] ?: @"")

#pragma mark - 打印到控制台
#if DEBUG
#define DLog(FORMAT, ...) fprintf(stderr,"\%s [第%d行] %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(FORMAT, ...)
#endif

#pragma mark - 常量
#pragma mark key
// 百度地图
#define kBaiduMapKey @"YB0mTXzVsPiIo4E1OXsbDtfy"

#pragma mark 数值
#define kMaxPadding(px) (px /2)
// 页面左右边距
#define kMargin (30 / 2.0)

#define kPadding 10
#define kPadding_left (20/2.0)
#define kPadding_bottom (20/2.0)
#define kPadding_top (20 / 2.0)
#define kPadding_right (16 / 2.0)

#pragma mark 取值



//单例化一个类
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}




#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#pragma mark - Tools methods

#pragma mark --判断一个对象是否为空
/**
 *  判断一个对象是否为空
 *
 *  @param thing 对象
 *
 *  @return 返回结果
 */
static inline BOOL kIsObjectEmpty(id thing){
    return thing == nil ||
            ([thing isEqual:[NSNull null]]) ||
            ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
            ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

#pragma mark --判断一个字符串是否为空
/**
 *  判断一个字符串是否为空
 *
 *  @param string 字符串
 *
 *  @return 返回结果
 */
static inline BOOL kIsStringEmpty(NSString *string){
    if (!kISKIND_OF_CLASS_NSSTRING(string)) {
        return YES;
    }
    if (string == nil) {
        return YES;
    }

    if (string.length == 0) {
        return YES;
    }

    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }

    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }

    return NO;
}

#pragma mark --判断是否为中文
/*!
 *  @author liujinliangcom.cn, 15-10-20 17:10:10
 *
 *  @brief  判断是否为中文
 *
 *  @param string <#string description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline BOOL kIsChinese(NSString *string)
{
    if (!string || [string length] == 0)
    {
        return NO;
    }
    for(int i=0; i< [string length];i++){
        int a = [string characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;

}

#pragma mark --解决请求api时因特殊字符引起的提交异常问题，如资产宝提交 1+1数据时，+号被置为空格
/*!
 *  @author liujinliang, 16-02-16 16:02:27
 *
 *  @brief  解决请求api时因特殊字符引起的提交异常问题，如资产宝提交 1+1数据时，+号被置为空格
 *
 *  @param dString <#dString description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline NSString* encodeURL(NSString* dString ) {
    NSString* escapedUrlString= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)dString, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));

    escapedUrlString = [escapedUrlString stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    return escapedUrlString;
}

#pragma mark --检查是否为手机
/*!
 *  @author liujinliangcom.cn, 15-10-20 17:10:04
 *
 *  @brief  检查是否为手机
 *
 *  @param phone <#phone description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline BOOL kIsMobilePhone(NSString *phone)
{
    if (!phone || [phone length] == 0)
    {
        return NO;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1+[0-9]+\\d{9}";//@"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:phone] == YES)
            || ([regextestcm evaluateWithObject:phone] == YES)
            || ([regextestct evaluateWithObject:phone] == YES)
            || ([regextestcu evaluateWithObject:phone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark --检查是否为Email
/*!
 *  @author liujinliangcom.cn, 15-10-20 17:10:19
 *
 *  @brief  检查是否为Email
 *
 *  @param email <#email description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline BOOL kIsEmail(NSString *email)
{
    if (!email || [email length] == 0)
    {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark --检查是否为金额
/*!
 *  @author liujinliangcom.cn, 15-10-20 17:10:00
 *
 *  @brief  检查是否为金额
 *
 *  @param price <#price description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline BOOL kIsPrice(NSString *price)
{
    if (!price || [price length] == 0)
    {
        return NO;
    }
    NSString *priceRegex = @"^(([0-9]|([1-9][0-9]{0,9}))((\\.[0-9]{1,2})?))$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", priceRegex];
    return [emailTest evaluateWithObject:price];
}

#pragma mark --检查是否为邮政编码
/*!
 *  @author liujinliangcom.cn, 15-10-20 17:10:53
 *
 *  @brief  检查是否为邮政编码
 *
 *  @param code <#code description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline BOOL kIsZipCode(NSString *code)
{
    if (!code || [code length] == 0)
    {
        return NO;
    }
    NSString *zipCodeRegex = @"[1-9]d{5}(?!d)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipCodeRegex];
    return [emailTest evaluateWithObject:code];
}

#pragma mark --检查是否为身份证号
/*!
 *  @author liujinliangcom.cn, 15-10-20 17:10:10
 *
 *  @brief  检查是否为身份证号
 *
 *  @param ident <#ident description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline BOOL kIsIdentity(NSString *ident)
{
    if (!ident || [ident length] == 0)
    {
        return NO;
    }
    NSString *identityRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",identityRegex];
    return [identityCardPredicate evaluateWithObject:ident];
}

#pragma mark --银行卡格式
/*!
 *  @author liujinliang, 15-12-18 13:12:18
 *
 *  @brief 银行卡格式
 *
 *  @param cardNum <#cardNum description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline NSString *kBankCardFormat(long cardNum)
{
    NSNumber *number = [NSNumber numberWithLongLong:cardNum];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setGroupingSize:4];
    [formatter setGroupingSeparator:@" "];
    NSString *string = [formatter stringFromNumber:number];
    return string;
}

#pragma mark --检查是否为姓名
/*!
 *  @author liujinliangcom.cn, 15-10-20 17:10:04
 *
 *  @brief  检查是否为姓名
 *
 *  @param name <#name description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline BOOL kIsSingleName(NSString *name)
{
    if (!name || [name length] == 0)
    {
        return NO;
    }
    NSString *singleRegex = @"^([\u4e00-\u9fa5]+|([a-zA-Z]+\\s?)+)$";
    NSPredicate *singleCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",singleRegex];
    return [singleCardPredicate evaluateWithObject:name];
}

#pragma mark --检查是否密码正确
/*!
 *  @author liujinliangcom.cn, 15-10-20 17:10:16
 *
 *  @brief  检查是否密码正确
 *
 *  @param pwd <#pwd description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline BOOL kIsPassword(NSString *pwd)
{
    if (!pwd || [pwd length] == 0)
    {
        return NO;
    }
    NSString *singleRegex = @"^[\\@A-Za-z0-9\\!\\#\\$\\%\\^\\&\\*\\.\\~]{6,22}$";
    NSPredicate *singleCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",singleRegex];
    return [singleCardPredicate evaluateWithObject:pwd];
}

#pragma mark --过滤html文本
/*!
 *  @author liujinliangcom.cn, 15-10-20 17:10:00
 *
 *  @brief  过滤html文本
 *
 *  @param html <#html description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline NSString * kFormatHtmlContent(NSString *html)
{
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
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

#pragma mark --获取MD5
/*!
 *  @author liujinliangcom.cn, 15-10-20 17:10:29
 *
 *  @brief  获取MD5
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
static inline NSString * kGetMD5Value(NSString *key)
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);

    //    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
    //                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r['a'], r['b'], r['c'], r['d'], r['e'], r['f']];
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                                    r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return filename;
}

#pragma mark --设置导航栏标题，左右按钮及事件回调
/*!
 *  @author liujinliang, 16-04-11 10:04:29
 *
 *  @brief 设置导航栏标题，左右按钮及事件回调
 *
 *  @param title       标题
 *  @param left        左边按钮
 *  @param leftAction  左边事件回调
 *  @param right       右边
 *  @param rightAction 右边事件回调
 *
 *  @return void
 *
 *  @since <#1.0#>
 */
CG_INLINE void kNAV_INIT(UIViewController *vc, NSString * title,NSString *left,SEL leftAction ,NSString * right, SEL rightAction){
    UIViewController *currentBC = vc;
    //Ios7 在自定义leftBarButtonItem情况下的右滑返回问题
//    if (currentBC) {
//        currentBC.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)currentBC;
//    }
    if(!kIsStringEmpty(left)){
        /*导航栏左边控件*/
//        [currentBC.navigationItem setHidesBackButton:YES];
        UIButton  *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(kIsImage(left)){
            [leftBtn setImage:kImageName(left) forState:UIControlStateNormal];
        } else{
            [leftBtn setTitle:left forState:UIControlStateNormal];
            [[leftBtn titleLabel] setFont:kFont(28)];
            [leftBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        }
        [leftBtn addTarget:currentBC action:leftAction forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        currentBC.navigationItem.leftBarButtonItem = leftItem;
    }
    if(!kIsStringEmpty(right)){
        /*导航栏右边控件*/
        UIImage *search = kIMAGE(right);
        UIButton  *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [rightBtn setFrame:(CGRect){0,0,50,20}];
        if(kIsImage(right)){
            [rightBtn setImage:search forState:UIControlStateNormal];
        } else{
            [rightBtn setTitle:right forState:UIControlStateNormal];
            [[rightBtn titleLabel] setFont:[UIFont fontContent]];
            [rightBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        }
        [rightBtn setTintColor:[UIColor mainSecondColor]];
        [rightBtn addTarget:currentBC action:rightAction forControlEvents:UIControlEventTouchUpInside];
        [rightBtn sizeToFit];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

        currentBC.navigationItem.rightBarButtonItem = rightItem;
    }
    if(!kIsStringEmpty(title)){
        /*导航栏*/
        if(kIsImage(right)){

            UIImageView *logoImgV = [[UIImageView alloc] initWithImage:kIMAGE(title)];
            [logoImgV setContentMode:UIViewContentModeCenter];
            currentBC.navigationItem.titleView = logoImgV;
            [logoImgV sizeToFit];
        } else{
            currentBC.title = title;
        }
    }
}
#pragma mark --只设置导航栏标题
/*!
 *  @author liujinliang, 16-04-11 10:04:56
 *
 *  @brief 只设置导航栏标题
 *
 *  @param title 标题
 *
 *  @return void
 *
 *  @since <#1.0#>
 */
CG_INLINE void kNAV_INIT_TITLE(UIViewController *vc, NSString *title){
    kNAV_INIT(vc,title,nil,nil,nil,nil);
}

#pragma mark --设置标题和导航栏左边的按钮
/*!
 *  @author liujinliang, 16-04-11 10:04:12
 *
 *  @brief 设置标题和导航栏左边的按钮
 *
 *  @param title      标题
 *  @param left       按钮名称或图片名称
 *  @param leftAction 回调事件
 *
 *  @return void
 *
 *  @since <#1.0#>
 */
CG_INLINE void kNAV_INIT_TITLEWIHTLEFT(UIViewController *vc, NSString *title,NSString *left,SEL leftAction){
    kNAV_INIT(vc,title,left,leftAction,nil,nil);
}

#pragma mark --设置标题和导航栏右边的按钮
/*!
 *  @author liujinliang, 16-04-11 10:04:12
 *
 *  @brief 设置标题和导航栏右边的按钮
 *
 *  @param title       标题
 *  @param right       按钮名称或图片名称
 *  @param rightAction 回调事件
 *
 *  @return void
 *
 *  @since <#1.0#>
 */
CG_INLINE void kNAV_INIT_TITLEWIHTRIGHT(UIViewController *vc, NSString *title,NSString *right,SEL rightAction){
    kNAV_INIT(vc,title,nil,nil,right,rightAction);
}

#pragma mark --------------------网络-------------------------------------
#define kNetworkNotReachability ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0)  //无网
CG_INLINE BOOL kNetworkReachabilityState(NSString *statusStr) {
//#pragma mark - 网络状态的实时检测；
//- (BOOL)isNetWorkReachable{

//    __block CGRect rect = _nonNetworkLabel.frame; //这里的声明前面加__block，作用是在块里可以修改rect的值；
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
//                rect.origin.y = footView.frame.origin.y - KNETWORK_LAB_HEIGHT;
//                statusStr = @"unknow";
                DLog(@"网络不通");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
//                rect.origin.y = footView.frame.origin.y + footView.frame.size.height;
//                statusStr = @"wifi";
                DLog(@"网络通过WIFI连接");
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
//                rect.origin.y = footView.frame.origin.y + footView.frame.size.height;
//                statusStr = @"mobile";
                DLog(@"网络通过无线连接");
                break;
            }
            default:
                break;
        }
        
//        _nonNetworkLabel.frame = rect;
        DLog(@"网络状态数字返回：%li", (long)status)
        AFStringFromNetworkReachabilityStatus(status);
        DLog(@"网络状态返回: %@", statusStr);
        
    }];
    
    
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}



//- (void)afNetworkStatusChanged:(NSNotification *)notifi{
//
//    NSLog(@"打印网络状态：%@", notifi);
//}


#pragma mark --------------------文件处理-------------------------------------
CG_INLINE NSString *kDocumentPath(){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    DLog(@"documentsDirectory:%@",documentsDirectory);
    return documentsDirectory;
}

#pragma mark ------------------------------系统配置------------------------------------------
#define _XX(A, B) _X(([NSString stringWithFormat:@"%@_c", A]), B)
CG_INLINE NSString * kStringFormat(NSString *format1,NSString *format2){
    return [NSString stringWithFormat:@"%@%@",format1,format2];
}

#pragma mark --------------------字体设置-------------------------------------
//#define kFont(px) [UIFont systemFontOfSize:px/2]//kPt(px)]
#define kFont_Bold(px) [UIFont boldSystemFontOfSize:px/2]


#pragma mark --StoryBoard----------------------------------------------------
#pragma mark --获取storyBoard——Mian面板
/*!
 *  @author liujinliang, 16-09-30 21:09:54
 *
 *  @brief 获取storyBoard——Mian面板
 *
 *  @return <#return value description#>
 *
 *  @since <#1.0#>
 */
CG_INLINE UIStoryboard *kMainStoryBoard(){
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return story;
}

CG_INLINE NSString *kSYS_NETADDRESS() {
    struct ifaddrs* addrs = NULL;
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    
    BOOL success = (getifaddrs(&addrs) == 0);
    if (success)
    {
        const struct ifaddrs* cursor = addrs;
        while (cursor != NULL)
        {
            NSMutableString* ip;
            if (cursor->ifa_addr->sa_family == AF_INET)
            {
                const struct sockaddr_in* dlAddr = (const struct sockaddr_in*)cursor->ifa_addr;
                const uint8_t* base = (const uint8_t*)&dlAddr->sin_addr;
                ip = [NSMutableString stringWithCapacity:0];
                for (int i = 0; i < 4; i++)
                {
                    if (i != 0)
                        [ip appendFormat:@"."];
                    [ip appendFormat:@"%d", base[i]];
                }
                [result setObject:(NSString*)ip forKey:[NSString stringWithFormat:@"%s", cursor->ifa_name]];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    NSString* localIP = [result objectForKey:@"en0"];
    if (!localIP)
    {
        localIP = [result objectForKey:@"en1"];
    }
    if (!localIP)
    {
        localIP = @"0.0.0.0";
    }
    
    return localIP;
}
#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//----------------------手机设备类型----------------------------
#define MOBILEPHONTTYPE @"I"

//设备屏幕高度
#ifndef UIScreenHeight
#define UIScreenHeight   [UIScreen mainScreen].bounds.size.height
#endif

//设备屏幕宽度
#ifndef UIScreenWidth
#define UIScreenWidth    [UIScreen mainScreen].bounds.size.width
#endif
