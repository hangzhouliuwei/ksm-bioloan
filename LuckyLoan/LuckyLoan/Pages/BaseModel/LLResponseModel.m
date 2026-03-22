//
//  ResponseModel.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "LLResponseModel.h"

@implementation LLResponseModel

- (id)initModelWithDic:(NSDictionary *)dic path:(NSString *)path {
    self = [super init];
    if (self) {
        self.path = path;
        self.code = [dic[c_code] stringValue];
        self.desc = dic[c_message];
        self.success = [self.code isEqualToString:@"00"] || [self.code isEqualToString:@"0"];
        if (!dic[c_data]) {
            return self;
        }
        if ([dic[c_data] isKindOfClass:[NSString class]]) {
            self.dataStr = NotNull(dic[c_data]);
        }
        if ([dic[c_data] isKindOfClass:[NSNumber class]]) {
            self.dataNumber = dic[c_data];
        }
        if ([dic[c_data] isKindOfClass:[NSArray class]]) {
            self.dataArr = dic[c_data];
        }
        if ([dic[c_data] isKindOfClass:[NSDictionary class]]) {
            self.dataDic = dic[c_data];
        }
    }
    return self;
}

@end
