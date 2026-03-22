//
//  AppMedia.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>
#import "LLUserModel.h"
#import "LLStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

#define App    [AppMedia sharedAppMedia]

@interface AppMedia : NSObject

@property (nonatomic, strong) LLUserModel *user;
@property (nonatomic, strong) LLStatusModel *status;

SINGLETON_H(AppMedia)

@end

NS_ASSUME_NONNULL_END
