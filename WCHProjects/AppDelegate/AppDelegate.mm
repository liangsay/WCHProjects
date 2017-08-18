//
//  AppDelegate.m
//  WCHProjects
//
//  Created by liujinliang on 16/9/19.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "AppDelegate.h"
#import "JRSwizzle.h"
#import "NSDictionary+Unicode.h"
#import "MineViewController.h"
#import "MainViewController.h"

#import "IQKeyboardManager.h"

#import "UIView+TYLaunchAnimation.h"
#import "UIImage+TYLaunchImage.h"
#import "UIImageView+WebCache.h"
#import "TYLaunchFadeScaleAnimation.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import <UMMobClick/MobClick.h>
#import <UMSocialCore/UMSocialManager.h>
#import "MainNavigationViewController.h"
#import "StoretoLocObj.h"
@interface AppDelegate ()<WXApiDelegate>

@end
static AppDelegate *appDelegate = nil;
static NSString *kLaunchImgUrl = @"kLaunchImgUrl";
static NSString *kLaunchImg = @"kLaunchImg";
@implementation AppDelegate
+ (AppDelegate *)delegate{
    
    return appDelegate;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *apiBase = kGetObjectForKey(@"apiBaseURLString");
    if(kIsObjectEmpty(apiBase)==NO){
    }else{
        kSetObjectForKey(@"http://www.66wch.com.cn", @"apiBaseURLString");
    }
    [UserInfoObj sendAppToAccess];
    
    
    [DLNavigationTransition enableNavigationTransitionWithPanGestureBack];
    // Override point for customization after application launch.
    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
    [self sendAdgetLatest];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UMConfigInstance.appKey = @"57dff57e67e58e2a52003099";
    UMConfigInstance.channelId = @"AppStore";
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMConfigInstance.appKey];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];

    [MobClick startWithConfigure:UMConfigInstance];
    
    
#if DEBUG
    [MobClick setLogEnabled:YES];
#endif
    
    [self setupBaiDuMapServer];
    [self setupIQKeyboardManager];
    
    
    //开启启动广告
    [self setupStartLaunchAnimation];
    [self checkLoginStateWithShowVC];
    
    //开启定位服务
    [[LocationServer shared] setupLocationServiceWithComplete:^(OrderInfoObj *oderObj) {
        DLog(@"定位结果oderObj:%@-%@",oderObj.provincef,oderObj.cityf);

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params addUnEmptyString:oderObj.cityf forKey:@"vo.cityf"];
        [params addUnEmptyString:oderObj.provincef forKey:@"vo.provincef"];
        [StoretoLocObj sendStoretoLocWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
            StoretoLocObj *obj = response.responseModel;
            if (obj) {
                [obj cache];
            }else{
                [StoretoLocObj clear];
            }
        } failedBlock:^(HttpRequest *request, HttpResponse *response) {
            [StoretoLocObj clear];
        }];
    }];
    
    //向微信注册appid.
    //Description :  更新后的api 没有什么作用,只是给开发者一种解释作用.
    [WXApi registerApp:kWXAppId() withDescription:@"微信支付"];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    
    
}

#pragma mark --主控制器视图
/*!
 *  @author liujinliang, 16-09-13 15:09:49
 *
 *  @brief 主控制器视图
 *
 *  @return <#return value description#>
 *
 *  @since <#1.0#>
 */
- (void)loadTabBarController {
    _tabBarVC = nil;
    _tabBarVC = [[MainTabBarViewController alloc] init];
    self.window.rootViewController = _tabBarVC;
    [self.window makeKeyAndVisible];
}

//- (void)logonMethod {
//    WEAKSELF
//    self.loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    self.loginVC.loginAction = ^(NSInteger index) {
//        [weakSelf loadTabBarController];
//    };
//    self.window.rootViewController = self.loginVC;
//    [self.window makeKeyAndVisible];
//}


#pragma mark --启动百度地图服务
/*!
 *  @author liujinliang, 16-09-20 00:09:39
 *
 *  @brief 启动百度地图服务
 *
 *  @since <#1.0#>
 */
