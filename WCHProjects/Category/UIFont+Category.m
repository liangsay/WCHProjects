//
//  UIFont+Category.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "UIFont+Category.h"

@implementation UIFont (Category)

/**
 *  大标题字体 34px
 */
+ (instancetype)fontBigTitle
{
    return kFont(34);
}

/**
 *  导航栏标题字体 34px
 */
+ (instancetype)fontNavTitle
{
    return kFont(32);
}

/**
 *  二级标题字体 32px
 */
+ (instancetype)fontSecondTitle
{
    return kFont(32);
}

/**
 *  主按钮字体 30px
 */
+ (instancetype)fontMainButton
{
    return kFont(30);
}

/**
 *  标题文字或正文 30px
 */
+ (instancetype)fontTitle
{
    return kFont(32);
}

/**
 *  内容备注、二级按钮、详情 28px
 */
+ (instancetype)fontContent
{
    return kFont(28);
}

/**
 *  提示信息、三级按钮 26px
 */
+ (instancetype)fontPrompt
{
    return kFont(26);
}

/**
 *  次要内容(时间、标签) 24px
 */
+ (instancetype)fontAssistant
{
    return kFont(24);
}

@end
