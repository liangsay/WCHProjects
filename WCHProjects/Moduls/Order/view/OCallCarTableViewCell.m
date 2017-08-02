//
//  OCallCarTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "OCallCarTableViewCell.h"
#import "OCallCarAddressCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

NSString * const kOCallCarTableViewCellID = @"kOCallCarTableViewCellID";
CGFloat const kOCallCarTableViewCellHeight = 110;

@interface OCallCarTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
@implementation OCallCarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor backgroundColor];
        [self setupViewsSet];
        [self setupContraintSet];
        self.hyb_lastViewInCell = self.bgView;
        self.hyb_bottomOffsetToCell = 10;
    }
    
    return self;
}

- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender {
    if ([self.oDelegate respondsToSelector:@selector(oCallCarTableViewCell:longPress:orderObj:)]) {
        [self.oDelegate oCallCarTableViewCell:self longPress:YES orderObj:self.orderObj];
    }
}

- (void)setupViewsSet {
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    
    longPressGesture.minimumPressDuration=1.5f;//设置长按 时间
    [bgView addGestureRecognizer:longPressGesture];
    
    
    UILabel *timeLab = [UILabel new];
    timeLab.font = [UIFont fontContent];
    timeLab.textColor = [UIColor fontBlack];
    [bgView addSubview:timeLab];
    self.timeLab = timeLab;
    
    UILabel *typeLab = [UILabel new];
    typeLab.font = [UIFont fontContent];
    typeLab.textColor = [UIColor mainColor];
    [bgView addSubview:typeLab];
    self.typeLab = typeLab;
    
    UIImageView *startImgV = [[UIImageView alloc] initWithImage:kIMAGE(@"出发地")];
    [bgView addSubview:startImgV];
    self.startImgV = startImgV;
    
    UILabel *startLab = [UILabel new];
    startLab.font = [UIFont fontAssistant];
    startLab.textColor = [UIColor fontGray];
    startLab.numberOfLines = 0;
    startLab.preferredMaxLayoutWidth = kScreenWidth - 15 - 15 - 12 -10;
    [bgView addSubview:startLab];
    self.startLab = startLab;
    
    BaseTableView *tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.userInteractionEnabled = NO;
    tableView.dataSource = self;
    [tableView setLayerCornerRadius:5];
    [tableView setLayerBorderWidth:0.5 color:[UIColor borderColor]];
    tableView.delegate = self;
    [tableView registerNib:[UINib nibWithNibName:@"OCallCarAddressCell" bundle:nil] forCellReuseIdentifier:kOCallCarAddressCellID];
    [bgView addSubview:tableView];
    self.tableView = tableView;
    
    UIImageView *endImgV = [[UIImageView alloc] initWithImage:kIMAGE(@"目的地")];
    [bgView addSubview:endImgV];
    self.endImgV = endImgV;
    
    UILabel *endLab = [UILabel new];
    endLab.font = [UIFont fontAssistant];
    endLab.textColor = [UIColor fontGray];
    endLab.preferredMaxLayoutWidth = kScreenWidth - 15 - 15 - 12 -10;
    endLab.numberOfLines = 0;
    [bgView addSubview:endLab];
    self.endLab = endLab;
    
    UILabel *priceLab = [UILabel new];
    priceLab.font = [UIFont fontAssistant];
    priceLab.textColor = [UIColor fontBlack];
    [bgView addSubview:priceLab];
    self.priceLab = priceLab;
    
    UILabel *statueLab = [UILabel new];
    statueLab.font = [UIFont fontAssistant];
    statueLab.textColor = [UIColor priceColor];
    [bgView addSubview:statueLab];
    self.statueLab = statueLab;
    
}

- (void)setupContraintSet{
    WEAKSELF
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 10, 0));
//        make.left.right.top.equalTo(@0);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
    }];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(weakSelf.timeLab);
        make.left.greaterThanOrEqualTo(weakSelf.timeLab.mas_right).offset(10);
    }];
    
    [self.startImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(weakSelf.timeLab.mas_bottom).offset(7);
        make.width.height.equalTo(@12);
    }];
    
    [self.startLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.startImgV.mas_right).offset(10);
        make.top.equalTo(weakSelf.startImgV);
        make.right.equalTo(@-15);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.top.equalTo(weakSelf.startImgV.mas_bottom).offset(10);
        make.height.equalTo(@0);
    }];
    
    [self.endImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(weakSelf.tableView.mas_bottom).offset(8);
        make.width.height.equalTo(@12);
    }];
    
    [self.endLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.startImgV.mas_right).offset(10);
        make.top.equalTo(weakSelf.endImgV);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@-10);
    }];
    
    
    

}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor backgroundColor];
    self.typeView.backgroundColor = [UIColor mainColor];
    self.typeLab.textColor = [UIColor whiteColor];
    [self.typeView setLayerCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
    
    __block CGFloat tableviewHeight = 0;
    self.dataArray = orderObj.orderPointList;
    for (OrderInfoObj *ordObj in self.dataArray) {
        CGFloat cellheight = [self.tableView fd_heightForCellWithIdentifier:kOCallCarAddressCellID configuration:^(id cell) {
            OCallCarAddressCell *_cell = cell;
            [_cell setupCellInfoWithObj:ordObj];
        }];
        tableviewHeight += cellheight;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(tableviewHeight));
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
    
    
    
    self.timeLab.text = [NSString stringWithFormat:@"下单时间:%@",orderObj.createTimef];
    if (!kIsObjectEmpty(orderObj.modelNamef)) {
        self.typeLab.text = orderObj.modelNamef;
    }else{
        self.typeLab.text = @"";
    }
    
    self.startLab.text = orderObj.startAddrNamef;
    self.endLab.text = orderObj.endAddrNamef;
    NSString *price = orderObj.pricef;
    NSString *priceStr = [NSString stringWithFormat:@"运价：%@",price];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange priceRange = [priceStr rangeOfString:price];
    [priceAtt setTextColor:[UIColor priceColor] range:priceRange];
    self.priceLab.attributedText = priceAtt;
    
    self.statueLab.text = orderObj.statusTextf;
    //0:未接单 1：已接单 2：未支付  3:已支付 4：已取消
    NSInteger statusf = orderObj.statusf.integerValue;
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat tableviewHeight = 0;
    __block OrderInfoObj *orderObj = self.dataArray[indexPath.row];
    tableviewHeight = [self.tableView fd_heightForCellWithIdentifier:kOCallCarAddressCellID configuration:^(id cell) {
        OCallCarAddressCell *_cell = cell;
        [_cell setupCellInfoWithObj:orderObj];
    }];
    
    if (tableviewHeight < kOCallCarAddressCellHeight) {
        tableviewHeight = kOCallCarAddressCellHeight;
    }
    return tableviewHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OCallCarAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kOCallCarAddressCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    OrderInfoObj *orderObj = _dataArray[indexPath.row];
    [cell setupCellInfoWithObj:orderObj];
    return cell;
}
@end
