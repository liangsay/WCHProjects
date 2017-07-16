//
//  NSUserDefaults+Category.h
//  SP2P_6.1
//
//  Created by liujinliang on 15/11/5.
//  Copyright © 2015年 liujinliang All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Category)
/**
 *  添加非空字符串
 *
 *  @param date 字符串
 *  @param key  关键字
 */
- (void)addUnEmptyString:(id)stringObject forKey:(NSString *)key;
@end
