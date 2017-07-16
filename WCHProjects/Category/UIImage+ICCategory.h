//
//  UIImage+ICCategory.h
//  ICLibraryProject
//
//  Created by Fox on 13-8-26.
//  Copyright (c) 2013年 iChance. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ImageScaleModeToFill,         // full
    ImageScaleModeAspectFit,      // scaled to fit with fixed aspect. remainder is transparent
    ImageScaleModeAspectFill,     // scaled to fill with fixed aspect. some portion of content may be clipped.
} ImageScaleMode;

@interface UIImage (ICCategory)

/*!
 @method
 @abstract      使用imageWithContentsOfFile添加本地的PNG图片
 @discussion
 */
+ (UIImage *) getPNGImageFromContentFile:(NSString *) imageName;

/*!
 @method
 @abstract      使用imageWithContentsOfFile添加本地的JPG图片
 @discussion
 */
+ (UIImage *) getJPEGImageFromContentFile:(NSString *) imageName;

/*!
 @method
 @abstract      添加图片倒映
 @discussion
 */
- (UIImage *)addImageReflection:(CGFloat)reflectionFraction;

/*!
 @method
 @abstract          截取图片的局部
 @discussion
 
 @param rect        截取的范围
 */
- (UIImage *)subImageAtRect:(CGRect)rect;

/*!
 @method
 @abstract          将图片缩放到一定范围
 @discussion
 
 @param size        缩放的范围
 */
- (UIImage *)imageScaledToSize:(CGSize)size;

/*!
 @method
 @abstract          将图片缩放到一定范围
 @discussion
 
 @param size        在某一块矩形区域的图片
 */
- (UIImage *)imageAtRect:(CGRect)rect;

/*!
 @method
 @abstract          将图片缩放到一定范围
 @discussion
 
 @param size        在某一块矩形区域的图片
 */
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur;

- (UIImage *)scaletoSize:(CGSize)size mode:(ImageScaleMode)mode;

@end
