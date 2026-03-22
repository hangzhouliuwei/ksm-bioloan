//
//  LLWebViewController.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLWebViewController.h"
#import "JSBridgeHelper.h"
#import "MBProgressHUD.h"
#import "LLBaseButton.h"

@interface LLWebViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, assign) BOOL loadSuccess;
@property (nonatomic, copy) NSArray *methodArr;
@end

@implementation LLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    kWeakself;
    if (weakSelf.loadSuccess) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!weakSelf.loadSuccess) {
            weakSelf.emptyView.hidden = NO;
        }else {
            weakSelf.emptyView.hidden = YES;
        }
    });
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)backBtnClick:(UIButton *)btn {
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [super backBtnClick:btn];
    }
}

- (void)loadView {
    [super loadView];
    self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    if (!self.loadSuccess) {
        [self loadRequest];
    }
}

- (void)setCanRefresh:(BOOL)canRefresh {
    kWeakself;
    if (canRefresh) {
        self.contentView.scrollEnabled = YES;
        self.contentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadRequest];
        }];
    }else {
        self.contentView.scrollEnabled = NO;
    }
    _canRefresh = canRefresh;
}

- (void)loadRequest {
    NSURL *url = [NSURL URLWithString:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
    [self.contentView.mj_header endRefreshing];
}

- (WKWebView *)webView {
    if (!_webView) {
        _methodArr = @[JSopenGooglePlay, JSuploadRiskLoan, JSopenUrl, JScloseSyn, JSjump, JSjumpToHome, JSjumpToLogin, JSbackDialog, JScallPhoneMethod, JStoGrade, JSopenAppstore, JSheadIsVisible];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        for (NSString *method in _methodArr) {
            [configuration.userContentController addScriptMessageHandler:self name:method];
        }
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.contentView.height) configuration:configuration];
        _webView.backgroundColor = UIColor.whiteColor;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [self.contentView addSubview:_webView];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成webview_didFinishNavigation");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.emptyView.hidden = YES;
    self.loadSuccess = YES;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"加载失败webview_didFailProvisionalNavigation");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.emptyView.hidden = NO;
    self.loadSuccess = NO;
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {//加载进度值
        
    } else if ([keyPath isEqualToString:@"title"]) {//网页title
        if (object == self.webView) {
            self.title = self.webView.title;
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"==%@", message);
    if ([_methodArr containsObject:message.name]) {
        JS.respondsWebView = self.webView;
        [JS receiveJSMessage:message];
    }
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth, 300)];
        [self.view addSubview:_emptyView];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:ImageWithName(@"image_no_network")];
        image.frame = CGRectMake(0, 0, 120, 120);
        image.centerX = ScreenWidth/2;
        [_emptyView addSubview:image];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, image.bottom + 30, SafeWidth, 30)];
        label.text = @"服务器出现异常，请稍后再试...";
        label.textColor = TextGrayColor;
        label.font = Font(15);
        label.textAlignment = NSTextAlignmentCenter;
        [_emptyView addSubview:label];
        
        LLBaseButton *btn = [[LLBaseButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 50, label.bottom + 50, 100, 44) title:@"稍后再试"];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_emptyView addSubview:btn];
    }
    return _emptyView;
}

- (void)btnClick:(UIButton *)btn {
    if (self.navigationBarHidden) {
        [Page pop];
    }
}

//H5调用native弹框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s",__FUNCTION__);
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
