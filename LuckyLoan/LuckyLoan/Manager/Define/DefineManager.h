//
//  DefineManager.h
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#ifndef DefineManager_h
#define DefineManager_h

#define AppFlyerId                  @"123456" //haotodo
#define ContractUrl                 @"http://8.208.71.59:8090/#/testapp"//haotodo
#define PrivacyUrl                  @"http://8.208.71.59:8090/#/testapp"//haotodo
#define AppStoreUrl                 @"https://itunes.apple.com/app/apple-store/idxxxxxxxxxx?mt=8"//haotodo

#define H5TestUrl                   @"https://www.cashhops.com/#/testapp"

#define NotNull(str)                [LLTools isBlankString:str]?@"":str
#define StrValue(value, dotNum)     [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%df",dotNum],(double)value]
#define StrFormat(format, args...)  [NSString stringWithFormat:format, args]
#define ImageWithName(name)         [UIImage imageNamed:name]
#define URLEncode(urlstring)        [NSURL URLWithString:[LLTools urlZhEncode:urlstring]]
#define Font(value)                 [UIFont systemFontOfSize:value]
#define FontBold(value)             [UIFont boldSystemFontOfSize:value]

#define LeftMargin                  16.0
#define TopSpace                    12.0
#define SafeWidth                   (ScreenWidth - 2*LeftMargin)
#define ScreenWidth                 ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight                ([UIScreen mainScreen].bounds.size.height)
#define StatusBarHeight             ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NavigationBarHeight         (44.0 + StatusBarHeight)
#define TabBarHeight                (StatusBarHeight > 20 ? 83.0 : 49.0)
#define SafeAreaBottomHeight        (StatusBarHeight > 20 ? 34.0 : 0)
#define WScale                      (ScreenWidth/375.0)            // 宽度比例 - 相对于375屏
#define HaoTag                      727

#define TopWindow                   [[[UIApplication sharedApplication] windows] firstObject]
#define kWeakself                   __weak typeof(self) weakSelf = self

#define IOS_VRESION_11              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11)
#define IOS_VRESION_12              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12)
#define IOS_VRESION_13              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13)
#define IOS_VRESION_14              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 14)
#define IOS_VRESION_15              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 15)
#define IOS_VRESION_16              ([[[UIDevice currentDevice] systemVersion] floatValue] >= 16)


#define COLORA(r,g,b,a)             [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:a]
#define COLOR(r,g,b)                [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1.0]
#define ClearColor                  [UIColor clearColor]
#define MainColor                   COLOR(0, 131, 94)
#define LightMainColor              COLOR(243, 248, 246)

#define BGColor                     COLOR(255, 255, 255)
#define ShadowColor                 COLOR(31, 31, 31)
#define LineGrayColor               COLOR(226, 234, 238)
#define LineLightGrayColor          COLOR(245, 246, 250)
#define TextWhiteColor              COLOR(255, 255, 255)
#define TextBlackColor              COLOR(46, 49, 62)
#define TextGrayColor               COLOR(99, 113, 130)
#define TextLightGrayColor          COLOR(203, 204, 210)


#define HideSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

// 单例.h文件
#define SINGLETON_H(name)           + (instancetype)shared##name;

// 单例.m文件
#define SINGLETON_M(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

#endif
