//
//  LLCacheTool.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLCacheTool.h"

#define UserDefault [NSUserDefaults standardUserDefaults]

@implementation LLCacheTool

+ (void)saveObject:(id)object forKey:(NSString *)key {
    NSString *path = [LLCacheTool findPath:key];
    BOOL success = [NSKeyedArchiver archiveRootObject:object toFile:path];
    if (success) {
//        NSLog(@"归档成功");
    }else {
//        NSLog(@"归档失败");
    }
}

+ (void)deleteObjectForKey:(NSString *)key {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Archive/%@.plist", key]];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exists) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (id)objectForKey:(NSString *)key {
    NSString *path = [LLCacheTool findPath:key];
    id object;
    @try {
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    } @catch (NSException *ex) {
        object = nil;
    }
    return object;
}

+ (NSString *)findPath:(NSString *)key {
    
    NSString *docPath = NSHomeDirectory();
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Archive/%@.plist", key]];
    NSString *directory = [path stringByDeletingLastPathComponent];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil];
    if (!fileExists) {
        NSLog(@"文件夹不存在");
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"文件夹创建失败errorInfo=%@",error.description);
        } else {
            NSLog(@"文件夹创建成功");
        }
    }
    return path;
}

+ (void)setBool:(BOOL)object forKey:(NSString *)key {
    [UserDefault setBool:object forKey:key];
    [UserDefault synchronize];
}

+ (void)setInt:(NSInteger)object forKey:(NSString *)key {
    [UserDefault setInteger:object forKey:key];
    [UserDefault synchronize];
}

+ (void)setDouble:(double)object forKey:(NSString *)key {
    [UserDefault setDouble:object forKey:key];
    [UserDefault synchronize];
}

+ (void)setFloat:(float)object forKey:(NSString *)key {
    [UserDefault setFloat:object forKey:key];
    [UserDefault synchronize];
}

+ (void)setString:(NSString *)object forKey:(NSString *)key {
    [UserDefault setObject:object forKey:key];
    [UserDefault synchronize];
}

+ (BOOL)boolValueForKey:(NSString *)key {
    return [UserDefault boolForKey:key];
}

+ (NSInteger)intValueForKey:(NSString *)key {
    return [UserDefault integerForKey:key];
}

+ (double)doubleValueForKey:(NSString *)key {
    return [UserDefault doubleForKey:key];
}

+ (float)floatValueForKey:(NSString *)key {
    return [UserDefault floatForKey:key];
}

+ (NSString *)stringValueForKey:(NSString *)key {
    return [UserDefault stringForKey:key];
}

@end
