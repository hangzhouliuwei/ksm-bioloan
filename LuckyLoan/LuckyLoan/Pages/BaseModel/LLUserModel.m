//
//  LLUserModel.m
//  king
//
//  Created by hao on 2023/96.
//

#import "LLUserModel.h"

@implementation LLUserModel

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.userName = [coder decodeObjectForKey:@"userName"];
        self.userId = [coder decodeObjectForKey:@"userId"];
        self.realname = [coder decodeObjectForKey:@"realname"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.token = [coder decodeObjectForKey:@"token"];
        self.appId = [coder decodeObjectForKey:@"appId"];
        self.appstoreAccount = [coder decodeObjectForKey:@"appstoreAccount"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.userName forKey:@"userName"];
    [coder encodeObject:self.userId forKey:@"userId"];
    [coder encodeObject:self.realname forKey:@"realname"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.token forKey:@"token"];
    [coder encodeObject:self.appId forKey:@"appId"];
    [coder encodeObject:self.appstoreAccount forKey:@"appstoreAccount"];
}

- (void)loginUserData:(NSDictionary *)dic {
    self.isLogin = YES;
    [self resetUserInfo:dic[c_item]];
}

- (void)resetUserInfo:(NSDictionary *)dic {
    self.userName = dic[c_username];
    self.userId = dic[c_uid];
    self.realname = dic[c_realname];
    self.phone = dic[c_username];
    self.token = dic[c_token];
    self.appId = dic[c_sessionid];
    self.appstoreAccount = [dic[c_appstoreAccount] stringValue];
}

- (void)clearUserInfo {
    self.isLogin = NO;
    self.userName = @"";
    self.userId = @"";
    self.realname = @"";
    self.phone = @"";
    self.token = @"";
    self.appId = @"";
    self.appstoreAccount = @"";
}

@end
