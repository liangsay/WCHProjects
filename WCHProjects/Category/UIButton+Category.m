//
//  UIButton+Category.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)

- (void)setTitleFontSize:(CGFloat)fontSize color:(UIColor *)color title:(NSString *)title
{
    self.titleLabel.font = kFont(fontSize);
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

- (void)setNormalHighlightedFont:(UIFont *)font color:(UIColor *)color
{
    self.titleLabel.font = font;
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

- (void)setNormalHighlightedTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
}

- (void)setNormalHighlightedImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
}

- (void)setNormalHighlightedImageName:(NSString *)imageName
{
    [self setNormalHighlightedImage:[UIImage imageNamed:imageName]];
}

- (void)setBackgroundImageColor:(UIColor *)backgroundImageColor
{
    [self setBackgroundImageColor:backgroundImageColor forState:UIControlStateNormal];
    [self setBackgroundImageColor:backgroundImageColor forState:UIControlStateHighlighted];
}

- (UIColor *)backgroundImageColor
{
    return [self backgroundImageColorForState:UIControlStateNormal];
}

- (void)setBackgroundImageColor:(UIColor *)backgroundImageColor forState:(UIControlState)state
{
    UIImage *image = [UIImage imageWithColor:backgroundImageColor];
    [self setBackgroundImage:image forState:state];
}

-(UIColor *)backgroundImageColorForState:(UIControlState)state
{
    UIImage *image = [self backgroundImageForState:state];
    if (!image) return nil;
    return [UIColor colorWithPatternImage:image];
}

- (void)setBackgroundColorAndImageClear
{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundImageColor = [UIColor clearColor];
}

/**
 *  调整布局
 *  @param type      布局类型
 *  @param midSpace  图片和文字的中间间距
 *  @param sizeToFit 是否调用sizeToFit方法
 */
- (void)adjustLayoutWithType:(UIButtonLayoutType)type midSpace:(CGFloat)midSpace sizeToFit:(BOOL)sizeToFit
{
    if (sizeToFit)
    {
        [self sizeToFit];
        if (UIButtonLayoutTypeLeftTitleRightImage == type)
        {
            self.width += midSpace;
        }
    }
    //    CGSize titleSize = [[self titleForState:UIControlStateNormal] sizeWithFont:self.titleLabel.font];
    CGSize titleSize = [[self titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    
    UIEdgeInsets titleEdgeInset = UIEdgeInsetsZero;
    UIEdgeInsets imageEdgeInset = UIEdgeInsetsZero;
    
    if (UIButtonLayoutTypeLeftTitleRightImage == type)
    {
        titleEdgeInset = UIEdgeInsetsMake(0, -self.imageView.size.width, 0, self.imageView.size.width + midSpace);
        imageEdgeInset = UIEdgeInsetsMake(0, titleSize.width + midSpace, 0, -titleSize.width);
    }
    
    [self setTitleEdgeInsets:titleEdgeInset];
    [self setImageEdgeInsets:imageEdgeInset];
}

/**
 *  @author King, 15-06-16 10:06:17
 *
 *  设置圆角或边框
 *
 *  @param radius <#radius description#>
 *  @param border <#border description#>
 *  @param color  <#color description#>
 */
- (void)setButtonRadiu:(CGFloat)radius border:(CGFloat)border color:(UIColor *)color{
    self.layer.masksToBounds = YES;
    radius?self.layer.cornerRadius = radius:0;
    border?self.layer.borderWidth = border:0;
    color?self.layer.borderColor =color.CGColor:0;
}

- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    
    //设置段落模式
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: self.titleLabel.font, NSParagraphStyleAttributeName: paragraph};
    
    CGSize titleSize = [self.titleLabel.text getSizeStringWithBoundingRectWithSize:(CGSize){self.width,self.titleLabel.height} options:-1 attributes:attribute context:nil].size;//[Tools HeightForViewClass:self.titleLabel.text fonts:self.titleLabel.font size:(CGSize){self.width,CGRectGetHeight(self.titleLabel.frame)} lineBreakModel:NSLineBreakByWordWrapping];//self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(
                                            - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                            0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
    //    [typeBtn setImageEdgeInsets:(UIEdgeInsets){-20,0,0,-size.width}];
    //    [typeBtn setTitleEdgeInsets:(UIEdgeInsets){20,-btnImage.size.width,0,0}];
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}


- (void)centerImageAndButton:(CGFloat)gap imageOnTop:(BOOL)imageOnTop {
    NSInteger sign = imageOnTop ? 1 : -1;
    
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake((imageSize.height+gap)*sign, -imageSize.width, 0, 0);
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: self.titleLabel.font, NSParagraphStyleAttributeName: paragraph};
    
    CGSize titleSize = [self.titleLabel.text getSizeStringWithBoundingRectWithSize:(CGSize){self.width,self.titleLabel.height} options:-1 attributes:attribute context:nil].size;//[Tools HeightForViewClass:self.titleLabel.text fonts:self.titleLabel.font size:(CGSize){self.width,CGRectGetHeight(self.titleLabel.frame)} lineBreakModel:NSLineBreakByWordWrapping];
    self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height+gap)*sign, 0, 0, -titleSize.width);
}

#pragma mark --左文右图
/**
 *  左文右字
 */
- (void)setLeftTitleAndRightImage{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.size.width, 0, self.imageView.size.width+5)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: self.titleLabel.font, NSParagraphStyleAttributeName: paragraph};
    
    CGSize titleSize = [self.titleLabel.text getSizeStringWithBoundingRectWithSize:(CGSize){self.width,self.titleLabel.height} options:-1 attributes:attribute context:nil].size;//[Tools HeightForViewClass:self.titleLabel.text fonts:self.titleLabel.font size:(CGSize){self.width,CGRectGetHeight(self.titleLabel.frame)} lineBreakModel:NSLineBreakByWordWrapping];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
}
#pragma mark --左文右图
/**
 *  左文右字
 */
- (void)setLeftTitleAndRightImage:(CGFloat)padding{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.size.width, 0, self.imageView.size.width+padding)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: self.titleLabel.font, NSParagraphStyleAttributeName: paragraph};
    
    CGSize titleSize = [self.titleLabel.text getSizeStringWithBoundingRectWithSize:(CGSize){self.width,self.titleLabel.height} options:-1 attributes:attribute context:nil].size;//[Tools HeightForViewClass:self.titleLabel.text fonts:self.titleLabel.font size:(CGSize){self.width,CGRectGetHeight(self.titleLabel.frame)} lineBreakModel:NSLineBreakByWordWrapping];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
}

#pragma mark --向右箭头
/**
 *  @author King, 15-05-16 10:05:20
 *
 *  <#Description#>
 */
- (void)addRightImageView{
    UIImage *img = [UIImage imageNamed:@"next_"];
    CGFloat x = self.width-kMargin-img.size.width;
    CGFloat height = self.height;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:(CGRect){x,0,img.size.width,height}];
    [imgV setImage:img];
    [imgV setContentMode:UIViewContentModeCenter];
    [self addSubview:imgV];
}

#pragma mark - button倒计时
- (void)setTheCountdownButton:(UIButton *)button startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0), 1.0 * NSEC_PER_SEC,0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut == 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = mColor;
                [button setTitle:title forState:UIControlStateNormal];
                button.userInteractionEnabled =YES;
            });
        } else {
            int seconds = timeOut % 60;
            NSString *timeStr = [NSString stringWithFormat:@"%0.1d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = color;
                [button setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle]forState:UIControlStateNormal];
                button.userInteractionEnabled =NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}
@end
