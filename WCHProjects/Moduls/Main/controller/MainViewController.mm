//
//  MainViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "MainViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "SearchAddressViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "MyBMKPointAnnotation.h"
#import "OrderInfoObj.h"
#import "ActionSheetStringPicker.h"
#import <AVFoundation/AVFoundation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "UIImage+Rotate.h"

#import "EndOrderLocationServer.h"
#import "MyPayTypeViewController.h"
#import "OrderPointAnnotation.h"
#import "AppraiseViewController.h"
#import <MapKit/MapKit.h>

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
//icon_center_point
@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

/**
 
 *计算指定两点之间的距离
 
 *@param a 第一个坐标点
 
 *@param b 第二个坐标点
 
 *@return 两点之间的距离，单位：米
 
 */

UIKIT_EXTERN CLLocationDistance BMKMetersBetweenMapPoints(BMKMapPoint a, BMKMapPoint b);
UIKIT_EXTERN BMKMapPoint BMKMapPointForCoordinate(CLLocationCoordinate2D coordinate);
@interface MainViewController ()<UITextFieldDelegate,
BMKLocationServiceDelegate,
BMKGeoCodeSearchDelegate,
BMKMapViewDelegate,
BMKRouteSearchDelegate,
SearchAddressViewControllerDelegate,
OrderViewControllerDelegate,
MyPayTypeViewDelegate>
{
    MyBMKPointAnnotation *_mypointAnnotation;
    MyBMKPointAnnotation *_endpointAnnotation;
//    MyBMKPointAnnotation *_currentpointAnnotation;//当前实时位置
    NSInteger _selType;
    CLLocationDistance _distance;
    double _price;
    NSString *_startLocationf;
    NSString *_endLocationf;
    AVAudioPlayer *player;
    BOOL isChange;
    
    NSInteger _index;
    float zoomValue;
    
    
}



@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocation *starLocation;
@property (nonatomic, strong) CLLocation *endLocation;
@property (nonatomic, strong) BMKGeoCodeSearch *mapSearch;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKRouteSearch* routesearch;

@property(nonatomic, strong) NSString *cityName;//当前城市名称
@property(nonatomic, strong) NSString *lastCityName;//记录最后定位的起点位置城市

//@property(nonatomic, strong) NSString *tipPricef;//小费


@property(nonatomic, strong) NSMutableArray *costDataArray;//小费数据
@property(nonatomic, strong) NSMutableArray *pointDataArray;//货运点数据
@property(nonatomic, strong) NSMutableArray *orderToDoneArray;//待接订单
@property(nonatomic, assign) NSInteger selectIndex;//当前所选车型

@property (nonatomic, copy) NSString *startProvince;
@property (nonatomic, copy) NSString *startCity;
@property (nonatomic, copy) NSString *endProvince;
@property (nonatomic, copy) NSString *endCity;
@property(nonatomic, assign) BOOL isStart;//是否为起点
@property(nonatomic, assign) BOOL isLocation;//是否为定位

@property(nonatomic, assign) NSInteger orderCount;//订单数


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailInfoLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailInfoTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carPersonLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sijiorderTopLayoutConstraint;


//用户端默认显示（司机，货主都是用户）
@property (weak, nonatomic) IBOutlet UIView *callView;
@property (weak, nonatomic) IBOutlet UITextField *startTextField;   //起点位置
@property (weak, nonatomic) IBOutlet UITextField *endTextField;     //结束位置
@property (weak, nonatomic) IBOutlet UITextField *carTypeTextField; //送货车型
@property (weak, nonatomic) IBOutlet UILabel *detailInfoLab;//公里和费用信息
@property (weak, nonatomic) IBOutlet UIButton *callCarBtn;

//货主或司机货主端，添加订单成功后的显示
@property (weak, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet UITextField *orderStartTextField;
@property (weak, nonatomic) IBOutlet UITextField *orderEndTextField;
@property (weak, nonatomic) IBOutlet UIButton *addCostBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
//@property (nonatomic, strong) NSTimer *timer;//用户端定时检查订单有没有被抢单

//货主端在司机接单后，货主端显示接单司机信息层
//如果订单被抢了，显示司机信息，同时隐藏添加订单层，显示司机信息点击立即下单则关闭该司机信息层，同事显示添加订单层，重置下单层
@property (weak, nonatomic) IBOutlet UIView *personView;
@property (weak, nonatomic) IBOutlet UIButton *personCallBtn;
@property (weak, nonatomic) IBOutlet UILabel *pCarLab;//车主
@property (weak, nonatomic) IBOutlet UILabel *pCarNumLab;//车牌号
@property (weak, nonatomic) IBOutlet UILabel *pCarScoreLab;//车主评分
@property (weak, nonatomic) IBOutlet UILabel *pCarCountLab;//车主接单数
@property (weak, nonatomic) IBOutlet UIButton *pCarOrderBtn;//立即下单

//司机端，抢单成功后，未完成抢的单，显示未完成单层
@property (weak, nonatomic) IBOutlet UIView *carOrderView;
@property (weak, nonatomic) IBOutlet UITextField *carStartTextField;//司机接单的订单开始位置
@property (weak, nonatomic) IBOutlet UITextField *carEndTextField;//司机接单的订单终点位置
@property (weak, nonatomic) IBOutlet UIButton *carInfoBtn;//司机端抢单后回到主界面，显示完成订单信息界面的费用和公里信息
@property (weak, nonatomic) IBOutlet UIButton *orderFinishBtn;//司机完成订单按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelFinishBtn;//司机抢单后可取消订单

@property (nonatomic, strong) OrderInfoObj *orderHuozhuObj;
@property (nonatomic, strong) OrderInfoObj *orderSiJiObj;

@property (weak, nonatomic) IBOutlet UIImageView *startImageView;


//onClickDriveSearch
@property (assign, nonatomic) NSInteger driverType;//路线规划类型，作为货主时1，作为司机接单时2，
@property (assign, nonatomic) NSInteger statusf;


@end


@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.navigationItem.backBarButtonItem = nil;
    self.orderVC = nil;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _routesearch.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    kAppDelegate.mainViewController = self;
    [self initNavigationBarWithIconName:@"菜单" navLeft:@"" navLeftAction:@selector(showMineCenterViewControllerWithAction:) ];
    if ([UserInfoObj model].userTypef.integerValue==2) {
        [self initNavigationBarWithLogoName:nil navTitle:@"六六微货" navRight:@"查看订单" navRightAction:@selector(viewOrderWithAction:)];
    }else{
        
    }
    self.navigationItem.title = @"六六微货";
    [self setupVCStyle];
    [self setupLocationService];
    if ([UserInfoObj model]) {
        [self startTimerServlet];
    }
    
//    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
//    [self.mapView addGestureRecognizer:mTap];
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    
    
    //    MKCoordinateRegion region;
    //    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    //    region.center= centerCoordinate;
    BMKCoordinateRegion region ;//表示范围的结构体
    CLLocationCoordinate2D centerCoordinate = touchMapCoordinate;
    region.center = centerCoordinate;//中心点(当前定位的点)
    /*region.span.latitudeDelta = 0.02;//经度范围
     region.span.longitudeDelta = 0.02;//纬度范围
     //设置地图的中心点和范围
     [_mapView setRegion:region animated:YES];
     */
   
    self.starLocation = nil;
    [self getLocationAddressWithUserLocation:centerCoordinate];
}

#pragma mark --开启定位服务
/*!
 *  @author liujinliang, 16-09-30 23:09:26
 *
 *  @brief 开启定位服务
 *
 *  @since <#1.0#>
 */
- (void)setupLocationService{
    self.orderView.alpha = 0;
    _mapSearch = nil;
    _locService = nil;
    _routesearch = nil;
    
    _mapSearch = [[BMKGeoCodeSearch alloc] init];
    _mapSearch.delegate = self;
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.distanceFilter = 100.0;
    _locService.allowsBackgroundLocationUpdates = NO;
    //普通态
    //以下_mapView为BMKMapView对象
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.zoomLevel = 18;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.ChangeWithTouchPointCenterEnabled = YES;
//
    _routesearch = [[BMKRouteSearch alloc]  init];
    //启动LocationService
    [_locService startUserLocationService];
}



#pragma mark --重置地图相关显示
- (void)resetLocation {
    _startLocationf = @"";
    _endLocationf = @"";
    _index = 0;
    self.isStart = YES;
    self.starLocation = nil;
    self.startCity = @"";
    self.endCity = @"";
    self.endProvince = @"";
    self.endLocation = nil;
    self.endTextField.text = @"";
    self.carTypeTextField.text = @"";
    self.currentLocation = nil;
    self.reciveOrder = nil;
    self.isReciveState = NO;
    
    _distance = 0;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
//    [self.locService startUserLocationService];
    [self setupLocationService];
}

#pragma mark --起点
- (void)setupStartLocation{
    
    //添加当前位置的标注
    CLLocationCoordinate2D coord;
    coord.latitude = _starLocation.coordinate.latitude;
    coord.longitude = _starLocation.coordinate.longitude;
    
    CGPoint point = self.mapView.center;
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    [_mapView removeAnnotation:_mypointAnnotation];
    
    if (_mypointAnnotation==nil) {
        _mypointAnnotation = [[MyBMKPointAnnotation alloc] init];
    }
    _mypointAnnotation.coordinate = touchMapCoordinate;
    
    _mypointAnnotation.title = [NSString stringWithFormat:@"起点：%@",self.startTextField.text];
    _mypointAnnotation.annotationType = 1;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView addAnnotation:_mypointAnnotation];
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
//    });
    
}

