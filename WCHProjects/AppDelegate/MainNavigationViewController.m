//
//  MainNavigationViewController.m
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/31.
//  Copyright © 2015年 WorldUnion. All rights reserved.
//

#import "MainNavigationViewController.h"
#import "LoginViewController.h"
#import "BaseViewController.h"
#import "UIViewController+MMDrawerController.h"

#import <objc/runtime.h>

@interface UINavigationController (Transition)<UIGestureRecognizerDelegate>

- (void)transitionPanGestureDidLoad;

@end

@interface DLNavigationTransition ()

@end
@implementation DLNavigationTransition

/**
 *  启动右滑pop
 */
+ (void)enableNavigationTransitionWithPanGestureBack
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method viewDidLoadMethod = class_getInstanceMethod([UINavigationController class], @selector(viewDidLoad));
        Method transitionPanGestureDidLoadMethod = class_getInstanceMethod([UINavigationController class], @selector(transitionPanGestureDidLoad));
        
        method_exchangeImplementations(viewDidLoadMethod, transitionPanGestureDidLoadMethod);
        
    });
}

@end


@implementation UINavigationController (Transition)

- (void)transitionPanGestureDidLoad
{
    if ([self isKindOfClass:[UINavigationController class]])
    {
        
        [self transitionPanGestureDidLoad];
        
        
        //1.获取系统interactivePopGestureRecognizer对象的target对象
        id target = self.interactivePopGestureRecognizer.delegate;
        //2.创建滑动手势，taregt设置interactivePopGestureRecognizer的target，所以当界面滑动的时候就会自动调用target的action方法。
        //handleNavigationTransition是私有类_UINavigationInteractiveTransition的方法，系统主要在这个方法里面实现动画的。
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
        [pan addTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
        //3.设置代理
        pan.delegate = self;
        //4.添加到导航控制器的视图上
        [self.view addGestureRecognizer:pan];
        
        //5.禁用系统的滑动手势
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark - 滑动开始会触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //只有导航的根控制器不需要右滑的返回的功能。
    if (self.viewControllers.count <= 1)
    {
        
        return NO;
    }
    
    return NO;
}

//-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
//    [self popViewControllerAnimated:YES];
//}

@end

@interface MainNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation MainNavigationViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    if(self.mm_drawerController.showsStatusBarBackgroundView){
        return UIStatusBarStyleLightContent;
    }
    else {
        return UIStatusBarStyleDefault;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //    [navBar setClipsToBounds:YES];
    [navBar setBarTintColor:[UIColor whiteColor]];
    [navBar setTintColor:[UIColor mainColor]];
    //
    NSDictionary *titleTextAttr = @{NSFontAttributeName : kFont(34),
                                    NSForegroundColorAttributeName : [UIColor fontBlack]};
    navBar.titleTextAttributes = titleTextAttr;
    [navBar ul_setUnderLineColor:[UIColor borderColor]];
    
}
/*

//全屏滑动返回效果实现
- (void)setupWindowBack {
    //获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    
    //创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(gestureRecognizerShouldBegin:)];
    //设置手势代理，拦截手势触发
    pan.delegate = self;
    //给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    //禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark --UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //注意：只有非根控制器才有滑动返回功能，根控制器没有
    //判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        //表示用户在根控制器界面，就不需要触发滑动手势
        return NO;
    }
    return YES;
}
*/

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSString *className = NSStringFromClass([viewController class]);
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //        self.interactivePopGestureRecognizer.enabled = YES;
    }
   
    if (self.viewControllers.count>0)
    {
        [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    }
    
    if (![viewController isKindOfClass:[BaseViewController class]])
    {
        // 放行
        [super pushViewController:viewController animated:animated];
        return;
    }
    
    if (![viewController isKindOfClass:[BaseViewController class]])
    {
        // 放行
        [super pushViewController:viewController animated:animated];
        return;
    }
    
    if (((BaseViewController *)viewController).needLoginBeforePush)
    {
        if (![UserInfoObj model])
        {
            // 转去登录
            [NSString toast:@"请先登录"];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.loginAction = ^(NSInteger index){
                
                [super pushViewController:viewController animated:animated];
            };
            [super pushViewController:loginVC animated:YES];
            return;
        }
    }
    
    // 放行
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    
    NSArray *viewVCs = self.viewControllers;
    if (viewVCs.count>2) {
        
        [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    }else{
        [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
        
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers.firstObject)
    {
        [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    }else{
        [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    }
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    
    return [super popToRootViewControllerAnimated:animated];
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
