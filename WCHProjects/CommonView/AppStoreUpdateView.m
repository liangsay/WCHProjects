//
//  AppStoreUpdateView.m
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/8.
//  Copyright © 2015年 liujinliang All rights reserved.
//

#import "AppStoreUpdateView.h"
#import "Masonry.h"

static AppStoreUpdateView *_alertView;

@implementation AppStoreUpdateView

#pragma mark - 类方法
+ (instancetype)showAlertViewWithObject:(UpdateVersion *)versionObj alertView:(UpdateVersionCompletedBlock)alertView
{
    if (!versionObj) return nil;
    
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    
    AppStoreUpdateView *view = [[AppStoreUpdateView alloc] init];
    view.versionObj = versionObj;
    view.alertViewCommplet = alertView;
    [keyWin addSubview:view];
    
    [view initInfoView];
    return view;
}

#pragma mark - Life Cycle
- (void)removeFromSuperview
{
    [self.maskBackground removeFromSuperview];
    [super removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)initInfoView{
    UIView *superV = self.superview;
//    kWEAKSELF

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(superV);
        make.width.mas_equalTo(@(kScreenWidth-2*kMargin));
//        make.size.mas_equalTo((CGSize){300,300});
    }];
    
    UIImageView *versionImgV = [UIImageView new];
    [self addSubview:versionImgV];
    UIImage *img =kIMAGE(@"icon-version-plan");
    [versionImgV setContentMode:UIViewContentModeCenter];
    [versionImgV setImage:img];
    [versionImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(5,5,5,5));
        make.top.equalTo(self).with.offset(15);
        make.left.equalTo(self).with.offset(15);
//        make.bottom.equalTo(sv).with.offset(-10);
        make.right.equalTo(self).with.offset(-15);
        make.height.mas_equalTo(@(img.size.height));
    }];
    
//
    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    [titleLab setBackgroundColor:[UIColor clearColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setFont:kFont(30)];
    [titleLab setTextColor:[UIColor fontBlack]];
    
    NSString *versionName = [NSString stringWithFormat:@"发现新版本 %@",[NSString toString:_versionObj.versionName]];
    [titleLab setText:versionName];
    [titleLab sizeToFit];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(versionImgV.mas_bottom);
        make.left.equalTo(self).with.offset(kMargin);
        make.right.equalTo(self).with.offset(-kMargin);
        make.height.mas_equalTo(@35);
    }];
//
    UITextView *contentView = [UITextView new];
    [contentView setDelegate:self];
    [self addSubview:contentView];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView setEditable:YES];
    [contentView setFont:kFont(30.)];
    [contentView setTextColor:[UIColor fontGray]];
    
//    _versionObj.describer = @"  圣诞节法律考试大姐夫开发了解粮食店街洛杉矶令肌肤了了解离开结束了会计法律实践失联客机了手机费老实交代垃圾垃圾费来刷卡缴费绿色空间了\n 房间数量的开发建设领导发生了空间分开始减肥了坚实的浪费了/n  圣诞节法律考试大姐夫开发了解粮食店街洛杉矶令肌肤了了解离开结束了会计法律实践失联客机了手机费老实交代垃圾垃圾费来刷卡缴费绿色空间了\n 房间数量的开发建设领导发生了空间分开始减肥了坚实的浪费了/n  圣诞节法律考试大姐夫开发了解粮食店街洛杉矶令肌肤了了解离开结束了会计法律实践失联客机了手机费老实交代垃圾垃圾费来刷卡缴费绿色空间了\n 房间数量的开发建设领导发生了空间分开始减肥了坚实的浪费了";
    [contentView setText:[NSString toString:_versionObj.describe]];
    NSMutableAttributedString *descAtt = [[NSMutableAttributedString alloc] initWithString:_versionObj.describe];
    [descAtt setTextAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping lineSpacing:1.0 lineHeightMultiple:1.5];
    [descAtt setFont:kFont(28)];
    contentView.attributedText = descAtt;