#pragma mark --终点
- (void)setupEndLocation{
    
    
        //添加当前位置的标注
    CLLocationCoordinate2D coord;
    coord.latitude = _endLocation.coordinate.latitude;
    coord.longitude = _endLocation.coordinate.longitude;
    
    [_mapView removeAnnotation:_endpointAnnotation];
    
    if (_endpointAnnotation==nil) {
        _endpointAnnotation = [[MyBMKPointAnnotation alloc] init];
    }
    _endpointAnnotation.coordinate = coord;
//    _mapView.centerCoordinate = coord;
    if (self.driverType==2||self.driverType==3) {
        _endpointAnnotation.title = [NSString stringWithFormat:@"终点：%@",self.carEndTextField.text];
    }else{
        _endpointAnnotation.title = [NSString stringWithFormat:@"终点：%@",self.endTextField.text];
    }
    _endpointAnnotation.annotationType = 2;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView addAnnotation:_endpointAnnotation];
        
    });
}


#pragma mark --BMKGeoCodeSearchDelegate
///BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (!result.address.isEmpty) {
        if (self.isStart) {
            if (_index==0) {
//                _mapView.centerCoordinate = result.location;
                _index++;
            }
            if (zoomValue != _mapView.zoomLevel) {
                _mapView.centerCoordinate = result.location;
                zoomValue = _mapView.zoomLevel;
            }
            
            UserInfoObj *user = [UserInfoObj model];
            user.provincef = result.addressDetail.province;
            user.cityf = result.addressDetail.city;
            [user cache];
            self.startProvince = user.provincef;
            self.startCity = user.cityf;
            self.startTextField.text = [NSString toString:result.address];
            self.cityName = result.addressDetail.city;
            self.starLocation = [[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude];
            _startLocationf = [NSString stringWithFormat:@"%f,%f",self.starLocation.coordinate.latitude,self.starLocation.coordinate.longitude];
        
            [self setupStartLocation];
            
        }else{
            self.endProvince = result.addressDetail.province;
            self.endCity = result.addressDetail.city;
            self.endTextField.text = [NSString toString:result.address];
            self.endLocation = [[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude];
            _endLocationf = [NSString stringWithFormat:@"%f,%f",self.endLocation.coordinate.latitude,self.endLocation.coordinate.longitude];
        }
        
        if (![self.lastCityName isEqualToString:self.startCity] && self.isStart) {
            [self sendFreighttoPriceWithProvincef:result.addressDetail.province cityf:result.addressDetail.city];
            self.lastCityName = self.startCity;
        }
        
        if ([UserInfoObj model].userTypef.integerValue==2) {
            //如果是司机，定时查询待接订单
            //身份是司机的也可以是货主，所以要执行以下接口检查，如果司机作为货主下单了，检查司机的货有没有被接单
            
            
        }
        if (!kIsObjectEmpty(self.startCity) && !kIsObjectEmpty(self.endCity)) {
            
            self.driverType = 1;
            [self onClickDriveSearch];
            [self updateWillOrderInfo];
        }
        
//        [_mapView setNeedsDisplay];
    }else{
        [NSString toast:@"无法获取该位置信息"];
    }
}

#pragma mark --BMKLocationServiceDelegate------------------
//实现相关delegate 处理位置信息更新
/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    DLog(@"regionDidChangeAnimated:%d",mapView.isMultipleTouchEnabled);
    CLLocationCoordinate2D coordinate= _mapView.centerCoordinate;
    
    
//    NSLog(@"%f %f",touchMapCoordinate.latitude, touchMapCoordinate.longitude);
    
   WEAKSELF
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_index!=0 && !_isLocation) {
//            CGPoint point = CGPointMake(weakSelf.startImageView.center.x, weakSelf.startImageView.center.y+36/2);
//            CLLocationCoordinate2D touchMapCoordinate =
//            [weakSelf.mapView convertPoint:point toCoordinateFromView:weakSelf.mapView];
            if (weakSelf.mapBottomLayoutConstraint.constant==0) {
                [weakSelf getLocationAddressWithUserLocation:coordinate];
            }
        }
        if (_isLocation) {
            _isLocation = NO;
        }
    });
    
//
//    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.01, 0.01);
//    BMKCoordinateRegion region = BMKCoordinateRegionMake(mapView.centerCoordinate, span);
//    [mapView setRegion:region animated:YES];
//    
//    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
//    [self getAddressByCoordinate:centerCoordinate];
    
//    _mapView.region = mapView.centerCoordinate;
//    float zoomLevel = 0.005;
//    BMKCoordinateRegion region = BMKCoordinateRegionMake(mapView.centerCoordinate, BMKCoordinateSpanMake(zoomLevel, zoomLevel));
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    /*self.isStart = YES;
     
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作在此次添加
        BMKReverseGeoCodeOption *coordinate = [[BMKReverseGeoCodeOption alloc] init];
        coordinate.reverseGeoPoint = (CLLocationCoordinate2D)mapView.centerCoordinate;
        [_mapSearch reverseGeoCode:coordinate];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //在主线程刷新UI
        });
    });*/
    
}

- (void)getAddressByCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    geocoder.accessibilityValue = @"zh-hans";
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks lastObject];
        NSString *Country = [placemark.addressDictionary objectForKey:@"Country"];  //国家
        NSString *State = [placemark.addressDictionary objectForKey:@"State"];  //省份
        NSString *city = [placemark.addressDictionary objectForKey:@"City"];        //省份
        NSString *SubLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];  //区
        NSString *Street = [placemark.addressDictionary objectForKey:@"Street"];
        NSString *Thoroughfare = [placemark.addressDictionary objectForKey:@"Thoroughfare"];
        
        NSString *Name = [placemark.addressDictionary objectForKey:@"Name"];
        NSLog(@"总：%@，城市:%@，国家：%@，省份：%@，街道：%@,%@--%@",Name,city,Country,State,Street,SubLocality,Thoroughfare);
        if (Thoroughfare == nil) {// 街道定位可能是空值
            Thoroughfare = @"";
        }
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@",State,city,SubLocality,Thoroughfare];
        DLog(@"address:%@",address);
        [self setupStartLocation];//添加标注
    }];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _isLocation = YES;
    CLLocationCoordinate2D coordinate;
    coordinate = userLocation.location.coordinate;
    [self getLocationAddressWithUserLocation:coordinate];
}


- (void)getLocationAddressWithUserLocation:(CLLocationCoordinate2D)coordinate {
    
    [_locService stopUserLocationService];
    
    self.isStart = YES;
    BMKReverseGeoCodeOption *geoCode = [[BMKReverseGeoCodeOption alloc] init];
    geoCode.reverseGeoPoint = coordinate;
    [_mapSearch reverseGeoCode:geoCode];
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
     
    if ([annotation isKindOfClass:[MyBMKPointAnnotation class]]) {
        
        MyBMKPointAnnotation *tt = (MyBMKPointAnnotation *)annotation;
       NSString *AnnotationViewID = @"myAnnotation";
        if (tt.annotationType==1) {
            AnnotationViewID = @"StartAnnotation";
            
        }else if (tt.annotationType==2){
            AnnotationViewID = @"EndAnnotation";
        }
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        if (newAnnotationView == nil) {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            newAnnotationView.animatesDrop = YES;
            // 设置可拖拽
            newAnnotationView.draggable = YES;
            newAnnotationView.animatesDrop = YES;
            newAnnotationView.annotation = annotation;
            newAnnotationView.canShowCallout = YES;
        }
        
        //这里我根据自己需要，继承了BMKPointAnnotation，添加了标注的类型等需要的信息
        
        //判断类别，需要添加不同类别，来赋予不同的标注图片
        NSString *title = @"您的当前位置";
        if (tt.annotationType==1) {
            title = self.startTextField.text;
            [newAnnotationView setDraggable:YES];//允许用户拖动
            newAnnotationView.image = [UIImage imageNamed:@"icon_nav_start"];
        }else if(tt.annotationType==2){
            title = self.endTextField.text;
            newAnnotationView.image = [UIImage imageNamed:@"icon_nav_end"];
        }else{
            newAnnotationView.image =[UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_center_point.png"]];
            [newAnnotationView setDraggable:YES];//允许用户拖动
        }
//        [newAnnotationView setSelected:YES animated:YES];
        
        UIView *paoView = [UIView new];
        paoView.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
        [paoView setLayerBorderWidth:.5 color:[UIColor mainColor]];
        [paoView setLayerCornerRadius:4];
        paoView.frame = (CGRect){0,0,kScreenWidth-30,60};
        UILabel *titleLab = [BaseViewServer addLabelInView:paoView font:kFont(28) text:title textColor:[UIColor fontBlack] textAilgnment:NSTextAlignmentCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(10);
            make.right.bottom.offset(-10);
        }];
        titleLab.numberOfLines = 0;
        
//        [titleLab setAdjustsFontSizeToFitWidth:YES];
        CGSize size=  [titleLab sizeThatFits:(CGSize){kScreenWidth-30,self.mapView.height/2}];
        paoView.height = size.height+10;
        BMKActionPaopaoView *papaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paoView];
        
        newAnnotationView.paopaoView = papaoView;
        return newAnnotationView;
    }else if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }else if ([annotation isKindOfClass:[OrderPointAnnotation class]]) {
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:kOrderPointAnnotationID];
        if (newAnnotationView == nil) {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kOrderPointAnnotationID];
            // 设置颜色
            newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            newAnnotationView.animatesDrop = YES;
            // 设置可拖拽
            newAnnotationView.draggable = YES;
            newAnnotationView.animatesDrop = YES;
            newAnnotationView.annotation = annotation;
            newAnnotationView.canShowCallout = YES;
        }
        
        //这里我根据自己需要，继承了BMKPointAnnotation，添加了标注的类型等需要的信息
        OrderPointAnnotation *tt = (OrderPointAnnotation *)annotation;
        if ([tt.orderObj.typeTextf isEqualToString:@"冷库"]) {
            newAnnotationView.image = kIMAGE(@"冷库");
        }else{
            newAnnotationView.image = kIMAGE(@"建材");
        }
        return newAnnotationView;
    }
    return nil;
}

