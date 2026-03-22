//
//  LLRepayCardView.h
//  LuckyLoan
//
//  Created by hao on 2024/1/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLRepayCardView : UIView
@property (nonatomic, copy) ReturnNoneBlock repayBlock;
- (id)initWithFrame:(CGRect)frame data:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
