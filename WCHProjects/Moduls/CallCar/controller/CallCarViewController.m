//
//  CallCarViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/5.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "CallCarViewController.h"
#import "CallCarTableViewCell.h"
#import "BaseTableView.h"
@interface CallCarViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation CallCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
}

- (void)setupTableViewSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"CallCarTableViewCell" bundle:nil] forCellReuseIdentifier:kCallCarTableViewCellID];
    self.tableView.rowHeight = kCallCarTableViewCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
        
        [_dataArray addObject:[OrderInfoObj new]];
        [_dataArray addObject:[OrderInfoObj new]];
        [_dataArray addObject:[OrderInfoObj new]];
        [_dataArray addObject:[OrderInfoObj new]];
    }
    return _dataArray;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count) {
        UIView *headV = [UIView new];
        headV.backgroundColor = [UIColor backgroundColor];
        return headV;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CallCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCallCarTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    return cell;
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
