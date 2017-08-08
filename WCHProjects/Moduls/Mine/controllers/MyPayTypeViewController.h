//
//  MyPayTypeViewController.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/14.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfoObj.h"
@class MyPayTypeViewController;
@protocol MyPayTypeViewDelegate <NSObject>

- (void)myPayTypeViewController:(MyPayTypeViewController *)myPayTypeViewController payStatus:(NSInteger)payStatus orderObj:(OrderInfoObj *)orderObj;

@end

@interface MyPayTypeViewController : BaseViewController
@property (nonatomic, assign) NSInteger viewType;//3、租车；4、购车
@property (nonatomic, strong) OrderInfoObj *orderObj;
@property (nonatomic, assign) id<MyPayTypeViewDelegate> delegate;
@end
