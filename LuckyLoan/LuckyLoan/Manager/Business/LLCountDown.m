//
//  LLCountDown.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLCountDown.h"

#define CountDownTime 60

@interface LLCountDown ()
@property (nonatomic, assign) kCountDownType countDonwnType;
@property (nonatomic, nullable, strong) dispatch_source_t loginTimer;//登录界面倒计时timer
@property (nonatomic, nullable, strong) dispatch_source_t bindPhoneTimer;//绑定手机号倒计时timer
@end

@implementation LLCountDown
SINGLETON_M(LLCountDown)

- (void)countDownWithType:(kCountDownType)countDownType {
    
    self.countDonwnType = countDownType;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t tempTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(tempTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    NSTimeInterval seconds = CountDownTime;
    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:seconds];
    
    dispatch_source_set_event_handler(tempTimer, ^{
        
        int interval = [endTime timeIntervalSinceNow];
        if (interval <= 0) {
            dispatch_source_cancel(tempTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([tempTimer isEqual:self.loginTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:CountDownLoginOverNotification object:@(interval)];
                } else if ([tempTimer isEqual:self.bindPhoneTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:CountDownBindCardOverNotification object:@(interval)];
                }
                
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"-----%d",interval);
                if ([tempTimer isEqual:self.loginTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:CountDownLoginNotification object:@(interval)];
                } else if ([tempTimer isEqual:self.bindPhoneTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:CountDownBindCardNotification object:@(interval)];
                }
            });
        }
    });
    
    if (self.countDonwnType == CountDownTypeLogin) {
        self.loginTimer = tempTimer;
    } else if (self.countDonwnType == CountDownTypeBindPhone) {
        self.bindPhoneTimer = tempTimer;
    }
    dispatch_resume(tempTimer);
}

- (void)cancelCountDownWithType:(kCountDownType)countDownType {
    
    switch (countDownType) {
        case CountDownTypeLogin:
            if (self.loginTimer) {
                dispatch_source_cancel(self.loginTimer);
                self.loginTimer = nil;
            }
            
            break;
        case CountDownTypeBindPhone:
            if (self.bindPhoneTimer) {
                dispatch_source_cancel(self.bindPhoneTimer);
                self.bindPhoneTimer = nil;
            }
            
            break;
            
        default:
            break;
    }
}

@end
