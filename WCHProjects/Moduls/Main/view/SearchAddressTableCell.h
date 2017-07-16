//
//  SearchAddressTableCell.h
//  WCHProjects
//
//  Created by liujinliang on 2016/10/8.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseModel.h"
#import <CoreLocation/CLLocation.h>
FOUNDATION_EXPORT NSString * const kSearchAddressTableCellID;
FOUNDATION_EXPORT CGFloat const kSearchAddressTableCellHeight;

@interface SearchAddressObj : BaseModel
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *province;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *detail;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

@interface SearchAddressTableCell : BaseTableCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;

- (void)setupCellInfoWith:(SearchAddressObj *)model;
@end
