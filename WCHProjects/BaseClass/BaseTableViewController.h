//
//  BaseTableViewController.h
//  
//
//  Created by liujinliang on 15/10/20.
//
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController
#pragma mark - 返回按钮
/**
 *  添加返回按钮
 */
- (void)setupBackButton;

/**
 *  添加返回按钮
 */
- (void)setupBackButtonTarget:(id)target action:(SEL)action;

/**
 *  返回按钮点击时回调
 */
- (void)onBackButton;
@end
