//
//  LLLocation.m
//  LuckyLoan
//
//  Created by hao on 2024/1/25.
//

#import "LLLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface LLLocation () <CLLocationManagerDelegate>
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL didGot;
@end

@implementation LLLocation

- (void)requestAuthLocation {
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (!self.didGot) {
        self.didGot = YES;
        CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
        BOOL unknown = NO;
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
                unknown = YES;
                break;
            default:
                NSLog(@"unknown");
                break;
        }
        if (unknown) {
            return;
        }
        if (self.resultBlock) {
            self.resultBlock(NO);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"locations: %@", locations);
    
    CLLocation *currLocation = [locations lastObject];
    NSString * latitude = StrFormat(@"%f", currLocation.coordinate.latitude);
    NSString * longitude = StrFormat(@"%f", currLocation.coordinate.longitude);
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            if (self.resultBlock) {
                self.resultBlock(NO);
            }
            return;
        }
        if (placemarks.count > 0) {
            CLPlacemark *place = placemarks[0];
            NSDictionary *info = place.addressDictionary;
            NSString *province = info[@"Province"];
            NSString *locality = info[@"City"];
            NSString *street = info[@"Street"];
            NSString *code = info[@"CountryCode"];
            NSString *subLocality = info[@"SubLocality"];
            NSString *country = info[@"Country"];
            
            NSDictionary *dic = @{@"latitude":NotNull(latitude), @"longitude":NotNull(longitude), @"province":NotNull(province), @"locality":NotNull(locality), @"street":NotNull(street), @"code":NotNull(code), @"subLocality":NotNull(subLocality), @"country":NotNull(country)};
            App.status.loctionDic = dic;
            if (!self.didGot) {
                self.didGot = YES;
                if (self.resultBlock) {
                    self.resultBlock(YES);
                }
            }
        }
    }];
    [self.locationManager stopUpdatingLocation];
}

@end
