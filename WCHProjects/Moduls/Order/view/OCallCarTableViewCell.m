//
//  OCallCarTableViewCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/7/17.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "OCallCarTableViewCell.h"
#import "OCallCarAddressCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

NSString * const kOCallCarTableViewCellID = @"kOCallCarTableViewCellID";
CGFloat const kOCallCarTableViewCellHeight = 110;

@interface OCallCarTableViewCell()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
@implementation OCallCarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self setupViewsSet];
        [self setupContraintSet];
        self.hyb_lastViewInCell = self.lineV;
        self.hyb_bottomOffsetToCell = 0;
    }
    
    return self;
}

- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender {
    if ([self.oDelegate respondsToSelector:@selector(oCallCarTableViewCell:longPress:orderObj:)]) {
        [self.oDelegate oCallCarTableViewCell:self longPress:YES orderObj:self.orderObj];
    }
}

- (IBAction)tapGestureAction:(UIGestureRecognizer *)sender {
    if ([self.oDelegate respondsToSelector:@selector(oCallCarTableViewCell:tapGesture:orderObj:)]) {
        [self.oDelegate oCallCarTableViewCell:self tapGesture:YES orderObj:self.orderObj];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若点击了tableViewCell，则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


- (void)setupViewsSet {
    UIView *touchView = [UIView new];
    touchView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:touchView];
    self.touchView = touchView;
    
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPressGesture.delegate = self;
    longPressGesture.minimumPressDuration=0.5f;//设置长按 时间
    [touchView addGestureRecognizer:longPressGesture];
    self.longPressGesture = longPressGesture;
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
//    [self.contentView addGestureRecognizer:tapGesture];
    
    UILabel *numLab = [UILabel new];
    numLab.font = [UIFont fontContent];
    numLab.textColor = [UIColor fontBlack];
    [self.contentView addSubview:numLab];
    self.numLab = numLab;
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setImage:kIMAGE(@"icon_card_call") forState:UIControlStateNormal];
    [callBtn setTitle:@"联系司机" forState:UIControlStateNormal];
    [callBtn setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    [callBtn.titleLabel setFont:[UIFont fontContent]];
    [callBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [callBtn setContentEdgeInsets:(UIEdgeInsets){0,5,0,-5}];
    [callBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:callBtn];
    self.callBtn = callBtn;
    
    UILabel *timeLab = [UILabel new];
    timeLab.font = [UIFont fontContent];
    timeLab.textColor = [UIColor fontBlack];
    [self.contentView addSubview:timeLab];
    self.timeLab = timeLab;
    
    UILabel *typeLab = [UILabel new];
    typeLab.font = [UIFont fontContent];
    typeLab.textColor = [UIColor fontGray];
    [self.contentView addSubview:typeLab];
    self.typeLab = typeLab;
    
    UIImageView *startImgV = [[UIImageView alloc] initWithImage:kIMAGE(@"出发地")];
    [self.contentView addSubview:startImgV];
    self.startImgV = startImgV;
    
    UILabel *startLab = [UILabel new];
    startLab.font = [UIFont fontAssistant];
    startLab.textColor = [UIColor fontGray];
    startLab.numberOfLines = 0;
    startLab.preferredMaxLayoutWidth = kScreenWidth - 15 - 15 - 12 -10;
    [self.contentView addSubview:startLab];
    self.startLab = startLab;
    
    BaseTableView *tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.scrollEnabled = NO;
    tableView.userInteractionEnabled = YES;
    [tableView setLayerCornerRadius:5];
    [tableView setLayerBorderWidth:0.5 color:[UIColor borderColor]];
    [tableView registerClass:NSClassFromString(@"OCallCarAddressCell") forCellReuseIdentifier:kOCallCarAddressCellID];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    UIImageView *endImgV = [[UIImageView alloc] initWithImage:kIMAGE(@"目的地")];
    [self.contentView addSubview:endImgV];
    self.endImgV = endImgV;
    
    UILabel *endLab = [UILabel new];
    endLab.font = [UIFont fontAssistant];
    endLab.textColor = [UIColor fontGray];
    endLab.preferredMaxLayoutWidth = kScreenWidth - 15 - 15 - 12 -10;
    endLab.numberOfLines = 0;
    [self.contentView addSubview:endLab];
    self.endLab = endLab;
    
    UILabel *priceLab = [UILabel new];
    priceLab.font = [UIFont fontAssistant];
    priceLab.textColor = [UIColor fontBlack];
    [self.contentView addSubview:priceLab];
    self.priceLab = priceLab;
    
    UILabel *statueLab = [UILabel new];
    statueLab.font = [UIFont fontAssistant];
    statueLab.textColor = [UIColor priceColor];
    [self.contentView addSubview:statueLab];
    self.statueLab = statueLab;
    
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor backgroundColor];
    [self.contentView addSubview:bgView];
    self.bgView = bgView;
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:lineV];
    self.lineV = lineV;
    
}

