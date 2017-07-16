//
//  UIFont+Category.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Category)

/**
 *  大标题字体 34px
 */
+ (instancetype)fontBigTitle;

/**
 *  导航栏标题字体 34px
 */
+ (instancetype)fontNavTitle;

/**
 *  二级标题字体 32px
 */
+ (instancetype)fontSecondTitle;

/**
 *  主按钮字体 30px
 */
+ (instancetype)fontMainButton;

/**
 *  标题文字或正文 30px
 */
+ (instancetype)fontTitle;

/**
 *  内容备注、二级按钮、详情 26px
 */
+ (instancetype)fontContent;

/**
 *  提示信息、三级按钮 26px
 */
+ (instancetype)fontPrompt;

/**
 *  次要内容(时间、标签) 24px
 */
+ (instancetype)fontAssistant;

@end
