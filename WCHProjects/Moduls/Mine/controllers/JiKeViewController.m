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
#import "StoretoLocObj.h"
#import "DutytoDecideObj.h"
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

- (IBAction)submitBtnAction:(UIButton *)sender {
    BOOL isResult = TRUE;
    for (OrderInfoObj *order in self.dataArray) {
        if (kIsObjectEmpty(order.content)) {
            isResult = NO;
            [NSString toast:order.placeholder];
            break;
        }
    }
    [self sendCustomerdoInsert_API];
    
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


/**
 vo.deptIdf	2_38
 vo.storeNamef	啦咯啦咯啦咯
 requestType	app
 vo.customerNamef	阿KKK
 vo.trueNamef	安志伟
 vo.categoryf	啦咯啦咯啦咯
 vo.createIdf	d24845ab-4662-4ba7-9a18-009fdfa2139f
 vo.intentionf	家里哈啊
 vo.telephonef	558555
 vo.tradingAreaf	空军建军节
 */
- (void)sendCustomerdoInsert_API {
    WEAKSELF
    
    NSArray *keys = @[@"vo.telephonef",@"vo.customerNamef",@"vo.categoryf",@"vo.storeNamef",@"vo.tradingAreaf",@"vo.intentionf"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        OrderInfoObj *order = self.dataArray[i];
        NSString *key = keys[i];
        [params addUnEmptyString:order.content forKey:key];
    }
    [params addUnEmptyString:[UserInfoObj model].trueNamef forKey:@"vo.trueNamef"];
    [params addUnEmptyString:[DutytoDecideObj model].storeIdf forKey:@"vo.deptIdf"];
    [params addUnEmptyString:[DutytoDecideObj model].userIdf forKey:@"vo.createIdf"];
    [OrderInfoObj sendCustomerdoInsertWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (response.responseCode == 1) {
            [weakSelf onBackButton];
            [NSString toast:@"提交成功"];
        }else{
            [NSString toast:@"提交失败"];
        }
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"提交失败"];
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
