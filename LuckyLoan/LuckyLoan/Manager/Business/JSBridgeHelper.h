//
//  JSBridgeHelper.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#define JSopenGooglePlay        @"openGooglePlay"
#define JSuploadRiskLoan        @"uploadRiskLoan"
#define JSopenUrl               @"openUrl"
#define JScloseSyn              @"closeSyn"
#define JSjump                  @"jump"
#define JSjumpToHome            @"jumpToHome"
#define JSjumpToLogin           @"jumpToLogin"
#define JSbackDialog            @"backDialog"
#define JScallPhoneMethod       @"callPhoneMethod"
#define JStoGrade               @"toGrade"
#define JSopenAppstore          @"openAppstore"
#define JSheadIsVisible         @"headIsVisible"

NS_ASSUME_NONNULL_BEGIN

#define JS    [JSBridgeHelper sharedJSBridgeHelper]

@interface JSBridgeHelper : NSObject

@property (nonatomic, strong) WKWebView *respondsWebView;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *callbackId;

SINGLETON_H(JSBridgeHelper)

- (void)receiveJSMessage:(WKScriptMessage *)message;

@end

NS_ASSUME_NONNULL_END

