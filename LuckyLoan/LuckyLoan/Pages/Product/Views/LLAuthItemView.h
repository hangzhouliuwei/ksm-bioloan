//
//  LLAuthItemView.h
//  LuckyLoan
//
//  Created by hao on 2024/1/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLAuthItemView : UIView
@property (nonatomic, copy) ReturnNoneBlock selectBlock;
@property (nonatomic, assign) BOOL selected;
- (void)loadIcon:(NSString *)icon title:(NSString *)title status:(NSString *)status;
@end

NS_ASSUME_NONNULL_END
