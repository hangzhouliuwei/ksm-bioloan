//
//  LLResponseModel.h
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLResponseModel : NSObject
@property (nonatomic, strong) NSNumber *dataNumber;
@property (nonatomic, copy) NSString *dataStr;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, copy) NSString *path;

- (id)initModelWithDic:(NSDictionary *)dic path:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