- (void)setupContraintSet{
    WEAKSELF
    
    [self.touchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    
    
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
        make.centerY.equalTo(weakSelf.numLab);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.right.greaterThanOrEqualTo(weakSelf.callBtn.mas_left).offset(-10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(weakSelf.numLab.mas_bottom).offset(5);
    }];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(weakSelf.timeLab);
        make.left.greaterThanOrEqualTo(weakSelf.timeLab.mas_right).offset(10);
    }];
    
    [self.startImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(weakSelf.timeLab.mas_bottom).offset(5);
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
        make.top.equalTo(weakSelf.startLab.mas_bottom).offset(10);
    }];
    
    [self.endImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(weakSelf.tableView.mas_bottom).offset(10);
        make.width.height.equalTo(@12);
    }];
    
    [self.endLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.endImgV.mas_right).offset(10);
        make.top.equalTo(weakSelf.endImgV);
        make.right.equalTo(@-15);
//        make.bottom.equalTo(@-10);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(weakSelf.endLab.mas_bottom).offset(10);
    }];
    
    [self.statueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(weakSelf.priceLab);
        make.left.greaterThanOrEqualTo(weakSelf.priceLab.mas_right).offset(10);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(weakSelf.priceLab.mas_bottom).offset(10);
        make.height.equalTo(@10);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakSelf.bgView.mas_bottom).offset(0);
        make.height.equalTo(@0);
    }];

}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
    WEAKSELF
    __block CGFloat tableviewHeight = 0;
    self.dataArray = orderObj.orderPointList;
    if (self.dataArray.count) {
        for (NSInteger i = 0;i<self.dataArray.count; i++) {
            OrderInfoObj *ordObj = self.dataArray[i];
            CGFloat cellheight = [OCallCarAddressCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
                OCallCarAddressCell *_cell = (OCallCarAddressCell *)sourceCell;
                [_cell setupCellInfoWithObj:ordObj];
            } cache:^NSDictionary *{
                NSDictionary *cache = @{kHYBCacheUniqueKey : @"",
                                        kHYBCacheStateKey : @"",
                                        kHYBRecalculateForStateKey : @(YES)};
                return cache;
            }];
            tableviewHeight += cellheight;
        }
    }
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(tableviewHeight);
        if (tableviewHeight==0) {
            make.top.equalTo(weakSelf.startLab.mas_bottom).offset(0);
        }else{
            make.top.equalTo(weakSelf.startLab.mas_bottom).offset(10);
        }
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
    self.numLab.text = [NSString stringWithFormat:@"订单号:%@",orderObj.orderNof];
    self.timeLab.text = [NSString stringWithFormat:@"下单时间:%@",orderObj.createTimef];
    if (!kIsObjectEmpty(orderObj.modelNamef)) {
        self.typeLab.text = orderObj.modelNamef;
    }else{
        self.typeLab.text = @"";
    }
    
    self.startLab.text = kIsObjectEmpty(orderObj.startAddrNamef)?@"--":orderObj.startAddrNamef;
    self.endLab.text = kIsObjectEmpty(orderObj.endAddrNamef)?@"--":orderObj.endAddrNamef;
    
    NSString *price = [NSString stringWithFormat:@"%.2f元",orderObj.pricef.doubleValue];
    NSString *priceStr = [NSString stringWithFormat:@"运价：%@",price];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange priceRange = [priceStr rangeOfString:price];
    [priceAtt setTextColor:[UIColor priceColor] range:priceRange];
    self.priceLab.attributedText = priceAtt;
    
    self.statueLab.text = orderObj.statusTextf;
//    (isAssess=0 未评价  1=已评价)
    //0:未接单 1：已接单 2：未支付  3:已支付 4：已取消
    NSInteger statusf = orderObj.statusf.integerValue;
    if (statusf==1) {
        self.callBtn.alpha=1;
    }else{
        self.callBtn.alpha=0;
    }
    if (statusf==0) {//在已接单状态，司机或货主可取消订单
        //可以加入长按取消订单
        self.touchView.hidden = NO;
        self.longPressGesture.enabled = YES;
    }else{
        self.touchView.hidden = YES;
        self.longPressGesture.enabled = NO;
    }
    if (statusf==3) {
        if (orderObj.isAssess.integerValue==0) {
            self.statueLab.text = @"待评价";
        }else{
            self.statueLab.text = @"已评价";
        }
    }
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
    __block OrderInfoObj *ordObj = self.dataArray[indexPath.row];
    CGFloat cellheight = [OCallCarAddressCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
        OCallCarAddressCell *_cell = (OCallCarAddressCell *)sourceCell;
        [_cell setupCellInfoWithObj:ordObj];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : @"",
                                kHYBCacheStateKey : @"",
                                kHYBRecalculateForStateKey : @(YES)};
        return cache;
    }];
    
    return cellheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OCallCarAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kOCallCarAddressCellID forIndexPath:indexPath];
    
    // Configure the cell...
    OrderInfoObj *orderObj = _dataArray[indexPath.row];
    [cell setupCellInfoWithObj:orderObj];
    return cell;
}


#pragma mark --callBtnAction:
- (void)callBtnAction:(UIButton *)sender{
    kMakeCallWithPhone(self.orderObj.driverIdf, kWindow);
}
@end
