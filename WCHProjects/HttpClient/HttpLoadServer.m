//
//  HttpLoadServer.m
//  WorldUnionBrokerPlatform
//
//  Created by liujinliang on 16/5/5.
//  Copyright © 2016年 www.liujinliang All rights reserved.
//

#import "HttpLoadServer.h"
#import "UIImage+GIF.h"
@implementation HttpLoadServer
DEFINE_SINGLETON_FOR_CLASS(HttpLoadServer)
- (void)show {
    
    if (self.isShow) {
        return;
    }
    
    self.isShow = YES;
    //    UIImage *gifImg = [[UIImage sd_animatedGIFNamed:@"loading"] sd_animatedImageByScalingAndCroppingToSize:(CGSize){10,10}];
    //    UIImageView *loadingV = [[UIImageView alloc] initWithImage:gifImg];
    
    __block UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0,0,60,60}];
    bgView.tag = 1010;
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
    bgView.alpha = 0;
    [bgView setLayerCornerRadius:12];
    UIImageView *loadingV = [UIImageView new];
    NSMutableArray *loadings = [NSMutableArray array];
    for (int i=0; i<17; i++) {
        NSString *imageStr = [NSString stringWithFormat:@"loading-%d",(i+1)];
        UIImage *loadImg = kIMAGE(imageStr);
        [loadings addObject:loadImg];
    }
    
    loadingV.animationImages = loadings;
    loadingV.animationDuration = .7;
    [loadingV startAnimating];
    [loadingV setContentMode:UIViewContentModeScaleToFill];
    [loadingV setFrame:(CGRect){0,0,39*.8,8}];
    loadingV.center = bgView.center;
    loadingV.tag = 1010;
    [bgView addSubview:loadingV];
    
    [kAppDelegate.window addSubview:bgView];
    [kAppDelegate.window bringSubviewToFront:bgView];
    [bgView setCenter:(CGPoint){kScreenWidth/2,kScreenHeight/2}];
    [UIView animateWithDuration:.1 animations:^{
        bgView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide {
    [self performSelector:@selector(timerHide) withObject:nil afterDelay:.5];
}

- (void)timerHide {
    self.isShow = NO;
    [kAppDelegate.window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *imgV = obj;
            if (imgV.tag==1010) {
                [UIView animateWithDuration:.5 animations:^{
                    imgV.alpha = 0;
                } completion:^(BOOL finished) {
                    [imgV removeFromSuperview];
                }];
            }
        }
    }];
}
@end
