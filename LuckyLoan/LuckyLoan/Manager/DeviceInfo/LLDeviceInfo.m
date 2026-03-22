//
//  LLDeviceInfo.m
//  LuckyLoan
//
//  Created by hao on 2024/1/18.
//

#import "LLDeviceInfo.h"
#import <AdSupport/AdSupport.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "LLIDFVTools.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "AFNetworkReachabilityManager.h"
#import<SystemConfiguration/CaptiveNetwork.h>


@implementation LLDeviceInfo

+ (NSString *)version {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return NotNull(appVersion);
}
+ (NSString *)deviceName {
    
    NSDictionary *dict = @{
        // iPhone
        @"iPhone1,1" : @"iPhone",
        @"iPhone1,2" : @"iPhone 3G",
        @"iPhone2,1" : @"iPhone 3GS",
        @"iPhone3,1" : @"iPhone 4",
        @"iPhone3,2" : @"iPhone 4",
        @"iPhone3,3" : @"iPhone 4",
        @"iPhone4,1" : @"iPhone 4S",
        @"iPhone5,1" : @"iPhone 5",
        @"iPhone5,2" : @"iPhone 5",
        @"iPhone5,3" : @"iPhone 5c",
        @"iPhone5,4" : @"iPhone 5c",
        @"iPhone6,1" : @"iPhone 5s",
        @"iPhone6,2" : @"iPhone 5s",
        @"iPhone7,2" : @"iPhone 6",
        @"iPhone7,1" : @"iPhone 6 Plus",
        @"iPhone8,1" : @"iPhone 6s",
        @"iPhone8,2" : @"iPhone 6s Plus",
        @"iPhone8,4" : @"iPhone SE (1st generation)",
        @"iPhone9,1" : @"iPhone 7",
        @"iPhone9,3" : @"iPhone 7",
        @"iPhone9,2" : @"iPhone 7 Plus",
        @"iPhone9,4" : @"iPhone 7 Plus",
        @"iPhone10,1" : @"iPhone 8",
        @"iPhone10,4" : @"iPhone 8",
        @"iPhone10,2" : @"iPhone 8 Plus",
        @"iPhone10,5" : @"iPhone 8 Plus",
        @"iPhone10,3" : @"iPhone X",
        @"iPhone10,6" : @"iPhone X",
        @"iPhone11,8" : @"iPhone XR",
        @"iPhone11,2" : @"iPhone XS",
        @"iPhone11,6" : @"iPhone XS Max",
        @"iPhone11,4" : @"iPhone XS Max",
        @"iPhone12,1" : @"iPhone 11",
        @"iPhone12,3" : @"iPhone 11 Pro",
        @"iPhone12,5" : @"iPhone 11 Pro Max",
        @"iPhone12,8" : @"iPhone SE (2nd generation)",
        @"iPhone13,1" : @"iPhone 12 mini",
        @"iPhone13,2" : @"iPhone 12",
        @"iPhone13,3" : @"iPhone 12 Pro",
        @"iPhone13,4" : @"iPhone 12 Pro Max",
        @"iPhone14,4" : @"iPhone 13 mini",
        @"iPhone14,5" : @"iPhone 13",
        @"iPhone14,2" : @"iPhone 13 Pro",
        @"iPhone14,3" : @"iPhone 13 Pro Max",
        @"iPhone14,6" : @"iPhone SE (3rd generation)",
        @"iPhone14,7" : @"iPhone 14",
        @"iPhone14,8" : @"iPhone 14 Plus",
        @"iPhone15,2" : @"iPhone 14 Pro",
        @"iPhone15,3" : @"iPhone 14 Pro Max",
        @"iPhone15,4" : @"iPhone 15",
        @"iPhone15,5" : @"iPhone 15 Plus",
        @"iPhone16,1" : @"iPhone 15 Pro",
        @"iPhone16,2" : @"iPhone 15 Pro Max",
        // iPad
        @"iPad1,1" : @"iPad",
        @"iPad2,1" : @"iPad 2",
        @"iPad2,2" : @"iPad 2",
        @"iPad2,3" : @"iPad 2",
        @"iPad2,4" : @"iPad 2",
        @"iPad3,1" : @"iPad (3rd generation)",
        @"iPad3,2" : @"iPad (3rd generation)",
        @"iPad3,3" : @"iPad (3rd generation)",
        @"iPad3,4" : @"iPad (4th generation)",
        @"iPad3,5" : @"iPad (4th generation)",
        @"iPad3,6" : @"iPad (4th generation)",
        @"iPad6,11" : @"iPad (5th generation)",
        @"iPad6,12" : @"iPad (5th generation)",
        @"iPad7,5" : @"iPad (6th generation)",
        @"iPad7,6" : @"iPad (6th generation)",
        @"iPad7,11" : @"iPad (7th generation)",
        @"iPad7,12" : @"iPad (7th generation)",
        @"iPad11,6" : @"iPad (8th generation)",
        @"iPad11,7" : @"iPad (8th generation)",
        @"iPad12,1" : @"iPad (9th generation)",
        @"iPad12,2" : @"iPad (9th generation)",
        @"iPad13,18" : @"iPad (10th generation)",
        @"iPad13,19" : @"iPad (10th generation)",
        @"iPad4,1" : @"iPad Air",
        @"iPad4,2" : @"iPad Air",
        @"iPad4,3" : @"iPad Air",
        @"iPad5,3" : @"iPad Air 2",
        @"iPad5,4" : @"iPad Air 2",
        @"iPad11,3" : @"iPad Air (3rd generation)",
        @"iPad11,4" : @"iPad Air (3rd generation)",
        @"iPad13,1" : @"iPad Air (4th generation)",
        @"iPad13,2" : @"iPad Air (4th generation)",
        @"iPad13,16" : @"iPad Air (5th generation)",
        @"iPad13,17" : @"iPad Air (5th generation)",
        @"iPad6,7" : @"iPad Pro (12.9-inch)",
        @"iPad6,8" : @"iPad Pro (12.9-inch)",
        @"iPad6,3" : @"iPad Pro (9.7-inch)",
        @"iPad6,4" : @"iPad Pro (9.7-inch)",
        @"iPad7,1" : @"iPad Pro (12.9-inch) (2nd generation)",
        @"iPad7,2" : @"iPad Pro (12.9-inch) (2nd generation)",
        @"iPad7,3" : @"iPad Pro (10.5-inch)",
        @"iPad7,4" : @"iPad Pro (10.5-inch)",
        @"iPad8,1" : @"iPad Pro (11-inch)",
        @"iPad8,2" : @"iPad Pro (11-inch)",
        @"iPad8,3" : @"iPad Pro (11-inch)",
        @"iPad8,4" : @"iPad Pro (11-inch)",
        @"iPad8,5" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,6" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,7" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,8" : @"iPad Pro (12.9-inch) (3rd generation)",
        @"iPad8,9" : @"iPad Pro (11-inch) (2nd generation)",
        @"iPad8,10" : @"iPad Pro (11-inch) (2nd generation)",
        @"iPad8,11" : @"iPad Pro (12.9-inch) (4th generation)",
        @"iPad8,12" : @"iPad Pro (12.9-inch) (4th generation)",
        @"iPad13,4" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,5" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,6" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,7" : @"iPad Pro (11-inch) (3rd generation)",
        @"iPad13,8" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,9" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,10" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad13,11" : @"iPad Pro (12.9-inch) (5th generation)",
        @"iPad2,5" : @"iPad mini",
        @"iPad2,6" : @"iPad mini",
        @"iPad2,7" : @"iPad mini",
        @"iPad4,4" : @"iPad mini 2",
        @"iPad4,5" : @"iPad mini 2",
        @"iPad4,6" : @"iPad mini 2",
        @"iPad4,7" : @"iPad mini 3",
        @"iPad4,8" : @"iPad mini 3",
        @"iPad4,9" : @"iPad mini 3",
        @"iPad5,1" : @"iPad mini 4",
        @"iPad5,2" : @"iPad mini 4",
        @"iPad11,1" : @"iPad mini (5th generation)",
        @"iPad11,2" : @"iPad mini (5th generation)",
        @"iPad14,1" : @"iPad mini (6th generation)",
        @"iPad14,2" : @"iPad mini (6th generation)",
        // 其他
        @"i386" : @"iPhone Simulator",
        @"x86_64" : @"iPhone Simulator",
    };
    
    struct utsname systemInfo;
    NSString *modelName = @"";
    if (uname(&systemInfo) < 0) {
        return @"";
    } else {
        // 获取设备标识Identifier
        NSString *deviceIdentifer = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        // 根据identifier去匹配到对应的型号名称
        modelName = [dict objectForKey:deviceIdentifer];
        return modelName?:@"";
    }
    return NotNull(modelName);
}

