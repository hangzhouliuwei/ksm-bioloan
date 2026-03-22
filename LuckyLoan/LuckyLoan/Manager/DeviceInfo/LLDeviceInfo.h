//
//  LLDeviceInfo.h
//  LuckyLoan
//
//  Created by hao on 2024/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLDeviceInfo : NSObject
+ (NSString *)version;
+ (NSString *)deviceName;
+ (NSString *)buildVersion;
+ (NSString *)systemVersion;
+ (NSString *)idfa;
+ (NSString *)idfv;
+ (NSString *)packageName;
+ (NSString *)bundleId;
+ (NSString *)ip;
+ (NSInteger)batteryLevel;
+ (BOOL)isCharging;
+ (UIDeviceBatteryState)batteryState;
+ (BOOL)getBatteryStatus;
+ (NSString *)getTotalMemorySize;
+ (NSString *)getAvailableMemorySize;
+ (NSString *)getTotalDiskSize;
+ (NSString *)getAvailableDiskSize;
+ (NSString *)deviceType;
+ (NSString *)deviceSize;
+ (CGFloat)deviceWidth;
+ (CGFloat)deviceHeight;
+ (NSString *)networkStatus;
+ (NSString *)getSIMCardInfo;
+ (NSString *)deviceModelName;
+ (BOOL)isJailbroken;
+ (BOOL)isSimulator;
+ (NSTimeInterval)getDeviceProTime;
+ (NSString *)timeZone;
+ (BOOL)isUseProxy;
+ (BOOL)isUseVPN;
+ (NSString *)deviceLanuage;
+ (NSString *)getBSSID;
+ (NSString *)getWifiName;
@end

NS_ASSUME_NONNULL_END
