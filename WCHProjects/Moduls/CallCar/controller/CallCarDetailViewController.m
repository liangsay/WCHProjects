//
//  CallCarDetailViewController.m
//  WCHProjects
//
//  Created by liujinliang on 2017/8/1.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "CallCarDetailViewController.h"
#import "BaseTableView.h"
#import "ActionSheetDatePicker.h"
#import "RentCarDetailCell.h"
#import "CallCarDetailCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SearchAddressViewController.h"
#import "AddressViewController.h"
@interface CallCarDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SearchAddressViewControllerDelegate,CallCarDetailCellDelegate,AddressViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (nonatomic, strong) NSString *outTime;//用车时间
@property (nonatomic, strong) NSIndexPath *selIndexPath;
@end

@implementation CallCarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.addBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.addBtn setLayerCornerRadius:5];
    
    [self.submitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.submitBtn setLayerCornerRadius:5];
    [self setupDataSet];
    [self setupTableSet];
    
    if (kScreenWidth == 320) {
        self.descLab.text = @"添加途经点请安卸货顺序填写";
    }else{
        self.descLab.text = @"添加途经点请安卸货顺序填写，以便估计价格";
    }
}
#pragma mark --UIButtonAction------------------
//添加途经点按钮事件
- (IBAction)addBtnAction:(UIButton *)sender {
    [self insertOneCell];
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
        [NSString toast:@"请选择用车时间"];
        return;
    }
    
    [self sendOrderdoInsert];
}


//设置数据
- (void)setupDataSet{
    
    NSArray *datas = @[@"请选择用车时间",@"请选择起点",@"请选择目的地",@"请输入吨数(非必填)"];
    NSDate *nowDate = [NSDate date];
    for (int i=0; i<datas.count; i++) {
        OrderInfoObj *order = [OrderInfoObj new];
        order.placeholder = datas[i];
        order.isMust = YES;
        order.iconName = @"行驶证";
        order.index = i;
        order.content = @"";
        if (i==0) {
            self.outTime =[nowDate formatStringWithFormat:@"yyyy-MM-dd"];
            order.content = self.outTime;
        }
        if (i==datas.count-1) {
            order.isTxt = YES;
        }else{
            order.isTxt = NO;
        }
        [self.dataArray addObject:order];
    }
    
}



//设置表
- (void)setupTableSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"RentCarDetailCell" bundle:nil] forCellReuseIdentifier:kRentCarDetailCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CallCarDetailCell" bundle:nil] forCellReuseIdentifier:kCallCarDetailCellID];
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
    
    __block OrderInfoObj *orderObj = self.dataArray[indexPath.row];
    if (orderObj.isTxt) {
        return kRentCarDetailCellHeight;
    }else{
        if (kIsObjectEmpty(orderObj.content)) {
            return kCallCarDetailCellHeight;
        }else{
            CGFloat height = [self.tableView fd_heightForCellWithIdentifier:kCallCarDetailCellID configuration:^(id cell) {
                CallCarDetailCell *_cell = cell;
                [_cell setupCellInfoWith:orderObj];
            }];
            if (height < kCallCarDetailCellHeight) {
                height = kCallCarDetailCellHeight;
            }
            return height;
        }
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    OrderInfoObj *orderObj = self.dataArray[indexPath.row];
    if (orderObj.isTxt) {
        RentCarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kRentCarDetailCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // Configure the cell...
        
        [cell setupCellInfoWith:orderObj];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentLab.tag = row;
        if (row == self.dataArray.count - 1) {
            cell.contentLab.userInteractionEnabled = YES;
            [cell.contentLab setKeyboardType:UIKeyboardTypeNumberPad];
        }else{
            cell.contentLab.userInteractionEnabled = NO;
            [cell.contentLab setKeyboardType:UIKeyboardTypeDefault];
        }
        cell.contentLab.delegate = self;
        return cell;
    }else{
        CallCarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCallCarDetailCellID forIndexPath:indexPath];
        cell.cellIndexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // Configure the cell...
        cell.cDelegate = self;
        if (!orderObj.isMust) {
            orderObj.placeholder = [NSString stringWithFormat:@"请选择途经点%ld",row - 1];
        }
        [cell setupCellInfoWith:orderObj];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.contentLab.userInteractionEnabled = NO;
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    self.selIndexPath = indexPath;
    if (row == 0) {
        [self showSelectDateViewIn:indexPath];
    }else if (row == 1){
        //起点
        //搜索地址
        AddressViewController *addressVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
        addressVC.delegate = self;
        kPushNav(addressVC, YES);
    }else if (self.dataArray.count - 1 == row){
        //吨数文本框
        
    }else if (self.dataArray.count - 2 == row){
        //目的地
        //搜索地址
        AddressViewController *addressVC = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:nil];
        addressVC.delegate = self;
        kPushNav(addressVC, YES);
    }else{
        //途径地点
        [self goAddressSelector];
    }
}

