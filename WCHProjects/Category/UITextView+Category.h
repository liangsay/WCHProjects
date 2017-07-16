//
//  UITextView+Category.h
//  SP2P_6.1
//
//  Created by liujinliang on 15/12/9.
//  Copyright © 2015年 liujinliang All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_LIMIT_NUMS 140
@interface UITextView (Category)

#pragma mark 获取本身内容后的size
/**
 *  @author liujinliang, 15-12-09 11:12:16
 *
 *  获取本身内容后的size
 *
 *  @return <#return value description#>
 */
- (CGSize )sizeWithTextViewWidth:(CGFloat)width;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text;

- (void)textViewDidChange:(UITextView *)textView;
@end
