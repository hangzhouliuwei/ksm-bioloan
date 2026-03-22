//
//  HaoTabBarController.m
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLTabBarViewController.h"
#import "LLHomeVC.h"
#import "LLUserVC.h"

@interface LLTabBarViewController ()
@property (nonatomic, assign) BOOL didShowAdView;
@end

@implementation LLTabBarViewController

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createViewController {
    LLHomeVC *home = [[LLHomeVC alloc] init];
    home.navigationBarHidden = YES;
    LLUserVC *user = [[LLUserVC alloc] init];
    user.navigationBarHidden = YES;
    self.viewControllers = @[home, user];
    NSArray *icons = @[@"tab_home", @"tab_mine"];
    NSArray *selecticons = @[@"tab_home_select", @"tab_mine_select"];
    for (int i = 0; i < icons.count; i ++) {
        
        UITabBarItem *item = self.tabBar.items[i];
        UIImage *image = [ImageWithName(icons[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imageSelect = [ImageWithName(selecticons[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item = [item initWithTitle:nil
                             image:image
                     selectedImage:imageSelect];
    }
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR(98, 98, 98)} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR(16, 16, 16)} forState:UIControlStateSelected];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    self.tabBar.tintColor = COLOR(16, 16, 16);
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = COLOR(98, 98, 98);
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];

    //添加阴影
    self.tabBar.layer.shadowColor = BGColor.CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -5);
    self.tabBar.layer.shadowOpacity = 0.3;
    
    CGRect frame = self.tabBar.frame;
    frame.size.height = 100;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    self.tabBar.frame = frame;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.barStyle = UIBarStyleBlack;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -10, ScreenWidth, 100)];
    view.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] insertSubview:view atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewController];
}


- (void)setSelectedIndex:(NSUInteger)selectedIndex param:(NSDictionary *)dic {
    [super setSelectedIndex:selectedIndex];
}

- (void)viewDidAppear:(BOOL)animated{
    [Network updateNetWorkStatus];
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return NO;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSMutableArray *tabBarBtnArray = [NSMutableArray array];
    int index = [NSNumber numberWithUnsignedInteger:[tabBar.items indexOfObject:item]].intValue;
    for (int i = 0 ;i < tabBar.subviews.count; i++ ) {
       UIView *tabBarButton = tabBar.subviews[i];
       if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
           [tabBarBtnArray addObject:tabBarButton];
       }
    }
    UIView *tabBarButton = tabBarBtnArray[index];
    for (UIView *view in tabBarButton.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            [self addAttentionAnimation:view];
        }
    }
}

- (void)addAttentionAnimation:(UIView *)view {
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@(0.2),@(1.2),@(0.9),@(1.1),@(1.0)];
    scale.calculationMode = kCAAnimationLinear;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scale];
    animationGroup.duration = 0.5;
    [view.layer addAnimation:animationGroup forKey:nil];
    [self shake];
}

- (void)shake {
    [LLTools shake];
}

@end
