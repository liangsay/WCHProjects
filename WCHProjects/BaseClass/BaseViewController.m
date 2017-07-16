//
//  BaseViewController.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationItem setHidesBackButton:YES];
    NSString *className =NSStringFromClass(self.class);//[[self.navigationController.viewControllers lastObject] class];
    kAppDelegate.currentViewController = self;
    DLog(@"进入：UITableViewController:%@",className);
    //    [[BaiduMobStat defaultStat] pageviewStartWithName:className];
    DLog(@"kScaleValue:%f",kScaleValue);
    //    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
//    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *className =NSStringFromClass(self.class);
    DLog(@"退出：UITableViewController:%@",className);
    //    [[BaiduMobStat defaultStat] pageviewEndWithName:className];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.width = kScreenWidth;
    // Do any additional setup after loading the view.
//    [self.navigationItem setHidesBackButton:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor backgroundColor];
    kAppDelegate.currentViewController = self;
    
    NSInteger n = [self.navigationController.childViewControllers count];
    if (n>1)
    {
        [self setupBackButton];
    }
    
    
}

//-(void)loadView
//{
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.view = scrollView;
//}

- (void)dealloc
{
    [kNotificationCenter() removeObserver:self];
}

#pragma mark - Life Cycle

- (CGFloat)statusHeight
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (CGFloat)navHeight
{
    UINavigationController *nav = [self currentNavigationController];
    return nav.navigationBar.frame.size.height;
}

- (CGFloat)navStatusHeight
{
    UINavigationController *nav = [self currentNavigationController];
    return CGRectGetMaxY(nav.navigationBar.frame);
}

- (CGFloat)navViewHeight
{
    UINavigationController *nav = [self currentNavigationController];
    return CGRectGetMaxY(nav.view.frame);
}

- (CGFloat)tabViewHeight
{
    return self.tabBarController.tabBar.height;
}
#pragma mark - 取当前控制器
- (UINavigationController *)currentNavigationController
{
    //    AppDelegate *dlg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return self.navigationController;//(UINavigationController *)dlg.tabBarController.selectedViewController;
}


#pragma mark --设置导航栏的标题、右边的对象,
/*!
 *  @author liujinliang, 16-01-08 10:01:00
 *
 *  @brief 设置导航栏的标题、右边的对象
 *
 *  @param logoName    <#logoName description#>
 *  @param navTitle    <#navTitle description#>
 *  @param right       <#right description#>
 *  @param rightAction <#rightAction description#>
 *
 *  @since <#2.0#>
 */
- (void)initNavigationBarWithLogoName:(NSString *)logoName navTitle:(NSString *)navTitle navRight:(NSString *)navRight navRightAction:(SEL)navRightAction
{
    
//    [self initNavigationBarWithLogoName:logoName navTitle:navTitle];
    if(navRight != nil){
        //        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(220, 10, 30, 25)];
        NSRange range = [navRight rangeOfString:@"查看订单"];
        if (range.location!=NSNotFound) {
            //            [button setTitle:navRight forState:UIControlStateNormal];
            //            [button setTitleColor:[UIColor fontBlack] forState:UIControlStateNormal];
            //            [[button titleLabel] setFont:kFontB(30)];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:navRight style:UIBarButtonItemStylePlain target:self action:navRightAction];
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontContent], NSFontAttributeName, nil] forState:UIControlStateNormal];
        }else{
            UIImage *rightImg = kIMAGE(navRight);
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:navRightAction];
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor mainColor]];
            //            UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            //            rightImgView.image = [UIImage imageNamed:navRight];
            //            rightImgView.contentMode = UIViewContentModeCenter;
            //            [button addSubview:rightImgView];
        }
        
        //        [button addTarget:self action:navRightAction forControlEvents:UIControlEventTouchUpInside];
        //
        //        [button setBackgroundColor:[UIColor clearColor]];
        //        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        //        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
    if (self) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
}

#pragma mark --设置导航栏的标题
/*!
 *  @author liujinliang, 16-01-08 10:01:00
 *
 *  @brief 设置导航栏的标题、右边的对象
 *
 *  @param logoName    <#logoName description#>
 *  @param navTitle    <#navTitle description#>
 *  @param right       <#right description#>
 *  @param rightAction <#rightAction description#>
 *
 *  @since <#2.0#>
 */
