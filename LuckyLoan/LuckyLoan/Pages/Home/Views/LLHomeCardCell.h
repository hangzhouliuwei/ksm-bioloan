//
//  LLHomeCardCell.h
//  LuckyLoan
//
//  Created by hao on 2023/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define HomeCardHeight (153*WScale)

@interface LLHomeCardCell : UITableViewCell
@property (nonatomic, copy) ReturnNoneBlock selectBlock;
- (void)loadData:(NSDictionary *)dic index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
