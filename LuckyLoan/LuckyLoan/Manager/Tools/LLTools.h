//url中文转义//
//  LLTools.h
//  Hao
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>

typedef void (^ReturnNoneBlock)(void);
typedef void (^ReturnBoolBlock)(BOOL value);
typedef void (^ReturnIntBlock)(NSInteger index);
typedef void (^ReturnStrBlock)(NSString *str);
typedef void (^ReturnDicBlock)(NSDictionary *dic);

@interface LLTools : NSObject
//根据十六进制生成颜色
+ (UIColor *)colorWithHexString: (NSString *)color;
//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string;

//判断尼日利亚手机号是否合法
+ (BOOL)isNrlyPhoneNo:(NSString *)phoneNo;
//计算系统字符串的size
+ (CGSize)getSizeByString:(NSString*)str fontValue:(CGFloat)fontValue maxSize:(CGSize)size;
//显示消息框
+ (void)showToast:(NSString *)str;
//显示消息框（时间）
+ (void)showToast:(NSString *)str time:(NSTimeInterval)time;
//url中文转义
+ (NSString *)urlZhEncode:(NSString *)urlStr;
//打电话
+ (void)callWithPhoneNo:(NSString *)str;
//点赞动画
+ (void)addAttentionAnimation:(UIView *)view;
//震动
+ (void)shake;
//显示loading框
+ (void)showHud;
//隐藏loading框
+ (void)hideHud;
+ (NSString *)nowTimeIntervalString;
//时间字符串转时间戳
+ (NSInteger)timeWithString:(NSString *)dateStr formatter:(NSString *)formatter;
//时间戳转时间字符串
+ (NSString *)stringWithTime:(NSInteger)time formatter:(NSString *)formatter;
//打开系统设置页面
+ (void)jumpSystemSetting;
@end
