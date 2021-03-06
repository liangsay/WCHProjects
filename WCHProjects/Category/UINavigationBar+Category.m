//
//  UINavigationBar+Category.m
//  WorldUnionBrokerPlatform
//
//  Created by liujinliang on 16/2/24.
//  Copyright © 2016年 www.liujinliang All rights reserved.
//

#import "UINavigationBar+Category.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Category)

static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ul_setUnderLineColor:(UIColor *)color
{
    if (!self.overlay)
    {
        UIImageView *shadowView = nil;
        
        NSArray *navigationBarSubviews = [self subviews];
        
        for (UIView *view in navigationBarSubviews)
        {
            NSString *viewName = NSStringFromClass([view class]);
            
            if ([viewName isEqualToString:@"_UINavigationBarBackground"])
            {
                shadowView = [view valueForKey:@"_shadowView"];
                
                if (shadowView == nil) {
                    return;
                }
                
                self.overlay = [[UIView alloc] initWithFrame:shadowView.frame];
                self.overlay.userInteractionEnabled = NO;
                self.overlay.translatesAutoresizingMaskIntoConstraints = NO;
                [view addSubview:self.overlay];
                
                [view addConstraints:@[
                                       
                                       [NSLayoutConstraint constraintWithItem:self.overlay
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:shadowView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.overlay
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:shadowView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.overlay
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:shadowView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:0],
                                       
                                       [NSLayoutConstraint constraintWithItem:self.overlay
                                                                    attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:shadowView
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1
                                                                     constant:0],
                                       ]];
                
                break;
            }
            
            if (shadowView) {
                break;
            }
        }
    }
    
    if (self.overlay) {
        self.overlay.backgroundColor = color;
    }
}

- (void)ul_reset
{
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
