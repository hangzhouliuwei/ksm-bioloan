//
//  LLTabBarViewController.h
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TabIndex) {
    TabIndexHome = 0,
    TabIndexUser,
};

@interface LLTabBarViewController : UITabBarController <UIGestureRecognizerDelegate>
- (void)setSelectedIndex:(NSUInteger)selectedIndex param:(NSDictionary *)dic;
@end
