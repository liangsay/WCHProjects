//
//  MainTabBarViewController.m
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/31.
//  Copyright © 2015年 WorldUnion. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "MainNavigationViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CallCarViewController.h"
#import "RentCarViewController.h"
#import "ShopViewController.h"
#import "OrderListViewController.h"
#import "MineViewController.h"


const CGFloat kMainTabBarHeight = 98 / 2;
const CGFloat kMainTabBarContentHeight = 98 / 2;

@interface MainTabBarViewController () <RDVTabBarDelegate>
{
    NSInteger selectedTabBarIiemTag;
    NSInteger oldTabBarIiemTag;
}

@property (nonatomic, strong) BaseViewController *currentBaseVC;
@property (nonatomic, assign) BOOL isOpenVC;

@end

@implementation MainTabBarViewController

+ (UINavigationController *)currentNavigationController
{
    MainTabBarViewController *tabBarCtrl = (MainTabBarViewController *)kAppDelegate.tabBarVC;
    return [tabBarCtrl.viewControllers objectAtIndex:tabBarCtrl.selectedIndex];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customizeChildViewControllers];
        [self customizeTabBar];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)customizeChildViewControllers
{
    self.tabBar.backgroundColor = [UIColor tabBgColor];
    CallCarViewController *tabVC1 = [[CallCarViewController alloc] initWithNibName:@"CallCarViewController" bundle:nil];
    tabVC1.navigationItem.title = @"叫车";
    //    tabVC1.needLoginBeforePush = YES;
    MainNavigationViewController *navVC1 = [[MainNavigationViewController alloc] initWithRootViewController:tabVC1];
    
    RentCarViewController *tabVC2 = [[RentCarViewController alloc] initWithNibName:@"RentCarViewController" bundle:nil];
    tabVC2.navigationItem.title = @"租车";
    //    tabVC2.needLoginBeforePush = YES;
    MainNavigationViewController *navVC2 = [[MainNavigationViewController alloc] initWithRootViewController:tabVC2];
    
    ShopViewController *tabVC3 = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
    tabVC3.navigationItem.title = @"商城";
    //    tabVC2.needLoginBeforePush = YES;
    MainNavigationViewController *navVC3 = [[MainNavigationViewController alloc] initWithRootViewController:tabVC3];
    
    OrderListViewController *tabVC4 = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:nil];
//    AddressBookViewController *tabVC4 = [[AddressBookViewController alloc] init];
    tabVC4.navigationItem.title = @"订单";
    //    tabVC3.needLoginBeforePush = YES;
    MainNavigationViewController *navVC4 = [[MainNavigationViewController alloc] initWithRootViewController:tabVC4];
    
    MineViewController *tabVC5 = [[MineViewController alloc] initWithNibName:@"MineViewController" bundle:nil];
    MainNavigationViewController *navVC5 = [[MainNavigationViewController alloc] initWithRootViewController:tabVC5];
    
    NSArray *navs = @[navVC1, navVC2, navVC3,navVC4,navVC5];
    self.viewControllers = navs;
    
    self.selectedIndex = 0;
    
}


- (void)customizeTabBar
{
    // 各项
    NSArray *titles = @[@"叫车", @"租车",@"商城", @"订单",@"我的"];
    NSArray *unselcteimageNames = @[@"tab_callcar", @"tab_rent", @"tab_shop", @"tab_order", @"tab_my"];
    NSArray *imageNames = @[@"tab_callcar_h", @"tab_rent_h",@"tab_shop_h", @"tab_order_h",@"tab_my_h"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];
    
    for (NSInteger index = 0; index < titles.count; index++)
    {
        UIImage *selectedimage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[imageNames objectAtIndex:index] stringByReplacingOccurrencesOfString:@"" withString:@""]]] imageScaledToSize:(CGSize){20,20}];
        UIImage *unselectedimage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                         [unselcteimageNames objectAtIndex:index]]] imageScaledToSize:(CGSize){20,20}];
        RDVTabBarItem *item = [[RDVTabBarItem alloc] init];
        item.badgeBackgroundColor = [UIColor mainColor];
        item.badgeTextColor = [UIColor mainColor];
        item.badgeTextFont = [UIFont fontAssistant];
        
        item.itemHeight = kMainTabBarContentHeight;
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.title = [titles objectAtIndex:index];
        item.titlePositionAdjustment = UIOffsetMake(0, 5);
        item.selectedTitleAttributes = @{NSFontAttributeName: kFont(24),
                                         NSForegroundColorAttributeName: [UIColor fontBlack]};
        item.unselectedTitleAttributes = @{NSFontAttributeName: kFont(22),
                                           NSForegroundColorAttributeName: [UIColor fontGray]};
        
        [items addObject:item];
        if (index==0) {
            _slideView = [UIView horizontalLineWithLength:40];
            _slideView.backgroundColor = [UIColor mainColor];
            _slideView.height = 2;
            _slideView.top = kMainTabBarHeight-2;
            _slideView.centerX = kScreenWidth/titles.count/2;
            [self.tabBar addSubview:_slideView];
            self.firstTabBarItem = item;
        }
        
    }
    self.tabBar.items = items;
    self.tabBar.delegate = self;
    
    // 背景
    
    self.tabBar.backgroundColor = [UIColor tabBgColor];
    [self.tabBar setHeight:kMainTabBarHeight];
    
    
    UIView *lineV = [UIView horizontalLineWithLength:self.view.width];
    lineV.backgroundColor = [UIColor borderColor];
    [self.tabBar addSubview:lineV];
    [self.tabBar bringSubviewToFront:lineV];
    
    //    // 突出的圆弧
    //    CGFloat circleSize = kMainTabBarHeight;
    //    CGFloat circleX = (self.view.width - circleSize) / 2;
    //    CGFloat circleY = -(kMainTabBarHeight - kMainTabBarContentHeight);
    //    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(circleX, circleY, circleSize, circleSize)];
    //    circle.backgroundColor = self.tabBar.backgroundView.backgroundColor;
    //    circle.layer.cornerRadius = circleSize / 2;
    //    circle.layer.masksToBounds = YES;
    //    [self.tabBar.backgroundView addSubview:circle];
}

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index
{
    
    __block RDVTabBarItem *item = (RDVTabBarItem *)tabBar.items[index];
    [UIView animateWithDuration:.35 animations:^{
//        if (index != 2) {
            _slideView.centerX = item.centerX;
//        }
    }];
    
    MainNavigationViewController *navVC = self.viewControllers[index];
    NSArray *navArr = navVC.viewControllers;
    UIViewController *viewCon =[navArr firstObject];//[nav topViewController];
    DLog(@"viewCon:%@",NSStringFromClass(viewCon.class));
    
    _slideView.alpha = 1;
    
    if(selectedTabBarIiemTag == index){
//        if (index == 2) {
//            self.selectedIndex = oldTabBarIiemTag;
//            selectedTabBarIiemTag = oldTabBarIiemTag;
//        }
        return NO;
    }else {
//        if (index != 2) {
//            oldTabBarIiemTag = index;
//        }else{
//            NSLog(@"--");
//            _slideView.alpha = 0;
//        }
        selectedTabBarIiemTag = index;
        return YES;
    }
    //    return YES;
}

#pragma mark --指定横竖屏-----------------------
// 是否支持转屏
- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

// 返回nav栈中的最后一个对象支持的旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

// 返回nav栈中最后一个对象,坚持旋转的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