/**
 * 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[OrderPointAnnotation class]]) {
        OrderPointAnnotation *orderPoint = (OrderPointAnnotation *)view.annotation;
        OrderInfoObj *orderObj = orderPoint.orderObj;
//        self.carTypeTextField.text = orderObj.typeTextf;
        self.endTextField.text = orderObj.pontAddrf;
        NSArray *points = [orderObj.pointCoordinatef componentsSeparatedByString:@","];
        CLLocationCoordinate2D coord;
        coord.latitude = [[points lastObject] doubleValue];
        coord.longitude = [[points firstObject] doubleValue];
        self.endLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        self.endProvince = orderObj.provincef;
        self.endCity = orderObj.cityf;
        self.isStart = NO;

        if (!kIsObjectEmpty(self.startCity) && !kIsObjectEmpty(self.endCity)) {
            
            self.driverType = 1;
            [self onClickDriveSearch];
            [self updateWillOrderInfo];
        }
    }
//    _shopCoor = view.annotation.coordinate;
}

/**
 *  选中气泡调用方法
 *  @param mapView 地图
 *  @param view    annotation
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    MyBMKPointAnnotation *tt = (MyBMKPointAnnotation *)view.annotation;
//    if (tt.shopID) {
//        BusinessIfonUVC *BusinessIfonVC = [[BusinessIfonUVC alloc]init];
//        BusinessIfonVC.shopId = tt.shopID;
//        [self.navigationController pushViewController:BusinessIfonVC animated:YES];
//    }
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark --路线图
-(IBAction)onClickDriveSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
//    start.name = self.startTextField.text;
//    start.cityName = self.startCity;
    start.pt = self.starLocation.coordinate;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = self.endLocation.coordinate;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;//获取路况信息
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* annotations = [NSArray arrayWithArray:_mapView.annotations];
    [annotations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[OrderPointAnnotation class]]) {
//            [obj removeFromSuperview];
            [_mapView removeAnnotation:obj];
        }
    }];
    
    
    NSArray *overlays = [NSArray arrayWithArray:_mapView.overlays];
//    [overlays];
    [_mapView removeOverlays:overlays];
    
    WEAKSELF
    CLLocationDistance distance = 0.00f;
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            distance +=transitStep.distance;
            if(i==0){
                [self setupStartLocation];
                
                //                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                //                item.coordinate = plan.starting.location;
                //                item.title = @"起点";
                //                item.type = 0;
                //                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                [self setupEndLocation];
                //                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                //                item.coordinate = plan.terminal.location;
                //                item.title = @"终点";
                //                item.type = 1;
                //                [_mapView addAnnotation:item]; // 添加起点标注
            }else{
                
                
                
            }
            //添加annotation节点
//            RouteAnnotation* item = [[RouteAnnotation alloc]init];
//            item.coordinate = transitStep.entrace.location;
//            item.title = transitStep.entraceInstruction;
//            item.degree = transitStep.direction * 30;
//            item.type = 4;
//            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        _distance = distance;
        if (_distance>1) {
            /*
            
            // 添加途经点
            if (plan.wayPoints) {
                for (BMKPlanNode* tempNode in plan.wayPoints) {
                    RouteAnnotation* item = [[RouteAnnotation alloc]init];
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = tempNode.pt;
                    item.type = 5;
                    item.title = tempNode.name;
                    [_mapView addAnnotation:item];
                }
            }
            //轨迹点
            BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
            int i = 0;
            for (int j = 0; j < size; j++) {
                BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
                int k=0;
                for(k=0;k<transitStep.pointsCount;k++) {
                    temppoints[i].x = transitStep.points[k].x;
                    temppoints[i].y = transitStep.points[k].y;
                    i++;
                }
                
            }
            // 通过points构建BMKPolyline
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
            [_mapView addOverlay:polyLine]; // 添加路线overlay
            delete []temppoints;
            [self mapViewFitPolyLine:polyLine];*/
        }else{
            [NSString toString:@"您要运送距离太近了"];
        }
        if (self.driverType==1) {
            OrderInfoObj *obj = self.carTypeArray[self.selectIndex];
            double price = 0;
            double kmeter =kDoubleToString(distance/1000.0).doubleValue;
            if (kmeter<obj.startKmf.doubleValue) {
                //如果计算出来的公里数小于起公里数 则为起步价
                //            kmeter = obj.startKmf.doubleValue;
                price = obj.startPricef.doubleValue;
            }else{
                //如果大于 则 （总公里数-起步公里数）*每公里价格+起步价
                price = (kmeter-obj.startKmf.doubleValue)*obj.kmPricef.doubleValue +obj.startPricef.doubleValue;
            }
            _price = price;
            
            self.detailInfoLab.text = [NSString stringWithFormat:@"全程约%.2f公里，费用估计%.2f元",kmeter,price];
        }else if(self.driverType==2){
            //司机完成订单操作时计算距离和费用
            __block OrderInfoObj *_modelObj = nil;
            [self.huozhuCarTypeArray enumerateObjectsUsingBlock:^(OrderInfoObj *molObj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([molObj.namef isEqualToString:weakSelf.orderHuozhuObj.modelNamef]) {
                    _modelObj = molObj;
                    double price = 0;
                    double kmeter =kDoubleToString(distance/1000.0).doubleValue;
                    if (kmeter<_modelObj.startKmf.doubleValue) {
                        //如果计算出来的公里数小于起公里数 则为起步价
                        //            kmeter = model.startKmf.doubleValue;
                        price = _modelObj.startPricef.doubleValue;
                    }else{
                        //如果大于 则 （总公里数-起步公里数）*每公里价格+起步价
                        price = (kmeter-_modelObj.startKmf.doubleValue)*_modelObj.kmPricef.doubleValue +_modelObj.startPricef.doubleValue;
                    }
                    _price = price;
                    weakSelf.orderHuozhuObj.pricef = kDoubleToString(price);
                    weakSelf.orderHuozhuObj.kmCountf = kDoubleToString(kmeter);
                    weakSelf.orderHuozhuObj.endLocationf=_endLocationf;
                    weakSelf.orderHuozhuObj.endAddrNamef =weakSelf.carEndTextField.text;
                    NSString *info = [NSString stringWithFormat:@"全程约%.2f公里，费用估计%.2f元",kmeter,price];
                    if (weakSelf.orderHuozhuObj.tipPricef.doubleValue) {
                        info = [NSString stringWithFormat:@"全程约%.2f公里，费用估计%.2f元",kmeter,price+self.orderHuozhuObj.tipPricef.doubleValue];
                    }
                    [weakSelf.carInfoBtn setTitle:info forState:UIControlStateNormal];
                    [weakSelf.carInfoBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
                    
                    
                    [UIAlertView alertViewWithTitle:@"提示：" message:@"确定完成订单吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger buttonIndex) {
                        [weakSelf sendOrderdoEnd];
                        weakSelf.isStart = YES;
                        weakSelf.endCity = @"";
                        //        [weakSelf setupLocationService];
                        [UIView animateWithDuration:0.35 animations:^{
                            weakSelf.mapBottomLayoutConstraint.constant = 0;
                            weakSelf.orderTopLayoutConstraint.constant =0;
                            weakSelf.sijiorderTopLayoutConstraint.constant = 0;
                            weakSelf.sijiorderTopLayoutConstraint.constant = 0;
                            weakSelf.orderView.alpha = 0;
                            weakSelf.personView.alpha = 0;
                            weakSelf.callView.alpha = 1;
                            weakSelf.carOrderView.alpha = 0;
                            weakSelf.detailInfoLayoutConstraint.constant = 0;
                            weakSelf.detailInfoTopLayoutConstraint.constant = 0;
                            [weakSelf setupLocationService];
                        }];
                    } onCancel:^{
                        
                    }];
                }
            }];

        }else if (self.driverType==3){
            //司机完成订单操作时计算距离和费用
            __block OrderInfoObj *_modelObj = nil;
            [self.huozhuCarTypeArray enumerateObjectsUsingBlock:^(OrderInfoObj *molObj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([molObj.namef isEqualToString:weakSelf.orderHuozhuObj.modelNamef]) {
                    _modelObj = molObj;
                    double price = 0;
                    double kmeter =kDoubleToString(distance/1000.0).doubleValue;
                    if (kmeter<_modelObj.startKmf.doubleValue) {
                        //如果计算出来的公里数小于起公里数 则为起步价
                        //            kmeter = model.startKmf.doubleValue;
                        price = _modelObj.startPricef.doubleValue;
                    }else{
                        //如果大于 则 （总公里数-起步公里数）*每公里价格+起步价
                        price = (kmeter-_modelObj.startKmf.doubleValue)*_modelObj.kmPricef.doubleValue +_modelObj.startPricef.doubleValue;
                    }
                    _price = price;
                    weakSelf.orderHuozhuObj.pricef = kDoubleToString(price);
                    weakSelf.orderHuozhuObj.kmCountf = kDoubleToString(kmeter);
                    weakSelf.orderHuozhuObj.endLocationf=_endLocationf;
                    weakSelf.orderHuozhuObj.endAddrNamef =weakSelf.carEndTextField.text;
                    NSString *info = [NSString stringWithFormat:@"全程约%.2f公里，费用估计%.2f元",kmeter,price];
                    if (weakSelf.orderHuozhuObj.tipPricef.doubleValue) {
                        info = [NSString stringWithFormat:@"全程约%.2f公里，费用估计%.2f元",kmeter,price+self.orderHuozhuObj.tipPricef.doubleValue];
                    }
                    [weakSelf.carInfoBtn setTitle:info forState:UIControlStateNormal];
                    [weakSelf.carInfoBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
                    
                }
            }];
        }
        
    }
}

