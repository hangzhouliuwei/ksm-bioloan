//
//  LLCountDown.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>

#define CountDownLoginOverNotification          @"CountDownLoginOverNotification"
#define CountDownBindCardOverNotification       @"CountDownBindCardOverNotification"

#define CountDownLoginNotification              @"CountDownLoginNotification"
#define CountDownBindCardNotification           @"CountDownBindCardNotification"

NS_ASSUME_NONNULL_BEGIN

#define CountDown    [LLCountDown sharedLLCountDown]

typedef NS_ENUM(NSInteger, kCountDownType) {
    CountDownTypeLogin = 0,
    CountDownTypeBindPhone,
};

@interface LLCountDown : NSObject

SINGLETON_H(LLCountDown)
- (void)countDownWithType:(kCountDownType)countDownType;
- (void)cancelCountDownWithType:(kCountDownType)countDownType;

@end

NS_ASSUME_NONNULL_END
