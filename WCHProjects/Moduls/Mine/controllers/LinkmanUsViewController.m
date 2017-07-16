//
//  LinkmanUsViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/3.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "LinkmanUsViewController.h"
#import "AboutUsTableCell.h"

@interface LinkmanUsViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableCellDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LinkmanUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableViewSet];
    
    __block NSArray *keys = @[@"版本号：",@"公司名称：",@"官方网址：",@"公司地址：",@"联系我们："];
    __block NSString *version = [NSString stringWithFormat:@"V%@",VERSION];
    NSArray *values = @[version,@"天津六六顺企业服务管理有限公司",@"http://www.66weihuo.com",@"天津市东丽区金钟河大街1666号",@"4000-300-966"];
    WEAKSELF
    _dataArray = [NSMutableArray arrayWithCapacity:keys.count];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AboutUsModel *mol = [AboutUsModel new];
        mol.keyString = obj;
        mol.valueString = values[idx];
        [weakSelf.dataArray addObject:mol];
    }];
    
}

- (void)setupTableViewSet {
    _tableView.backgroundColor = [UIColor backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[AboutUsTableCell class] forCellReuseIdentifier:kAboutUsTableCellID];
    [_tableView setRowHeight:kAboutUsTableCellHeight];
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
    AboutUsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kAboutUsTableCellID forIndexPath:indexPath];
    cell.delegate = self;
    // Configure the cell...
    [cell setupCellInfoWith:_dataArray[indexPath.row]];
    [cell setBottomLineStyle:row<_dataArray.count-1?CellLineStyleRightLong:CellLineStyleLong];
    return cell;
}

- (void)cell:(BaseTableCell *)cell tableView:(UITableView *)tableView didSelectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==4) {
        [self.view makeCallWithPhone:@"4000300966"];
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