#pragma mark - 私有

- (NSString*)getMyBundlePath1:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}


#pragma mark --
/*!
 *  @author liujinliang, 16-09-30 23:09:24
 *
 *  @brief 设置控制器视图样式
 *
 *  @since <#1.0#>
 */
- (void)setupVCStyle{
    //    [self.startTextField setLayerCornerRadius:4];
    //    [self.startTextField setLayerBorderWidth:.5 color:[UIColor borderColor]];
    //    [self.startTextField setTextFieldLeftPaddingWidth:kPadding];
    //    [self.endTextField setLayerCornerRadius:4];
    //    [self.endTextField setLayerBorderWidth:.5 color:[UIColor borderColor]];
    //    [self.endTextField setTextFieldLeftPaddingWidth:kPadding];
    
    self.carPersonLayoutConstraint.constant = 0;
    self.personView.alpha = 0;
    self.pCarScoreLab.textColor = [UIColor redColor];
    self.pCarCountLab.textColor = [UIColor mainColor];
    self.orderView.alpha = 0;
    [self.callCarBtn setLayerCornerRadius:4];
    [self.callCarBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.callCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.pCarOrderBtn setLayerCornerRadius:4];
    [self.pCarOrderBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.pCarOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.carInfoBtn setLayerCornerRadius:4];
    [self.carInfoBtn setLayerBorderWidth:.5 color:[UIColor mainColor]];
    
    self.carOrderView.alpha = 0;
    [self.orderFinishBtn setLayerCornerRadius:4];
    [self.orderFinishBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.orderFinishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.cancelFinishBtn setLayerCornerRadius:4];
    [self.cancelFinishBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.cancelFinishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self.cancelBtn setLayerCornerRadius:4];
    [self.cancelBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}




#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark --查看订单
/*!
 *  @author liujinliang, 16-09-30 22:09:23
 *
 *  @brief 查看订单
 *
 *  @param sender <#sender description#>
 *
 *  @since <#1.0#>
 */
- (void)viewOrderWithAction:(UIButton *)sender{
    if (self.isReciveState) {
        [NSString toast:@"您的订单正在进行中，不能继续接单哦"];
        return;
    }
    OrderViewController *orderVC = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
    self.orderVC = orderVC;
    orderVC.delegate = self;
    kPushNav(orderVC, YES);
}

#pragma mark --开启左视图-个人中心
/*!
 *  @author liujinliang, 16-09-30 22:09:49
 *
 *  @brief 开启左视图-个人中心
 *
 *  @since <#1.0#>
 */
- (void)showMineCenterViewControllerWithAction:(UIButton *)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark --UITextFieldDelegate------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //搜索地址
    SearchAddressViewController *addressVC = [[SearchAddressViewController alloc] initWithNibName:@"SearchAddressViewController" bundle:nil];
    addressVC.delegate = self;
    addressVC.provinceName = [UserInfoObj model].provincef;
    if (textField.tag==0) {
        addressVC.searchType = SearchAddressTypeStart;
        addressVC.cityName = _cityName;
        kPushNav(addressVC, YES);
    }else if(textField.tag==1){
        addressVC.searchType = SearchAddressTypeEnd;
        addressVC.cityName = _cityName;
        kPushNav(addressVC, YES);
    }else{
        [self carTypeBtnAction:nil];
    }
    
    return NO;
}

#pragma mark --SearchAddressViewControllerDelegate
- (void)searchAddressViewController:(SearchAddressViewController *)searchAddressViewController searchAddressObj:(SearchAddressObj *)searchObj selType:(NSInteger)selType {
    _selType = selType;
    
    if (selType==0) {
        self.isStart = YES;
        [UserInfoObj model].provincef = searchObj.province;
        [[UserInfoObj model] cache];
    }else{
        
        self.isStart = NO;
    }
    searchObj.detail = [NSString stringWithFormat:@"%@%@",[NSString toString:searchObj.detail],[NSString toString:searchObj.title]];
    
    if (self.isStart) {
        UserInfoObj *user = [UserInfoObj model];
        user.provincef = searchObj.province;
        user.cityf = searchObj.city;
        [user cache];
        self.startProvince = user.provincef;
        self.startCity = user.cityf;
        self.startTextField.text = [NSString toString:searchObj.detail];
        self.cityName = searchObj.city;
        self.starLocation = [[CLLocation alloc] initWithLatitude:searchObj.coordinate.latitude longitude:searchObj.coordinate.longitude];
        _startLocationf = [NSString stringWithFormat:@"%f,%f",self.starLocation.coordinate.latitude,self.starLocation.coordinate.longitude];
        [self setupStartLocation];
    }else{
        self.endProvince = searchObj.province;
        self.endCity = searchObj.city;
        self.endTextField.text = [NSString toString:searchObj.detail];
        self.endLocation = [[CLLocation alloc] initWithLatitude:searchObj.coordinate.latitude longitude:searchObj.coordinate.longitude];
        _endLocationf = [NSString stringWithFormat:@"%f,%f",self.endLocation.coordinate.latitude,self.endLocation.coordinate.longitude];
    
    }
    
    if (![self.lastCityName isEqualToString:self.startCity] && self.isStart) {
        [self sendFreighttoPriceWithProvincef:searchObj.province cityf:searchObj.city];
        self.lastCityName = self.startCity;
    }
    
    if ([UserInfoObj model].userTypef.integerValue==2) {
        //如果是司机，定时查询待接订单
        //身份是司机的也可以是货主，所以要执行以下接口检查，如果司机作为货主下单了，检查司机的货有没有被接单
    }
    if (!kIsObjectEmpty(self.startCity) && !kIsObjectEmpty(self.endCity)) {
        
        self.driverType = 1;
        [self onClickDriveSearch];
        [self updateWillOrderInfo];
    }
    //检索位置
//    BMKReverseGeoCodeOption *coordinate = [[BMKReverseGeoCodeOption alloc] init];
//    coordinate.reverseGeoPoint = (CLLocationCoordinate2D)searchObj.coordinate;
//    [_mapSearch reverseGeoCode:coordinate];
    
    
}

#pragma mark --OrderViewControllerDelegate抢单成功后的回调处理----
- (void)orderViewController:(OrderViewController *)orderViewController orderObj:(OrderInfoObj *)orderObj isOrderRecive:(BOOL)isOrderRecive {
    self.isReciveState = YES;
    if (isOrderRecive) {
        [self reciveOrderWithOrderObj:orderObj];
    }
    
}

- (void)setupCheckOrderState {
    if (self.checkTimer) {
        dispatch_source_cancel(self.checkTimer);
        self.checkTimer = nil;
    }
    
    WEAKSELF
    
    //如果接单则不需要有新订单提醒
    // 队列（队列时用来确定该定时器存在哪个队列中）
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建GCD定时器
    self.checkTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
    // 时间间隔
    uint64_t interval = 1 * NSEC_PER_SEC;
    
    // 设置GCD定时器开始时间，间隔时间
    dispatch_source_set_timer(self.checkTimer, start, interval, 0);
    // GCD定时器处理回调方法
    dispatch_source_set_event_handler(self.checkTimer, ^{
        DLog(@"sendOrdertoReLoad---------%@", [NSThread currentThread]);
        [weakSelf checkOrderWithOrderObj:weakSelf.orderHuozhuObj];
    });
    
    dispatch_source_set_cancel_handler(self.checkTimer, ^{
        NSLog(@"cancel");
        
    });
    
    // GCD定时器启动，默认是关闭的
    dispatch_resume(self.checkTimer);
}

