//
//  CitysViewController.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/19.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfoObj.h"
@class CitysViewController;

@protocol CitysViewControllerDelegate <NSObject>

- (void)citysViewController:(CitysViewController *)citysViewController cityObj:(OrderInfoObj *)cityObj;

@end

@interface CitysViewController : BaseViewController
@property (nonatomic, strong) OrderInfoObj *cityObj;
@property (nonatomic, assign) id<CitysViewControllerDelegate> delegate;
@end
