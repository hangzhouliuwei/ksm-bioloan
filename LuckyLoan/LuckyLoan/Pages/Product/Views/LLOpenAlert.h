//
//  LLOpenAlert.h
//  LuckyLoan
//
//  Created by hao on 2024/1/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLOpenAlert : UIView
@property (nonatomic, copy) ReturnNoneBlock selectBlock;
- (id)initWithImage:(NSString *)imageUrl;
- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
