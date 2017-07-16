//
//  NSMutableArray+Category.m
//  SP2P_6.1
//
//  Created by liujinliang on 15/11/5.
//  Copyright © 2015年 liujinliang All rights reserved.
//

#import "NSMutableArray+Category.h"

@implementation NSMutableArray (Category)
- (void)addUnEmptyObject:(id)_object{
    
    if (kIsObjectEmpty(_object)) {
        [self addObject:@""];
    }else{
        [self addObject:_object];
    }
}
@end