- (void)setupBaiDuMapServer{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:kBaiDuMapKey()  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark --用于查询最新的广告图
- (void)sendAdgetLatest {
    
    [BannerInfoObj sendAdgetLatestWithParameters:[NSMutableDictionary dictionary] successBlock:^(HttpRequest *request, HttpResponse *response) {
        NSString *launchImgUrl = [NSString stringWithFormat:@"%@/upimages/%@",apiBaseURLString(),response.result];
        kSetObjectForKey(launchImgUrl, kLaunchImgUrl);
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        NSString *launchImgUrl = [NSString stringWithFormat:@"%@/upimages/%@",apiBaseURLString(),response.result];
        kSetObjectForKey(launchImgUrl, kLaunchImgUrl);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIApplication*  app =[UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    
    bgTask= [app beginBackgroundTaskWithExpirationHandler:^{
        
        dispatch_async(dispatch_get_main_queue(),^{if(bgTask !=UIBackgroundTaskInvalid)
            
        {
            
            bgTask=UIBackgroundTaskInvalid;
            
        }
            
        });
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        dispatch_async(dispatch_get_main_queue(),^{if(bgTask !=UIBackgroundTaskInvalid)
            
        {
            
            bgTask=UIBackgroundTaskInvalid;
            
        }
            
        });
        
    });
    
    
        
        
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




#pragma mark --登录页面

#pragma mark --检查是否登陆，没有则直接进入登陆界面
/*!
 *  @author liujinliang, 16-10-02 07:10:05
 *
 *  @brief 检查是否登陆，没有则直接进入登陆界面
 *
 *  @since <#1.0#>
 */
- (void)checkLoginStateWithShowVC {
    if (![UserInfoObj model]) {
        [self showLoginVCWithLoginAction:^(NSInteger index) {
            
        }];
    }else{
        [self loadTabBarController];
    }
}
/**
 *  登陆页面
 */
- (void)showLoginVCWithLoginAction:(LoginVCAction)loginAction{
    WEAKSELF
    [self setupLoginViewControllerWithNotification:nil loginAction:^(NSInteger index) {
        [weakSelf loadTabBarController];
    }];
}

- (void)setupLoginViewControllerWithNotification:(NSNotification *)noti{
    WEAKSELF
    [self setupLoginViewControllerWithNotification:noti loginAction:^(NSInteger index) {
        [weakSelf loadTabBarController];
    }];
}
/*!
 *  @author worldunion.com.cn, 16-09-28 14:09:21
 *
 *  @brief 登录页面
 *
 *  @param noti <#noti description#>
 *
 *  @since <#1.0#>
 */
- (void)setupLoginViewControllerWithNotification:(NSNotification *)noti loginAction:(LoginVCAction)loginAction{
    if (self.callCarVC) {
        [self.callCarVC cancelTimer];
    }
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginVC.loginAction = loginAction;
    
    MainNavigationViewController *nav = [[MainNavigationViewController alloc] initWithRootViewController:loginVC];
    [nav setNavigationBarHidden:YES];
//    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    self.window.rootViewController = nav;
    
    NSLog(@"重新登录");
    
}

#pragma mark --开启启动广告
/*!
 *  @author liujinliang, 16-10-03 06:10:20
 *
 *  @brief 开启启动广告
 *
 *  @since <#1.0#>
 */
- (void)setupStartLaunchAnimation{
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage ty_getLaunchImage]];
    imageView.backgroundColor = [UIColor whiteColor];
    NSString *url = kGetObjectForKey(kLaunchImgUrl);
    if (kISKIND_OF_CLASS_NSSTRING(url) && url.length) {
        [imageView sd_setImageWithURL:kURLFromString(url)];
    }
    imageView.userInteractionEnabled = YES;
    [imageView showInWindowWithAnimation:[TYLaunchFadeScaleAnimation fadeScaleAnimation] completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        NSLog(@"finished");
        
    }];
}


- (void)setupIQKeyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;//这个是它自带键盘工具条开关
    //控制整个功能是否启用。
//    manager.enable = YES;
//    //控制点击背景是否收起键盘
//    manager.shouldResignOnTouchOutside = YES;
//    //控制键盘上的工具条文字颜色是否用户自定义。  注意这个颜色是指textfile的tintcolor
//    manager.shouldToolbarUsesTextFieldTintColor = YES;
//    //中间位置是否显示占位文字
//    manager.shouldShowTextFieldPlaceholder = YES;
//    //设置占位文字的字体
//    manager.placeholderFont = [UIFont boldSystemFontOfSize:14];
//    //控制是否显示键盘上的工具条。
//    manager.enableAutoToolbar = YES;
    //某个类中禁止使用工具条
//    [[IQKeyboardManager sharedManager]disableToolbarInViewControllerClass:[UIViewController class]];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString *host = url.host;
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }else if ([host isEqualToString:@"pay"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }else{
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        if (!result) {
            // 其他如支付等SDK的回调
        }
        return result;
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSString *host = url.host;
    if ([host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSString *resultStatus = resultDic[@"resultStatus"];
            if ([resultStatus isEqualToString:@"6001"]) {
                [NSString toast:@"您取消了支付操作"];
            }else if ([resultStatus isEqualToString:@"9000"]){
                [NSString toast:@"支付成功"];
            }
            DLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
//        return YES;
    }else if ([host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
        if (!result) {
            // 其他如支付等SDK的回调
        }
        return result;
    }
    return YES;
}

#pragma mark --微信支付
#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                DLog(@"支付成功");
                [kNotificationCenter() postNotificationName:kNotificationWXPayStatus() object:@"1"];
                if (self.payType==1) {
                    [NSString toast:@"微信充值成功"];
                }else{
                    [NSString toast:@"微信支付成功"];
                }
                break;
            default:
                DLog(@"支付失败，retcode=%d",resp.errCode);
                [kNotificationCenter() postNotificationName:kNotificationWXPayStatus() object:@"0"];
                if (self.payType==1) {
                    [NSString toast:@"微信充值失败"];
                }else{
                    [NSString toast:@"微信支付失败"];
                }
                break;
        }
    }
}
@end
