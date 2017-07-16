//
//  NSMutableDictionary+Category.m
//  WUFrameWork
//
//  Created by liujinliang on 15/9/6.
//  Copyright (c) 2015年 liujinliang All rights reserved.
//

#import "NSMutableDictionary+Category.h"

@implementation NSMutableDictionary (Category)

#pragma mark --NSSortDescriptor 对 NSMutableArray 排序
/*!
 *  @author King, 15-09-06 10:09:12
 *
 *  @brief  NSSortDescriptor 对 NSMutableArray 排序
 *
 *  @param dictionaryValue <#dictionaryValue description#>
 *  @param yesOrNo         <#yesOrNo description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
- (NSDictionary *)sortDictionary:(NSMutableDictionary *)dictionaryValue ascending:(BOOL)yesOrNo
{
    NSArray *sortedArray;
    NSArray *keys = [dictionaryValue allKeys];
    
    //是否降序
    if (yesOrNo) {
        
        sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result = [obj1 compare:obj2];
            return result;
        }];
        
    }else{
        sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
    }
    __weak NSMutableDictionary *currDic = dictionaryValue;
    NSMutableDictionary *tempDic =[NSMutableDictionary dictionary];
    [sortedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = obj;
        id val = currDic[key];
        if (kISKIND_OF_CLASS_NSARRAY(val)) {
            NSArray *arr = val;
            if (arr.count) {
                [tempDic setObject:arr forKey:key];
            }else{
                [tempDic setObject:@"" forKey:key];
            }
        }else if (kISKIND_OF_CLASS_NSDICTIONARY(val)) {
            NSDictionary *dic = val;
            if (dic.count) {
                [tempDic setObject:dic forKey:key];
            }else{
                [tempDic setObject:@"" forKey:key];
            }
        }
        else{
            [tempDic addUnEmptyString:val forKey:key];
        }
        
    }];

    return tempDic;
}

#define mark --添加非空对象
/*!
 *  @author King, 15-09-06 10:09:51
 *
 *  @brief  添加非空对象
 *
 *  @param stringObject <#stringObject description#>
 *  @param key          <#key description#>
 *
 *  @since <#version number#>
 */
- (void)addUnEmptyString:(id)stringObject forKey:(NSString *)key{

    if (kIsObjectEmpty(stringObject)) {
        [self setObject:@"" forKey:key];
    }else{
        [self setObject:stringObject forKey:key];
    }
}
@end
