//
//  LLPageManager.h
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>
#import "LLBaseViewController.h"
#import "LLTabBarViewController.h"

#define Page    [LLPageManager sharedLLPageManager]

@interface LLPageManager : NSObject


SINGLETON_H(LLPageManager)

//配置Window
- (void)configureWindow:(UIWindow *)window;

//回到主页面
- (void)showRoot;
- (void)showRootAnimated:(BOOL)animated;
/**
 *  返回上一界面
 *   @param animated 是否需要动画
 *   @return 当前界面
*/
- (LLBaseViewController *)popAnimated:(BOOL)animated;
- (LLBaseViewController *)pop;

/**
 *  返回到指定的界面
 *
 *  @param viewController  指定的界面对象
 *  @param notFoundBlock   未找到指定的对象，执行该block
 *
 *  @return pop出的数组
 */
- (NSArray *)popToVC:(UIViewController *)viewController notFoundBlock:(void(^)(void))notFoundBlock;
- (NSArray *)popToVC:(UIViewController *)viewController;

/**
 *  返回到指定的界面
 *
 *  @param pageName 指定的界面
 *  @param notFoundBlock      未知道指定的界面，执行该block
 *
 *  @return pop出的数组
 */
- (NSArray *)popTo:(NSString *)pageName notFoundBlock:(void(^)(void))notFoundBlock animated:(BOOL)animated;
- (NSArray *)popTo:(NSString *)pageName;
- (NSArray *)popTo:(NSString *)pageName animated:(BOOL)animated;

/**
 *  根据类进行界面跳转
 *
 *  @param pageName 目标类名字符串
 *  @param dic                传递的参数
 *  @param animated           是否显示动画
 *
 *  @return UIViewController 要显示的VC对象
 */
- (LLBaseViewController *)show:(NSString *)pageName param:(NSDictionary *)dic animated:(BOOL)animated;

- (LLBaseViewController *)show:(NSString *)pageName;

- (LLBaseViewController *)show:(NSString *)pageName param:(NSDictionary *)dic;

- (LLBaseViewController *)show:(NSString *)pageName animated:(BOOL)animated;

//移除某个viewController
- (void)removeVC:(UIViewController *)viewController;

//顶层ViewController
- (LLBaseViewController *)topVC;

//tabBar当前选中的viewController
- (LLBaseViewController *)selectedTabVC;

 //tabBar当前选中的viewController的类名
- (NSString *)selectedTabVCName;

//切换tabBar
- (void)switchTabAt:(NSUInteger)index;
- (void)switchTabAt:(NSUInteger)index param:(NSDictionary *)dic;

//tabBar选中的index
- (NSInteger)tabSelectedIndex;

//模态视图
- (void)present:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(ReturnNoneBlock)completion;
- (void)dismiss;
@end
