//
//  LLPhoneInputView.h
//  LuckyLoan
//
//  Created by hao on 2023/12/21.
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define AuthCodeLength  6

@interface LLAuthcodeInputView : UIView
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) ReturnIntBlock inputBlock;
- (id)initWithFrame:(CGRect)frame;
- (void)toResponder;
@end

NS_ASSUME_NONNULL_END
