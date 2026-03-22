//
//  LLAccessAlert.h
//  LuckyLoan
//
//  Created by hao on 2024/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLAccessAlert : UIView
@property (nonatomic, copy) ReturnNoneBlock confirmBlock;
- (id)initWithIcon:(NSString *)icon content:(NSString *)content;
- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
