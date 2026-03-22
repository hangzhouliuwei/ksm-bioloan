//
//  LLBaseContentView.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLBaseContentView : UIScrollView
- (id)initWithFrame:(CGRect)frame;
- (void)setSizeFit:(UIView *)bottomView;
@end

NS_ASSUME_NONNULL_END
