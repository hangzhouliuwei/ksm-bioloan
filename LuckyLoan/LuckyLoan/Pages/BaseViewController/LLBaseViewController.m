//
//  BaseVC.m
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLBaseViewController.h"

@interface LLBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation LLBaseViewController

- (id)init{
    self = [super init];
    if (self) {
        self.lifeCycle = VCLifeCycleInit;
        self.canPanBack = YES;
    }
    return self;
}

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = UIColor.whiteColor;
    self.lifeCycle = VCLifeCycleLoadView;
    [self.view addSubview:self.contentView];
    NSLog(@"");
}

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 243*WScale)];
        [self.view addSubview:_bgImage];
        [self.view insertSubview:_bgImage atIndex:0];
    }
    return _bgImage;
}

- (void)addGradient:(NSArray *)colors start:(CGPoint)start end:(CGPoint)end {
    _bgImage = nil;
    [self.bgImage addGradient:@[COLOR(229, 243, 239), UIColor.whiteColor] start:CGPointMake(0, 0) end:CGPointMake(0, 1)];
}

- (void)addHeaderImage:(NSString *)imageName {
    _bgImage = nil;
    self.bgImage.image = ImageWithName(imageName);
}

- (LLBaseContentView *)contentView {
    if (!_contentView) {
        CGFloat height = [self contentViewHeight];
        _contentView = [[LLBaseContentView alloc] initWithFrame:CGRectMake(0, self.navigationBarHidden ? 0 : NavigationBarHeight, ScreenWidth, height)];
        _contentView.contentSize = CGSizeMake(_contentView.width, _contentView.height + 1);
        _contentView.backgroundColor = ClearColor;
        _contentView.userInteractionEnabled = YES;
        _contentView.showsVerticalScrollIndicator = NO;
        self.contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _contentView;
}

- (CGFloat)contentViewHeight{
    CGFloat height = ScreenHeight;
    if (!self.navigationBarHidden) {
        height -= NavigationBarHeight;
    }
    if (self.tabBarController) {
        height -= TabBarHeight;
    }
    return height;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.lifeCycle = VCLifeCycleViewDidLoad;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navBar.hidden = self.navigationBarHidden;
}

- (LLNavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[LLNavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight)];
        kWeakself;
        _navBar.leftBtnClick = ^{
            [weakSelf backBtnClick:nil];
        };
        
        [self.view addSubview:_navBar];
    }
    return _navBar;
}

- (void)setTitle:(NSString *)title {
    self.navBar.midView.text = title;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lifeCycle = VCLifeCycleViewWillAppear;
    if (!self.canPanBack) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.lifeCycle = VCLifeCycleViewDidAppear;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.lifeCycle = VCLifeCycleViewWillDisappear;
    if (!self.canPanBack) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.lifeCycle = VCLifeCycleViewDidDisappear;
}

- (void)backBtnClick:(UIButton *)btn {
    [Page pop];
}

- (void)dealloc{
    self.lifeCycle = VCLifeCycleDealloc;
}

@end
