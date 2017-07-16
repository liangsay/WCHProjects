//
//  UIImageView+Extension.m
//  ZiChanBao
//
//  Created by liujinliang on 15/6/15.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//
/*
 注意以上几个常量，凡是没有带Scale的，当图片尺寸超过
 ImageView尺寸时，只有部分显示在ImageView中。
 UIViewContentModeScaleToFill
    属性会导致图片变形。
 UIViewContentModeScaleAspectFit
    会保证图片比例不变，而且全部显示在ImageView中，这意味着ImageView会有部分空白。
 UIViewContentModeScaleAspectFill
    也会证图片比例不变，但是是填充整个ImageView的，可能只有部分图片显示出来。
 */
#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

#pragma mark --给图片添加圆角
/**
 *  给图片添加圆角
 *
 *  @param imageView 要添加圆角的图片对象
 *  @param radiuNum  圆角值
 */
- (void)setImageRadiusNum:(CGFloat)radiuNum
{
    [self.layer setCornerRadius:radiuNum];
    [self.layer setBorderWidth:.5f];
    [self.layer setBorderColor:[[UIColor borderColor] CGColor]];
    [self.layer setMasksToBounds:YES];
}

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
- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height{
    
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    UIImage *qrImg =[UIImage imageWithCIImage:transformedImage];//[self createNonInterpolatedUIImageFormCIImage:qrcodeImage withSize:width];//
    [self setImage:qrImg];
    
    
    return qrImg;
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

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
- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height withLogo:(UIImage *)logoImg {
    [self generateQRCode:code width:width height:height];
    [self setQRcodeLogoWithImage:logoImg];
    return self.image;
}

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
- (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    // 生成二维码图片
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

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
-(UIImage *)colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    //    CGContextDrawImage(ctx, area, baseImage.CGImage);
    //    CGContextDrawTiledImage(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    //    CGContextDrawImage(ctx, area, baseImage.CGImage); //改变背景
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.image = newImage;
    return newImage;
}

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
-(UIImage *)colorizeImage:(UIImage *)baseImage withBackgroundColor:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    
    [theColor set];
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage); //改变背景
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.image = newImage;
    return newImage;
}

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
-(UIImage *)maskWithImage:(UIImage *)theMaskImage {
    UIImage *baseImage = self.image;
    UIGraphicsBeginImageContext(baseImage.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGImageRef maskRef = theMaskImage.CGImage;
    
    CGImageRef maskImage = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                             CGImageGetHeight(maskRef),
                                             CGImageGetBitsPerComponent(maskRef),
                                             CGImageGetBitsPerPixel(maskRef),
                                             CGImageGetBytesPerRow(maskRef),
                                             CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([baseImage CGImage], maskImage);
    //	CGImageRelease(maskImage);
    //	CGImageRelease(maskRef);
    
    CGContextDrawImage(ctx, area, masked);
    //	CGImageRelease(masked);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.image = newImage;
    return newImage;
}

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
- (UIImage *) setQRcodeLogoWithImage:(UIImage *)logoImage{
//    UIImage *qrImage = self.image;
//    if(logoImage)
//    {
//        UIGraphicsBeginImageContext(qrImage.size);
//        
//        //Draw image2
//        [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
//        
//        //Draw image1
//        float r=qrImage.size.width*35/240;
//        [logoImage drawInRect:CGRectMake((qrImage.size.width-r)/2, (qrImage.size.height-r)/2 ,r, r)];
//        //     [topimg drawInRect:CGRectMake(101, 101 ,37, 37)];
//        //        [topimg drawInRect:CGRectMake((qrImage.size.width-38)/2, (qrImage.size.height-38)/2 ,38, 38)];
//        qrImage=UIGraphicsGetImageFromCurrentImageContext();
//        
//        UIGraphicsEndImageContext();
//    }
//    return qrImage;
    
    // two-dimension code 二维码
    CGSize size = self.image.size;
    CGSize size2 =CGSizeMake(1.0 / 4.5 * size.width, 1.0 / 4.5 * size.height);
    UIGraphicsBeginImageContext(size);
    
    [self.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [logoImage drawInRect:CGRectMake((size.width - size2.width) / 2.0, (size.height - size2.height) / 2.0, size2.width, size2.height)];
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = resultingImage;
    return resultingImage;
}

//
- (UIImage *) avatarImage:(UIImage *)avatarImage{
    UIImage * avatarBackgroudImage = avatarImage;
    CGSize size = avatarBackgroudImage.size;
    UIGraphicsBeginImageContext(size);
    
    [avatarBackgroudImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [avatarImage drawInRect:CGRectMake(10, 10, size.width - 20, size.height - 20)];
    
    UIImage *resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
@end
