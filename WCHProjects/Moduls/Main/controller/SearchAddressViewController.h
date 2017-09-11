//
//  SearchAddressViewController.h
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "SearchAddressTableCell.h"

typedef NS_ENUM(NSUInteger, SearchAddressType) {
    SearchAddressTypeStart,//起点
    SearchAddressTypeEnd,//终点
    SearchAddressTypeCallCar,
};

@class SearchAddressViewController;

@protocol SearchAddressViewControllerDelegate <NSObject>
@required
- (void)searchAddressViewController:(SearchAddressViewController *)searchAddressViewController searchAddressObj:(SearchAddressObj *)searchObj selType:(NSInteger)selType;
@end

@interface SearchAddressViewController : BaseViewController<BMKPoiSearchDelegate>
@property (nonatomic, assign) SearchAddressType searchType;
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, strong) BMKPoiSearch* poisearch;
@property(nonatomic, strong) NSString *provinceName;//当前省名称
@property(nonatomic, strong) NSString *cityName;//当前城市名称
@property (nonatomic, strong) OrderInfoObj *curOrderInfoObj;

@property (nonatomic, assign) id<SearchAddressViewControllerDelegate> delegate;
@end
