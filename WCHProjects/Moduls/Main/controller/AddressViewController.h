//
//  AddressViewController.h
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "SearchAddressTableCell.h"

@class AddressViewController;

@protocol AddressViewControllerDelegate <NSObject>
@required
- (void)addressViewController:(AddressViewController *)addressViewController searchAddressObj:(SearchAddressObj *)searchObj selType:(NSInteger)selType;
@end

@interface AddressViewController : BaseViewController<BMKPoiSearchDelegate>
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, strong) BMKPoiSearch* poisearch;
@property(nonatomic, strong) NSString *provinceName;//当前省名称
@property(nonatomic, strong) NSString *cityName;//当前城市名称
@property (nonatomic, assign) id<AddressViewControllerDelegate> delegate;
@end
