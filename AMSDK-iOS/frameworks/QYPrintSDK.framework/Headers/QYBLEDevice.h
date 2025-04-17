//
//  QYBLEDevice.h
//  QYPrintSDK
//
//  Created by aimo on 2023/11/28.
//

#import <Foundation/Foundation.h>
#import "QYConstants.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "QYDeviceConfigurationItem.h"



NS_ASSUME_NONNULL_BEGIN


/// 表示连接前，手机扫描到的设备信息，区别于 QYPrinterInfo
@interface QYBLEDevice : NSObject<
QYDeviceConfigurationItem,
NSCopying
>
/**蓝牙外设*/
@property(nonatomic, strong,readonly) CBPeripheral *peripheral;


/**外设mac地址*/
@property(nonatomic, copy) NSString *mac;


/**外设是否已连接*/
@property(nonatomic, assign) BOOL isConnected;




//蓝牙名字
@property(nonatomic, strong,readonly)NSString *bluetoothName;


/// 是否内部设备
///  没有型号名字说明没有被匹配，是外部过滤的设备
@property(nonatomic, assign,readonly)BOOL  isInternalDevice;

/// 是否支持查询
/// - Parameter type: 查询的指令，譬如说电量
- (BOOL)isSupportedQueryWithInstructionType:(QYQueryInstructionType)type;

- (BOOL)isSupportedQueryWithInstructionType_:(NSNumber*)type;



/// 根据外设创建对象
/// - Parameters:
///   - peripheral: 外设对象
///   - bluetoothName: 蓝牙名字
///   - mac: mac地址
///   - configItem: 配置信息
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral
                     bluetoothName:(NSString*)bluetoothName
                               mac:(NSString *)mac
                        configItem:(nullable id<QYDeviceConfigurationItem>  )configItem;








/// 计算关机时间
///  0,表示不自动关机，其他值表示关机时间- 单位分钟
/// - Parameter value: 查询到的值
- (int)offTimeWithValue:(int)value;


/// 从分钟换算到有效的值
///  0 表示 不自动关机
/// - Parameter minute: 分钟数
- (void)valueForMinute:(int)minute block:(void (^)(BOOL valid,int ret))block;



///// 是否支持该纸张类型
///// - Parameter paperType: 纸张类型
//- (BOOL)isSupportWithPaperType:(QYPaperType)paperType;


/// 是否支持该色阶
/// - Parameter colorScale: 色阶
- (BOOL)isSupportWithColorScale:(QYColorScale)colorScale;


/// 是否支持该浓度档位置
/// - Parameter con:浓度档位
- (BOOL)isSupportWithCon:(int)con;


/// 每毫米的点数
- (float)floatDotFormm;

@end

NS_ASSUME_NONNULL_END