#pragma mark --司机接单后检查订单状态
- (void)checkOrderWithOrderObj:(OrderInfoObj *)orderObj{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:orderObj.provincef forKey:@"vo.provincef"];
    [params addUnEmptyString:orderObj.cityf forKey:@"vo.cityf"];
    [params addUnEmptyString:orderObj.ownerIdf forKey:@"vo.ownerIdf"];
    [params addUnEmptyString:orderObj.orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:@"YES" forKey:kIsHideLoadingView];
    
    WEAKSELF
    [OrderInfoObj sendOrdertoReLoadWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        NSDictionary *dic = response.responseObject;
        OrderInfoObj *order = [OrderInfoObj mj_objectWithKeyValues:dic];
        //0:未接单 1：已接单 2：未支付  3:已支付 4：已取消
        if (order.order){
            
            OrderInfoObj *obj = order.order;
            if (obj.statusf.integerValue==4){
                [weakSelf pCarorderBtnAction:nil];
                if (weakSelf.checkTimer) {
                    dispatch_source_cancel(weakSelf.checkTimer);
                    weakSelf.checkTimer = nil;
                }
                if (obj.cancelManf.integerValue==0) {
                    [NSString toast:@"订单已被货主取消"];
                }else{
                    [NSString toast:@"订单已被司机取消"];
                }
            }
        }
    }];
}

#pragma mark --已接单后显示
- (void)reciveOrderWithOrderObj:(OrderInfoObj *)orderObj {
    self.orderHuozhuObj = orderObj;
    self.reciveOrder = orderObj;
    
    self.isReciveState = YES;
    self.carStartTextField.text = orderObj.startAddrNamef;
    self.carEndTextField.text = orderObj.endAddrNamef;
    NSString *info = [NSString stringWithFormat:@"全程约%.2f公里，费用估计%.2f元",orderObj.kmCountf.doubleValue,orderObj.pricef.doubleValue];
    if (orderObj.tipPricef.doubleValue) {
        info = [NSString stringWithFormat:@"全程约%.2f公里，费用估计%.2f元",orderObj.kmCountf.doubleValue,orderObj.pricef.doubleValue+orderObj.tipPricef.doubleValue];
    }
    [self.carInfoBtn setTitle:info forState:UIControlStateNormal];
    [self.carInfoBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    
    NSArray *starts = [orderObj.startLocationf componentsSeparatedByString:@","];
    self.starLocation = [[CLLocation alloc] initWithLatitude:[[starts firstObject] doubleValue] longitude:[[starts lastObject] doubleValue]];
    NSArray *ends = [orderObj.endLocationf componentsSeparatedByString:@","];
    self.endLocation = [[CLLocation alloc] initWithLatitude:[[ends firstObject] doubleValue] longitude:[[ends lastObject] doubleValue]];
    
    [self onClickDriveSearch];
    //接单后实时检查订单状态
    [self setupCheckOrderState];
    WEAKSELF
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.mapBottomLayoutConstraint.constant = 35;
        weakSelf.orderTopLayoutConstraint.constant =0;
        weakSelf.sijiorderTopLayoutConstraint.constant = -weakSelf.mapBottomLayoutConstraint.constant;
        weakSelf.orderView.alpha = 0;
        weakSelf.personView.alpha = 0;
        weakSelf.callView.alpha = 0;
        weakSelf.carOrderView.alpha = 1;
        weakSelf.detailInfoLayoutConstraint.constant = 0;
        weakSelf.detailInfoTopLayoutConstraint.constant = 0;
    }];

}

#pragma mark --
#pragma mark --MyPayTypeViewDelegate
- (void)myPayTypeViewController:(MyPayTypeViewController *)myPayTypeViewController payStatus:(NSInteger)payStatus orderObj:(OrderInfoObj *)orderObj{
    
    [self pCarorderBtnAction:nil];
    /*
    AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
    appraiseVC.orderObj =orderObj;
    appraiseVC.viewType = 1;
    kPushNav(appraiseVC, YES);*/
//    if (payStatus==1) {
//        
//    }
    
}

#pragma mark --提示确认叫车
- (IBAction)callCarBtnAction:(UIButton *)sender {
    WEAKSELF
    if (kIsObjectEmpty(self.startTextField.text)) {
        [NSString toast:@"请选择开始位置或检查您的定位功能有没有开启"];
        return;
    }
    if (kIsObjectEmpty(self.endTextField.text)) {
        [NSString toast:@"请选择您要送货的终点位置"];
        return;
    }
    if (kIsObjectEmpty(self.carTypeTextField.text)) {
        [NSString toast:@"请选择送货的车型"];
        return;
    }
    [UIAlertView alertViewWithTitle:@"提示" message:@"您确认要叫车吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger buttonIndex) {
        [weakSelf sendOrderdoInsert];
    } onCancel:^{
        
    }];
}

#pragma mark --打开手机导航系统或web订单导航
- (IBAction)carLocationBtnAction:(id)sender {
    self.driverType = 3;
    WEAKSELF
    
    NSArray *starts = [self.orderHuozhuObj.startLocationf componentsSeparatedByString:@","];
    self.starLocation = [[CLLocation alloc] initWithLatitude:[[starts firstObject] doubleValue] longitude:[[starts lastObject] doubleValue]];
    NSArray *ends = [self.orderHuozhuObj.endLocationf componentsSeparatedByString:@","];
    self.endLocation = [[CLLocation alloc] initWithLatitude:[[ends firstObject] doubleValue] longitude:[[ends lastObject] doubleValue]];
//    NSArray *ends = [self.orderHuozhuObj.endLocationf componentsSeparatedByString:@","];
//    self.endLocation = [[CLLocation alloc] initWithLatitude:[[ends firstObject] doubleValue] longitude:[[ends lastObject] doubleValue]];
    
    
    //起点
    
    CLLocationCoordinate2D coords1 = self.starLocation.coordinate;
    
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
    
    //目的地的位置
    
    CLLocationCoordinate2D coords2 = self.endLocation.coordinate;
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
    
    toLocation.name =self.orderHuozhuObj.endAddrNamef;
    
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    //打开苹果自身地图应用，并呈现特定的item
    
    [MKMapItem openMapsWithItems:items launchOptions:options];
    
     /*
    [[EndOrderLocationServer sharedLocationServer] setupLocationServiceWithComplete:^(OrderInfoObj *oderObj) {
        
        weakSelf.endCity = oderObj.cityf;
        weakSelf.endProvince = oderObj.provincef;
        weakSelf.carEndTextField.text = oderObj.endAddrNamef;
        weakSelf.endLocation = oderObj.endLocation;
       
        _endLocationf = [NSString stringWithFormat:@"%f,%f",oderObj.endLocation.coordinate.latitude,oderObj.endLocation.coordinate.longitude];
   
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params addUnEmptyString:weakSelf.orderHuozhuObj.provincef forKey:@"vo.provincef"];
        [params addUnEmptyString:weakSelf.orderHuozhuObj.cityf forKey:@"vo.cityf"];
        
        [OrderInfoObj sendFreighttoPriceWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
            if (kISKIND_OF_CLASS_NSARRAY(response.responseModel)) {
                
                NSArray *modelf =  response.responseModel;
                weakSelf.huozhuCarTypeArray = [NSMutableArray arrayWithArray:modelf];
                [weakSelf onClickDriveSearch];
                
            }
            
        } failedBlock:^(HttpRequest *request, HttpResponse *response) {
            if (kISKIND_OF_CLASS_NSARRAY(response.responseModel)) {
                
                NSArray *modelf =  response.responseModel;
                weakSelf.huozhuCarTypeArray = [NSMutableArray arrayWithArray:modelf];
                [weakSelf onClickDriveSearch];
                
            }
        }];
        
        
    }];
*/
}

#pragma mark --拨打电话联系货主
- (IBAction)makeCallHuoZhuBtnAction:(id)sender {
    [self.view makeCallWithPhone:self.orderHuozhuObj.ownerIdf];
}

#pragma mark --拨打电话联系司机
- (IBAction)makeCallSiJiBtnAction:(id)sender {
    [self.view makeCallWithPhone:self.orderSiJiObj.linkPhonef];
}

#pragma mark --司机操作取消dingdan
- (IBAction)cancelFinishBtnAction:(id)sender {
    WEAKSELF
    [UIAlertView alertViewWithTitle:@"提示" message:@"您确认要取消订单吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger buttonIndex) {
        weakSelf.isReciveState = NO;
        [weakSelf sendOrderdoCancelWithOrderNof:self.orderHuozhuObj.orderNof cancelManf:[UserInfoObj model].userTypef];
    } onCancel:^{
        
    }];
}

