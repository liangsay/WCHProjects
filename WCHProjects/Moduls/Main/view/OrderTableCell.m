//
//  OrderTableCell.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/5.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "OrderTableCell.h"
#import "UIAlertView+ICBlockAdditions.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "OCallCarAddressCell.h"
NSString * const kOrderTableCellID = @"kOrderTableCellID";
CGFloat const kOrderTableCellHeight = 91;
@interface OrderTableCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation OrderTableCell

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupViewsSet];
        [self setupContraintSet];
        self.hyb_lastViewInCell = self.lineV;
        self.hyb_bottomOffsetToCell = 0;
    }
    return self;
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
    
    UILabel *typeLab = [UILabel new];
    typeLab.font = [UIFont fontContent];
    typeLab.textColor = [UIColor mainColor];
    [self.contentView addSubview:typeLab];
    self.typeLab = typeLab;
    
    UILabel *priceLab = [UILabel new];
    priceLab.font = [UIFont fontContent];
    priceLab.textColor = [UIColor priceColor];
    [self.contentView addSubview:priceLab];
    self.priceLab = priceLab;
    
    UIImageView *startImgV = [[UIImageView alloc] initWithImage:kIMAGE(@"出发地")];
    [self.contentView addSubview:startImgV];
    self.startImgV = startImgV;
    
    UILabel *startLab = [UILabel new];
    startLab.font = [UIFont fontContent];
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
    endLab.font = [UIFont fontContent];
    endLab.textColor = [UIColor fontGray];
    endLab.preferredMaxLayoutWidth = kScreenWidth - 15 - 15 - 12 -10;
    endLab.numberOfLines = 0;
    [self.contentView addSubview:endLab];
    self.endLab = endLab;
    
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderBtn setTitle:@"立即抢单" forState:UIControlStateNormal];
    [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [orderBtn.titleLabel setFont:[UIFont fontContent]];
    [orderBtn setLayerCornerRadius:4];
    [orderBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(orderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:orderBtn];
    self.orderBtn = orderBtn;
    
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
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@15);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.left.greaterThanOrEqualTo(weakSelf.typeLab.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.typeLab);
    }];
    
    
    [self.startImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(weakSelf.typeLab.mas_bottom).offset(10);
        make.width.height.equalTo(@12);
    }];
    
    [self.startLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.startImgV.mas_right).offset(10);
        make.top.equalTo(weakSelf.typeLab.mas_bottom).offset(8);
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
        make.top.equalTo(weakSelf.tableView.mas_bottom).offset(8);
        make.right.equalTo(@-15);
        //        make.bottom.equalTo(@-10);
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(weakSelf.endLab.mas_bottom).offset(10);
        make.right.equalTo(@-15);
        make.height.equalTo(@40);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(weakSelf.orderBtn.mas_bottom).offset(10);
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
//
//- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
//    self.orderObj = orderObj;
//    WEAKSELF
//    __block CGFloat tableviewHeight = 0;
//    self.dataArray = orderObj.orderPointList;
//    if (self.dataArray.count) {
//        for (NSInteger i = 0;i<self.dataArray.count; i++) {
//            OrderInfoObj *ordObj = self.dataArray[i];
//            CGFloat cellheight = [OCallCarAddressCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
//                OCallCarAddressCell *_cell = (OCallCarAddressCell *)sourceCell;
//                [_cell setupCellInfoWithObj:ordObj];
//            } cache:^NSDictionary *{
//                NSDictionary *cache = @{kHYBCacheUniqueKey : @"",
//                                        kHYBCacheStateKey : @"",
//                                        kHYBRecalculateForStateKey : @(YES)};
//                return cache;
//            }];
//            tableviewHeight += cellheight;
//        }
//    }
//    
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//        make.height.mas_equalTo(tableviewHeight);
//        if (tableviewHeight==0) {
//            make.top.equalTo(weakSelf.startLab.mas_bottom).offset(0);
//        }else{
//            make.top.equalTo(weakSelf.startLab.mas_bottom).offset(10);
//        }
//    }];
//    
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    [self.tableView reloadData];
//    
//    if (!kIsObjectEmpty(orderObj.modelNamef)) {
//        self.typeLab.text = orderObj.modelNamef;
//    }else{
//        self.typeLab.text = @"";
//    }
//    
//    self.startLab.text = kIsObjectEmpty(orderObj.startAddrNamef)?@"--":orderObj.startAddrNamef;
//    self.endLab.text = kIsObjectEmpty(orderObj.endAddrNamef)?@"--":orderObj.endAddrNamef;
//    
//    NSString *price = orderObj.pricef;
//    NSString *priceStr = [NSString stringWithFormat:@"运价：%@",price];
//    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
//    NSRange priceRange = [priceStr rangeOfString:price];
//    [priceAtt setTextColor:[UIColor priceColor] range:priceRange];
//    self.priceLab.attributedText = priceAtt;
//
//}

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

#pragma mark --抢单事件响应
/*!
 *  @author liujinliang, 16-10-05 22:10:13
 *
 *  @brief 抢单事件响应
 *
 *  @param sender <#sender description#>
 *
 *  @since <#1.0#>
 */
- (IBAction)orderBtnAction:(UIButton *)sender{
    WEAKSELF
    [UIAlertView alertViewWithTitle:@"提示" message:@"确定抢单吗?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger buttonIndex) {
        if (weakSelf.orderDelegate && [weakSelf.orderDelegate respondsToSelector:@selector(orderTableCell:orderObj:)]) {
            [weakSelf.orderDelegate orderTableCell:weakSelf orderObj:weakSelf.orderObj];
        }
    } onCancel:^{
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.orderBtn setLayerCornerRadius:4];
    [self.orderBtn setBackgroundImage:[UIImage imageWithColor:[UIColor mainColor]] forState:UIControlStateNormal];
    [self.orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.bgView setLayerCornerRadius:8];
}

#pragma mark --行数据显示
/*!
 *  @author liujinliang, 16-10-04 13:10:06
 *
 *  @brief 行数据显示
 *
 *  @param model <#model description#>
 *
 *  @since <#1.0#>
 */
- (void)setupCellInfoWith:(OrderInfoObj *)model {
    self.orderObj = model;
    
    WEAKSELF
    __block CGFloat tableviewHeight = 0;
    self.dataArray = model.orderPointList;
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

    self.startLab.text = [NSString toString:model.startAddrNamef];
    self.endLab.text = [NSString toString:model.endAddrNamef];
    self.typeLab.text = [NSString toString:model.modelNamef];
    NSString *price = model.pricef;
    NSString *priceStr = [NSString stringWithFormat:@"运价：%@",price];
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange priceRange = [priceStr rangeOfString:price];
    [priceAtt setTextColor:[UIColor priceColor] range:priceRange];
    self.priceLab.attributedText = priceAtt;

//    self.priceLab.text = kDoubleToString([[NSString toString:model.tipPricef] doubleValue]+[[NSString toString:model.pricef] doubleValue]);
}

@end
