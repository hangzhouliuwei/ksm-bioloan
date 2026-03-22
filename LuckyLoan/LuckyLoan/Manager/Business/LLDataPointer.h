//
//  LLDataPointer.h
//  LuckyLoan
//
//  Created by hao on 2024/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define DataPoint   [LLDataPointer sharedLLDataPointer]

@interface LLDataPointer : NSObject

SINGLETON_H(LLDataPointer)

- (void)userburiePoint:(NSDictionary *)dic;

- (void)updateUserInfo:(ReturnBoolBlock)success;

@end

NS_ASSUME_NONNULL_END
