//
//  MyBMKPointAnnotation.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/7.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
FOUNDATION_EXPORT NSString * const kMyBMKPointAnnotationID;
@interface MyBMKPointAnnotation : BMKPointAnnotation
@property (nonatomic, assign) NSInteger annotationType;//0自己的位置，1起点，2终点
@end
