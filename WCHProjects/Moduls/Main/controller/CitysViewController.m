//
//  CitysViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/19.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "CitysViewController.h"
#import "BaseTableView.h"
#import "CitysTableCell.h"
@interface CitysViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, copy) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@end

@implementation CitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择城市";
    [self setupTableStyle];
    [self sendCitystoCustom];
}

- (void)setupTableStyle {
    [self.cityTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingChanged];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CitysTableCell class]) bundle:nil] forCellReuseIdentifier:kCitysTableCellID];
    [self.tableView setRowHeight:kCitysTableCellHeight];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    WEAKSELF
    self.cityArray = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(OrderInfoObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.namef containsString:self.cityTextField.text]) {
            [weakSelf.cityArray addObject:obj];
        }
    }];
    [self.tableView placeholderViewShow:!self.cityArray.count];
    [self.tableView reloadData];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    CitysTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCitysTableCellID forIndexPath:indexPath];
    // Configure the cell...
    [cell setupCellInfoWith:self.cityArray[indexPath.row]];
    [cell setBottomLineStyle:row<self.cityArray.count-1?CellLineStyleRightLong:CellLineStyleLong];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(citysViewController:cityObj:)]) {
        [self.delegate citysViewController:self cityObj:self.cityArray[indexPath.row]];
        [self onBackButton];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark --用于查询城市
- (void)sendCitystoCustom {
    WEAKSELF
    [OrderInfoObj sendCitystoCustomWithParameters:[NSMutableDictionary dictionary] successBlock:^(HttpRequest *request, HttpResponse *response) {
        weakSelf.cityArray = response.responseModel;
        weakSelf.dataArray = [weakSelf.cityArray mutableCopy];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView placeholderViewShow:!weakSelf.cityArray.count];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
     
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
