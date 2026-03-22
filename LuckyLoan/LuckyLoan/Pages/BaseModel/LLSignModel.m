//
//  LLSignModel.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLSignModel.h"

@implementation LLSignModel

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.token = [coder decodeObjectForKey:@"token"];
        self.appId = [coder decodeObjectForKey:@"appId"];
        self.phone = [coder decodeObjectForKey:@"phone"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.token forKey:@"token"];
    [coder encodeObject:self.appId forKey:@"appId"];
    [coder encodeObject:self.phone forKey:@"phone"];
}


@end
