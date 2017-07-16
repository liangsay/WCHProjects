//
//  NSUserDefaults+Category.m
//  SP2P_6.1
//
//  Created by liujinliang on 15/11/5.
//  Copyright © 2015年 liujinliang All rights reserved.
//

#import "NSUserDefaults+Category.h"

@implementation NSUserDefaults (Category)
- (void)addUnEmptyString:(id)stringObject forKey:(NSString *)key{
    
    if (kIsObjectEmpty(stringObject)) {
        [self setObject:@"" forKey:key];
    }else{
        [self setObject:stringObject forKey:key];
    }
    [self synchronize];
}
@end
