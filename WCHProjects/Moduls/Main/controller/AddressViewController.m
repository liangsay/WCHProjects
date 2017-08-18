//
//  AddressViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/9/30.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "AddressViewController.h"
#import "BaseTableView.h"
#import "CitysViewController.h"
#import "LocationServer.h"
CG_INLINE int kPageSize() {
    return 15;
}
@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableCellDelegate,
UITextFieldDelegate,CitysViewControllerDelegate>
{
    int _curPage;
    BOOL _bFromList;
}
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTxtField;
@property (weak, nonatomic) IBOutlet UITextField *cityTxtField;
@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, strong) SearchAddressObj *cityObj;

@end

@implementation AddressViewController


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
    self.provinceName = [LocationServer shared].provincef;
    self.cityName = [LocationServer shared].cityf;
    [self.submitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.submitBtn setLayerCornerRadius:5];
    
    [self.cityTxtField becomeFirstResponder];
    [self.cityTxtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _poisearch = [[BMKPoiSearch alloc]init];
    [self onHeaderRefreshing];
    
}

- (SearchAddressObj *)cityObj {
    if (!_cityObj) {
        _cityObj = [SearchAddressObj new];
    }
    return _cityObj;
}

- (UIButton *)cityBtn {
    if (!_cityBtn) {
        _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [[_cityBtn titleLabel] setFont:kFont(28)];
        [_cityBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        [_cityBtn setFrame:(CGRect){0,0,80,40}];
        [_cityBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_cityBtn addTarget:self action:@selector(cityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_cityBtn setTitle:[LocationServer shared].cityf forState:UIControlStateNormal];
    return _cityBtn;
}

- (void)setupNavigator{
    self.navigationItem.title = @"搜索地址";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityBtn];
}

- (void)cityBtnAction:(UIButton *)sender {
    CitysViewController *cityVC = [[CitysViewController alloc] initWithNibName:@"CitysViewController" bundle:nil];
    cityVC.delegate = self;
    kPushNav(cityVC, YES);
}

#pragma mark --UIButtonAction---------
- (IBAction)submitBtnAction:(UIButton *)sender {
    if (kIsObjectEmpty(self.cityTxtField.text)) {
        [NSString toast:self.nameTxtField.placeholder];
        return;
    }
    if (kIsObjectEmpty(self.cityObj.addrf)) {
        [NSString toast:@"请从地址列表选择您途径的地点"];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(addressViewController:searchAddressObj:selType:)]) {
        [_delegate addressViewController:self searchAddressObj:self.cityObj selType:0];
    }
    [self onBackButton];
}

#pragma mark --设置检索功能
-(IBAction)onClickOk
{
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = _curPage;
    citySearchOption.pageCapacity = kPageSize();
    citySearchOption.city= _cityName;
    citySearchOption.keyword = _cityTxtField.text;
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
    _cityObj = nil;
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

#pragma mark --UITextFieldDelegate-----
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger tag = textField.tag;
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    long leg = [toBeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    if (tag == 100) {
        if (leg>10) {
            textField.text = [toBeString substringToIndex:10];
        }
    }else if (tag==101){
        if (leg>10) {
            textField.text = [toBeString substringToIndex:10];
        }
        if (![textField ChenkInputNSCharacterSet:string typeInt:2]) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    //防止输入拼音状态时查询
    NSString *str = [textField textInRange:textField.markedTextRange];
    NSLog(@"textChangeAction str = %@",str);
    
    if (![str isEqualToString:@""]) {
        return;
    }
    [self onHeaderRefreshing];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchAddressObj *addObj = _dataArray[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(addressViewController:searchAddressObj:selType:)]) {
        [_delegate addressViewController:self searchAddressObj:addObj selType:0];
    }
    [self onBackButton];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark --CitysViewControllerDelegate
- (void)citysViewController:(CitysViewController *)citysViewController cityObj:(OrderInfoObj *)cityObj {
    self.cityName = cityObj.namef;
    self.provinceName = cityObj.provincialNamef;
//    [self.cityBtn setTitle:cityObj.cityf forState:UIControlStateNormal];
    self.cityTxtField.text = @"";
    _cityObj = nil;
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
