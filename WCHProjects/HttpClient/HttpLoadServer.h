//
//  HttpLoadServer.h
//  WorldUnionBrokerPlatform
//
//  Created by liujinliang on 16/5/5.
//  Copyright © 2016年 www.liujinliang All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpLoadServer : NSObject
DEFINE_SINGLETON_FOR_HEADER(HttpLoadServer)
@property (nonatomic, assign) BOOL isShow;
- (void)show;
- (void)hide;
@end
