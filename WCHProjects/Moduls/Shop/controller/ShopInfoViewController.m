//
//  ShopInfoViewController.m
//  WCHProjects
//
//  Created by liu jinliang on 2017/8/5.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "BaseTableView.h"
#import "ShopInfoTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ShopInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *datas = @[@"品牌",@"车系",@"车辆型号",@"车辆颜色",@"发动机型号",@"燃料类型",@"排量",@"功率",@"排放标准",@"油耗",@"外轮廓长",@"外轮廓高",@"外轮廓宽",@"货箱内部尺寸长",@"货箱内部尺寸宽",@"货箱内部尺寸高",@"前钢板弹簧片数",@"后钢板弹簧片数",@"轮胎数",@"轮胎规格",@"前轮胎",@"后轮胎",@"轴距",@"轴荷1",@"轴荷2",@"轴数",@"转向形式",@"总质量",@"整备质量",@"额定载质量",@"载质量利用系数",@"准牵引总质量",@"半挂车鞍座最大允许总质量",@"驾驶室准乘人数",@"额定载客",@"最高设计车速",@"车辆制造日期",@"备注"];
    for (NSInteger i=0; i<datas.count; i++) {
        OrderInfoObj *order = [OrderInfoObj new];
        order.typef = datas[i];
        [self.dataArray addObject:order];
    }
    
    [self setupTableViewSet];
    [self refreshHeaderData];
    
    
}

- (void)setupTableViewSet {
    [self.tableView registerNib:[UINib nibWithNibName:@"ShopInfoTableViewCell" bundle:nil] forCellReuseIdentifier:kShopInfoTableViewCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor backgroundColor];
    [self.tableView addHeaderRefreshTarget:self action:@selector(refreshHeaderData)];
}

