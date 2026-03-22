//
//  LLLoginVC.h
//  LuckyLoan
//
//  Created by hao on 2023/12/21.
//
#import "LLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLLoginAuthCodeVC : LLBaseViewController
@property (nonatomic, copy) ReturnBoolBlock loginBLock;
@property (nonatomic, copy) NSString *phoneNo;
@end

NS_ASSUME_NONNULL_END
