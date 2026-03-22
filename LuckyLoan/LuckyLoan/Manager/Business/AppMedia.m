//
//  AppMedia.m
//  king
//
//  Created by hao on 2023/9/4.
// 
//

#import "AppMedia.h"

@implementation AppMedia

SINGLETON_M(AppMedia)

- (id)init{
    self = [super init];
    if (self) {
        self.user = [[LLUserModel alloc] init];
        self.status = [[LLStatusModel alloc] init];
    }
    return self;
}

@end
