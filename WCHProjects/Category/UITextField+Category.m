//
//  UITextField+Category.m
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/11.
//  Copyright © 2015年 liujinliang All rights reserved.
//

#import "UITextField+Category.h"
#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."
#define kNumbersheng  @"0123456789-_"
#define kNumbersX  @"0123456789Xx"

@implementation UITextField (Category)

#pragma mark --txtField左间距
/**
 *  @author liujinliang, 15-12-11 15:12:06
 *
 *  txtField左间距
 *
 *  @param textField <#textField description#>
 *  @param leftWidth <#leftWidth description#>
 */
-(void)setTextFieldLeftPaddingWidth:(CGFloat)leftWidth
{
    CGRect frame = self.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftview;
}

#pragma mark --检查输入金额格式
static BOOL isHaveDian;
/**
 *  @author liujinliang, 15-12-14 15:12:01
 *
 *  检查输入金额格式
 *
 *  @param toBeString <#toBeString description#>
 *  @param string     <#string description#>
 *  @param range      <#range description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)checkMoneyFormatWithString:(NSString *)toBeString string:(NSString *)string range:(NSRange)range{
    if ([toBeString rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([self.text length] == 0){
                if(single == '.') {
//                    [self showError:@"亲，第一个数字不能为小数点"];
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
//                if (single == '0') {
//                    [self showError:@"亲，第一个数字不能为0"];
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
//                    [self showError:@"亲，您已经输入过小数点了"];
                    [self.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [toBeString rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
//                        [self showError:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
//            [self showError:@"亲，您输入的格式不正确"];
            [self.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

#pragma mark --检查限制性输入
/*!
 *  @author liujinliang, 16-01-23 14:01:36
 *
 *  @brief *  检查限制性输入
 *
 #define 0 kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
 #define 1 kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
 #define 2 kNumbers     @"0123456789"
 #define 3 kNumbersPeriod  @"0123456789."
 #define 4 kNumbersheng  @"0123456789-"
 *
 *  @param string_ <#string_ description#>
 *  @param typ     <#typ description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#2.0.0#>
 */
-(BOOL)ChenkInputNSCharacterSet:(NSString *)string_ typeInt:(int)typ {
    NSString *typeString;
    
    if (typ==0) {
        typeString = kAlphaNum;
    }else if (typ==1){
        typeString = kAlpha;
    }else if (typ==2){
        typeString = kNumbers;
    }else if(typ==3){
        typeString = kNumbersPeriod;
    }else if (typ==4){
        typeString = kNumbersheng;
    }else if (typ==5){
        typeString = kNumbersX;
    }
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:typeString] invertedSet];
    NSString *filtered =
    [[string_ componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string_ isEqualToString:filtered];
    return basic;
}
#pragma mark --设置文本框右视图，支持按钮事件
/*!
 *  @author liujinliang, 16-01-23 11:01:46
 *
 *  @brief 设置文本框右视图，支持按钮事件
 *
 *  @param iconName    <#iconName description#>
 *  @param selIconName <#selIconName description#>
 *  @param target      <#target description#>
 *  @param action      <#action description#>
 *
 *  @since <#2.0.0#>
 */
- (UIButton *) setRightViewWithImageName:(NSString *)iconName selIconName:(NSString *)selIconName addTarget:(id)target action:(SEL)action {
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn setImage:kIMAGE(iconName) forState:UIControlStateNormal];
    [iconBtn setImage:kIMAGE(selIconName) forState:UIControlStateHighlighted];
    [iconBtn setImage:kIMAGE(selIconName) forState:UIControlStateSelected];
    [iconBtn setFrame:(CGRect){0,0,self.height,self.height}];
    [iconBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = iconBtn;
    
    return iconBtn;
}

#pragma mark --设置文本框左视图
/*!
 *  @author liujinliang, 16-01-23 11:01:09
 *
 *  @brief 设置文本框左视图
 *
 *  @param iconName <#iconName description#>
 *
 *  @since <#2.0.0#>
 */
- (UIImageView *)setLeftViewWithImageName:(NSString *)iconName {
    UIImageView *iconImgV = [UIImageView new];
    UIImage *iconImg = kIMAGE(iconName);
    iconImg= [iconImg resizedImageToSize:(CGSize){15,15}];
    iconImgV.image = iconImg;
    iconImgV.contentMode = UIViewContentModeCenter;
    [iconImgV setFrame:(CGRect){0,0,30,self.height}];
    self.leftView = iconImgV;
    self.leftViewMode = UITextFieldViewModeAlways;
    return iconImgV;
}
//
//- (id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//
//    if ([[super hitTest:point withEvent:event] isEqual:self.rightView]) {
//        if (CGRectContainsPoint(self.rightView.frame, point)) {
//            return self.rightView;
//        } else {
//            return self;
//        }
//    }
//    
//    return [super hitTest:point withEvent:event];
//}

@end
