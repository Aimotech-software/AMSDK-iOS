//
//  QYLocationManager.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2023/11/28.
//  Copyright © 2023 pengbi. All rights reserved.
//

#import "QYLocationManager.h"
#import <CoreLocation/CoreLocation.h>
@interface QYLocationManager()
<CLLocationManagerDelegate
>
@end

@implementation QYLocationManager
- (void)requestLocation {
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    [manager requestLocation];
    [manager requestAlwaysAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"定位回调成功");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位报错");
}

@end
