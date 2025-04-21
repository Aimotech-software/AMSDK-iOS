//
//  QYBLEDeviceConfiguration.h
//  QYPrintSDK
//
//  Created by aimo on 2023/11/17.
//

#import <Foundation/Foundation.h>
#import "QYConstants.h"
#import "QYPrinter.h"
NS_ASSUME_NONNULL_BEGIN
/// 包含设备系列，分类，sn关键信息的
///



/// 颜色设备分类的逻辑类
@interface QYBLEDeviceConfiguration : NSObject


/// 加载默认的配置
+ (void)loadDefaultConfiguration;


+ (QYPrinterModel)modelFromString:(NSString*)model;

/// 外部传递的类型配置
/// - Parameter list: 列表
+ (void)addExternalConfigurationList:(NSArray<id<QYDeviceConfigurationItem>>*)list;



/// 更新配置表文件
/// - Parameter dictionary: 配置文件
+ (void)updateConfigDictionary:(NSDictionary*)dictionary;


/// 从外设获得系列,如果是未知类型，表示并不支持
/// - Parameter peripheralName: 蓝牙名字
+ (_Nullable id<QYDeviceConfigurationItem>)configItemFromBleName:(NSString*)bleName;


/// 从外设名字获取型号,表示并不支持
/// - Parameter peripheralName: 外设名字
+ (QYPrinterModel)modelFromBleName:(NSString*)bleName;



/// 获取设备型号
/// - Parameters:
///   - bleName: 蓝牙名字
///   - sn: sn
+ (QYPrinterModel)modelFromBleName:(NSString *)bleName sn:(NSString*)sn;





/// 获取连接方式，分为三种类型 具体看 QYTransmitType
/// - Parameter printerType: 设备型号
+ (QYTransmitType)linkTypeWithPrinterType:(QYPrinterModel)printerType;


/// 是否 wifi 或者 blewifi ，知否支持 wifi 连接
/// - Parameter linkType: 连接类型
+ (BOOL)supportWifiWithLinkType:(QYTransmitType)linkType;


+ (_Nullable id<QYDeviceConfigurationItem>)itemWithModelName:(NSString*)modelName;



/// 毫米转点数
/// - Parameters:
///   - modelName: 型号名字
///   - mm: 毫米
+ (float)mm2dotWithModelName:(NSString*)modelName mm:(float)mm;

/// 点数转毫米数
/// - Parameters:
///   - modelName: 型号名字
///   - dot: 点数
+ (float)dot2mmWithModelName:(NSString*)modelName dot:(float)dot;
@end

NS_ASSUME_NONNULL_END
