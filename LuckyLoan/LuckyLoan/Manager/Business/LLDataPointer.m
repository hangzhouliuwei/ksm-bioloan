//
//  LLDataPointer.m
//  LuckyLoan
//
//  Created by hao on 2024/1/25.
//

#import "LLDataPointer.h"
#import "LLDeviceInfo.h"
#import "LLLocation.h"
#import "LLAccessAlert.h"

@interface LLDataPointer ()
@property (nonatomic, strong) LLLocation *location;

@end

@implementation LLDataPointer
SINGLETON_M(LLDataPointer)


- (void)userburiePoint:(NSDictionary *)dic {
    NSString *longitude = App.status.loctionDic[@"longitude"];
    NSString *latitude = App.status.loctionDic[@"latitude"];
    NSString *start = dic[@"startTime"];
    NSString *end = dic[@"endTime"];
    NSString *seceneType = dic[@"seceneType"];
    NSString *productId = dic[@"productId"];
    NSString *orderId = dic[@"orderId"];
    NSDictionary *info = @{c_start_time:NotNull(start),
                           c_end_time:NotNull(end),
                           c_orderNo:NotNull(orderId),
                           c_sceneType:NotNull(seceneType),
                           c_longitude:NotNull(longitude),
                           c_latitude:NotNull(latitude),
                           c_productId:NotNull(productId),
                           c_device_no:[LLDeviceInfo idfv]};
    [Network postWithPath:path_buriePoint params:info success:^(LLResponseModel *response) {
        if (response.success) {
        }
    } failure:^(NSError *error) {
    }];

}

- (void)updateUserInfo:(ReturnBoolBlock)success {
    _location = [[LLLocation alloc] init];
    kWeakself;
    _location.resultBlock = ^(BOOL value) {
        if (value) {
            [weakSelf uploadUserInfo:success];
        }else {
            LLAccessAlert *alert = [[LLAccessAlert alloc] initWithIcon:@"ic_location_access" content:@"Please provide manual access CashHop"];
            alert.confirmBlock = ^{
                [LLTools jumpSystemSetting];
            };
            [alert show];
        }
    };
    [_location requestAuthLocation];
}

- (void)uploadUserInfo:(ReturnBoolBlock)success {
    if (App.status.loctionDic.allKeys.count == 0) {
        success(NO);
        return;
    }
    kWeakself;
    NSDictionary *dic = App.status.loctionDic;
    NSDictionary *info = @{c_admin_area:dic[@"province"],
                           c_country_code:dic[@"code"],
                           c_country_name:dic[@"country"],
                           c_feature_name:dic[@"street"],
                           c_longitude:dic[@"longitude"],
                           c_latitude:dic[@"latitude"],
                           c_locality:dic[@"locality"],
                           c_sub_admin_area:dic[@"subLocality"]};
    [Network postWithPath:path_uploadLocation params:info success:^(LLResponseModel *response) {
        if (response.success) {
            [weakSelf uploadDevice:success];
        }else {
            success(NO);
        }
    } failure:^(NSError *error) {
    } showLoading:YES];
}

- (void)uploadDevice:(ReturnBoolBlock)success {
    
    NSDictionary *dic = @{
        @"battementMc": @{//（ 单位Byte字节）
            @"peronistaMc": [LLDeviceInfo getAvailableDiskSize], //可用存储大小
            @"realizationMc": [LLDeviceInfo getTotalDiskSize],  //总存储大小
            @"anxietyMc": [LLDeviceInfo getTotalMemorySize],  //总内存大小
            @"lueticMc": [LLDeviceInfo getAvailableMemorySize] //内存可用大小
        },
        @"battery_status": @{
            @"landfillMc": @([LLDeviceInfo batteryLevel]),  //剩余电量（百分比）
            @"battery_status": @([LLDeviceInfo getBatteryStatus] ? 1 : 0),  //Battery full
            @"gemologicalMc": @([LLDeviceInfo isCharging] ? 1 : 0)   //是否正在充电 0、1
        },
        @"hardware": @{
            @"crossarmMc": [LLDeviceInfo systemVersion], //系统版本
            @"beagleMc": @"iPhone", //设备名牌
            @"vanadiniteMc": [LLDeviceInfo deviceModelName],//设备型号
            @"ricerMc": @([LLDeviceInfo deviceHeight]),//分辨率高
            @"repugnantMc": @([LLDeviceInfo deviceWidth]),//分辨率宽
            @"inordinatelyMc": [LLDeviceInfo deviceSize],//物理尺寸
            @"societalMc": @([LLDeviceInfo getDeviceProTime]),//手机出厂时间戳
        },
        @"neuropathMc": @{},
        @"pneumatoceleMc": @{
            @"allowablyMc": @"0",//信号强度，传0即可
            @"curtilageMc": @([LLDeviceInfo isSimulator] ? 1 : 0),//是否为模拟器
            @"talmiMc": @([LLDeviceInfo isJailbroken] ? 1 : 0) //是否越狱
        },
        @"kibedMc": @{
            @"patoisMc": [LLDeviceInfo timeZone],//时区的 ID
            @"jujubeMc": @([LLDeviceInfo isUseProxy] ? 1 : 0),//是否使用代理 0、1
            @"hardcaseMc": @([LLDeviceInfo isUseVPN] ? 1 : 0),//是否使用vpn 0、1
            @"agadaMc": [LLDeviceInfo getSIMCardInfo],
            @"climeMc": [LLDeviceInfo idfv],//idfv
            @"millihenryMc": [LLDeviceInfo deviceLanuage],//语言
            @"brahmaMc": [LLDeviceInfo networkStatus],//网络类型 2G、3G、4G、5G、WIFI、OTHER、NONE
            @"barbicelMc": @1,//指示设备电话类型的常量1 手机;2 平板
            @"gramdanMc": [LLDeviceInfo ip],//外网ip
            @"noisefulMc": [LLDeviceInfo idfa]//idfa
        },
        @"committeemanMc": @{
            @"thermelMc": @[@{
                    @"sandbaggerMc": [LLDeviceInfo getBSSID],//基本服务集标识符；设备的的虚拟mac
                    @"chiffonierMc": [LLDeviceInfo getWifiName],//服务集标识符
                    @"scarMc": [LLDeviceInfo getBSSID],//wifimac地址
                    @"postliterateMc": [LLDeviceInfo getWifiName]//wifi 名称
            }]}
        };
    [Network postWithPath:path_uploadDevice params:dic success:^(LLResponseModel *response) {
        if (response.success) {
            success(YES);
        }else {
            success(NO);
        }
    } failure:^(NSError *error) {
    } showLoading:YES];
}




@end
