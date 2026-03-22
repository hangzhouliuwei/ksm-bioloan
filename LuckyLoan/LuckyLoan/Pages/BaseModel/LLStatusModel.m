//
//  LLStatusModel.m
//  king
//
//  Created by hao on 2023/96.
//

#import "LLStatusModel.h"

@implementation LLStatusModel

- (void)updateVersion:(NSMutableDictionary *)dic needUpdate:(ReturnBoolBlock)block sure:(ReturnNoneBlock)sureBlock cancel:(ReturnNoneBlock)cancelBlock {
    if (!dic) {
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *newVersion = dic[@"versionName"];
    if ([self transforVersion:appVersion] < [self transforVersion:newVersion]) {
        block(YES);
    }else{
        block(NO);
    }
}

- (NSInteger)transforVersion:(NSString *)version {
    NSArray *numbers = [version componentsSeparatedByString:@"."];
    NSInteger number = 0;
    for (int i = 0; i < numbers.count; i++) {
        NSString *str = numbers[i];
        number += [str integerValue]*pow(10, 4 - 2*i);
    }
    return number;
}

@end