#pragma mark --司机操作完成订单
- (IBAction)finishOrderBtnAction:(UIButton *)sender {
    //关闭司机接单提示层
    self.isReciveState = NO;

    self.endTextField.text = @"";

    WEAKSELF
    self.driverType = 2;
    
    [[EndOrderLocationServer sharedLocationServer] setupLocationServiceWithComplete:^(OrderInfoObj *oderObj) {
        weakSelf.endCity = oderObj.cityf;
        weakSelf.endProvince = oderObj.provincef;
        weakSelf.carEndTextField.text = oderObj.endAddrNamef;
        weakSelf.endLocation = oderObj.endLocation;
        
//        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(_starLocation.coordinate.latitude, _starLocation.coordinate.longitude));
//        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(oderObj.endLocation.coordinate.latitude, oderObj.endLocation.coordinate.longitude));
        _endLocationf = [NSString stringWithFormat:@"%f,%f",oderObj.endLocation.coordinate.latitude,oderObj.endLocation.coordinate.longitude];
//        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
//        _distance = distance;
//        NSLog(@"距离: %0.2f米", distance);
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params addUnEmptyString:weakSelf.orderHuozhuObj.provincef forKey:@"vo.provincef"];
        [params addUnEmptyString:weakSelf.orderHuozhuObj.cityf forKey:@"vo.cityf"];
        
        [OrderInfoObj sendFreighttoPriceWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
            if (kISKIND_OF_CLASS_NSARRAY(response.responseModel)) {
                
                NSArray *modelf =  response.responseModel;
                weakSelf.huozhuCarTypeArray = [NSMutableArray arrayWithArray:modelf];
                [weakSelf onClickDriveSearch];
                
            }
            
        } failedBlock:^(HttpRequest *request, HttpResponse *response) {
            if (kISKIND_OF_CLASS_NSARRAY(response.responseModel)) {
                
                NSArray *modelf =  response.responseModel;
                weakSelf.huozhuCarTypeArray = [NSMutableArray arrayWithArray:modelf];
                [weakSelf onClickDriveSearch];
                
            }
        }];
       
        
    }];

    
}

#pragma mark --优惠劵查询接口
- (void)sendDiscoupontoUserWithOrderObj:(OrderInfoObj *)orderObj{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[UserInfoObj model].mobilePhonef forKey:@"queryMap.phonef"];
    [params addUnEmptyString:@"0" forKey:@"isUsef"];
    [CoupontoUserObj sendDiscoupontoUserWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        NSArray *datas = response.responseModel;
        if (kISKIND_OF_CLASS_NSARRAY(datas) && datas.count) {
            __block CoupontoUserObj *coupontoObj = nil;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [datas enumerateObjectsUsingBlock:^(CoupontoUserObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if(obj.couponCountf>=orderObj.pricef.doubleValue && obj.isUsef.integerValue==0 && !obj.isExpiryDatef){
                        coupontoObj = obj;
                        *stop = YES;
                    }
                }];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //如果优惠券金额>=订单金额，且可使用和没过期可直接抵扣，否则进入支付页面进行支付
                    if (coupontoObj) {
                        orderObj.couponIdf = coupontoObj.idf;
                        [weakSelf sendDiscoupontoUseWithOrderObj:orderObj];
                    }else{
                        MyPayTypeViewController *payVC = [[MyPayTypeViewController alloc] initWithNibName:@"MyPayTypeViewController" bundle:nil];
                        payVC.title = @"支付方式";
                        payVC.delegate = self;
                        payVC.orderObj = orderObj;
                        kPushNav(payVC, YES);
                        //                    [weakSelf.timer invalidate];
                    }
                });
            });
            
            
        }else{
            MyPayTypeViewController *payVC = [[MyPayTypeViewController alloc] initWithNibName:@"MyPayTypeViewController" bundle:nil];
            payVC.title = @"支付方式";
            payVC.delegate = self;
            payVC.orderObj = orderObj;
            kPushNav(payVC, YES);
//            [weakSelf.timer invalidate];
        }
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        MyPayTypeViewController *payVC = [[MyPayTypeViewController alloc] initWithNibName:@"MyPayTypeViewController" bundle:nil];
        payVC.title = @"支付方式";
        payVC.delegate = self;
        payVC.orderObj = orderObj;
        kPushNav(payVC, YES);
//        [weakSelf.timer invalidate];
    }];
}

#pragma mark --优惠劵使用接口
- (void)sendDiscoupontoUseWithOrderObj:(OrderInfoObj *)orderObj{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:orderObj.orderNof forKey:@"orderNof"];
    [params addUnEmptyString:orderObj.couponIdf forKey:@"couponIdf"];
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    [OrderInfoObj sendCoupontoPayWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        [self pCarorderBtnAction:nil];
        //已完成支付才可以评价
//        AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
//        appraiseVC.orderObj =orderObj;
//        appraiseVC.viewType = 1;
//        kPushNav(appraiseVC, YES);
        [NSString toast:@"您的订单已用优惠券抵扣支付成功"];
        
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
         [self pCarorderBtnAction:nil];
        //已完成支付才可以评价
//        AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
//        appraiseVC.orderObj =orderObj;
//        appraiseVC.viewType = 1;
//        kPushNav(appraiseVC, YES);
       
        [NSString toast:@"您的订单已用优惠券抵扣支付成功"];
    }];
}


#pragma mark --选择车型
- (IBAction)carTypeBtnAction:(UIButton *)sender {
    WEAKSELF
    if (self.carTypeArray.count<1 && self.cityName.isEmpty) {
        [NSString toast:@"为了不影响您的正常使用，请开启定位功能"];
        return;
    }
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:self.carTypeArray.count];
    [self.carTypeArray enumerateObjectsUsingBlock:^(OrderInfoObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [rows addObject:obj.namef];
    }];
    [ActionSheetStringPicker showPickerWithTitle:@"请选择车型" rows:rows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        _index = 0;
        weakSelf.selectIndex = selectedIndex;
        weakSelf.carTypeTextField.text = selectedValue;
        [weakSelf updateWillOrderInfo];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.navigationController.view];
}

#pragma mark --取消订单
- (IBAction)cancelBtnAction:(id)sender {
    WEAKSELF
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定取消订单？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger buttonIndex) {
        [weakSelf sendOrderdoCancelWithOrderNof:weakSelf.orderNof cancelManf:[UserInfoObj model].userTypef];
    } onCancel:^{
        
    }];
    
}

#pragma mark --加小费
- (IBAction)addCostBtnAction:(id)sender {
    WEAKSELF
    NSArray *rows = @[@"5",@"10",@"20",@"30"];
    [ActionSheetStringPicker showPickerWithTitle:@"小费金额" rows:rows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [sender setTitle:[NSString stringWithFormat:@"加小费(%@)",selectedValue] forState:UIControlStateNormal];
        [weakSelf sendOrdertoTipWithOrderNof:weakSelf.orderNof tipPricef:selectedValue];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.navigationController.view];
    
}

#pragma mark --立即下单
- (IBAction)pCarorderBtnAction:(UIButton *)sender {
    //继续操作下单
    self.orderNof = @"";
    self.orderHuozhuObj = nil;
    if (self.checkTimer) {
        dispatch_source_cancel(self.checkTimer);
        self.checkTimer = nil;
    }
    WEAKSELF
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.mapBottomLayoutConstraint.constant = 0;
        weakSelf.orderTopLayoutConstraint.constant =0;
        weakSelf.detailInfoLayoutConstraint.constant = 0;
        weakSelf.detailInfoTopLayoutConstraint.constant = 0;
        weakSelf.carPersonLayoutConstraint.constant = 0;
        weakSelf.orderView.alpha = 0;
        weakSelf.personView.alpha = 0;
        weakSelf.callView.alpha = 1;
        weakSelf.carOrderView.alpha = 0;
        [weakSelf resetLocation];
        [weakSelf setupLocationService];
    }];
}


#pragma mark --更新预订单信息

/**
 更新预订单信息
 */
- (void)updateWillOrderInfo {
    
    if (self.startTextField.text.length>0 && self.endTextField.text.length>0 && self.carTypeTextField.text.length>0 && self.orderView.alpha==0) {

        _startLocationf = [NSString stringWithFormat:@"%f,%f",_starLocation.coordinate.latitude,_starLocation.coordinate.longitude];
        _endLocationf = [NSString stringWithFormat:@"%f,%f",_endLocation.coordinate.latitude,_endLocation.coordinate.longitude];

        OrderInfoObj *obj = self.carTypeArray[self.selectIndex];
        double price = 0;
        double kmeter =kDoubleToString(_distance/1000.0).doubleValue;
        if (kmeter<obj.startKmf.doubleValue) {
            //如果计算出来的公里数小于起公里数 则为起步价
//            kmeter = obj.startKmf.doubleValue;
            price = obj.startPricef.doubleValue;
        }else{
            //如果大于 则 （总公里数-起步公里数）*每公里价格+起步价
            price = (kmeter-obj.startKmf.doubleValue)*obj.kmPricef.doubleValue +obj.startPricef.doubleValue;
        }
        _price = price;
        
        self.detailInfoLab.text = [NSString stringWithFormat:@"全程约%.2f公里，费用估计%.2f元",kmeter,price];
        self.detailInfoLayoutConstraint.constant = 20;
        self.detailInfoTopLayoutConstraint.constant = 10;
        self.carPersonLayoutConstraint.constant = 0;
        self.detailInfoLab.alpha = 1;
        self.personView.alpha = 0;
//        [self.view needsUpdateConstraints];
    }else{
        self.detailInfoLab.alpha = 0;
        self.detailInfoLayoutConstraint.constant = 0;
        self.detailInfoTopLayoutConstraint.constant = 0;
    }
}
#pragma mark --服务器数据请求
#pragma mark --运价查询接口
/**
 运价查询接口

 @param provincef <#provincef description#>
 @param cityf     <#cityf description#>
 */
