//
//  OrderPointAnnotation.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/23.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import "OrderInfoObj.h"
FOUNDATION_EXPORT NSString * const kOrderPointAnnotationID;
@interface OrderPointAnnotation : BMKPointAnnotation
@property (nonatomic, strong) OrderInfoObj *orderObj;
@end
