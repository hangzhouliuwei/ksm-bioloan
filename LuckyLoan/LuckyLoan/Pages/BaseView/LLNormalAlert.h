//
//  LLNormalAlert.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLNormalAlert : UIView
@property (nonatomic, copy) ReturnNoneBlock bottomTapBlock;
- (id)initWithTitle:(NSString *)title content:(NSString *)content buttonDesc:(NSString *)buttonDesc;
- (id)initWithCustomView:(UIView *)customView;
- (void)show;
- (void)hide;
@end
NS_ASSUME_NONNULL_END
