//
//  HaoNavigationController.m
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLNavigationViewController.h"
#import "LLTabBarViewController.h"

@implementation LLNavigationViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
        [[UINavigationBar appearance] setBarTintColor:UIColor.whiteColor];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];//去掉导航栏下方边界线
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:FontBold(17)}];
    }
    return self;
}

@end
