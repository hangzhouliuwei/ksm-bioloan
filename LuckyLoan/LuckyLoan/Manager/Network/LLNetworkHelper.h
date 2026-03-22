//
//  LLNetworkHelper.h
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>
#import "LLResponseModel.h"

#define Network     [LLNetworkHelper sharedLLNetworkHelper]

typedef void(^HttpSuccessBlock)(LLResponseModel* response);
typedef void(^HttpFailureBlock)(NSError *error);
typedef void(^HttpDownloadProgressBlock)(CGFloat progress);
typedef void(^HttpUploadProgressBlock)(CGFloat progress);

typedef NS_ENUM(NSInteger, NetworkType) {
    NetworkTypeRelease = 0,
    NetworkTypePre,
    NetworkTypeTest,
};

typedef NS_ENUM(NSInteger, NLNetworkStatus) {
    NLNetworkStatusUnNone = 0,
    NLNetworkStatusUnknown,
    NLNetworkStatusWAN,
    NLNetworkStatusWiFi
};

@interface LLNetworkHelper : NSObject

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *h5Url;
@property (nonatomic, assign) NetworkType networkType;
@property (nonatomic, assign) NLNetworkStatus networkStatus;
@property (nonatomic, copy) NSString *headerString;

SINGLETON_H(LLNetworkHelper)

/**
 get网络请求

 @param path url地址
 @param params url参数 NSDictionary类型
 @param success 请求成功 返回NSDictionary或NSArray
 @param failure 请求失败 返回NSError
 */
- (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure;

- (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure
        showLoading:(BOOL)loading;

/**
 post网络请求
 
 @param path url地址
 @param params url参数 NSDictionary类型
 @param success 请求成功 返回NSDictionary或NSArray
 @param failure 请求失败 返回NSError
 */
- (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure;

- (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure
         showLoading:(BOOL)loading;

/**
 下载文件
 
 @param path url路径
 @param success 下载成功
 @param failure 下载失败
 @param progress 下载进度
 */
- (void)downloadWithPath:(NSString *)path
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure
                progress:(HttpDownloadProgressBlock)progress;

/**
 上传图片
 
 @param path url地址
 @param image UIImage对象
 @param thumbName imagekey
 @param params 上传参数
 @param success 上传成功
 @param failure 上传失败
 @param progress 上传进度
 */
- (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)thumbName
                      image:(UIImage *)image
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress;

/**
 上传多张图片
 
 @param path url地址
 @param imageList UIImage对象
 @param thumbName imagekey
 @param params 上传参数
 @param success 上传成功
 @param failure 上传失败
 @param progress 上传进度
 */
- (void)uploadImagesWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)thumbName
                  imageList:(NSMutableArray *)imageList
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress;

/**
更新网络状态
*/
- (void)updateNetWorkStatus;

/**
清除请求header
*/
- (void)clearHttpHeaders;

/**
刷新请求header
*/
- (void)refreshHeaders;

@end
