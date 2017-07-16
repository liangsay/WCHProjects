//
//  NSMutableDictionary+Category.h
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Category)

/*!
 *  @author King, 15-09-06 10:09:40
 *
 *  @brief  字典排序
 *
 *  @param dictionaryValue <#dictionaryValue description#>
 *  @param yesOrNo         <#yesOrNo description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (NSDictionary *)sortDictionary:(NSMutableDictionary *)dictionaryValue ascending:(BOOL)yesOrNo;

/*!
 *  @author King, 15-09-06 10:09:44
 *
 *  @brief  添加非空对象
 *
 *  @param stringObject <#stringObject description#>
 *  @param key          <#key description#>
 *
 *  @since <#version number#>
 */
- (void)addUnEmptyString:(id)stringObject forKey:(NSString *)key;
@end