- (void)sendFreighttoPriceWithProvincef:(NSString *)provincef
                                  cityf:(NSString *)cityf{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:provincef forKey:@"vo.provincef"];
    [params addUnEmptyString:cityf forKey:@"vo.cityf"];
    
    [OrderInfoObj sendFreighttoPriceWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (kISKIND_OF_CLASS_NSARRAY(response.responseModel)) {
            
            weakSelf.carTypeArray = response.responseModel;
//            weakSelf.selectIndex = 0;
//            OrderInfoObj *obj = weakSelf.carTypeArray[0];
//            weakSelf.carTypeTextField.text = obj.namef;
        }
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --用于加小费
- (void)sendOrdertoTipWithOrderNof:(NSString *)orderNof tipPricef:(NSString *)tipPricef{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:tipPricef forKey:@"vo.tipPricef"];
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    
    [OrderInfoObj sendOrdertoTipWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
//        NSArray *data  = response.responseModel;
//        weakSelf.costDataArray = [NSMutableArray array];
//        __block NSMutableArray *costs = weakSelf.costDataArray;
//        [data enumerateObjectsUsingBlock:^(OrderInfoObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [costs addObject:<#(nonnull id)#>]
//        }];
        
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --取消订单接口
/**
 取消订单接口

 @param orderNof   订单号
 @param cancelManf 取消方  0货主 1司机
 */
- (void)sendOrderdoCancelWithOrderNof:(NSString *)orderNof cancelManf:(NSString *)cancelManf{
    WEAKSELF
    //vo.cancelManf 取消方  0货主 1司机
    cancelManf = [UserInfoObj model].userTypef.integerValue==2?@"1":@"0";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:cancelManf forKey:@"vo.cancelManf"];
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    
    [OrderInfoObj sendOrderdoCancelWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        [UIView animateWithDuration:.35 animations:^{
//            weakSelf.orderView.alpha = 0;
//            weakSelf.mapBottomLayoutConstraint.constant = 0;
//            weakSelf.orderTopLayoutConstraint.constant = 0;
//            weakSelf.detailInfoLayoutConstraint.constant = 20;
//            weakSelf.detailInfoTopLayoutConstraint.constant = 10;
//            weakSelf.carPersonLayoutConstraint.constant = 0;
//            weakSelf.sijiorderTopLayoutConstraint.constant = 0;
//            weakSelf.personView.alpha = 0;
            weakSelf.mapBottomLayoutConstraint.constant = 0;
            weakSelf.orderTopLayoutConstraint.constant =0;
            weakSelf.sijiorderTopLayoutConstraint.constant = 0;
            weakSelf.sijiorderTopLayoutConstraint.constant = 0;
            weakSelf.orderView.alpha = 0;
            weakSelf.personView.alpha = 0;
            weakSelf.callView.alpha = 1;
            weakSelf.carOrderView.alpha = 0;
            weakSelf.detailInfoLayoutConstraint.constant = 0;
            weakSelf.detailInfoLab.alpha = 0;
            weakSelf.detailInfoTopLayoutConstraint.constant = 0;

            [weakSelf setupLocationService];
            [weakSelf.view needsUpdateConstraints];
        }];
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [UIView animateWithDuration:.35 animations:^{
//            weakSelf.orderView.alpha = 0;
//            weakSelf.mapBottomLayoutConstraint.constant = 0;
//            weakSelf.orderTopLayoutConstraint.constant = 0;
//            weakSelf.detailInfoLayoutConstraint.constant = 20;
//            weakSelf.sijiorderTopLayoutConstraint.constant = 0;
//            weakSelf.detailInfoTopLayoutConstraint.constant = 10;
//            weakSelf.carPersonLayoutConstraint.constant = 0;
//            weakSelf.personView.alpha = 0;
            
            weakSelf.mapBottomLayoutConstraint.constant = 0;
            weakSelf.orderTopLayoutConstraint.constant =0;
            weakSelf.sijiorderTopLayoutConstraint.constant = 0;
            weakSelf.sijiorderTopLayoutConstraint.constant = 0;
            weakSelf.orderView.alpha = 0;
            weakSelf.personView.alpha = 0;
            weakSelf.callView.alpha = 1;
            weakSelf.carOrderView.alpha = 0;
            weakSelf.detailInfoLayoutConstraint.constant = 0;
            weakSelf.detailInfoTopLayoutConstraint.constant = 0;
            weakSelf.detailInfoLab.alpha = 0;
            [weakSelf.view needsUpdateConstraints];
            [weakSelf setupLocationService];
        }];

    }];
}
#pragma mark --货主（或司机作为货主用户时）订单添加接口
/**
 订单添加接口
 
 @param provincef <#provincef description#>
 @param cityf     <#cityf description#>
 */
- (void)sendOrderdoInsert{
    if (kIsObjectEmpty(self.endTextField.text)) {
        [NSString toast:@"请选择终点"];
        return;
    }
    if (kIsObjectEmpty(self.carTypeTextField.text)) {
        [NSString toast:@"请选择车型"];
        return;
    }
    [self.addCostBtn setTitle:[NSString stringWithFormat:@"加小费"] forState:UIControlStateNormal];
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:self.startTextField.text forKey:@"vo.startAddrNamef"];
    [params addUnEmptyString:self.endTextField.text forKey:@"vo.endAddrNamef"];
    [params addUnEmptyString:self.startProvince forKey:@"vo.provincef"];
    [params addUnEmptyString:self.startCity forKey:@"vo.cityf"];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.ownerIdf"];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.mobilePhonef"];
    [params addUnEmptyString:_startLocationf forKey:@"vo.startLocationf"];
    [params addUnEmptyString:_endLocationf forKey:@"vo.endLocationf"];
    [params addUnEmptyString:kDoubleToString(_distance/1000) forKey:@"vo.kmCountf"];
    [params addUnEmptyString:kDoubleToString(_price) forKey:@"vo.pricef"];
    [params addUnEmptyString:@"0" forKey:@"vo.statusf"];
    [params addUnEmptyString:@"0" forKey:@"vo.payStatusf"];
    [params addUnEmptyString:self.carTypeTextField.text forKey:@"vo.modelNamef"];
    [params addUnEmptyString:@"app" forKey:@"requestType"];

    [OrderInfoObj sendOrderdoInsertWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
//        if (!kIsObjectEmpty(response.result)) {
        
            weakSelf.orderNof = response.result;
            weakSelf.orderStartTextField.text = weakSelf.startTextField.text;
            weakSelf.orderEndTextField.text = weakSelf.endTextField.text;
            WEAKSELF
            [UIView animateWithDuration:.35 animations:^{
                weakSelf.detailInfoLayoutConstraint.constant = 0;
                weakSelf.detailInfoTopLayoutConstraint.constant = 0;
                weakSelf.detailInfoLab.alpha = 0;
                weakSelf.orderView.alpha = 1;
                weakSelf.personView.alpha = 0;
            }];
//            [weakSelf.view needsUpdateConstraints];

//        }
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
//        if (!kIsObjectEmpty(response.result)) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return;
        }
            weakSelf.orderNof = response.result;
            weakSelf.orderStartTextField.text = weakSelf.startTextField.text;
            weakSelf.orderEndTextField.text = weakSelf.endTextField.text;
            WEAKSELF
            [UIView animateWithDuration:.35 animations:^{
                weakSelf.detailInfoLayoutConstraint.constant = 0;
                weakSelf.detailInfoTopLayoutConstraint.constant = 0;
                weakSelf.detailInfoLab.alpha = 0;
                weakSelf.orderView.alpha = 1;
                weakSelf.personView.alpha = 0;
            }];
//            [weakSelf.view needsUpdateConstraints];

//        }
    }];
}

#pragma mark --每一秒执行一次 （重复性）
- (void)startTimerServlet {
//    每一秒执行一次 （重复性）
//    [self performSelector:@selector(sendOrdertoReLoad) withObject:nil afterDelay:1];
    
    if (self.disTimer) {
        dispatch_source_cancel(self.disTimer);
        self.disTimer = nil;
    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    WEAKSELF
    
    //如果接单则不需要有新订单提醒
    // 队列（队列时用来确定该定时器存在哪个队列中）
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建GCD定时器
    self.disTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);
    // 时间间隔
    uint64_t interval = 1 * NSEC_PER_SEC;
    
    // 设置GCD定时器开始时间，间隔时间
    dispatch_source_set_timer(self.disTimer, start, interval, 0);
    // GCD定时器处理回调方法
    dispatch_source_set_event_handler(self.disTimer, ^{
        DLog(@"sendOrdertoReLoad---------%@", [NSThread currentThread]);
        [weakSelf sendOrdertoReLoad];
    });
    
    dispatch_source_set_cancel_handler(self.disTimer, ^{
        NSLog(@"cancel");
       
    });
    
    // GCD定时器启动，默认是关闭的
    dispatch_resume(self.disTimer);
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(playSound) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantPast]];
    NSRunLoop *runLoop=[NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
//    dispatch_time_ttime=dispatch_time(DISPATCH_TIME_NOW,3NSEC_PER_SEC);dispatch_after(time,dispatch_get_main_queue(),^{NSLog(@"3秒后添加到队列");})
//    ;}
    
}

