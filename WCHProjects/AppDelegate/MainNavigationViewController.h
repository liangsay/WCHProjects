//
//  MainNavigationViewController.h
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/31.
//  Copyright © 2015年 WorldUnion. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DLNavigationTransition : NSObject

/**
 *  启动右滑pop
 */
+ (void)enableNavigationTransitionWithPanGestureBack;

@end
@interface MainNavigationViewController : UINavigationController

@end
