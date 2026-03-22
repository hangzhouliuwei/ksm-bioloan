//
//  LoginStatus.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define Login   [LoginStatus sharedLoginStatus]

@interface LoginStatus : NSObject

SINGLETON_H(LoginStatus)
- (void)login:(ReturnBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
