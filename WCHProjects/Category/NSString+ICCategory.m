//
//  NSString+ICCategory.m
//  iChanceSample
//
//  Created by Fox on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+ICCategory.h"
#import <CommonCrypto/CommonDigest.h>

int const GGCharacterIsNotADigit = 10;

@implementation NSString (ICCategory)

- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
//    CC_MD5(value, self.length, digest);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString lowercaseString];
}

+ (NSString*)stringWithFormattedUnsignedInteger:(NSUInteger)integer {
	NSNumber* number = [NSNumber numberWithUnsignedInteger:integer];
	NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSString* formattedString = [formatter stringFromNumber:number];
	return formattedString;
}

- (BOOL)containsString:(NSString*)string {
	return [self containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options {
	return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}

#pragma mark -
#pragma mark Long conversions

- (long)longValue {
	return (long)[self longLongValue];
}

- (long long)longLongValue {
	NSScanner* scanner = [NSScanner scannerWithString:self];
	long long valueToGet;
	if([scanner scanLongLong:&valueToGet] == YES) {
		return valueToGet;
	} else {
		return 0;
	}
}

/*
 * Contact info@enormego.com if you're the author and we'll update this comment to reflect credit
 */

- (unsigned)digitValue:(unichar)c {
	
	if ((c>47)&&(c<58)) {
        return (c-48);
	}
	
	return GGCharacterIsNotADigit;
}

- (unsigned long long)unsignedLongLongValue {
	NSUInteger n = [self length];
	unsigned long long v,a;
	unsigned small_a, j;
	
	v=0;
	for (j=0;j<n;j++) {
		unichar c=[self characterAtIndex:j];
		small_a=[self digitValue:c];
		if (small_a==GGCharacterIsNotADigit) continue;
		a=(unsigned long long)small_a;
		v=(10*v)+a;
	}
	
	return v;
	
}

#pragma mark -
#pragma mark Hashes
// TODO: Add other methods, specifically SHA1
//
///*
// * Contact info@enormego.com if you're the author and we'll update this comment to reflect credit
// */
//
//- (NSString*)md5 {
//	const char* string = [self UTF8String];
//	unsigned char result[16];
//	CC_MD5(string, strlen(string), result);
//	NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//                      result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], 
//                      result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
//    
//	return [hash lowercaseString];
//}

#pragma mark -
#pragma mark Truncation

/*
 * Contact info@enormego.com if you're the author and we'll update this comment to reflect credit
 */

- (NSString*)stringByTruncatingToLength:(int)length {
	return [self stringByTruncatingToLength:length direction:NSTruncateStringPositionEnd];
}

- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom {
	return [self stringByTruncatingToLength:length direction:truncateFrom withEllipsisString:@"..."];
}

- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom withEllipsisString:(NSString*)ellipsis {
	NSMutableString *result = [[NSMutableString alloc] initWithString:self];
	NSString *immutableResult;
	
	if([result length] <= length) {
		return self;
	}
	
	unsigned int charactersEachSide = length / 2;
	
	NSString* first;
	NSString* last;
	
	switch(truncateFrom) {
		case NSTruncateStringPositionStart:
			[result insertString:ellipsis atIndex:[result length] - length + [ellipsis length] ];
			immutableResult  = [[result substringFromIndex:[result length] - length] copy];
			return immutableResult;
		case NSTruncateStringPositionMiddle:
			first = [result substringToIndex:charactersEachSide - [ellipsis length]+1];
			last = [result substringFromIndex:[result length] - charactersEachSide];
			immutableResult = [[[NSArray arrayWithObjects:first, last, NULL] componentsJoinedByString:ellipsis] copy];
			return immutableResult;
		default:
		case NSTruncateStringPositionEnd:
			[result insertString:ellipsis atIndex:length - [ellipsis length]];
			immutableResult  = [[result substringToIndex:length] copy];
			return immutableResult;
	}
}

- (NSString *)stringByDeleteWhitespaceAndWrap{
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",self];
    
    return [NSString stringWithFormat:@"%@",[mutableString stringByTrimmingCharactersInSet:
                                             [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}



- (NSURL *)url
{
    return [NSURL URLWithString:self];
}

@end
