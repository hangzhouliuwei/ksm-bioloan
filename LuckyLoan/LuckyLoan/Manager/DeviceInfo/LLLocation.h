//
//  LLLocation.h
//  LuckyLoan
//
//  Created by hao on 2024/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLLocation : NSObject
@property (nonatomic, copy) ReturnBoolBlock resultBlock;
- (void)requestAuthLocation;
@end

NS_ASSUME_NONNULL_END