//选择地址
- (void)goAddressSelector {
    //搜索地址
    SearchAddressViewController *addressVC = [[SearchAddressViewController alloc] initWithNibName:@"SearchAddressViewController" bundle:nil];
    addressVC.delegate = self;
    addressVC.provinceName = [UserInfoObj model].provincef;
    addressVC.searchType = SearchAddressTypeCallCar;
    kPushNav(addressVC, YES);
}

//动态插入一行途经点
- (void)insertOneCell {
    [self.tableView beginUpdates];
    NSInteger row = self.dataArray.count - 2;
    OrderInfoObj *order = [OrderInfoObj new];
    order.placeholder = [NSString stringWithFormat:@"请选择途经点%ld",(self.dataArray.count - 4) + 1];
    order.isMust = NO;
    order.iconName = @"行驶证";
    order.content = @"";
    order.isTxt = NO;
    [self.dataArray insertObject:order atIndex:row];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
}

- (void)showSelectDateViewIn:(NSIndexPath *)indexPath {
    WEAKSELF
    NSInteger row = indexPath.row;
    NSString *title = @"";
    title = @"用车时间";
    NSDate *selDate = [NSDate new];
    NSDate *minimumDate = [NSDate new];
    NSDate *maximumDate = nil;
    
    __block OrderInfoObj *order = self.dataArray[row];
    if (order.content) {
        selDate = [NSDate dateWithString:order.content formatString:@"yyyy-MM-dd"];
    }
    [ActionSheetDatePicker showPickerWithTitle:title datePickerMode:UIDatePickerModeDate selectedDate:selDate minimumDate:minimumDate maximumDate:maximumDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        if (row == 0) {
            weakSelf.outTime = [selectedDate formattedDateWithFormatString:@"yyyy-MM-dd"];
            order.content = weakSelf.outTime;
        }
        
        [weakSelf.dataArray replaceObjectAtIndex:row withObject:order];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.view];
}

#pragma mark --UITextFieldDelegate-------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    long leg = [toBeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    NSInteger tag = textField.tag;
    if (tag == self.dataArray.count - 1) {
        if([string chenkInputNSCharacterSetWithType:3])//kNumbersPeriod
        {
            NSArray  *arr =[textField.text componentsSeparatedByString:@"."];
            if(arr.count == 1)
            {
                if (textField.text.length>3 && [NSString notEmptyOrNull:string]) {
                    return NO;
                }
                OrderInfoObj *order = self.dataArray[tag];
                order.content = toBeString;
                [self.dataArray replaceObjectAtIndex:tag withObject:order];
                return YES;
            }
            else if (arr.count == 2 && ![string isEqualToString:@"."])
            {
                NSString  *str = [arr objectAtIndex:1];
                
                if(str.length >1 && range.location > textField.text.length-1){
                    return NO;
                }
                if ([[arr objectAtIndex:0] length]>3 && [NSString notEmptyOrNull:string]) {
                    return NO;
                }else{
                    OrderInfoObj *order = self.dataArray[tag];
                    order.content = toBeString;
                    [self.dataArray replaceObjectAtIndex:tag withObject:order];
                    return YES;
                }
            }
            else
                return NO;
        }else
            return NO;
    }
    
    
    return YES;
}

