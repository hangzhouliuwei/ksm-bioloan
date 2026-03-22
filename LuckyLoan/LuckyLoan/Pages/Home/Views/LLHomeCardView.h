//
//  LLHomeCardView.h
//  LuckyLoan
//
//  Created by hao on 2023/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLHomeCardView : UIView
@property (nonatomic, copy) ReturnNoneBlock applyBlock;
- (id)initWithFrame:(CGRect)frame data:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
