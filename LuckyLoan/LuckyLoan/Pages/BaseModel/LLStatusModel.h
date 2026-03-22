//
//  LLStatusModel.h
//  king
//
//  Created by hao on 2023/96.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLStatusModel : NSObject

@property (nonatomic, strong) NSString *version;
@property (nonatomic, copy) NSDictionary *loctionDic;
@property (nonatomic, assign) BOOL needUpdate;
@property (nonatomic, assign) BOOL personInfoAuth;
@property (nonatomic, assign) BOOL workInfoAuth;
@property (nonatomic, assign) BOOL contactInfoAuth;
@property (nonatomic, assign) BOOL bankInfoAuth;
@property (nonatomic, copy) NSString *appUpdateUrl;
@property (nonatomic, copy) NSArray *authItems;
@property (nonatomic, copy) NSString *authJumpUrl;
@property (nonatomic, assign) BOOL didSendMarket;
@property (nonatomic, copy) NSString *didSendSmsPhone;
@property (nonatomic, copy) NSArray *cityList;

- (void)updateVersion:(NSMutableDictionary *)dic needUpdate:(ReturnBoolBlock)block sure:(ReturnNoneBlock)sureBlock cancel:(ReturnNoneBlock)cancelBlock;

@end

NS_ASSUME_NONNULL_END
