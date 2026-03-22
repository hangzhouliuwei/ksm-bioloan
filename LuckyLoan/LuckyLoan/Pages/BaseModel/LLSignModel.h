//
//  LLSignModel.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLSignModel : NSObject <NSCoding>

//token
@property (nonatomic, copy) NSString *token;

//apppId
@property (nonatomic, copy) NSString *appId;

//phone
@property (nonatomic, copy) NSString *phone;

@end

NS_ASSUME_NONNULL_END
