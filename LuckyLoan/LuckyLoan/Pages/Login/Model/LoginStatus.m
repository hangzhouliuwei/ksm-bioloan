//
//  LoginStatus.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LoginStatus.h"
#import "LLLoginVC.h"
#import "LLLanuchHelper.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface LoginStatus()
@property (nonatomic, copy) ReturnBoolBlock resultBlock;
@end

@implementation LoginStatus

SINGLETON_M(LoginStatus)

- (void)login:(ReturnBoolBlock)block {
    self.resultBlock = block;
    LLLoginVC *login = [[LLLoginVC alloc] init];
    login.navigationBarHidden = YES;
    login.modalPresentationStyle = UIModalPresentationFullScreen;
    kWeakself;
    login.loginBLock = ^(BOOL value) {
        if (weakSelf.resultBlock) {
            weakSelf.resultBlock(value);
        }
        if (value) {
            [self requestUserInfo];
        }
    };
    [Page present:login animated:YES completion:nil];
}

- (void)requestUserInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:self];
    NSUUID *uuid = [ASIdentifierManager sharedManager].advertisingIdentifier;
    [Lanuch sendMarket:uuid.UUIDString];

}

@end
