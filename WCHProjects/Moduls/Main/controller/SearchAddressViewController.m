//
//  SearchAddressViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "SearchAddressViewController.h"
#import "BaseTableView.h"
#import "CitysViewController.h"

CG_INLINE int kPageSize() {
    return 15;
}
@interface SearchAddressViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,BaseTableCellDelegate,
UITextFieldDelegate,CitysViewControllerDelegate>
{
    int _curPage;
    BOOL _bFromList;
}
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITextField *cityTxtField;

@end

@implementation SearchAddressViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _poisearch.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupBackButton];
    [self setupNavigator];
    [self setupTableViewSet];
    self.cityTxtField.text = self.cityName;
    [_cityTxtField setLayerBorderWidth:.5 color:[UIColor mainColor]];
    [_cityTxtField setLayerCornerRadius:4];
    _poisearch = [[BMKPoiSearch alloc]init];
    [self.searchBar becomeFirstResponder];
//    self.searchBar.text = _cityName;
    [self onHeaderRefreshing];
    
}

- (void)setupNavigator{
    if (self.searchType==SearchAddressTypeStart) {
        self.title = @"起点位置";
    }else{
        self.title = @"终点位置";
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger tag = textField.tag;
    if (tag==100) {
        CitysViewController *cityVC = [[CitysViewController alloc] initWithNibName:@"CitysViewController" bundle:nil];
        cityVC.delegate = self;
        kPushNav(cityVC, YES);
        return NO;
    }
    return YES;
}

#pragma mark --设置检索功能
-(IBAction)onClickOk
{
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _curPage;
    citySearchOption.pageCapacity = kPageSize();
    citySearchOption.city= _cityName;
    citySearchOption.keyword = _searchBar.text;
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        
        NSLog(@"城市内检索发送成功");
        [self.tableView addFooterRefreshTarget:self action:@selector(onFooterRefreshing)];
    }
    else
    {
        [self.tableView removeFooterRefresh];
        NSLog(@"城市内检索发送失败");
    }
}

- (void)onHeaderRefreshing
{
    _curPage = 0;
    self.dataArray = [NSMutableArray array];
    NSTimeInterval delay = 0.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadProjectsOnPage:_curPage refresh:YES];
    });
}

- (void)onFooterRefreshing
{
    [self loadProjectsOnPage:(_dataArray.count + kPageSize() - 1)/kPageSize() refresh:NO];
}

- (void)loadProjectsOnPage:(int)page refresh:(BOOL)refresh
{
    if(page == 1)
    {
        [_tableView removeFooterRefresh];
        return;
    }
    _curPage = page;
    [self onClickOk];
}

#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            SearchAddressObj *obj = [SearchAddressObj new];
            obj.province = self.provinceName;
            obj.city = poi.city;
            obj.title = poi.name;
            obj.detail = poi.address;
            obj.coordinate = poi.pt;
            [self.dataArray addObject:obj];
        }
        [self.tableView reloadData];
        if (_curPage==0) {
            [self.tableView endHeaderRefreshing];
        }else{
            [self.tableView endFooterRefreshing];
        }
       
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
        [self.tableView reloadData];
    } else {
        // 各种情况的判断。。。
        [self.tableView reloadData];
    }
}


#pragma mark --UISearchBarDelegate---------
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self onHeaderRefreshing];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self onHeaderRefreshing];
    [self.view endEditing:YES];
}

- (void)setupTableViewSet {
    _tableView.backgroundColor = [UIColor backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[SearchAddressTableCell class] forCellReuseIdentifier:kSearchAddressTableCellID];
    [_tableView setRowHeight:kSearchAddressTableCellHeight];
    [self.tableView addHeaderRefreshTarget:self action:@selector(onHeaderRefreshing)];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    SearchAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchAddressTableCellID forIndexPath:indexPath];
    cell.delegate = self;
    // Configure the cell...
    [cell setupCellInfoWith:_dataArray[indexPath.row]];
    [cell setBottomLineStyle:row<_dataArray.count-1?CellLineStyleRightLong:CellLineStyleLong];
    return cell;
}

- (void)cell:(BaseTableCell *)cell tableView:(UITableView *)tableView didSelectAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(searchAddressViewController:searchAddressObj:selType:)]) {
        [_delegate searchAddressViewController:self searchAddressObj:_dataArray[indexPath.row] selType:self.searchType==SearchAddressTypeStart?0:1];
    }
    [self onBackButton];
}

#pragma mark --CitysViewControllerDelegate
- (void)citysViewController:(CitysViewController *)citysViewController cityObj:(OrderInfoObj *)cityObj {
    self.cityName = cityObj.namef;
    self.provinceName = cityObj.provincialNamef;
    self.cityTxtField.text = self.cityName;
    self.searchBar.text = @"";
    [self onHeaderRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
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
