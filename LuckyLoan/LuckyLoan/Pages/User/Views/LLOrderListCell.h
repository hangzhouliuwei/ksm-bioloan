//
//  LLOrderListCell.h
//  LuckyLoan
//
//  Created by hao on 2023/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define OrderListHeight 281

@interface LLOrderListCell : UITableViewCell
@property (nonatomic, copy) ReturnNoneBlock selectBlock;
- (void)loadData:(NSDictionary *)dic;
+ (CGFloat)cellHeight:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
