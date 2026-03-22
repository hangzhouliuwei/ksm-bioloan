//
//  NSString+Adds.m
//  king
//
//  Created by hao on 2023/9/8.
//

#import "NSString+Adds.h"

@implementation NSString (Adds)

- (NSString *)stringValue {
    if (self) {
        return self;
    }else {
        return @"";
    }
}
@end