- (void)refreshHeaderData {
    [self sendMallgoodstoView_API];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block OrderInfoObj *orderObj = self.dataArray[indexPath.row];
    CGFloat height = [self.tableView fd_heightForCellWithIdentifier:kShopInfoTableViewCellID configuration:^(id cell) {
        ShopInfoTableViewCell *_cell = (ShopInfoTableViewCell *)cell;
        [_cell setupCellInfoWithObj:orderObj];
    }];
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShopInfoTableViewCellID forIndexPath:indexPath];
    // Configure the cell...
    OrderInfoObj *orderObj = _dataArray[indexPath.row];
    cell.cellIndexPath = indexPath;
    
    [cell setupCellInfoWithObj:orderObj];
    if (indexPath.row==0) {
        cell.baseTopLine.alpha = 0;
    }else{
        cell.baseTopLine.alpha = 1;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark --查询商品评价
/**
 查询商品评价
 queryMap.goodIdf	0a3d5b19-5ac8-4f7d-a17a-516d2b5b4991
 idf; //编号
	brandIdf; //品牌编号
	brandNamef; //品牌编号
	serieIdf; //车系
	serieNamef; //车系
	carNamef; //车辆名称
	carModelf; //车辆型号
	carColorf; //车身颜色
	engineModelf; //发动机型号
	fuelTypef; //燃料种类
	outputVolf; //排量
	powerf; //功率
	emissionStaf; //排放标准
	oilwearf; //油耗
	abroadLongf; //外轮廓长
	abroadHighf; //外轮廓高
	abroadWidthf; //外轮廓宽
	insideLongf; //货箱内部尺寸长
	insideHighf; //货箱内部尺寸高
	insideWidthf; //货箱内部尺寸宽
	qthNumf; //前钢板弹簧片数
	hthNumf; //后钢板弹簧片数
	tyreNumf; //轮胎数
	tyreRulef; //轮胎规格
	frontTyreDistf; //前轮距
	backTyreDistf; //后轮距
	wheelbasef; //轴距
	frontAxleWeightf; //轴荷1
	backtAxleWeightf; //轴荷2
	axisNumf; //轴数
	turnTypef; //转向形式
	totalWeightf; //总质量
	curbWeightf; //整备质量
	ratedWeightf; //额定载质量
	payloadFactorf; //载质量利用系数
	dragWeightf; //准牵引总质量
	bgcWeightf; //半挂车鞍座最大允许总质量
	cabPeopleNumf; //驾驶室准乘人数
	travellerNumf; //额定载客
	maxSpeedf; //最高设计车速
	madeDatef; //车辆制造日期
	remarksf; //备注
	complyInfof; //车辆制企业信息
	isGroundingf; //是否上架
	pricef; //单价
	depositRatiof; //订金比例
	depositf; //固定定金
	paymentRatiof; //分期首款比例
	paymentf; //固定分期首款
	loanRatiof; //贷款比例
	insurancef; //保险计算
	dataSortNumf; //排序号
	deptIdf; //部门编号
	deptNamef; //部门名称
	createIdf; //创建者编号
	trueNamef; //创建者名称
	createTimef; //创建时间
 */
- (void)sendMallgoodstoView_API{
    WEAKSELF
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addUnEmptyString:self.orderObj.idf forKey:@"fid"];
    [OrderInfoObj sendMallgoodstoViewWithParameters:params successBlock:^(HttpRequest *request, HttpResponse *response) {
        OrderInfoObj *order = response.responseModel;
        NSArray *datas = @[[NSString toString:order.brandNamef],
                           [NSString toString:order.serieNamef],
                           [NSString toString:order.carModelf],
                           [NSString toString:order.carColorf],
                           [NSString toString:order.engineModelf],
                           [NSString toString:order.fuelTypef],
                           [NSString toString:order.outputVolf],
                           [NSString toString:order.powerf],
                           [NSString toString:order.emissionStaf],
                           [NSString toString:order.oilwearf],
                           [NSString toString:order.abroadLongf],
                           [NSString toString:order.abroadHighf],
                           [NSString toString:order.abroadWidthf],
                           [NSString toString:order.insideLongf],
                           [NSString toString:order.insideHighf],
                           [NSString toString:order.insideWidthf],
                           [NSString toString:order.qthNumf],
                           [NSString toString:order.hthNumf],
                           [NSString toString:order.tyreNumf],
                           [NSString toString:order.tyreRulef],
                           [NSString toString:order.frontTyreDistf],
                           [NSString toString:order.backTyreDistf],
                           [NSString toString:order.wheelbasef],
                           [NSString toString:order.frontAxleWeightf],
                           [NSString toString:order.backtAxleWeightf],
                           [NSString toString:order.axisNumf],
                           [NSString toString:order.turnTypef],
                           [NSString toString:order.totalWeightf],
                           [NSString toString:order.curbWeightf],
                           [NSString toString:order.ratedWeightf],
                           [NSString toString:order.payloadFactorf],
                           [NSString toString:order.dragWeightf],
                           [NSString toString:order.bgcWeightf],
                           [NSString toString:order.cabPeopleNumf],
                           [NSString toString:order.travellerNumf],
                           [NSString toString:order.maxSpeedf],
                           [NSString toString:order.madeDatef],
                           [NSString toString:order.remarksf]];
        for (NSInteger i=0; i<datas.count; i++) {
            OrderInfoObj *order = weakSelf.dataArray[i];
            NSString *content = datas[i];
            order.content = content;
            [weakSelf.dataArray replaceObjectAtIndex:i withObject:order];
            
        }
       
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
    } failedBlock:^(HttpRequest *request, HttpResponse *response) {
        if (!kIsObjectEmpty(response.responseMsg)) {
            [NSString toast:response.responseMsg];
            return ;
        }
        [weakSelf.tableView endHeaderRefreshing];
        [weakSelf.tableView placeholderViewShow:!weakSelf.dataArray.count];
    }];
}
/*
 abroadHighf = 0;
 abroadLongf = 0;
 abroadWidthf = 0;
 axisNumf = 0;
 backTyreDistf = 0;
 backtAxleWeightf = 0;
 bgcWeightf = 0;
 brandIdf = "8930a590-c3db-4dc2-be06-f08c56d2a034";
 brandNamef = "长安";
 cabPeopleNumf = 0;
 carColorf = "";
 carModelf = "";
 carNamef = "长安轿车";
 complyInfof = "";
 createIdf = 0;
 createTimef = "2017-08-03 17:01:59";
 curbWeightf = 0;
 dataSortNumf = 0;
 depositRatiof = 0;
 depositf = 300;
 deptIdf = 0;
 deptNamef = 0;
 diskFilePathf = "2017-07/b5e71359-a76f-4d88-a5e4-b6fbd49a53ea.png";
 dragWeightf = 0;
 emissionStaf = "";
 engineModelf = "";
 frontAxleWeightf = 0;
 frontTyreDistf = 0;
 fuelTypef = "";
 hthNumf = 0;
 idf = "0a3d5b19-5ac8-4f7d-a17a-516d2b5b4991";
 insideHighf = 0;
 insideLongf = 0;
 insideWidthf = 0;
 insurancef = 0;
 isGroundingf = 0;
 loanRatiof = 0;
 madeDatef = "";
 maxSpeedf = 0;
 oilwearf = 0;
 outputVolf = 0;
 payloadFactorf = 0;
 paymentRatiof = 0;
 paymentf = 0;
 powerf = 0;
 pricef = 29999;
 qthNumf = 0;
 ratedWeightf = 0;
 remarksf = "";
 serieIdf = "81a57f44-fa67-4122-a83f-510146d3d1c3";
 serieNamef = "轿车";
 totalWeightf = 0;
 travellerNumf = 0;
 trueNamef = 0;
 turnTypef = "";
 tyreNumf = 0;
 tyreRulef = "";
 wheelbasef = 0;
 */

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
