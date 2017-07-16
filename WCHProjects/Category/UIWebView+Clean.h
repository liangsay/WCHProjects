//
//  UIWebView+Clean.h
//  YunZhangGui
//
//  Created by liujinliang on 2017/1/19.
//  Copyright © 2017年 worldunion.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Clean)
// performs various cleanup activities recommended for UIWebView before dealloc.
// see comments in implementation for usage examples
-(void)cleanForDealloc;
@end
