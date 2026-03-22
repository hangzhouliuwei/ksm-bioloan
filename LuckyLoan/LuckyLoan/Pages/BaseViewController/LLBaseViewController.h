//
//  LLBaseViewController.h
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import <UIKit/UIKit.h>
#import "LLNavigationBar.h"
#import "LLBaseContentView.h"

typedef NS_ENUM(NSInteger, VCLifeCycle) {
    VCLifeCycleInit = 1,
    VCLifeCycleLoadView,
    VCLifeCycleViewDidLoad,
    VCLifeCycleViewWillAppear,
    VCLifeCycleViewDidAppear,
    VCLifeCycleViewWillDisappear,
    VCLifeCycleViewDidDisappear,
    VCLifeCycleDealloc,
};

@interface LLBaseViewController : UIViewController
@property (nonatomic, strong) LLBaseContentView *contentView;
@property (nonatomic, strong) NSDictionary *paramDic;
@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, assign) BOOL canPanBack;
@property (nonatomic, strong) LLNavigationBar *navBar;
@property (nonatomic, assign) VCLifeCycle lifeCycle;
@property (nonatomic, strong) UIImageView *bgImage;
- (void)addGradient:(NSArray *)colors start:(CGPoint)start end:(CGPoint)end;
- (void)addHeaderImage:(NSString *)imageName;
- (void)backBtnClick:(UIButton *)btn;

@end