#pragma mark --AddressViewControllerDelegate------
- (void)addressViewController:(AddressViewController *)addressViewController searchAddressObj:(SearchAddressObj *)searchObj selType:(NSInteger)selType {
    OrderInfoObj *orderObj = self.dataArray[self.selIndexPath.row];
    orderObj.content = searchObj.detail;
    if (self.selIndexPath.row==1) {
        orderObj.startLocationf = [NSString stringWithFormat:@"%.6f,%.6f",searchObj.coordinate.latitude,searchObj.coordinate.longitude];
    }else if (self.selIndexPath.row == self.dataArray.count - 2){
        orderObj.endLocationf = [NSString stringWithFormat:@"%.6f,%.6f",searchObj.coordinate.latitude,searchObj.coordinate.longitude];
    }
    [self.dataArray replaceObjectAtIndex:self.selIndexPath.row withObject:orderObj];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[self.selIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark --SearchAddressViewControllerDelegate--------
- (void)searchAddressViewController:(SearchAddressViewController *)searchAddressViewController searchAddressObj:(SearchAddressObj *)searchObj selType:(NSInteger)selType{
    
    //vo.nodes	[{"addressf":"天津市河西区平江道60号","namef":"王健","phonef":"15886523363","positionf":"39.091078,117.219921"}]
    OrderInfoObj *orderObj = self.dataArray[self.selIndexPath.row];
    orderObj.content = searchObj.addrf;
    orderObj.namef = searchObj.namef;
    orderObj.positionf = searchObj.positionf;
    orderObj.modelf = searchObj.modelf;
    
    if (self.selIndexPath.row==1) {
        orderObj.startLocationf = [NSString stringWithFormat:@"%.2f,%.2f",searchObj.coordinate.latitude,searchObj.coordinate.longitude];
    }else if (self.selIndexPath.row == self.dataArray.count - 2){
        orderObj.endLocationf = [NSString stringWithFormat:@"%.2f,%.2f",searchObj.coordinate.latitude,searchObj.coordinate.longitude];
    }
    [self.dataArray replaceObjectAtIndex:self.selIndexPath.row withObject:orderObj];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[self.selIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark --CallCarDetailCellDelegate-------------
- (void)callCarDetailCell:(CallCarDetailCell *)callCarDetailCell closeBtn:(UIButton *)closeBtn {
    NSInteger index = closeBtn.tag;
    //    [self.tableView beginUpdates];
    [self.dataArray removeObjectAtIndex:index];
    [self.tableView reloadData];
    //    self.selIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //    [self.tableView deleteRowsAtIndexPaths:@[self.selIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    //    [self.tableView endUpdates];
}

#pragma mark --货主（或司机作为货主用户时）订单添加接口
/**
 订单添加接口
 requestType	app
 vo.tonf	0.0
 vo.nodes	[{"addressf":"天津市河西区平江道60号","namef":"王健","phonef":"15886523363","positionf":"39.091078,117.219921"}]
 vo.payStatusf	0
 vo.pricef	520.0
 vo.provincef	天津市
 vo.ownerIdf	13820633188
 vo.kmCountf	89.0
 vo.startLocationf	39.478186,117.714142
 vo.modelNamef	大型平板
 vo.deptIdf	2_38
 vo.endLocationf	39.062796,117.067497
 vo.statusf	0
 vo.cityf	天津市
 vo.endAddrNamef	天津市西青区张家窝镇津晋高速公路(近京福支线)
 vo.startAddrNamef	宁河镇
 
 @param provincef <#provincef description#>
 @param cityf     <#cityf description#>
 
 
 int distance = result.getRouteLines().get(0).getDistance();;
 BigDecimal   b= new   BigDecimal(distance/1000);
 kms = b.setScale(2,BigDecimal.ROUND_HALF_UP).floatValue();
 callPriceTv.setText(String.valueOf(kms));
 ViewUtil.showShortToast(CallDetailActivity.this, String.valueOf(distance));
 if(isCold==1){//冷藏车计价
 float ton=1;
 if(tonEv.getText()!=null||!"".equals(tonEv.getText().toString())){
 ton=Float.parseFloat(tonEv.getText().toString());
 }
 ton=ton<1?1:ton;
 kms=kms<5?5f:kms;
 finPrice=80*ton+5*(distance-5);
 }else{
 if(kms>startKm){
 finPrice= startPrice+(kms-startKm)*kmPrice;
 }else{
 finPrice=startPrice;
 }
 }
 finPrice=finPrice+nodePrice;
 callPriceTv.setText("全程约"+kms+"公里   费用估计:"+String.valueOf(finPrice)+"元");
 }
 */
- (void)sendOrderdoInsert{
    NSString *kmCountf = @"";
    NSString *pricef = @"";
    OrderInfoObj *timeObj = self.dataArray[0];
    OrderInfoObj *startObj = self.dataArray[1];
    OrderInfoObj *endObj = self.dataArray[self.dataArray.count - 2];
    OrderInfoObj *tonObj = self.dataArray[self.dataArray.count - 1];
    
    NSMutableArray *nodes = [NSMutableArray array];
    
    if (self.dataArray.count > 4) {
        //大于3代表有途经点数据
        for (NSInteger i = 2; i<self.dataArray.count-2; i++) {
            OrderInfoObj *childObj = self.dataArray[i];
            if (!kIsObjectEmpty(childObj.content)) {
                NSMutableDictionary *orderDic = [NSMutableDictionary dictionary];
                [orderDic addUnEmptyString:childObj.content forKey:@"addressf"];
                [orderDic addUnEmptyString:childObj.namef forKey:@"namef"];
                [orderDic addUnEmptyString:childObj.modelf forKey:@"phonef"];
                [orderDic addUnEmptyString:childObj.positionf forKey:@"positionf"];
                [nodes addObject:orderDic];
            }
        }
    }
    
    NSString *nodeStr = [nodes mj_JSONString];
    if (kIsObjectEmpty(tonObj.content)) {
        tonObj.content = @"0";
    }
    
    if (kIsObjectEmpty(startObj.content)) {
        [NSString toast:@"请选择起点"];
        return;
    }
    if (kIsObjectEmpty(endObj.content)) {
        [NSString toast:@"请选择目的地"];
        return;
    }
    
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:startObj.content forKey:@"vo.startAddrNamef"];
    [params addUnEmptyString:endObj.content forKey:@"vo.endAddrNamef"];
    [params addUnEmptyString:[LocationServer shared].provincef forKey:@"vo.provincef"];
    [params addUnEmptyString:[LocationServer shared].cityf forKey:@"vo.cityf"];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.ownerIdf"];
    [params addUnEmptyString:[UserInfoObj model].mobilePhonef forKey:@"vo.mobilePhonef"];
    [params addUnEmptyString:startObj.startLocationf forKey:@"vo.startLocationf"];
    [params addUnEmptyString:endObj.endLocationf forKey:@"vo.endLocationf"];
    [params addUnEmptyString:kmCountf forKey:@"vo.kmCountf"];
    [params addUnEmptyString:pricef forKey:@"vo.pricef"];
    [params addUnEmptyString:@"0" forKey:@"vo.statusf"];
    [params addUnEmptyString:@"0" forKey:@"vo.payStatusf"];
    [params addUnEmptyString:tonObj.content forKey:@"vo.tonf"];
    [params addUnEmptyString:self.orderObj.namef forKey:@"vo.modelNamef"];
    [params addUnEmptyString:nodeStr forKey:@"vo.nodes"];
    [OrderInfoObj sendOrderdoInsertWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        
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