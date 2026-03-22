//
//  LLNavigationBar.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLNavigationBar : UIView

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *midView;
@property (nonatomic, copy) ReturnNoneBlock leftBtnClick;
@property (nonatomic, copy) ReturnNoneBlock rightBtnClick;

- (id)initWithFrame:(CGRect)frame;
- (void)hideLeftBtn;
- (void)showLeftBtn;
- (void)hideRightBtn;
- (void)showRightBtn;

@end

NS_ASSUME_NONNULL_END
