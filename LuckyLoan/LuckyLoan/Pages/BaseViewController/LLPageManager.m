//
//  LLPageManager.m
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLPageManager.h"
#import "LLNavigationViewController.h"

@interface LLPageManager() <UITabBarControllerDelegate>

@property (nonatomic, strong) LLNavigationViewController *navigationController; // 程序全局的navigationController
@property (nonatomic, strong) LLTabBarViewController *tabBarController;// 程序全局的tabBarController

@end

@implementation LLPageManager

SINGLETON_M(LLPageManager)

- (id)init{
    self = [super init];
    if (self) {
        [self createTabAndNav];
    }
    return self;
}

- (void)createTabAndNav{
    self.tabBarController = [[LLTabBarViewController alloc] init];
    self.tabBarController.delegate = self;
    self.navigationController = [[LLNavigationViewController alloc] initWithRootViewController:self.tabBarController];
    self.navigationController.navigationBarHidden = YES;
}

- (void)configureWindow:(UIWindow *)window{
    window.rootViewController = self.navigationController;
    window.backgroundColor = BGColor;
}


- (void)showRoot{
    [self showRootAnimated:YES];
}

- (void)showRootAnimated:(BOOL)animated{
    [self.navigationController popToViewController:self.tabBarController animated:animated];
}

- (LLBaseViewController *)pop{
    return [self popAnimated:YES];
}

- (LLBaseViewController *)popAnimated:(BOOL)animated{
    if (self.navigationController.viewControllers.count == 0) {
        return nil;
    }
    
    UIViewController *viewController = [self.navigationController popViewControllerAnimated:animated];
    if (![viewController isKindOfClass:[LLBaseViewController class]]) {
        return nil;
    }
    
    return (LLBaseViewController *)viewController;
}

- (NSArray *)popToVC:(UIViewController *)viewController {
    return [self popToVC:viewController notFoundBlock:NULL];
}

- (NSArray *)popToVC:(UIViewController *)viewController notFoundBlock:(void(^)(void))notFoundBlock {
    if ((!viewController)||(![viewController isKindOfClass:UIViewController.self])) {
        return nil;
    }
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *vc in [viewControllers reverseObjectEnumerator]) {
        if (vc == viewController) {
            return [self.navigationController popToViewController:viewController animated:YES];
        } else if ([vc isEqual:self.tabBarController]) {
            NSArray *views = self.tabBarController.viewControllers;
            for (UIViewController* tabVC in views) {
                if (tabVC == viewController) {
                    return [self.navigationController popToViewController:self.tabBarController animated:YES];
                }
            }
        }
    }
    
    if (notFoundBlock) {
        notFoundBlock();
    }
    
    return nil;
}

- (NSArray *)popTo:(NSString *)pageName {
    return [self popTo:pageName notFoundBlock:NULL animated:YES];
}

- (NSArray *)popTo:(NSString *)pageName animated:(BOOL)animated {
    return [self popTo:pageName notFoundBlock:NULL animated:animated];
}

- (NSArray *)popTo:(NSString *)pageName notFoundBlock:(void(^)(void))notFoundBlock animated:(BOOL)animated {
    if ([LLTools isBlankString:pageName]) {
        return nil;
    }
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *viewController in [viewControllers reverseObjectEnumerator]) {
        NSString *tempName = NSStringFromClass([viewController class]);
        if ([tempName isEqualToString:pageName]) {
            return [self.navigationController popToViewController:viewController animated:animated];
        } else if ([viewController isEqual:self.tabBarController]) {
            NSArray *views = self.tabBarController.viewControllers;
            for (UIViewController* tabView in views) {
                if ([pageName isEqualToString:NSStringFromClass([tabView class])]) {
                    return [self.navigationController popToViewController:self.tabBarController animated:animated];
                }
            }
        }
    }
    
    if (notFoundBlock) {
        notFoundBlock();
    }
    
    return nil;
}

