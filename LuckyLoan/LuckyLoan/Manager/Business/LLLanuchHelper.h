//
//  LLLanuchHelper.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define Lanuch   [LLLanuchHelper sharedLLLanuchHelper]

@interface LLLanuchHelper : NSObject

SINGLETON_H(LLLanuchHelper)

- (void)launch;
- (void)sendMarket:(NSString *)idfa;

@end

NS_ASSUME_NONNULL_END
