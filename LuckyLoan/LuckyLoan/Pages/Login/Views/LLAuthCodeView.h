//
//  LLPhoneInputView.h
//  LuckyLoan
//
//  Created by hao on 2023/12/21.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AuthCodeType) {
    AuthCodeTypeFastLogin = 0,
    AuthCodeTypeRegister,
    AuthCodeTypeForgotPassWord,
    AuthCodeTypeBindPhoneNo,
    AuthCodeTypeOther,
};

@interface LLAuthCodeView : UIView

@property (nonatomic, assign) AuthCodeType type;
@property (nonatomic, copy) ReturnNoneBlock clickBlock;

- (id)initWithFrame:(CGRect)frame phone:(NSString *)phone;
- (void)startCountDown;

@end

NS_ASSUME_NONNULL_END
