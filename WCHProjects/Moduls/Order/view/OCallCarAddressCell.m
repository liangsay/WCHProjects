//
//  OCallCarAddressCell.m
//  WCHProjects
//
//  Created by liujinliang on 2017/8/2.
//  Copyright © 2017年 liujinliang. All rights reserved.
//

#import "OCallCarAddressCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
NSString * const kOCallCarAddressCellID = @"kOCallCarAddressCellID";
CGFloat const kOCallCarAddressCellHeight = 58;
@implementation OCallCarAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViewsSet];
        [self setupContraintSet];
        self.hyb_lastViewInCell = self.lineV;
        self.hyb_bottomOffsetToCell = 0;
    }
    return self;
}

- (void)setupViewsSet {
    
    UILabel *nameLab = [UILabel new];
    nameLab.font = [UIFont fontContent];
    nameLab.textColor = [UIColor mainColor];
    [self.contentView addSubview:nameLab];
    self.nameLab = nameLab;
    
    UILabel *mobileLab = [UILabel new];
    mobileLab.font = [UIFont fontContent];
    mobileLab.userInteractionEnabled = YES;
    mobileLab.multipleTouchEnabled = YES;
    mobileLab.textColor = [UIColor priceColor];
    [self.contentView addSubview:mobileLab];
    self.mobileLab = mobileLab;
    
    UILabel *addressLab = [UILabel new];
    addressLab.font = [UIFont fontAssistant];
    addressLab.textColor = [UIColor fontGray];
    addressLab.numberOfLines = 0;
    addressLab.preferredMaxLayoutWidth = kScreenWidth - 15 * 4;
    addressLab.userInteractionEnabled = YES;
    [self.contentView addSubview:addressLab];
    self.addressLab = addressLab;
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor borderColor];
    [self.contentView addSubview:lineV];
    self.lineV = lineV;
    
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mobileLabAction:)];
    tapAction.delegate = self;
    [mobileLab addGestureRecognizer:tapAction];
    
    UITapGestureRecognizer *startTapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTapAction:)];
    startTapAction.delegate = self;
    [addressLab addGestureRecognizer:startTapAction];
}

- (void)mobileLabAction:(UIGestureRecognizer *)sender {
    kMakeCallWithPhone(self.orderObj.phonef, kWindow);
}

#pragma mark --地址导航
- (void)startTapAction:(UIGestureRecognizer *)sender{
    NSArray *points = [self.orderObj.positionf componentsSeparatedByString:@","];
    CLLocationCoordinate2D coord;
    coord.latitude = [[points firstObject] doubleValue];
    coord.longitude = [[points lastObject] doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    self.orderObj.pointLocation = location;
    [[LocationServer shared] carLocationWith:location orderObj:self.orderObj seleIndex:2];
}

- (void)setupContraintSet{
    WEAKSELF
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
    }];
    
    [self.mobileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(weakSelf.nameLab);
        make.left.greaterThanOrEqualTo(weakSelf.nameLab.mas_right).offset(10);
    }];
    
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).offset(5);
        make.right.equalTo(@-15);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@-15);
        make.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(weakSelf.addressLab.mas_bottom).offset(10);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addressLab.preferredMaxLayoutWidth = kScreenWidth - 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若点击了tableViewCell，则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


- (void)setupCellInfoWithObj:(OrderInfoObj *)orderObj {
    self.orderObj = orderObj;
    
    self.nameLab.text = kIsObjectEmpty(orderObj.namef)?@"--":orderObj.namef;
    self.mobileLab.text = kIsObjectEmpty(orderObj.phonef)?@"--":orderObj.phonef;
    self.addressLab.text =kIsObjectEmpty(orderObj.addressf)?@"--":orderObj.addressf;
    
}

@end
