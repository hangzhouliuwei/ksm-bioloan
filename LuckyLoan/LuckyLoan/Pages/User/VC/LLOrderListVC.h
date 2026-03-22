//
//  LLOrderListVC.h
//  LuckyLoan
//
//  Created by hao on 2023/12/29.
//

#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLOrderListVC : LLBaseViewController
@property (nonatomic, assign) NSInteger selectTabIndex;
@property (nonatomic, copy) NSString *orderType;// 状态 4全部 7进行中 6待还款 5已结清
@end

NS_ASSUME_NONNULL_END
