//
//  AppDelegate.m
//  LuckyLoan
//
//  Created by hao on 2023/12/21.
//

#import "AppDelegate.h"
#import "LLLanuchHelper.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    sleep(2);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [Lanuch launch];
    [Page configureWindow:self.window];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication*)application {//request idfa must put code include applicationDidBecomeActive
    if (App.status.didSendMarket) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    NSUUID *uuid = [ASIdentifierManager sharedManager].advertisingIdentifier;
                    [Lanuch sendMarket:uuid.UUIDString];
                    App.status.didSendMarket = YES;
                }
            }];
        } else {
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                [Lanuch sendMarket:idfa];
                App.status.didSendMarket = YES;
            } else {
                NSLog(@"reject");
            }
        }
    });
}

@end
