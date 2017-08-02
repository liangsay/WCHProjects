//
//  ShopViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/5.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopViewController.h"
#import "BaseTableView.h"
#import "ShopCollectionViewCell.h"
#import "OrderInfoObj.h"
#import "NSObject+Property.h"
#import "ShopDetailViewController.h"
#import "MJRefresh.h"
@interface ShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowlayout;
/** 布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
@property (strong, nonatomic) UIButton *swithBtn;
@end

@implementation ShopViewController
{
    BOOL _isGrid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isGrid = YES;
    //设置导航栏
    [self setupNavigationItem];
    //设置table数据源
    [self setupTableViewSet];
    //初始化数据
    [self sendMallgoodstoCustom_API];
}

- (void)setupTableViewSet {
    UIView *bgV = [UIView new];
    bgV.backgroundColor = [UIColor backgroundColor];
    _flowlayout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    [_flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //左右间距
    _flowlayout.minimumInteritemSpacing = 0;
    //上下间距
    _flowlayout.minimumLineSpacing = 0;
    _collectionView.collectionViewLayout = _flowlayout;
    
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(2 , 2 , self.view.bounds.size.width - 4, self.view.bounds.size.height - 4) collectionViewLayout:flowlayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    //注册cell
    [_collectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:kShopCollectionViewCellID];
    [self addHeaderRefreshTarget:self action:@selector(sendMallgoodstoCustom_API)];
}

#pragma mark 顶部刷新
- (void)addHeaderRefreshTarget:(id)target action:(SEL)action
{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i=1; i<19; i++) {
        NSString *loadStr = [NSString stringWithFormat:@"loading-gray-%d",i];
        UIImage *loadImg = kIMAGE(loadStr);
        [idleImages addObject:[loadImg imageByScalingToSize:(CGSize){loadImg.size.width/2,loadImg.size.height/2}]];
    }
    // 设置普通状态的动画图片
    [header setImages:idleImages forState:MJRefreshStateIdle|MJRefreshStatePulling|MJRefreshStateRefreshing];
    header.backgroundColor = [UIColor backgroundColor];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    
    //    [header setImages:pullingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    
    //    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    self.collectionView.mj_header = header;
    //        if (self.mj_header && [self.mj_header isKindOfClass:[MJRefreshHeader class]]) return;
    //
    //        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    
    
}

#pragma mark 加载数据
-(void)initData{
    
//    NSString *path=[[NSBundle mainBundle] pathForResource:@"Commodity" ofType:@"plist"];
//    NSArray *array=[NSArray arrayWithContentsOfFile:path];
//    _commodity=[[NSMutableArray alloc]init];
//    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [_commodity addObject:[CommodityModel commodityWithDictionary:obj]];
//    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"product" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *products = dict[@"wareInfo"];
    for (id obj in products) {
        [self.dataSource addObject:[GridListModel objectWithDictionary:obj]];
    }
    
}
- (void)setupNavigationItem {
    kNAV_INIT(self, @"", @"", nil, @"product_list_grid_btn.png", @selector(changeClick:));
    self.swithBtn = self.navigationItem.rightBarButtonItem.customView;
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"changeProductListGrid" highBackgroudImageName:nil target:self action:@selector(changeClick)];
    //将搜索条放在一个UIView上
//    SearchBarView *searchView = [[SearchBarView alloc]initWithFrame:CGRectMake(0, 7, 240 , 30)];
//    searchView.delegate=self;
//    self.navigationItem.titleView = searchView;
//    self.navigationController.navigationBar.shadowImage=[[UIImage alloc]init];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShopCollectionViewCellID forIndexPath:indexPath];
    cell.isGrid = _isGrid;
    cell.model = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGrid) {
        return CGSizeMake((kScreenWidth - 2) / 2, (kScreenWidth - 2) / 2 + 20);
    } else {
        return CGSizeMake(kScreenWidth, kScreenWidth/ 4 + 20);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexpath: row:%d; section:%d; item:%d",indexPath.row,indexPath.section,indexPath.item);
    ShopDetailViewController *shopVC = [[ShopDetailViewController alloc] initWithNibName:@"ShopDetailViewController" bundle:nil];
    shopVC.style = 1;
    shopVC.layout = 1;
    shopVC.hidesBottomBarWhenPushed = YES;
    shopVC.orderObj = self.dataSource[indexPath.row];
    kPushNav(shopVC, YES);
}

#pragma mark - Action

- (IBAction)changeClick:(id)sender
{
    _isGrid = !_isGrid;
    if (_isGrid) {
        //上下间距
        _flowlayout.minimumLineSpacing = 2;
        //左右间距
        _flowlayout.minimumInteritemSpacing = 2;
    }else{
        //上下间距
        _flowlayout.minimumLineSpacing = 0;
        //左右间距
        _flowlayout.minimumInteritemSpacing = 0;
    }
    self.collectionView.collectionViewLayout = _flowlayout;
    [self.collectionView reloadData];
    
    if (_isGrid) {
        [self.swithBtn setImage:[UIImage imageNamed:@"product_list_list_btn"] forState:0];
    } else {
        [self.swithBtn setImage:[UIImage imageNamed:@"product_list_grid_btn"] forState:0];
    }
}

#pragma mark --查询品牌、车系下的数据
/**
 查询品牌、车系下的数据
 */
- (void)sendMallgoodstoCustom_API{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:[LocationServer shared].cityf forKey:@"vo.cityf"];
    [params addUnEmptyString:[LocationServer shared].provincef forKey:@"vo.provincef"];
    [OrderInfoObj sendMallgoodstoCustomWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.dataSource = [NSMutableArray arrayWithArray:response.responseModel];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [weakSelf.collectionView.mj_header endRefreshing];
        
    }];
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