+(NSString *)deviceModelName
{

    NSString *deiceName = @"";
    if ([[self systemVersion] containsString:@"15"]) {
        struct utsname systemInfo;
        uname(&systemInfo);
        deiceName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    } else {
        deiceName = [self deviceName];
    }
    return NotNull(deiceName);
}

+ (NSString *)buildVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return NotNull(appBuildVersion);
}
//
+ (NSString *)systemVersion {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return NotNull(systemVersion);
}
+ (NSString *)idfa {
    NSString *uuid = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    return NotNull(uuid);
}
+ (NSString *)idfv {
    NSString *idfv = [LLIDFVTools getIDFV];
    return NotNull(idfv);
}

+ (NSString *)packageName {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    return NotNull(appName);
}

+ (NSString *)bundleId {
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    return NotNull(bundleId);
}

+ (NSString *)ip {
    NSString *address = @"127.0.0.1";
    struct ifaddrs *interfaces;
    struct ifaddrs *temp_addr;
    int success = 0;
    // 获取当前网络接口信息
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 遍历网络接口
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // 如果是IPv4地址
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 获取IP地址
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    return address;
}

//获取电池电量
+ (NSInteger)batteryLevel {
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    CGFloat quantiy = [[UIDevice currentDevice] batteryLevel];
    NSString *value = [NSString stringWithFormat:@"%.2f",quantiy * 100];
    return value.integerValue;
}