//    [contentView sizeThatFits:(CGSize){self.width-30,MAXFLOAT}];
    CGSize size =[contentView sizeWithTextViewWidth:kScreenWidth-2*kMargin];
    if(size.height>(kScreenHeight*2/3))
        size.height = kScreenHeight*2/3;
    contentView.height+=10;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom);
        make.left.equalTo(self).with.offset(kMargin);
        make.right.equalTo(self).with.offset(-kMargin);
        make.height.mas_equalTo(@(size.height));
        
    }];
//
    UILabel *lineLab = [UILabel horizontalLineWithLength:0];
    [self addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_bottom);
        make.left.width.right.equalTo(self);
        make.height.mas_equalTo(@(.5));
    }];
    
    UIButton *cancelBtn;
    UIButton *sureBtn;
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"前往AppStore" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor hexValue:0x0079fe] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor fontBlack] forState:UIControlStateHighlighted];
    [[sureBtn titleLabel] setFont:kFont(30.f)];
    [sureBtn addTarget:self action:@selector(alertViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTag:101];
    [self addSubview:sureBtn];
    _versionObj.isForecdUpdate = @"0";
    if (![_versionObj.isForecdUpdate boolValue]) {
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"忽略提示" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor fontGray] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor fontBlack] forState:UIControlStateHighlighted];
        [[cancelBtn titleLabel] setFont:kFont(30.f)];
        [cancelBtn setTag:100];
        [cancelBtn addTarget:self action:@selector(alertViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@50);
            make.width.equalTo(sureBtn);
            make.right.equalTo(sureBtn.mas_left);
            make.left.equalTo(self);
            make.top.mas_equalTo(lineLab.mas_bottom);
        }];
        
        UIView *vLineV = [UILabel verticalLineWithLength:0];
        [self addSubview:vLineV];
        [vLineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineLab.mas_bottom);
            make.left.equalTo(sureBtn.mas_left);
            make.width.mas_equalTo(@(.5));
            make.height.equalTo(cancelBtn);
        }];
        
    }
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (cancelBtn) {
            make.width.equalTo(cancelBtn);
            make.left.equalTo(cancelBtn.mas_right);
            make.right.equalTo(self);
        }else{
            make.width.equalTo(self);
            make.left.right.equalTo(self);
        }
        make.top.mas_equalTo(lineLab.mas_bottom);
        make.height.mas_equalTo(@50);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sureBtn.mas_bottom);
//        make.center.equalTo(superV);
    }];
}

#pragma mark UITextViewDelegate
#pragma mark --禁止复制，编辑，放大等功能
/**
 *  @author liujinliang, 15-12-09 14:12:05
 *  禁止复制，编辑，放大等功能
 *  txtView.editable一定要设置成YES
 *
 *  @param textView <#textView description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}
#pragma mark -- 按钮功能事件
/**
 *  @author liujinliang, 15-12-09 11:12:10
 *
 *  按钮功能事件
 *
 *  @param sender <#sender description#>
 */
- (void)alertViewBtnAction:(UIButton *)sender {
    if (_alertViewCommplet) {
        NSInteger tag = sender.tag;
        _alertViewCommplet(tag-100,self);
    }
    [self onMaskBackground];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_alertView)
    {
        [_alertView removeFromSuperview];
    }
    _alertView = self;
    
    UIView *superView = self.superview;
    self.maskBackground.frame = superView.bounds;
    [superView insertSubview:self.maskBackground belowSubview:self];
    
    self.maskBackground.alpha = 0;
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.maskBackground.alpha = 0.2;
        self.alpha = 1.0;
    }];
    
//    [self performSelector:@selector(onMaskBackground) withObject:nil afterDelay:2.0];
}

#pragma mark - Action
- (void)onMaskBackground
{
    [UIView animateWithDuration:0.25 animations:^{
        self.maskBackground.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.maskBackground removeFromSuperview];
        [super removeFromSuperview];
    }];
}

#pragma mark - View
- (UIView *)maskBackground
{
    if (!_maskBackground)
    {
        _maskBackground = [[UIView alloc] init];
        _maskBackground.backgroundColor = [UIColor blackColor];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaskBackground)];
//        [_maskBackground addGestureRecognizer:tap];
    }
    return _maskBackground;
}



@end
