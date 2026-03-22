//
//  LLDateAlert.h
//  LuckyLoan
//
//  Created by hao on 2024/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLDateAlert : UIView
@property (nonatomic, copy) ReturnStrBlock selectBlock;
- (id)initWithData:(nullable NSString *)dateStr;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
