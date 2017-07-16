//
//  NSDictionary+Unicode.m
//  YunZhangGui
//
//  Created by liujinliang on 16/4/8.
//  Copyright © 2016年 liujinliang All rights reserved.
//

#import "NSDictionary+Unicode.h"

@implementation NSDictionary (Unicode)
- (NSString*)my_description {
    NSString *desc = [self my_description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}
@end
