//
//  ORentCarViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ORentCarViewController.h"
#import "BaseTableView.h"
#import "ORentCarTableViewCell.h"
@interface ORentCarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation ORentCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
}

- (void)setupTableViewSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"ORentCarTableViewCell" bundle:nil] forCellReuseIdentifier:kORentCarTableViewCellID];
    self.tableView.rowHeight = kORentCarTableViewCellHeight;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORentCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kORentCarTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    OrderInfoObj *orderObj = _dataArray[indexPath.row];
    [cell setupCellInfoWithObj:orderObj];
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
