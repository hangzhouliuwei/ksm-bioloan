//
//  LLCacheTool.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLCacheTool : NSObject

+ (void)saveObject:(id)object forKey:(NSString *)key;
+ (void)deleteObjectForKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

+ (void)setBool:(BOOL)object forKey:(NSString *)key;
+ (void)setInt:(NSInteger)object forKey:(NSString *)key;
+ (void)setDouble:(double)object forKey:(NSString *)key;
+ (void)setFloat:(float)object forKey:(NSString *)key;
+ (void)setString:(NSString *)object forKey:(NSString *)key;

+ (BOOL)boolValueForKey:(NSString *)key;
+ (NSInteger)intValueForKey:(NSString *)key;
+ (double)doubleValueForKey:(NSString *)key;
+ (float)floatValueForKey:(NSString *)key;
+ (NSString *)stringValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
