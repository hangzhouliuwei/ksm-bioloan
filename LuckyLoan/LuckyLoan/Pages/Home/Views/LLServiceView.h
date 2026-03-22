//
//  LLServiceView.h
//  LuckyLoan
//
//  Created by hao on 2024/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLServiceView : UIView
@property (nonatomic, copy) ReturnNoneBlock clickBlock;
- (id)initWithFrame:(CGRect)frame image:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
