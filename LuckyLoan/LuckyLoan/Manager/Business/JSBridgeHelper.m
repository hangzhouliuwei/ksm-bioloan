//
//  JSBridgeHelper.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "JSBridgeHelper.h"
#import "LLSignModel.h"
#import "LoginStatus.h"
#import <StoreKit/StoreKit.h>

@interface JSBridgeHelper ()
@end

@implementation JSBridgeHelper

SINGLETON_M(JSBridgeHelper)

- (void)receiveJSMessage:(WKScriptMessage *)message {
    id data = message.body;
    NSLog(@"===%@--%@", message.name, message.body);
    if (!data) {
        return;
    }
    self.key = message.name;
    if ([LLTools isBlankString:self.key]) {
        return;
    }
    SEL selector = NSSelectorFromString(StrFormat(@"%@:", self.key));
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:data afterDelay:0];
    }else {
//        [self callBack:@""];
    }
}

- (void)callBack:(NSString *)str {
    if ([LLTools isBlankString:str]) {
        str = @"";
    }
    NSString *js = [NSString stringWithFormat:@"window.JSBridge.receiveMessage({data:'%@',callbackId:%@});", NotNull(str), NotNull(self.callbackId)];
    [self.respondsWebView evaluateJavaScript:js completionHandler:^(id object, NSError * _Nullable error) {
        NSLog(@"obj:%@---error:%@", object, error);
    }];
}

- (void)openAppstore:(id)info {//openAppstore
   NSString *url = AppStoreUrl;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options: @{} completionHandler:^(BOOL success) {
        
    }];
}

- (void)toGrade:(id)info {//toGrade
    [SKStoreReviewController requestReview];
}

- (void)callPhoneMethod:(id)info {//callPhoneMethod
    if ([info isKindOfClass:[NSString class]]) {
        NSString *phone = (NSString *)info;
        [LLTools callWithPhoneNo:phone];
    }
}

- (void)jumpToLogin:(id)info {//jumpToLogin
    [Login login:^(BOOL value) {
        
    }];
}

- (void)jumpToHome:(id)info {//jumpToHome
    [Page switchTabAt:0];
}

- (void)jump:(id)info {//jump
    NSString *page = @"";
    if ([info isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)info;
        if (arr.count > 0) {
            id item = arr[0];
            if ([item isKindOfClass:[NSString class]]) {
                page = (NSString *)item;
            }
        }
    }else if ([info isKindOfClass:[NSString class]]) {
        page = (NSString *)info;
    }
    if (page.length == 0) {
        return;
    }
    if ([page isEqualToString:@"X2e3cBS"]) {//setting 设置页
        [Page show:@"LLSetUpVC"];
    }else if ([page isEqualToString:@"EDoKx0g"]) {//main 首页
        [Page switchTabAt:0];
    }else if ([page isEqualToString:@"CBfy83V"]) {//login 登录页
        [Login login:^(BOOL value) {
        }];
    }else if ([page isEqualToString:@"Jvb72m4"]) {//order 订单列表页
        NSInteger tabIndex = 0;
        NSString *orderType = @"4";// 状态 4全部 7进行中 6待还款 5已结清
        [Page show:@"LLOrderListVC" param:@{@"selectTabIndex":@(tabIndex), @"orderType":orderType}];
    }else if ([page isEqualToString:@"xZDMmR8"]) {//productDetail 产品详情
        NSArray *arr = (NSArray *)info;
        if (arr.count > 1) {
            id item = arr[1];
            if ([item isKindOfClass:[NSString class]]) {
                NSString *pid = (NSString *)item;
                [Page show:@"LLApplyInfoVC" param:@{@"productId":pid}];
            }
        }
    }
}

- (void)closeSyn:(id)info {//closeSyn
    [Page pop];
}

- (void)openUrl:(id)info {//openUrl
    if ([info isKindOfClass:[NSString class]]) {
        NSString *url = (NSString *)info;
        if (url.length > 0) {
            [Page show:@"LLWebViewController" param:@{@"url":url, @"navigationBarHidden":@(NO), @"title":@""}];
        }
    }
}

- (void)uploadRiskLoan:(id)info {//uploadRiskLoan
    if ([info isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)info;
        if (arr.count == 4) {
            [DataPoint userburiePoint:@{@"seceneType":@"8", @"productId":NotNull(arr[2]), @"orderId":NotNull(arr[3]), @"startTime":NotNull(arr[0]), @"endTime":NotNull(arr[1])}];
        }
    }
}

@end
