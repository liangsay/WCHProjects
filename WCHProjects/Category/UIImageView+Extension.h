//
//  UIImageView+Extension.h
//  ZiChanBao
//
//  Created by liujinliang on 15/6/15.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)
#pragma mark --给图片添加圆角
- (void)setImageRadiusNum:(CGFloat)radiuNum;

#pragma mark --生成二维码
/**
 *  @author liujinliang, 15-12-09 16:12:53
 *
 *  生成二维码
 *
 *  @param code   <#code description#>
 *  @param width  <#width description#>
 *  @param height <#height description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;

#pragma mark --生成条形码
/**
 *  @author liujinliang, 15-12-09 16:12:24
 *
 *  生成条形码
 *
 *  @param code   <#code description#>
 *  @param width  <#width description#>
 *  @param height <#height description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;

#pragma mark --生成二维码
/**
 *  @author liujinliang, 15-12-09 16:12:53
 *
 *  生成二维码
 *
 *  @param code   <#code description#>
 *  @param width  <#width description#>
 *  @param height <#height description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height withLogo:(UIImage *)logoImg;
#pragma mark --改变二维码颜色
/**
 *  @author liujinliang, 15-12-10 10:12:24
 *
 *  改变图片的颜色
 *
 *  @param baseImage <#baseImage description#>
 *  @param theColor  <#theColor description#>
 *
 *  @return <#return value description#>
 */
-(UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor;

#pragma mark --改变图片的背景色
/**
 *  @author liujinliang, 15-12-10 10:12:37
 *
 *  改变图片的背景色
 *
 *  @param baseImage <#baseImage description#>
 *  @param theColor  <#theColor description#>
 *
 *  @return <#return value description#>
 */
-(UIImage *)colorizeImage:(UIImage *)baseImage withBackgroundColor:(UIColor *)theColor;

#pragma mark --二维码中间加入icon
/**
 *  @author liujinliang, 15-12-10 10:12:05
 *
 *  二维码中间加入icon
 *
 *  @param baseImage    <#baseImage description#>
 *  @param theMaskImage <#theMaskImage description#>
 *
 *  @return <#return value description#>
 */
-(UIImage *)maskWithImage:(UIImage *)theMaskImage;

#pragma mark --设置二维码logo
/**
 *  @author liujinliang, 15-12-10 11:12:11
 *
 *  设置二维码logo
 *
 *  @param logoImage <#avatarImage description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *) setQRcodeLogoWithImage:(UIImage *)logoImage;
@end
