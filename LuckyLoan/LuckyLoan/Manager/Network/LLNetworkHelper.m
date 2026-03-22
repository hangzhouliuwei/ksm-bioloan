//
//  LLNetworkHelper.m
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLNetworkHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "LLSignModel.h"
#import "LoginStatus.h"
#import "LLDeviceInfo.h"

#define MobilePhone       @"axstone_now"
#define Sessionid         @"microecology_now"


@interface LLNetworkHelper()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation LLNetworkHelper

SINGLETON_M(LLNetworkHelper)

- (id)init{
    self = [super init];
    if (self) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 60;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/json", @"text/javascript", @"text/html", nil];
        _manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
//        [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [self loadBaseHeader];
        [self LoadHeaderString];
        [self resetNetworkType];
        [self updateNetWorkStatus];
    }
    return self;
}

- (void)networkStatus:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"567890-");
    [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingReachabilityDidChangeNotification object:nil];
}


- (void)resetNetworkType {
    self.baseUrl = @"http:/8.208.71.59:8090/api";
    self.h5Url = @"https://*****";
#ifdef DEBUG
    //不同环境网络请求路径
    _networkType = [LLCacheTool intValueForKey:@"NetworkType"];
    if (_networkType == NetworkTypeRelease) {
        self.baseUrl = @"http:/8.208.71.59:8090/api";
        self.h5Url = @"https://*****";
    }else if (_networkType == NetworkTypePre) {
        self.baseUrl = @"https://*****";
        self.h5Url = @"https://*****";
    }else if (_networkType == NetworkTypeTest) {
        self.baseUrl = @"http:/8.208.71.59:8090/api";
        self.h5Url = @"https://*****";
    }
#endif
}

- (void)LoadHeaderString {
    if (App.user.isLogin) {
        LLSignModel *sign = [LLCacheTool objectForKey:@"sign"];
        _headerString = StrFormat(@"axstone_now=%@&microecology_now=%@&huttonite_now=%@&recertification_now=%@&heterosis_now=%@&preincline_now=%@&skidoo_now=%@&physiographer_now=%@&embryonal_now=%@&succulent_now=%@", sign.phone, sign.appId, @"iOS", [LLDeviceInfo version], [LLDeviceInfo deviceName], [LLDeviceInfo idfv], [LLDeviceInfo systemVersion], @"ng", [LLDeviceInfo bundleId], [LLDeviceInfo idfa]);
    }else {
        _headerString = StrFormat(@"huttonite_now=%@&recertification_now=%@&heterosis_now=%@&preincline_now=%@&skidoo_now=%@&physiographer_now=%@&embryonal_now=%@&succulent_now=%@", @"iOS", [LLDeviceInfo version], [LLDeviceInfo deviceName], [LLDeviceInfo idfv], [LLDeviceInfo systemVersion], @"ng", [LLDeviceInfo bundleId], [LLDeviceInfo idfa]);
    }
    [LLCacheTool saveObject:[LLDeviceInfo idfa] forKey:@"idfa"];
    [LLCacheTool saveObject:[LLDeviceInfo idfv] forKey:@"idfv"];

}

- (void)loadBaseHeader {
    
    [_manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"huttonite_now"];//终端版本
    [_manager.requestSerializer setValue:[LLDeviceInfo version] forHTTPHeaderField:@"recertification_now"];//App版本
    [_manager.requestSerializer setValue:[LLDeviceInfo deviceModelName] forHTTPHeaderField:@"heterosis_now"];//设备名称
    [_manager.requestSerializer setValue:[LLDeviceInfo idfv] forHTTPHeaderField:@"preincline_now"];//设备id idfv
    [_manager.requestSerializer setValue:[LLDeviceInfo systemVersion] forHTTPHeaderField:@"skidoo_now"];//设备os版本
    [_manager.requestSerializer setValue:@"ng" forHTTPHeaderField:@"physiographer_now"];//市场
    [_manager.requestSerializer setValue:[LLDeviceInfo bundleId] forHTTPHeaderField:@"embryonal_now"];//包名
    [_manager.requestSerializer setValue:[LLDeviceInfo idfa] forHTTPHeaderField:@"succulent_now"];//gps_adid idfa
    if (App.user.isLogin) {
        LLSignModel *sign = [LLCacheTool objectForKey:@"sign"];
        [_manager.requestSerializer setValue:NotNull(sign.phone) forHTTPHeaderField:@"axstone_now"];//手机号
        [_manager.requestSerializer setValue:NotNull(sign.appId) forHTTPHeaderField:@"microecology_now"];//登录后获取的用户的sessionId
    }
}

