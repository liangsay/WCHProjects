//
//  ToastView.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "ToastView.h"
#import "Masonry.h"
#import "UIView+Toast.h"
static ToastView *_displayingView;
@implementation ToastView

#pragma mark --指定位置显示消息
/*!
 *  @author liujinliang, 16-12-30 13:12:25
 *
 *  @brief 指定位置显示消息
 *
 *  @param message        <#message description#>
 *  @param toastAlignment <#toastAlignment description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#1.1.0#>
 */
+ (instancetype)toast:(NSString *)message toastAlignment:(ToastViewAlignment)toastAlignment {
    
    __weak ToastView *toastView = [self toast:message];
    
    if (toastAlignment==ToastView_PAlignmentTop) {
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(toastView.superview.mas_top).with.offset(2*kPadding);
            [make.bottom uninstall];
        }];
    }else if (toastAlignment==ToastView_PAlignmentCenter){
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(toastView.superview.center);
        }];
    }
    return toastView;
}

#pragma mark - 类方法
+ (instancetype)toast:(NSString *)message
{
    if (!message || message.length == 0) return nil;
    
    UIWindow *keyWin = [UIApplication sharedApplication].windows.lastObject;
    
    ToastView *view = [[ToastView alloc] init];
    view.text = message;
    [view sizeToFit];
    
    
    //    CGFloat width = view.width + 15 * 2;
    //    CGFloat height = view.height + 15 * 2;
    //    CGFloat x = (keyWin.width - width) / 2;
    //    CGFloat y = (keyWin.height - height) / 2;
    //    view.frame = CGRectMake(x, y, width, height);
    
    [keyWin addSubview:view];
    
    
    __weak ToastView *weakSelf = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat vWidth =(weakSelf.width+4*kPadding);
        if (vWidth>kScreenWidth-4*kPadding) {
            vWidth = kScreenWidth-4*kPadding;
            make.width.mas_offset(@(vWidth));
            make.left.equalTo(weakSelf.superview).with.offset(2*kPadding);
            make.right.equalTo(weakSelf.superview).with.offset(-2*kPadding);
            weakSelf.width = vWidth;
            CGSize size = [weakSelf sizeOfStringWithMaxHeight:100];
            make.height.mas_equalTo(@(size.height+20));
        }else{
            make.centerX.equalTo(weakSelf.superview.mas_centerX);
            make.width.mas_offset(@(weakSelf.width+2*kPadding));
            make.height.mas_equalTo(@(weakSelf.height+20));
        }
        
        make.bottom.equalTo(weakSelf.superview).with.offset(-30);
        
    }];
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
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.font = [UIFont systemFontOfSize:30 / 2];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 0;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_displayingView)
    {
        [_displayingView removeFromSuperview];
    }
    _displayingView = self;
    
    UIView *superView = self.superview;
    self.maskBackground.frame = superView.bounds;
    [superView insertSubview:self.maskBackground belowSubview:self];
    
    self.maskBackground.alpha = 0;
    self.alpha = 0;
    self.y = kScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.maskBackground.alpha = 0.2;
        self.alpha = 1.0;
        self.y = self.height+30;
    }];
    
    [self performSelector:@selector(onMaskBackground) withObject:nil afterDelay:2.0];
}

#pragma mark - Action
- (void)onMaskBackground
{
    [UIView animateWithDuration:0.25 animations:^{
        self.maskBackground.alpha = 0;
        self.y = kScreenHeight;
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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaskBackground)];
        [_maskBackground addGestureRecognizer:tap];
    }
    return _maskBackground;
}

@end
