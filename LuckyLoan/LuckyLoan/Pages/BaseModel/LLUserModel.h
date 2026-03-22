//
//  LLUserModel.h
//  king
//
//  Created by hao on 2023/96.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLUserModel : NSObject <NSCoding>
//登录状态
@property (nonatomic, assign) BOOL isLogin;

//用户名
@property (nonatomic, copy) NSString *userName;

//用户真名
@property (nonatomic, copy) NSString *realname;

//手机号
@property (nonatomic, copy) NSString *phone;

//token
@property (nonatomic, copy) NSString *token;

//appId
@property (nonatomic, copy) NSString *appId;

//appstoreAccount
@property (nonatomic, copy) NSString *appstoreAccount;

//用户ID
@property (nonatomic, copy) NSString * userId;

//性别
@property (nonatomic, copy) NSString *sex;

- (void)loginUserData:(NSDictionary *)dic;

- (void)resetUserInfo:(NSDictionary *)dic;

- (void)clearUserInfo;

@end

NS_ASSUME_NONNULL_END