- (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure {
    [self getWithPath:path params:params success:success failure:failure showLoading:NO];
}

- (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure showLoading:(BOOL)loading {
    if (loading) {
        [LLTools showHud];
    }
    __block BOOL load = loading;
    __block NSString *pathStr = path;
    NSString *urlString = [LLTools urlZhEncode:[self.baseUrl stringByAppendingPathComponent:path]];
    urlString = StrFormat(@"%@?%@", urlString, [LLTools urlZhEncode:_headerString]);
    [_manager GET:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (load) {
            [LLTools hideHud];
        }
        NSDictionary *resDic = (NSDictionary *)responseObject;
        LLResponseModel *model = [[LLResponseModel alloc] initModelWithDic:resDic path:pathStr];
        if ([self managerReturnData:model]) {
            return;
        }
        success(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (load) {
            [LLTools hideHud];
        }
        failure(error);
    }];
}

- (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure {
    [self postWithPath:path params:params success:success failure:failure showLoading:NO];
}

- (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure showLoading:(BOOL)loading {
    if (loading) {
        [LLTools showHud];
    }
    __block BOOL load = loading;
    __block NSString *pathStr = path;
    NSString *urlString = [LLTools urlZhEncode:[self.baseUrl stringByAppendingPathComponent:path]];
    urlString = StrFormat(@"%@?%@", urlString, [LLTools urlZhEncode:_headerString]);
    [_manager POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (load) {
            [LLTools hideHud];
        }
        NSDictionary *resDic = (NSDictionary *)responseObject;
        LLResponseModel *model = [[LLResponseModel alloc] initModelWithDic:resDic path:pathStr];
        if ([self managerReturnData:model]) {
            return;
        }
        success(model);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (load) {
            [LLTools hideHud];
        }
        failure(error);
        NSLog(@"faild==%@", error);
    }];
}

- (BOOL)managerReturnData:(LLResponseModel *)model {
    if (model.success) {
        if ([@[path_login_sms] containsObject:model.path]) {
            [self loginResult:model];//登录接口处理
        }
        return NO;
    }
    if ([model.code isEqualToString:@"-2"]) {//token登陆过期
        [LLTools showToast:model.desc time:3];
        [self showLoginVC];
        return YES;
    }else if (!model.success) {//toast
        [LLTools showToast:model.desc time:1.5];
        return NO;
    }
    return NO;
}

- (void)showLoginVC {
    [Login login:^(BOOL value) {
        
    }];
}

- (void)loginResult:(LLResponseModel *)model {

    LLSignModel *sign = [[LLSignModel alloc] init];
    sign.token = model.dataDic[c_item][c_token];
    sign.appId = model.dataDic[c_item][c_sessionid];
    sign.phone = model.dataDic[c_item][c_username];
    [LLCacheTool saveObject:sign forKey:@"sign"];
    
    LLUserModel *user = [[LLUserModel alloc] init];
    user.userName = model.dataDic[c_item][c_username];
    user.userId = model.dataDic[c_item][c_uid];
    user.realname = model.dataDic[c_item][c_realname];
    user.phone = model.dataDic[c_item][c_username];
    user.token = model.dataDic[c_item][c_token];
    user.appId = model.dataDic[c_item][c_sessionid];
    user.appstoreAccount = [model.dataDic[c_item][c_appstoreAccount] stringValue];
    [LLCacheTool saveObject:user forKey:@"user"];
        
    [App.user loginUserData:model.dataDic];
    
    [self LoadHeaderString];
}

- (void)downloadWithPath:(NSString *)path success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpDownloadProgressBlock)progress {

    // 获取完整的url路径
    NSString *url = [self.baseUrl stringByAppendingPathComponent:path];

    // 下载
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

        progress(downloadProgress.fractionCompleted);

    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        // 获取沙盒cache路径
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];

        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {

        if (error) {
            failure(error);
        } else {
            success(nil);
        }

    }];

    [downloadTask resume];
}

- (void)uploadImageWithPath:(NSString *)path params:(NSDictionary *)params thumbName:(NSString *)thumbName image:(UIImage *)image success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure progress:(HttpUploadProgressBlock)progress {
    [LLTools showHud];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    __block NSString *pathStr = [LLTools urlZhEncode:[self.baseUrl stringByAppendingPathComponent:path]];
    [_manager POST:pathStr parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:StrFormat(@"%@.png", thumbName) mimeType:@"image/octet-stream"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LLTools hideHud];
        NSDictionary *resDic = (NSDictionary *)responseObject;
        LLResponseModel *model = [[LLResponseModel alloc] initModelWithDic:resDic path:pathStr];
        if (!model.success) {
            [LLTools showToast:model.desc];
        }
        success(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LLTools hideHud];
        failure(error);
    }];
}

- (void)uploadImagesWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)thumbName
                  imageList:(NSMutableArray *)imageList
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                    progress:(HttpUploadProgressBlock)progress {
    [LLTools showHud];
        
    __block NSString *pathStr = [LLTools urlZhEncode:[self.baseUrl stringByAppendingPathComponent:path]];
    [_manager POST:pathStr parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for (int i = 0; i < imageList.count; i++) {
            NSData *data = UIImageJPEGRepresentation(imageList[i], 0.5);
            NSLog(@"-----%@",data);
            [formData appendPartWithFileData:data name:@"file" fileName:StrFormat(@"%@.png", thumbName) mimeType:@"image/octet-stream"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LLTools hideHud];
        NSDictionary *resDic = (NSDictionary *)responseObject;
        LLResponseModel *model = [[LLResponseModel alloc] initModelWithDic:resDic path:pathStr];
        if (!model.success) {
            [LLTools showToast:model.desc];
        }
        success(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LLTools hideHud];
        failure(error);
    }];
}

- (void)updateNetWorkStatus {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkStatusChanged" object:self];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.networkStatus = NLNetworkStatusUnNone;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.networkStatus = NLNetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.networkStatus = NLNetworkStatusWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.networkStatus = NLNetworkStatusWiFi;
                break;
            default:
                break;
        }
    }];
}

- (void)clearHttpHeaders {
    [App.user clearUserInfo];
    [LLCacheTool deleteObjectForKey:@"sign"];
    [LLCacheTool deleteObjectForKey:@"user"];
    
    NSMutableDictionary *dic = [_manager.requestSerializer valueForKey:@"mutableHTTPRequestHeaders"];
    [dic removeAllObjects];
    [self loadBaseHeader];
}

- (void)refreshHeaders {
    [self loadBaseHeader];
}

@end
