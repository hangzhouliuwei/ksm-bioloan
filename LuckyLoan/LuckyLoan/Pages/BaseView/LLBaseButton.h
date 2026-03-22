//
//  LLBaseButton.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ButtonType) {
    BtnTypeNormal = 0,
    BtnTypeGray,
    BtnTypeGreen,
    BtnTypeDisable,
    BtnTypeBorder,
    BtnTypeSimple,
};

@interface LLBaseButton : UIButton

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) ButtonType type;
@property (nonatomic, strong) CAGradientLayer *gradient;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)setTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
