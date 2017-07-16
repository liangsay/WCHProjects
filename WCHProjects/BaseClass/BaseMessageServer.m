//
//  BaseMessageServer.m
//  JiKePlus
//
//  Created by liujinliang on 16/7/4.
//  Copyright © 2016年 liujinliang. All rights reserved.
//

#import "BaseMessageServer.h"



@implementation BaseMessageServer
DEFINE_SINGLETON_FOR_CLASS(BaseMessageServer)
#pragma mark --发送邮件服务-------------------------------
#pragma mark --系统格式发送邮件
/*!
 *  @author liujinliang, 16-07-04 09:07:25
 *
 *  @brief 系统格式发送邮件
 *
 *  @since <#1.0#>
 */
-(void)displayComposerSheet {
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    [mailPicker setSubject:_msgTitle];
    
    // 添加发送者
    //    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com", nil];
    [mailPicker setToRecipients:_msgRecives];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    /*
     // 添加图片
     UIImage *addPic = [UIImage imageNamed:@"Icon.png"];
     NSData *imageData = UIImagePNGRepresentation(addPic);            // png
     // NSData *imageData = UIImageJPEGRepresentation(addPic, 1);    // jpeg
     [mailPicker addAttachmentData:imageData mimeType:@"" fileName:@"Icon.png"];
     
     NSString *emailBody = @"eMail 正文";
     [mailPicker setMessageBody:emailBody isHTML:YES];*/
    
    [_baseVC presentViewController:mailPicker animated:YES completion:nil];
}

#pragma mark --url格式发送邮件
/*!
 *  @author liujinliang, 16-07-04 09:07:01
 *
 *  @brief url格式发送邮件
 *
 *  @since <#1.0#>
 */
-(void)launchMailAppOnDevice {
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@&subject=%@",[_msgRecives firstObject],_msgTitle];
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark --执行发送邮件方法
/*!
 *  @author liujinliang, 16-07-04 09:07:47
 *
 *  @brief 执行发送邮件
 *
 *  @since <#1.0#>
 */
-(void)sendEMail {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            [self displayComposerSheet];
        } else {
            [self launchMailAppOnDevice];
        }
    } else {
        [self launchMailAppOnDevice];
    }
}

#pragma mark --发送邮件结果回调
/*!
 *  @author liujinliang, 16-07-04 09:07:38
 *
 *  @brief 发送邮件结果回调
 *
 *  @param controller <#controller description#>
 *  @param result     <#result description#>
 *  @param error      <#error description#>
 *
 *  @since <#1.0#>
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSString *msg;
    
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    NSLog(@"发送结果：%@", msg);
    [_baseVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --结果提示
/*!
 *  @author liujinliang, 16-07-04 09:07:40
 *
 *  @brief 结果提示
 *
 *  @param msg <#msg description#>
 *
 *  @since <#1.0#>
 */
- (void)alertWithTitle:(NSString *)title msg:(NSString *)msg {
    [NSString toast:msg];
}


#pragma mark --发送短信--------------------------------------------

- (void)sendMessage {
    UINavigationBar *navibar = [UINavigationBar appearanceWhenContainedIn:[_baseVC  class], nil];
    navibar.barTintColor = UIColorFromRGB(0x3cd66f);// RGBACOLOR(0x00, 0xbe, 0xbc, 0.7);//[UIColor colorWithHexString:@"#00abb8"];
    //[[UIBarButtonItem appearance] setTintColor:RGB(0x00, 0xab, 0xb8, 0.7)];
    [navibar setTintColor:[UIColor whiteColor]];//这个可以决定系统返回按钮的返回的箭头的颜色
    
    [navibar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = _msgRecives;
        controller.body = _msgContent;
        controller.messageComposeDelegate = self;
        [_baseVC presentViewController:controller animated:YES completion:nil];
        
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:_msgTitle];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma markk --发送短信结果回调
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [_baseVC dismissViewControllerAnimated:YES completion:nil];
    NSString *msg = @"";
    switch (result) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
            msg = @"信息发送取消！";
        }
            break;
        case MessageComposeResultFailed:// send failed
            msg = @"消息发送失败！";
            break;
            
        case MessageComposeResultSent:
        {
            //do something
            msg = @"消息发送成功";
        }
            break;
        default:
            msg = @"消息未发送";
            break;
    } 
    [self alertWithTitle:@"" msg:msg];
}
@end
