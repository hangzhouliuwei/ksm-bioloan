//
//  LLWebViewController.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLBaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLWebViewController : LLBaseViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL canRefresh;
@property (nonatomic, assign) BOOL isPresent;

- (void)loadRequest;
@end

NS_ASSUME_NONNULL_END