- (void)initNavigationBarWithLogoName:(NSString *)logoName navTitle:(NSString *)navTitle
{
    
    //首页
    UIButton *titleBtn;
    UIView *navbar = [UIView new];
    self.navigationItem.titleView = navbar;
    
    [navbar setFrame:(CGRect){0,0,200,self.navHeight}];
    [navbar setBackgroundColor:[UIColor clearColor]];
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.backgroundColor = [UIColor clearColor];
    navbar.backgroundColor = [UIColor clearColor];
    [titleBtn setBackgroundImageColor:[UIColor clearColor]];
    [titleBtn setUserInteractionEnabled:NO];
    [navbar addSubview:titleBtn];
    
    if ([NSString isEmptyOrNull:logoName]) {
//        logoName = @"icon_navigation_back";
    }
    __weak UIView *navBarV = navbar;
    if ([NSString notEmptyOrNull:logoName]) {
        
        [titleBtn setImage:kIMAGE(logoName) forState:UIControlStateNormal];
        [titleBtn sizeToFit];
    }
    if ([NSString notEmptyOrNull:navTitle]) {
        [titleBtn setTitle:navTitle forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor fontBlack] forState:UIControlStateNormal];
        [titleBtn.titleLabel setFont:kFont(32)];
        [titleBtn sizeToFit];
    }
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navBarV);
        make.centerY.equalTo(navBarV);
    }];
    if (self) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    //
    //    UIView *lineV = [UIView new];
    //    lineV.backgroundColor = [UIColor borderColor];
    //    UINavigationBar *navigationBar = self.navigationController.navigationBar;//[UINavigationBar appearance];
    //    [navigationBar addSubview:lineV];
    //    [lineV setFrame:(CGRect){0,self.navHeight-.5,self.view.width,.5}];
    //    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
    ////        make.left.offset(0);//.offset(kMargin);
    ////        make.right.offset(0);
    ////        make.height.mas_equalTo(@.5);
    ////        make.bottom.equalTo(navigationBar.mas_bottom).with.offset(0);
    ////        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    //    }];
    
    //    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
    //                                                                      [UIColor fontBlack], NSForegroundColorAttributeName,
    //                                                                      [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage getImageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    //        [[UINavigationBar appearance] setBarTintColor:[UIColor mainSecondColor]];
    //    [[UINavigationBar appearance] setTintColor:[UIColor proPercentColor]];
    //    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    //    [[UINavigationBar appearance] setShadowImage:[UIImage getImageFromColor:[UIColor borderColor]]];
    
    //    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage getImageFromColor:[UIColor proPercentColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    UIImage *lineV = [UIImage getImageFromColor:[UIColor borderColor]];
    //iOS7 阴影需单独设定 UIColor clearColor 是去掉字段 1像素阴影
    //    [self.navigationController.navigationBar setShadowImage:[lineV getClickImage:(CGSize){.5,.5}]];
    //    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];//如果用这个，则没有1像素阴影
    //    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
    //                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
    //                                                           [UIFont fontWithName:@"Arial-BoldMT" size:18.0], NSFontAttributeName, nil]];
    
    
}

#pragma mark --导航栏左边icon或标题
/*!
 *  @author liujinliang, 16-02-18 15:02:50
 *
 *  @brief 导航栏左边icon或标题
 *
 *  @param iconName      <#iconName description#>
 *  @param navLeft       <#navLeft description#>
 *  @param navLeftAction <#navLeftAction description#>
 *
 *  @since <#version number#>
 */
- (void)initNavigationBarWithIconName:(NSString *)iconName navLeft:(NSString *)navLeft  navLeftAction:(SEL)navLeftAction {
    
    if(navLeft != nil){
        self.navigationItem.leftBarButtonItem=nil ;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, kNavVCBarHeight)];
        [button setTitle:navLeft forState:UIControlStateNormal];
        if (!iconName.isEmpty) {
            [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        }
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        //        button.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
        
        [[button titleLabel] setFont:[UIFont fontContent]];
        [button setTitleColor:[UIColor fontBlack] forState:UIControlStateNormal];
        [button addTarget:self action:navLeftAction forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = rightBarBtnItem;
    }
    if (self) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
}

#pragma mark --刷新ui数据
/*!
 *  @author liujinliang, 16-01-08 10:01:51
 *
 *  @brief 刷新ui数据
 *
 *  @since <#2.0#>
 */
- (void)reloadViewData{}

#pragma mark --绘制ui界面
/*!
 *  @author liujinliang, 16-01-08 09:01:27
 *
 *  @brief 绘制ui界面
 *
 *  @since <#2.0#>
 */
- (void)initUIViews
{
    
}
#pragma mark --请求服务器数据
/*!
 *  @author liujinliang, 15-12-24 10:12:50
 *
 *  @brief 请求服务器数据
 *
 *  @since <#1.1.0#>
 */
- (void)loadServletData{
    
}

#pragma mark - 返回按钮
/**
 *  添加返回按钮
 */
- (void)setupBackButton
{
    [self setupBackButtonTarget:self action:@selector(onBackButton)];
}

/**
 *  添加返回按钮
 */
- (void)setupBackButtonTarget:(id)target action:(SEL)action
{
    UIImage *image = kIMAGE(@"icon_navigation_back");
    image = [image resizedImageToSize:(CGSize){15,15}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
}

/**
 *  返回按钮点击时回调
 */
- (void)onBackButton
{
    NSInteger n = [self.navigationController.childViewControllers count];
    if (n>1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSDictionary *)getAttributes:(BOOL)isOpen{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.lineHeightMultiple = 1.0;
    if (isOpen) {
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    }else{
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    NSDictionary *attributes = @{NSFontAttributeName:kFont(28), NSParagraphStyleAttributeName:paragraphStyle.copy};
    return attributes;
}


#pragma mark --登录成功回调处理
/*!
 *  @author liujinliang, 16-01-18 17:01:21
 *
 *  @brief 登录成功回调处理
 *
 *  @param successBlock <#successBlock description#>
 *
 *  @since <#2.0#>
 */
- (void)loginVCWithSuccessBlock:(LoginVCAction)successBlock {
    [self loginVCWithSuccessBlockWithIsForget:NO successBlock:successBlock];
}

#pragma mark --获取StoryBoard指定identifier的控制器
/*!
 *  @author liujinliang, 16-09-30 21:09:59
 *
 *  @brief 获取StoryBoard指定identifier的控制器
 *
 *  @param identifier <#identifier description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#1.0#>
 */
- (BaseViewController *)getViewControllerWithIdentifier:(NSString *)identifier {
    return [kMainStoryBoard() instantiateViewControllerWithIdentifier:identifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
