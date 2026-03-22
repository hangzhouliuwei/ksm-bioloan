//
//  LLNoticeView.h
//  LuckyLoan
//
//  Created by hao on 2023/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLNoticeView : UIView
@property (nonatomic, copy) ReturnNoneBlock closeBlock;
- (void)setNoticeTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
