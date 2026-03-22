//
//  LLLanuchHelper.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLLanuchHelper.h"
#import "LLSignModel.h"
#import "LLLocation.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import "LLDeviceInfo.h"

@interface LLLanuchHelper ()
@property (nonatomic, strong) LLLocation *location;
@end

@implementation LLLanuchHelper

SINGLETON_M(LLLanuchHelper)

- (void)launch {
    [self getSign];
}

- (void)getSign {
    LLSignModel *sign = [LLCacheTool objectForKey:@"sign"];
    if (sign) {
        if (sign.phone.length > 0 && sign.appId.length > 0) {
            LLUserModel *user = [LLCacheTool objectForKey:@"user"];
            user.isLogin = YES;
            App.user = user;
        }else {
            App.user.isLogin = NO;
        }
    }else {
        App.user.isLogin = NO;
    }
}

- (void)sendMarket:(NSString *)idfa {
    kWeakself;
    NSString *idfv = [LLDeviceInfo idfv];
    NSDictionary *dic = @{c_idfa:NotNull(idfa), c_idfv:idfv, @"gateway_now":@"fewfdf", @"encounter_now":@"123123555"};
    [Network postWithPath:path_market params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            NSString *afKey = response.dataDic[c_afKey];
            [weakSelf initAppFlyer:afKey];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)initAppFlyer:(NSString *)key {
    [[AppsFlyerLib shared] setAppsFlyerDevKey:key];
    [[AppsFlyerLib shared] setAppleAppID:AppFlyerId];
    [[AppsFlyerLib shared] startWithCompletionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
    }];
}

@end
