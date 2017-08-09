//
//  MyRouteTableCell.m
//  WCHProjects
//
//  Created by liujinliang on 2016/10/4.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "MyRouteTableCell.h"
NSString * const kMyRouteTableCellID = @"kMyRouteTableCellID";
CGFloat const kMyRouteTableCellHeight = 80;
@implementation MyRouteTableCell

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
        [self initUIViews];
        self.backgroundColor = [UIColor backgroundColor];
        self.contentView.backgroundColor = [UIColor backgroundColor];
        self.backgroundView.backgroundColor = [UIColor backgroundColor];
        self.backgroundBtnView.userInteractionEnabled = YES;
        [self.backgroundBtnView setBackgroundImageColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)initUIViews {
    WEAKSELF
    _timeLab = [BaseViewServer addLabelInView:self.contentView font:kFont(28) text:@"" textColor:[UIColor fontGray] textAilgnment:NSTextAlignmentLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backgroundBtnView.mas_left).offset(kMargin).priorityHigh(1000);
        make.top.offset(kPadding);
    }];
    
    _typeLab = [BaseViewServer addLabelInView:self.contentView font:kFont(28) text:@"" textColor:[UIColor mainColor] textAilgnment:NSTextAlignmentLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.timeLab.mas_right).offset(kPadding/2).priorityHigh(1000);
        make.centerY.equalTo(weakSelf.timeLab);
    }];
    
    _stateLab = [BaseViewServer addLabelInView:self.contentView font:kFont(28) text:@"" textColor:[UIColor fontBlack] textAilgnment:NSTextAlignmentRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.centerY.equalTo(weakSelf.timeLab);
        make.left.greaterThanOrEqualTo(weakSelf.typeLab.mas_right).offset(5);
    }];
    
    _startImgV = [BaseViewServer addImageViewInView:self.contentView image:kIMAGE(@"出发地") contentMode:UIViewContentModeScaleAspectFit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kPadding);
        make.top.equalTo(weakSelf.timeLab.mas_bottom).offset(kPadding-2);
        make.width.height.mas_equalTo(8);
    }];
    
    _startLab = [BaseViewServer addLabelInView:self.contentView font:kFont(28) text:@"" textColor:[UIColor fontGray] textAilgnment:NSTextAlignmentLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.timeLab).offset(kPadding);;
        make.centerY.equalTo(weakSelf.startImgV);
        make.right.equalTo(weakSelf.stateLab.mas_right);
    }];
    
    _endImgV = [BaseViewServer addImageViewInView:self.contentView image:kIMAGE(@"目的地") contentMode:UIViewContentModeScaleAspectFit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kPadding);
        make.top.equalTo(weakSelf.startImgV.mas_bottom).offset(kMargin);
        make.width.height.mas_equalTo(8);
    }];
    
    _endLab = [BaseViewServer addLabelInView:self.contentView font:kFont(28) text:@"" textColor:[UIColor fontGray] textAilgnment:NSTextAlignmentLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.endImgV.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.endImgV);
    }];
    _cancelBtn = [BaseViewServer addButtonInView:self.contentView font:kFont(24) title:@"取消订单" titleColor:[UIColor mainColor] addTarget:self action:@selector(cancelBtnAction:) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.endLab.mas_right).offset(5);
        make.right.offset(-5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
        make.centerY.equalTo(weakSelf.endLab);
    }];
    _cancelBtn.alpha = 0;
    [_cancelBtn setLayerCornerRadius:4];
    [_cancelBtn setLayerBorderWidth:.5 color:[UIColor mainColor]];
}

#pragma mark --货主在订单被接的时候可以取消订单
- (void)cancelBtnAction:(UIButton *)sender {
    WEAKSELF
    [UIAlertView alertViewWithTitle:@"提示：" message:@"确定取消该订单吗" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger buttonIndex) {
        if (weakSelf.inComeDelegate && [weakSelf.inComeDelegate respondsToSelector:@selector(myRouteTableCell:orderObj:cancelOrder:)]) {
            [weakSelf.inComeDelegate myRouteTableCell:self orderObj:self.orderObj cancelOrder:YES];
        }
    } onCancel:^{
        
    }];
    
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
    NSString *createTimef = model.createTimef;
    if (!kIsObjectEmpty(createTimef) && createTimef.length>15) {
        createTimef = [model.createTimef substringToIndex:16];
    }
    self.timeLab.text = createTimef;
    //对司机评价
    BOOL assessDriverf = model.assessDriverf.boolValue;
    //对货主评价
    BOOL assessOwerf = model.assessOwerf.boolValue;
    //0:未接单 1：已接单 2：未支付  3:已支付 4：已取消
    NSInteger statusf = model.statusf.integerValue;
    if (_cellType==MyRouteTableCellTypeInCome) {
        //司机
        self.typeLab.textColor = [UIColor redColor];
//        if (model.tipPricef.doubleValue) {
//            self.typeLab.text = [NSString stringWithFormat:@"%.2f+%@",model.pricef.doubleValue,model.tipPricef];
//        }else{
            self.typeLab.text = [NSString stringWithFormat:@"%.2f",model.pricef.doubleValue];
//        }
        //对货主评价
        if (statusf==3) {
            if (!assessOwerf) {
                self.stateLab.text = @"待评价";
            }else{
                self.stateLab.text = @"已评价";
            }
            
        }else{
            self.stateLab.text = [NSString toString:model.statusTextf];
        }
    }else{
        //货主
        self.typeLab.text = [NSString stringWithFormat:@"%@ %@",[NSString toString:model.modelNamef],model.pricef];
//        if (!kIsObjectEmpty(model.tipPricef) && model.tipPricef.doubleValue>0) {
//            self.typeLab.text=[self.typeLab.text stringByAppendingFormat:@"+%@",model.tipPricef];
//        }
        //对司机评价
        if (statusf==3) {
            if (!assessDriverf) {
                self.stateLab.text = @"待评价";
            }else{
                self.stateLab.text = @"已评价";
            }
            
        }else{
            self.stateLab.text = [NSString toString:model.statusTextf];
        }
    }
    
    self.startLab.text = [NSString toString:model.startAddrNamef];
    self.endLab.text = [NSString toString:model.endAddrNamef];
    
    if ((statusf==1 &&_cellType==MyRouteTableCellTypeInCome)|| statusf==0) {//在已接单状态，司机或货主可取消订单
        self.cancelBtn.alpha = 1;
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
        }];
    }else{
        [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [super layoutIfNeeded];
    [self.backgroundBtnView setLayerCornerRadius:4];
    WEAKSELF
    [self.backgroundBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, kPadding, 0, kPadding));
    }];
}
@end
