//
//  LLItemAlert.h
//  LuckyLoan
//
//  Created by hao on 2024/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLItemAlert : UIView
@property (nonatomic, copy) ReturnDicBlock selectBlock;
- (id)initWithData:(NSArray *)arr selected:(NSString *)selectType title:(NSString *)titleStr;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
