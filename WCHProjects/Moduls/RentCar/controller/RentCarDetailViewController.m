//
//  RentCarDetailViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/30.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "RentCarDetailViewController.h"
#import "BaseTableView.h"
#import "RentCarDetailCell.h"
#import "RentCarDetailOtherCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ActionSheetDatePicker.h"
#import "StoretoLocObj.h"
@interface RentCarDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) NSString *outTime;//借车时间
@property (nonatomic, strong) NSString *inTime;//还车时间
@property (nonatomic, strong) StoretoLocObj *storeObj;

@end

@implementation RentCarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.submitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.submitBtn setLayerCornerRadius:5];
    [self setupDataSet];
    [self setupTableSet];
}

//提交租车资料
- (IBAction)submitBtnAction:(UIButton *)sender {
    OrderInfoObj *nameObj = self.dataArray[0];
    OrderInfoObj *cardObj = self.dataArray[1];
    if (kIsObjectEmpty(nameObj.content)) {
        [NSString toast:@"请输入承租人姓名"];
        return;
    }
    if (kIsObjectEmpty(cardObj.content)) {
        [NSString toast:@"请输入身份证号"];
        return;
    }
    if (kIsObjectEmpty(self.outTime)) {
        [NSString toast:@"请选择取车时间"];
        return;
    }
    if (kIsObjectEmpty(self.inTime)) {
        [NSString toast:@"请选择还车时间"];
        return;
    }
    [self sendRentorderdoInsert_API];
}


//设置数据
- (void)setupDataSet{
    StoretoLocObj *storeObj = [StoretoLocObj model];
    self.storeObj = storeObj;
    NSArray *datas = @[@"请输入承租人姓名",@"请输入身份证号",@"请选择取车时间",@"请选择还车时间",@"",@""];
    NSDate *nowDate = [NSDate date];
    for (int i=0; i<datas.count; i++) {
        OrderInfoObj *order = [OrderInfoObj new];
        order.placeholder = datas[i];
        order.isMust = YES;
        order.iconName = @"行驶证";
        
        if (i==2) {
            self.outTime =[nowDate formatStringWithFormat:@"yyyy-MM-dd"];
            order.content = self.outTime;
        }else if (i==3){
            double otherDate = [NSDate getNowTimeTimestamp2].doubleValue + ((24 * 3600) * 2);
            self.inTime = [NSDate dateFormTimestampString:[NSString stringWithFormat:@"%.0f",otherDate * 1000] format:@"yyyy-MM-dd"];
            order.content = self.inTime;
        }
        if (i<2) {
            order.isTxt = YES;
        }else{
            order.isTxt = NO;
        }
        if (i>1 && i<4) {
            order.isSelDate = YES;
        }else{
            order.isSelDate = NO;
        }
        
        if (i==4) {
            NSString *addrf = kIsObjectEmpty(storeObj.addrf)?@"暂无":storeObj.addrf;
            order.content = [NSString stringWithFormat:@"取/还车地址:\n%@",addrf];
        }else if(i==5){
            NSString *storeNamef = kIsObjectEmpty(storeObj.storeNamef)?@"暂无":storeObj.storeNamef;
            order.content = [NSString stringWithFormat:@"取/还车门店:\n%@",storeNamef];
        }
        [self.dataArray addObject:order];
    }
    
}



//设置表
- (void)setupTableSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"RentCarDetailCell" bundle:nil] forCellReuseIdentifier:kRentCarDetailCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"RentCarDetailOtherCell" bundle:nil] forCellReuseIdentifier:kRentCarDetailOtherCellID];
    self.tableView.rowHeight = kRentCarDetailCellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