- (LLBaseViewController *)topVC {
    UIViewController *topVC = self.navigationController.topViewController;
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        return [self selectedTabVC];
    }
    
    if (![topVC isKindOfClass:[LLBaseViewController class]]) {
        return nil;
    }
    
    return (LLBaseViewController *)topVC;
}

- (LLBaseViewController *)show:(NSString *)pageName{
    return [self show:pageName animated:YES];
}

- (LLBaseViewController *)show:(NSString *)pageName param:(NSDictionary *)dic{
    return [self show:pageName param:dic animated:YES];
}

- (LLBaseViewController *)show:(NSString *)pageName animated:(BOOL)animated{
    return [self show:pageName param:nil animated:animated];
}

- (LLBaseViewController *)show:(NSString *)pageName param:(NSDictionary *)dic animated:(BOOL)animated{
    LLBaseViewController *viewController = [self createViewController:pageName param:dic];
    if (!viewController) {
        return nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showViewController:viewController animated:animated];
    });
    
    return viewController;
}

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.navigationController pushViewController:viewController animated:animated];
}



- (LLBaseViewController *)createViewController:(NSString *)viewControllerName param:(NSDictionary *)dic{
    if ([LLTools isBlankString:viewControllerName]) {
        return nil;
    }
    
    Class targetClass = NSClassFromString(viewControllerName);
    if (!targetClass) {
        return nil;
    }
    
    LLBaseViewController *viewController = [[targetClass alloc] init];
    if (!viewController || ![viewController isKindOfClass:[LLBaseViewController class]]) {
        return nil;
    }
    
    viewController.paramDic = dic;
    [self checkParamDic:viewController];
    return viewController;
}

- (void)checkParamDic:(LLBaseViewController *)targetViewController{
    if (!targetViewController.paramDic) {
        return;
    }
    
    [targetViewController.paramDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![key isKindOfClass:[NSString class]]) {
            return;
        }
        
        NSString *upperKey = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[key substringToIndex:1] uppercaseString]];
        
        SEL setMethod = NSSelectorFromString([NSString stringWithFormat:@"set%@:", upperKey]);
        if (![targetViewController respondsToSelector:setMethod]) {
            return;
        }
        
        [targetViewController setValue:obj forKeyPath:key];
    }];
}

- (void)switchTabAt:(NSUInteger)index{
    [self switchTabAt:index param:nil];
}

- (void)switchTabAt:(NSUInteger)index param:(NSDictionary *)dic {
    if (self.tabBarController) {
        [self.tabBarController setSelectedIndex:index param:dic];
        [self showRootAnimated:NO];
    }
}

- (NSInteger)tabSelectedIndex{
    return self.tabBarController.selectedIndex;
}

- (LLBaseViewController *)selectedTabVC{
    if (!self.tabBarController) {
        return nil;
    }
    
    UIViewController *viewController = self.tabBarController.selectedViewController;
    if (![viewController isKindOfClass:[LLBaseViewController class]]) {
        return nil;
    }
    return (LLBaseViewController *)viewController;
}

- (NSString *)selectedTabVCName{
    LLBaseViewController *viewController = [self selectedTabVC];
    if (!viewController) {
        return nil;
    }
    return NSStringFromClass([viewController class]);
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:NSClassFromString(@"LLUserVC")]) {
        if (!App.user.isLogin) {
            [Login login:^(BOOL value) {
            }];
            return NO;
        }else {
            return YES;
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

}

- (void)removeVC:(UIViewController *)viewController{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *subViewControllers = [self.navigationController.viewControllers mutableCopy];
        [subViewControllers removeObject:viewController];
        self.navigationController.viewControllers = subViewControllers;
    });
}

- (void)present:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(ReturnNoneBlock)completion {
    [self.topVC presentViewController:viewControllerToPresent animated:YES completion:completion];
}

- (void)dismiss {
    [self.topVC.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
