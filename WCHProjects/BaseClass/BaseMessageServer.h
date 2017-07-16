//
//  BaseMessageServer.h
//  JiKePlus
//
//  Created by liujinliang on 16/7/4.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BaseViewController.h"
@interface BaseMessageServer : NSObject<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
DEFINE_SINGLETON_FOR_HEADER(BaseMessageServer)
//消息标题
@property (nonatomic, strong) NSString *msgTitle;
//消息内容
@property (nonatomic, strong) NSString *msgContent;
//接受人
@property (nonatomic, strong) NSArray *msgRecives;
//
@property (nonatomic, strong) BaseViewController *baseVC;

#pragma mark --执行发送邮件方法
/*!
 *  @author liujinliang, 16-07-04 09:07:47
 *
 *  @brief 执行发送邮件
 *
 *  @since <#1.0#>
 */
-(void)sendEMail;
@end
