//
//  UIImage+Category.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage-Helpers.h"
@interface UIImage (Category)

- (id)setCircleImageWithSize:(CGSize)size radius:(NSInteger)r;

//按原图比例返回限定大小的图片 （未剪切）
-(UIImage*) getLimitImage:(CGSize) size;

// 按原图比例返回限定大小的图片（剪切）
-(UIImage*) getClickImage:(CGSize) size;

-(UIImage*)resizedImageToSize:(CGSize)dstSize;
-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;
#pragma mark 颜色转image并设置size
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 * 修发图片大小
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;
/**
 * 保存图片
 */
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
/**
 * 生成GUID
 */
+ (NSString *)generateUuidString;

/**
 *POST 提交 并可以上传图片目前只支持单张
 */
+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN 提交参数据集合
                     picImg: (UIImage *)picImg  // IN 上传图片Data
                     picFileName: (NSString *)picFileName;  // IN 上传图片名称
@end