/**
 获取是否正在充电
 @return getAlcidine
 */
+ (BOOL)isCharging {
    UIDevice * device = [UIDevice currentDevice];
    //是否允许监测电池
    //要想获取电池状态和监控电池状态 必须允许
    device.batteryMonitoringEnabled = YES;
    UIDeviceBatteryState state = device.batteryState;
    if(state == UIDeviceBatteryStateUnplugged){
        return NO;
    }else if (state == UIDeviceBatteryStateCharging){
        return YES;
    }
    return NO;
}

+ (BOOL)getBatteryStatus {
    UIDevice * device = [UIDevice currentDevice];
    //是否允许监测电池
    //要想获取电池状态和监控电池状态 必须允许
    device.batteryMonitoringEnabled = YES;
    UIDeviceBatteryState state = device.batteryState;
    if(state == UIDeviceBatteryStateFull){
        return YES;
    }
    return NO;
}


//获取电池状态(UIDeviceBatteryState为枚举类型)
+ (UIDeviceBatteryState)batteryState {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    return [UIDevice currentDevice].batteryState;
}

//获取总内存大小
+ (NSString *)getTotalMemorySize {
    double totalsize = [NSProcessInfo processInfo].physicalMemory;
    return [NSString stringWithFormat:@"%.f",totalsize];
}

+ (NSUInteger)getUsedMemory {
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    if (task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count) == KERN_SUCCESS) {
        return info.resident_size;
    } else {
        return 0;
    }
}

//获取当前可用内存
+ (NSString *)getAvailableMemorySize {
    NSString *used_megabytes = @"0";
    NSByteCountFormatter *byteFormatter = [[NSByteCountFormatter alloc] init];
    [byteFormatter setAllowedUnits:NSByteCountFormatterUseBytes];
    [byteFormatter setCountStyle:NSByteCountFormatterCountStyleBinary];
    mach_task_basic_info_data_t info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    kern_return_t kerr = task_info(mach_task_self(),
                                   MACH_TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &count);
    if (kerr == KERN_SUCCESS) {
        int64_t used_bytes = info.resident_size;
        used_megabytes = [NSString stringWithFormat:@"%lld", used_bytes];
    }
    return used_megabytes;
}

//获取总磁盘容量
+ (NSString *)getTotalDiskSize {
    double totalsize = 0.0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue]*1.0;
    } else
    {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return [NSString stringWithFormat:@"%.f",totalsize];}

//获取可用磁盘容量
+ (NSString *)getAvailableDiskSize {
    double freesize = 0.0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue]*1.0;
    } else
    {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return  [NSString stringWithFormat:@"%.f",freesize];}

//型号
+ (NSString *)deviceType {
    NSString *deviceType = [UIDevice currentDevice].model;
    return NotNull(deviceType);
}

//尺寸
+ (NSString *)deviceSize {
    CGFloat width =  [[UIScreen mainScreen] nativeBounds].size.width;
    CGFloat height =  [[UIScreen mainScreen] nativeBounds].size.height;
    CGFloat physical = sqrt(width * width + height * height);
    
    return [NSString stringWithFormat:@"%0.1f",physical];
}

//尺寸宽
+ (CGFloat)deviceWidth {
    CGSize rect_screen = [[UIScreen mainScreen] nativeBounds].size;
    return rect_screen.width;
}

//尺寸高
+ (CGFloat)deviceHeight {
    CGSize rect_screen = [[UIScreen mainScreen] nativeBounds].size;

    return rect_screen.height;
}

+ (NSString *)networkStatus {
    NSString *type = @"";
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        //2g,3g
        type = @"4g";
    }
    else if (status == AFNetworkReachabilityStatusReachableViaWiFi)
    {
        //wifi
        type = @"WIFI";
    }
    return type;
}