#pragma mark --UITextFieldDelegate-------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    long leg = [toBeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    NSInteger tag = textField.tag;
    if (tag == 1) {
        if (leg > 18){
            textField.text = [toBeString substringToIndex:18];
        }
        BOOL isCar = [textField ChenkInputNSCharacterSet:string typeInt:5];
        if (!isCar) {
            return NO;
        }
    }
    
    OrderInfoObj *order = self.dataArray[tag];
    order.content = toBeString;
    [self.dataArray replaceObjectAtIndex:tag withObject:order];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 4) {
        return kRentCarDetailCellHeight;
    }else{
        WEAKSELF
        return [self.tableView fd_heightForCellWithIdentifier:kRentCarDetailOtherCellID configuration:^(id cell) {
            RentCarDetailOtherCell *_cell = cell;
            [_cell setupCellInfoWith:weakSelf.dataArray[indexPath.row]];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row < 4) {
        RentCarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kRentCarDetailCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // Configure the cell...
        OrderInfoObj *orderObj = self.dataArray[indexPath.row];
        [cell setupCellInfoWith:orderObj];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentLab.tag = row;
        if (row<2) {
            cell.contentLab.userInteractionEnabled = YES;
        }else{
            cell.contentLab.userInteractionEnabled = NO;
        }
        cell.contentLab.delegate = self;
        return cell;
    }else{
        RentCarDetailOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:kRentCarDetailOtherCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // Configure the cell...
        OrderInfoObj *orderObj = self.dataArray[indexPath.row];
        [cell setupCellInfoWith:orderObj];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 || indexPath.row == 3 ) {
        if (_outTime.length==0 && indexPath.row == 3) {
            [NSString toast:@"请先选择取车时间"];
            return;
        }
        
        [self showSelectDateViewIn:indexPath];
    }
}

- (void)showSelectDateViewIn:(NSIndexPath *)indexPath {
    WEAKSELF
    NSInteger row = indexPath.row;
    NSString *title = @"";
    if (row == 2) {
        title = @"取车时间";
    }else if(row == 3) {
        title = @"还车时间";
    }
    NSDate *selDate = [NSDate new];
    NSDate *minimumDate = [NSDate new];
    NSDate *maximumDate = nil;
    if (self.outTime.length && row == 3) {
        //还车时间不能小于借车时间，所以需要最小时间
        double addTime = [NSDate converDatetimeToTimeIntervalWith:self.outTime format:@"yyyy-MM-dd"].doubleValue + 24 * 3600;
        NSString *inTime = [NSDate timeIntervalToDataString:addTime formate:@"yyyy-MM-dd"];
        minimumDate = [NSDate dateWithString:inTime formatString:@"yyyy-MM-dd"];
    }
    __block OrderInfoObj *order = self.dataArray[row];
    if (order.content) {
        selDate = [NSDate dateWithString:order.content formatString:@"yyyy-MM-dd"];
    }
    [ActionSheetDatePicker showPickerWithTitle:title datePickerMode:UIDatePickerModeDate selectedDate:selDate minimumDate:minimumDate maximumDate:maximumDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        if (row == 2) {
            weakSelf.outTime = [selectedDate formattedDateWithFormatString:@"yyyy-MM-dd"];
            order.content = weakSelf.outTime;
            
            NSInteger days = ABS([NSDate getTheCountOfTwoDaysWithBeginDate:weakSelf.inTime endDate:order.content]);
            if (days<1) {
                //还车时间不能小于借车+1的时间，所以需要最小时间
                double addTime = [NSDate converDatetimeToTimeIntervalWith:order.content format:@"yyyy-MM-dd"].doubleValue + 24 * 3600;
                NSString *inTime = [NSDate timeIntervalToDataString:addTime formate:@"yyyy-MM-dd"];
                self.inTime = inTime;
                OrderInfoObj *oInfo = weakSelf.dataArray[row+1];
                oInfo.content = inTime;
                [weakSelf.dataArray replaceObjectAtIndex:row+1 withObject:oInfo];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }else{
            weakSelf.inTime = [selectedDate formattedDateWithFormatString:@"yyyy-MM-dd"];
            order.content = weakSelf.inTime;
        }
        
        [weakSelf.dataArray replaceObjectAtIndex:row withObject:order];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.view];
}

/**
 *
 vo.rentCerNof	45542588555
 requestType	app
 vo.pickupDatef	2017-07-31
 vo.pickupLocationf	天津市北辰区韩家墅海吉星农产品批发市场
 vo.orderNof	3101501501935514
 vo.pickupPersonf	塔里克
 vo.rentMoneyf	210//租金(租价*天数)
 vo.deptIdf	2_38
 vo.returnLocationf	天津市北辰区韩家墅海吉星农产品批发市场
 vo.returnDatef	2017-08-02
 vo.trueNamef	13820633188
 vo.days	2
 vo.createIdf	defbe3fb-96a2-491a-80c8-3197dc34277e
 vo.hirerf	塔里克
 vo.rentCerTypef	72e41a6e-f7d4-4da1-916d-8f6686f3ac02
 vo.mobilef	13820633188
 */
#pragma mark --添加租车订单
- (void)sendRentorderdoInsert_API{
    WEAKSELF
    OrderInfoObj *nameObj = self.dataArray[0];
    OrderInfoObj *cardObj = self.dataArray[1];
    UserInfoObj *userObj = [UserInfoObj model];
    NSInteger days = ABS([NSDate getTheCountOfTwoDaysWithBeginDate:self.inTime endDate:self.outTime]);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:cardObj.content forKey:@"vo.rentCerNof"];
    [params addUnEmptyString:self.outTime forKey:@"vo.pickupDatef"];
    [params addUnEmptyString:_storeObj.addrf forKey:@"vo.pickupLocationf"];
    NSString *orderNof = [NSString stringWithFormat:@"%@%@",userObj.sortNumf,[NSDate getNowTimeTimestamp2]];
    [params addUnEmptyString:orderNof forKey:@"vo.orderNof"];
    [params addUnEmptyString:nameObj.content forKey:@"vo.pickupPersonf"];
    [params addUnEmptyString:kDoubleToString(days*self.orderObj.startPricef.doubleValue) forKey:@"vo.rentMoneyf"];
    [params addUnEmptyString:_storeObj.idf forKey:@"vo.deptIdf"];
    [params addUnEmptyString:_storeObj.storeNamef forKey:@"vo.returnLocationf"];
    [params addUnEmptyString:self.inTime forKey:@"vo.returnDatef"];
    [params addUnEmptyString:userObj.trueNamef forKey:@"vo.trueNamef"];
    
    [params addUnEmptyString:kIntegerToString(days) forKey:@"vo.days"];
    [params addUnEmptyString:_storeObj.createIdf forKey:@"vo.createIdf"];
    [params addUnEmptyString:nameObj.content forKey:@"vo.hirerf"];
    [params addUnEmptyString:@"72e41a6e-f7d4-4da1-916d-8f6686f3ac02" forKey:@"vo.rentCerTypef"];
    [params addUnEmptyString:userObj.mobilePhonef forKey:@"vo.mobilef"];
    [OrderInfoObj sendRentorderdoInsertWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        if (response.isSuccess) {
            [self onBackButton];
            [NSString toast:@"租车成功"];
        }else{
            [NSString toast:@"租车失败"];
        }
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        [NSString toast:@"租车失败"];
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