#pragma mark --用于查询运费点类别
- (void)sendApptoPointType {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    WEAKSELF
    [OrderInfoObj sendApptoPointTypeWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        
        weakSelf.pointDataArray = response.responseModel;
        NSMutableArray *rows = [NSMutableArray arrayWithCapacity:self.carTypeArray.count];
        [weakSelf.pointDataArray enumerateObjectsUsingBlock:^(OrderInfoObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [rows addObject:obj.bdValuef];
        }];
        
        [ActionSheetStringPicker showPickerWithTitle:@"请选择类别" rows:rows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            OrderInfoObj *orderObj = weakSelf.pointDataArray[selectedIndex];
            [weakSelf sendGoodpointtoMarksWithTypef:orderObj.idf];
            
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:weakSelf.navigationController.view];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --用于查询周边的运货点
- (void)sendGoodpointtoMarksWithTypef:(NSString *)typef{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].provincef forKey:@"vo.provincef"];
    [params addUnEmptyString:[UserInfoObj model].cityf forKey:@"vo.cityf"];
    [params addUnEmptyString:_startLocationf forKey:@"vo.pointCoordinatef"];
    [params addUnEmptyString:typef forKey:@"vo.typef"];
    [params addUnEmptyString:@"post" forKey:@"method"];
    WEAKSELF
    [OrderInfoObj sendGoodpointtoMarksWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        NSArray *datas =response.responseModel;
        if (!datas.count ||datas==nil) {
            return ;
        }
        [weakSelf addMapPointViewWithArray:response.responseModel];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:response.responseMsg];
    }];
}

#pragma mark --对运货点进行添加标注
- (void)addMapPointViewWithArray:(NSMutableArray *)dataArray {
    WEAKSELF
    
    NSArray* annotations = [NSArray arrayWithArray:_mapView.annotations];
    [annotations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[OrderPointAnnotation class]]) {
            [_mapView removeAnnotation:obj];
        }
    }];
    
    [dataArray enumerateObjectsUsingBlock:^(OrderInfoObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *points = [obj.pointCoordinatef componentsSeparatedByString:@","];
        CLLocationCoordinate2D coord;
        coord.latitude = [[points lastObject] doubleValue];
        coord.longitude = [[points firstObject] doubleValue];
        OrderPointAnnotation *orderPoint = [[OrderPointAnnotation alloc] init];
        orderPoint.coordinate = coord;
        orderPoint.title = [NSString stringWithFormat:@"运货点：%@",obj.pontAddrf];
        orderPoint.orderObj = obj;
        [weakSelf.mapView addAnnotation:orderPoint];
    }];
}

#pragma mark --用于结束订单
- (void)sendOrderdoEnd {
    WEAKSELF
    self.driverType = 0;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:self.orderHuozhuObj.endAddrNamef forKey:@"vo.endAddrNamef"];
    [params addUnEmptyString:self.orderHuozhuObj.endLocationf forKey:@"vo.endLocationf"];
    [params addUnEmptyString:self.orderHuozhuObj.kmCountf forKey:@"vo.kmCountf"];
    
    double pricef = self.orderHuozhuObj.pricef.doubleValue+self.orderHuozhuObj.tipPricef.doubleValue;
    [params addUnEmptyString:kDoubleToString(pricef) forKey:@"vo.pricef"];
    [params addUnEmptyString:self.orderHuozhuObj.orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.driverIdf"];
    [params addUnEmptyString:self.orderHuozhuObj.ownerIdf forKey:@"vo.ownerIdf"];
    [params addUnEmptyString:@"app" forKey:@"requestType"];
    
    [OrderInfoObj sendOrderdoEndWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        NSInteger result = [response.responseObject[@"result"] integerValue];
        if (result==0 && response.responseCode) {
            [NSString stringWithFormat:@"订单异常"];
            return ;
        }
        [NSString toast:@"订单完成"];
        [weakSelf pCarorderBtnAction:nil];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
         [NSString toast:@"网络请求异常"];
    }];
}

#pragma mark --用于定时查询订单
- (void)sendOrdertoReLoad {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[UserInfoObj model].provincef forKey:@"vo.provincef"];
    [params addUnEmptyString:[UserInfoObj model].cityf forKey:@"vo.cityf"];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.ownerIdf"];
    [params addUnEmptyString:self.orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:@"YES" forKey:kIsHideLoadingView];
    
    WEAKSELF
    [OrderInfoObj sendOrdertoReLoadWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        NSDictionary *dic = response.responseObject;
        OrderInfoObj *order = [OrderInfoObj mj_objectWithKeyValues:dic];
        if (order.driverinfoVo.statusf.integerValue==1) {
            weakSelf.isReciveState = YES;
        }
        weakSelf.orderCount = order.count.integerValue;
        if (self.orderVC) {
            [self.orderVC headerRefresh];
        }
        if(order.count.integerValue){

            if ([UserInfoObj model].userTypef.integerValue==2) {
                if (!self.isReciveState) {
                    [weakSelf initNavigationBarWithLogoName:nil navTitle:@"六六微货" navRight:[NSString stringWithFormat:@"查看订单(%@)",order.count] navRightAction:@selector(viewOrderWithAction:)];
                    
                }
                
            }
        }
        else{
           if ([UserInfoObj model].userTypef.integerValue==2) {
                [weakSelf initNavigationBarWithLogoName:nil navTitle:@"六六微货" navRight:[NSString stringWithFormat:@"查看订单"] navRightAction:@selector(viewOrderWithAction:)];
            }
        }
        
        if (!kIsObjectEmpty(order.driverinfoVo.carNof)) {
//            [weakSelf.timer invalidate];
            weakSelf.mapBottomLayoutConstraint.constant = -172.5;
            weakSelf.orderTopLayoutConstraint.constant =-weakSelf.mapBottomLayoutConstraint.constant;
            weakSelf.orderView.alpha = 0;
            weakSelf.personView.alpha = 1;
            weakSelf.carPersonLayoutConstraint.constant = 100;
            weakSelf.callView.alpha = 0;
            weakSelf.carOrderView.alpha = 0;
            
            weakSelf.pCarLab.text = order.driverinfoVo.driverNamef;
            weakSelf.pCarNumLab.text = [NSString stringWithFormat:@"车牌号：%@",order.driverinfoVo.carNof];
            weakSelf.pCarScoreLab.text = [NSString stringWithFormat:@"评分：%.1f",order.driverinfoVo.scoref.doubleValue];
            weakSelf.pCarCountLab.text = [NSString stringWithFormat:@"订单数：%@",order.driverinfoVo.orderCountf];
            weakSelf.orderSiJiObj = order.driverinfoVo;
        }
        //0:未接单 1：已接单 2：未支付  3:已支付 4：已取消
        if (order.order){
            if (!weakSelf.orderNof.length) {
                return ;
            }
            OrderInfoObj *obj = order.order;
            weakSelf.statusf = obj.statusf.integerValue;
            //未支付
            if (obj.statusf.integerValue==2) {
                weakSelf.driverType = 0;
                weakSelf.orderNof = @"";
                [weakSelf sendDiscoupontoUserWithOrderObj:order.order];
                
            }else if (obj.statusf.integerValue==4){
                [self pCarorderBtnAction:nil];
                if (obj.cancelManf.integerValue==0) {
                    [NSString toast:@"订单已被货主取消"];
                }else{
                    [NSString toast:@"订单已被司机取消"];
                }
                
            }else if(obj.statusf.integerValue==3){
                //已支付
                weakSelf.driverType = 0;
                
                [self pCarorderBtnAction:nil];
                
                //已完成支付才可以评价
                AppraiseViewController *appraiseVC = [[AppraiseViewController alloc] initWithNibName:@"AppraiseViewController" bundle:nil];
                appraiseVC.orderObj =obj;
                appraiseVC.viewType = 1;
                kPushNav(appraiseVC, YES);
                
                [NSString toast:@"您的订单已用优惠券抵扣支付成功"];
            }
        }
        
    }];
}


- (void)playSound {
    if (self.isReciveState||[UserInfoObj model].userTypef.integerValue!=2 ||self.orderCount==0) {
        if (player) {
            player.currentTime = 0;
            [player stop];
        }
        return;
    }
    NSString *filepath = [[NSBundle mainBundle]pathForResource:@"order" ofType:@"mp3"];
    NSData *data = [[NSData data]initWithContentsOfFile:filepath];
    if (!player) {
        player = [[AVAudioPlayer alloc]initWithData:data error:nil];
        player.numberOfLoops = 0;
    }
    if (player.isPlaying) {
        player.currentTime = 0;
    }
    [player play];
    
}

- (void)endTimer {
    if (self.timer) {
        //关闭定时器
//        [self.timer setFireDate:[NSDate distantFuture]];
        player.currentTime = 0;
        [player stop];
        player = nil;
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.timer invalidate];
        self.timer = nil;
        
//        _timer = nil; // 将 dispatch_source_t 置为nil
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
