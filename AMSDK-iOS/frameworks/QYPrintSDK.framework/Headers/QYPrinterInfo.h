//
//  QYPrinterInfo.h
//  QYPrintSDK
//
//  Created by aimo on 2023/11/27.
//

#import <Foundation/Foundation.h>
#import "QYConstants.h"
#import "QYBLEDevice.h"
NS_ASSUME_NONNULL_BEGIN


@interface QYRFIDInfo : NSObject
/**耗材的背景色*/
@property(nonatomic, strong)NSString *rfidBackgroundColor;

/**耗材碳带的内容色*/
@property(nonatomic, strong)NSString *rfidContentColor;

/**覆膜类型*/
@property(nonatomic, assign)QYCoveringMembraneType coveringMembraneType;

/// RFID 纸张类型
@property(nonatomic, assign)QYPaperType rfidPaperType;

/// RFID 纸张宽度 单位是 mm
/// 0 表示连续纸
@property(nonatomic, assign)int rfidPaperWidth;

/// RFID 纸张长度 ，单位是 mm
/// 0 表示无效值
@property(nonatomic, assign)int rfidPaperLength;

/**RFID材料类型*/
@property(nonatomic, assign) QYRFIDMaterialType matrialType;

/**RFID标签碳带序列号*/
@property(nonatomic, strong) NSString *rfidSerialNumber;
@end

@interface QYRFIDOverLengthInfo : NSObject
/**RFID材料类型*/
@property(nonatomic, assign) QYRFIDMaterialType matrialType;
@property(nonatomic, assign) int overLength;
@end

/// 打印机对象，描述是连接后设备的信息
/// 只读的属性，表示拿到设备类型之后都已经确定的信息
@interface QYPrinterInfo : NSObject


/// 是否已经支持配置的参数下发，以及指令
@property(assign,nonatomic)BOOL isSupportedNewInstruction;

/// 设备信息
@property(nonatomic, strong,readonly)QYBLEDevice *device;

/**是否缺纸，YES为缺纸*/
@property(nonatomic, assign) BOOL outofPaper;

/**纸张类型*/
@property(nonatomic, assign) QYPaperType paperType;

/**连续纸间隔*/
@property(nonatomic, assign) int offset;



///SN
@property(nonatomic, strong,readonly)NSString *sn;

/**设备固件版本号*/
@property(nonatomic, copy) NSString *firmwareVersion;

/**设备硬件版本号*/
@property(nonatomic, copy) NSString *hardwareVersion;

/**通讯版本号*/
@property(nonatomic, copy) NSString *communicateVersion;

/**打印头温度*/
@property(nonatomic, assign) int printHeadTemp;


/**是否开盖状态*/
@property(nonatomic) BOOL coverIsOpen;

/**切刀是否按下*/
@property(nonatomic) BOOL cuteIsPress;

/**远程域名*/
@property(nonatomic,strong)NSString *remoteDomain;


@property(assign)QYBLEType bleType;


@property(nonatomic, assign)BOOL  is6951Chip;


/**设备剩余电量，百分比
 如返回50，则剩余电量为50%
 */
@property(nonatomic, assign) int remainingBattery;

/**设备自动关机时间，单位分钟
 如返回5，则自动关机时间为5分钟
 如果返回值为10000，则不自动关机
 */
@property(nonatomic, assign) int shutdownTime;

/**是否处于高温警告
 */
@property(nonatomic, assign) BOOL isTempWarning;
/** 打印机当前打印浓度
 注意：仅B246D有浓度
 返回值：1-15
 其他打印机无打印浓度，返回0
 */
@property(nonatomic, assign) int concentration;
/** 打印机当前打印速度
 注意：仅B246D有速度
 返回值：1-5
 其他打印机无打印速度，返回0
 */
@property(nonatomic, assign) int speed;

/**
 对于一台机器来说可能存在的RFID 存在三种情况：
 纸张 、 纸张 + 碳带、 碳带 、 色带 这四种情况
 */
/// rfid 信息列表
@property(nonatomic, strong)NSMutableArray<QYRFIDInfo*> *_Nullable rfidInfoList;


/// rfid 余量的列表
@property(nonatomic, strong)NSMutableArray<QYRFIDOverLengthInfo*> * _Nullable rfidOverLengthInfoList;

///rfid 查询的错误列表
@property(nonatomic, strong)NSMutableArray<NSNumber*> * _Nullable rfidErrorList;

/**
B 246D 设备的设置信息
 */
@property(nonatomic, strong) NSArray *  _Nullable tsplSettingInfo;
/**
是否低版本 （即低于 6.0版本的 tspl）
 */
@property(nonatomic, assign) BOOL lowerTspl;


/// 碳带状态异常(错误)
@property(nonatomic, assign)QYRibbonState  ribbonState;

/// wifi名字
@property(nonatomic, strong)NSString*  wifiName;

/// ip
@property(nonatomic, strong)NSString*  ip;


/// 初始化
/// - Parameters:
///   - device: 设备
///   - sn: sn
- (instancetype)initWithDevice:(QYBLEDevice* _Nonnull)device sn:(NSString* _Nonnull)sn;



///  同一耗材类型只存一份数据
///  如果存在就已经替换掉老的
/// - Parameter info: RFID信息
- (void)updateRfidInfo:(QYRFIDInfo*)info;

///  同一耗材类型只存一份数据
///  如果存在就已经替换掉老的
/// - Parameter rfidOverLengthInfo: 余量信息
- (void)updateRfidOverlengthInfo:(QYRFIDOverLengthInfo*)rfidOverLengthInfo;

///  同一耗材类型只存一份数据
///  如果存在就已经替换掉老的
/// - Parameter errorType: 错误类型
- (void)updateErrorList:(NSNumber*)errorType;


/// 碳带序列号
- (NSString*)ttfNumber;


/// 纸张序列号
- (NSString*)paperNumber;

/// 色带序列号
- (NSString*)tapeNumber;


/// 碳带余量
- (int)ttfOverLength;


/// 纸张余量
- (int)paperOverLength;

/// 色带余量
- (int)tapeOverLength;


/// 覆膜类型
- (QYCoveringMembraneType)coveringMembraneType;


/// 用于查询到Sn后敷值到这个设备
/// - Parameter sn: sn
- (void)attachSn:(NSString*)sn;



/// 是否支持固件升级
- (BOOL)isSupportedUpdateFirmware;


/// 支持的查询的耗材类型
- (NSArray<NSNumber *> *)supportedMaterialIndentify;
@end

NS_ASSUME_NONNULL_END
