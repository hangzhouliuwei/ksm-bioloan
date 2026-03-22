//
//  LLCityAlert.h
//  LuckyLoan
//
//  Created by hao on 2024/1/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLCityAlert : UIView
@property (nonatomic, copy) ReturnDicBlock selectBlock;
- (id)initWithAddress:(NSString *)selectAddress;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
