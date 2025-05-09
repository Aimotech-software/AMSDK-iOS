//
//  QYFilterDevice.h
//  QYPrintSDK
//
//  Created by aimo on 2024/5/15.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
NS_ASSUME_NONNULL_BEGIN

@interface QYFilterDevice : NSObject
@property(nonatomic, strong)CBPeripheral *peripheral;
@property(nonatomic, strong)NSDictionary<NSString *,id> *advertisementData;
@property(nonatomic, strong)NSNumber *RSSI;
@property(nonatomic, strong)NSString *mac;
@end

NS_ASSUME_NONNULL_END