+ (NSString *)getSIMCardInfo {
    //获取本机运营商名称
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (carrier.isoCountryCode) {
        return [carrier carrierName];
    }
    return @"";
}

// 是否越狱
+ (BOOL)isJailbroken {
    return false;
}
// 是否是模拟器
+ (BOOL)isSimulator {
#if TARGET_IPHONE_SIMULATOR//模拟器
    BOOL simulator = YES;
#elif TARGET_OS_IPHONE//真机
    BOOL simulator = false;

#endif
    return simulator;
}

// 获取手机出厂时间
+ (NSTimeInterval)getDeviceProTime {
    UIDevice *device = [UIDevice currentDevice];
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSDate *creationDate = systemAttributes[NSFileCreationDate];

    if (creationDate) {
        return [creationDate timeIntervalSince1970];
    } else {
        return 0;
    }
}

//时区
+ (NSString *)timeZone {
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    return [currentTimeZone abbreviation] ?: @"";
}

//获取当前是否使用代理
+ (BOOL)isUseProxy {
    CFArrayRef proxies = NULL;
    CFDictionaryRef proxySettings = NULL;
    NSDictionary *proxySettingsDict = NULL;

    proxySettings = CFNetworkCopySystemProxySettings();
    if (!proxySettings) {
        return NO;
    }

    proxySettingsDict = (__bridge NSDictionary *)proxySettings;
    if (proxySettingsDict == nil || !proxySettingsDict) {
        return NO;
    }

    proxies = CFNetworkCopyProxiesForURL((__bridge CFURLRef)[NSURL URLWithString:@"http://www.google.com"], NULL);
    if (!proxies) {
        return NO;
    }

    proxySettingsDict = (__bridge NSDictionary *)proxies;
    if (proxySettingsDict == nil || !proxySettingsDict) {
        return NO;
    }

    return YES;
}

+ (BOOL)isUseVPN {
    BOOL flag = NO;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 9.0) {
        NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
        NSArray *keys = [dict[@"__SCOPED__"] allKeys];
        for (NSString *key in keys) {
            if ([key rangeOfString:@"tap"].location != NSNotFound ||
                [key rangeOfString:@"tun"].location != NSNotFound ||
                [key rangeOfString:@"ipsec"].location != NSNotFound ||
                [key rangeOfString:@"ppp"].location != NSNotFound){
                flag = YES;
                break;
            }
        }
    }else {
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        success = getifaddrs(&interfaces);
        if (success == 0)
        {
            temp_addr = interfaces;
            while (temp_addr != NULL)
            {
                NSString *string = [NSString stringWithFormat:@"%s" , temp_addr->ifa_name];
                if ([string rangeOfString:@"tap"].location != NSNotFound ||
                    [string rangeOfString:@"tun"].location != NSNotFound ||
                    [string rangeOfString:@"ipsec"].location != NSNotFound ||
                    [string rangeOfString:@"ppp"].location != NSNotFound)
                {
                    flag = YES;
                    break;
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        freeifaddrs(interfaces);
    }
    return flag;
}

//语言
+ (NSString *)deviceLanuage {
    //判断当前系统语言
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSArray  *array = [language componentsSeparatedByString:@"-"];
    NSString *currentLanguage = array[0];
    return language;
}

+ (NSString *)getBSSID {
    if ([[AFNetworkReachabilityManager sharedManager]isReachableViaWiFi]) {
        CFArrayRef myArray = CNCopySupportedInterfaces();
        if (myArray != nil) {
            CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
            if (myDict != nil) {
                NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
                NSString *bssid = [dict valueForKey:@"BSSID"];
                bssid = bssid ? [self standardFormateMAC:bssid] : bssid;
                return NotNull(bssid);
            }
        }
    }
    return @"";
}

+ (NSString *)standardFormateMAC:(NSString *)MAC {
    NSArray * subStr = [MAC componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":-"]];
    NSMutableArray * subStr_M = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString * str in subStr) {
        if (1 == str.length) {
            NSString * tmpStr = [NSString stringWithFormat:@"0%@", str];
            [subStr_M addObject:tmpStr];
        } else {
            [subStr_M addObject:str];
        }
    }
    NSString * formateMAC = [subStr_M componentsJoinedByString:@":"];
    return NotNull([formateMAC uppercaseString]);
}

//获取Wi-Fi名字
+ (NSString *)getWifiName {
    if ([[AFNetworkReachabilityManager sharedManager]isReachableViaWiFi]) {
        CFArrayRef myArray = CNCopySupportedInterfaces();
        if (myArray != nil) {
            CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
            if (myDict != nil) {
                NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
                NSString *name = [dict valueForKey:@"SSID"];
                return NotNull(name);
            }
        }
    }
    return @"";
}


@end
