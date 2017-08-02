//
//  JiKeViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/19.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "JiKeViewController.h"
#import "JiKeTableViewCell.h"
#import "BaseTableView.h"
@interface JiKeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

@implementation JiKeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableSet];
    [self.submitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.submitBtn setLayerCornerRadius:5];
    NSArray *datas = @[@"请输入11位数手机号码",@"请输入客户姓名",@"请输入品类",@"请输入商品名",@"请输入商圈名",@"请输入意向"];
    for (NSString *type in datas) {
        OrderInfoObj *order = [OrderInfoObj new];
        order.placeholder = type;
        [self.dataArray addObject:order];
    }
}

- (void)setupTableSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"JiKeTableViewCell" bundle:nil]forCellReuseIdentifier:kJiKeTableViewCellID];
    self.tableView.rowHeight = kJiKeTableViewCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark --UITextFieldDelegate-------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    long leg = [toBeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    NSInteger tag = textField.tag;
    if (tag == 0) {
        if (leg > 10){
            textField.text = [toBeString substringToIndex:10];
        }
        if (![textField ChenkInputNSCharacterSet:string typeInt:2]) {
            return NO;
        }
    }else
    if (tag == 1) {
        if (leg > 20){
            textField.text = [toBeString substringToIndex:20];
        }
        
    }
    
    OrderInfoObj *order = self.dataArray[tag];
    order.content = toBeString;
    [self.dataArray replaceObjectAtIndex:tag withObject:order];
    return YES;
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
    JiKeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJiKeTableViewCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    OrderInfoObj *orderObj = _dataArray[indexPath.row];
    cell.contentTxtF.tag = indexPath.row;
    cell.contentTxtF.delegate = self;
    [cell setupCellInfoWith:orderObj];
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
