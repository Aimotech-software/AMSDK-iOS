//
//  LMAPI.h
//  LMAPI
//
//  Created by YFB-CDS on 2020/7/15.
//  Copyright © 2020 YFB-CDS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>
#import "QYPrinterInfo.h"
#import "QYConstants.h"
#import "QYBLEDevice.h"
#import "QYDataChannel.h"
#import "QYPrintParams.h"
#import "QYFilterDevice.h"

typedef NS_ENUM(NSInteger,QYPrintState){
    QYPrintState_Init = 0,     //初始状态
    QYPrintState_Printing, //打印中
    QYPrintState_Canceled, //打印取消
};

typedef NS_ENUM(NSInteger,QYUpdateFirmwareState){
    QYUpdateFirmwareState_Init = 0,     //初始状态
    QYUpdateFirmwareState_Updating, //固件更新中
    QYUpdateFirmwareState_Cancelled, //固件更新取消
};

#pragma mark 打印机Wifi模块扫描的Wifi信息
@interface WifiInfo : NSObject
/**Wifi信号量**/
@property(nonatomic, assign) int rssi;
/**Wifi名称**/
@property(nonatomic, copy) NSString *name;
@end



@interface QYPrinter : NSObject


#pragma mark 是否开启调试日志
/**
 * @brief 是否开启调试日志
 * @param open true or false
 */
+ (void)setLogStatus:(BOOL)open;



/// 单例
+ (instancetype)sharedInstance;

# pragma mark 打印机搜索，连接

/**
 * @brief 蓝牙状态变更回调（iOS默认蓝牙都是 BLE）
 * @param completion 蓝牙状态回调闭包，蓝牙状态更新时也会回调
 */
- (void)setUpBLEStatusCallback:(void(^)(BLEStatus state))completion;



/// 扫描蓝牙设备
/// @param timeout 超时时间，单位描述，如果是小于等于0 ，则默认是10 s
/// @param completion 完成回调
- (void)scanPrinterWithTimeout:(int)timeout
         additionalDeviceNames:(NSArray*)additionalDeviceNames
                   compoletion:(void (^_Nullable)( NSArray<QYBLEDevice *> * _Nullable , NSError * _Nullable))completion;



/// 扫描蓝牙设备, 无超时版本
/// @param completion 完成回调
- (void)scanPrinterWithAdditionalDeviceNames:(NSArray*_Nullable)additionalDeviceNames
                                 compoletion:(void (^_Nullable)(NSArray<QYBLEDevice *> * _Nullable, NSError * _Nullable))completion;



/**
 @breif 停止扫描
 */
- (void)stopScan;


/// 连接指定的设备，通常是直连的设备
/// @param device 设备,内部会执行一份拷贝的操作,所以最后连接的对象device 不是 这个device 
/// @param completion 完成
- (void)connectPrinterWithDevice:(QYBLEDevice *_Nonnull)device
                      completion:(void(^_Nullable)(BOOL isSuccess,NSError * _Nullable error))completion;





/// 连接通过 mac 地址连接设备
///  需提前调用 scanPrinterWithTimeout 方法，因为设备的连接依赖于已经扫描的设备
/// @param mac 设备的mac地址
/// @param completion 完成
- (void)connectPrinterWithMac:(NSString *_Nullable)mac
                   completion:(void(^_Nullable)(BOOL isSuccess,NSError * _Nullable error))completion;


/// 断开当前连接的打印机
/// @param completion 完成回调
- (void)disConnectPrinter:(void(^_Nullable)(BOOL isSuccess,BOOL isBLE))completion;







/// 获取当前Wifi名字
/// 该方法需要获得定位权限
- (NSString*_Nullable)getWifiName;


/// 系统连接的设备
- (NSArray<QYBLEDevice*> *_Nullable)systemConnectedPeripherals;




/**
 * @brief 扫描WiFi
 * @param completion 回调WifiInfo数组
 */
- (void)scanWifi:(void(^_Nullable)(NSArray<WifiInfo *> * _Nullable wifiArray))completion;



/// 进入配网模式
- (void)openSetupNetModel:(void (^_Nullable)(BOOL success,NSError * _Nullable error))completion;

/**
* @brief 配置打印机连接的Wifi
 该方法在打印机ip地址为0.0.0.0时使用，需配网再建立长连接
 如果手机连接的Wifi与打印机配置的Wifi是同一个，则可以进行局域网打印
* @param wifiName Wifi名称
* @param password Wifi密码
* @param completion 回调是否成功及错误信息，成功会回调配网后的IP
 建议：配网成功后的IP可以根据Mac地址进行缓存，下次可以直接使用以下方法进行建立wifi连接，则无需通过蓝牙连接
 ‘wifiConnect:(NSString *)ip
   completion:(void(^)(BOOL isSuccess, NSError *error))completion
 ’
*/
- (void)setupNetwork:(NSString * _Nonnull)wifiName
            password:(NSString * _Nonnull)password
          completion:(void(^_Nonnull)(NSString * _Nullable ip, NSError * _Nullable error))completion;

/**
 * @brief
 * @param completion 回调是否成功及错误信息
 */



///  通过ip地址连接wifi
///该方法需在打印机ip地址不为0.0.0.0时使用，表示打印机Wifi已配网
/// 如果果手机连接的Wifi ip与打印机Wifi的ip不一致，则表示不在同一个局域网，需切换手机连接的wifi或重新配网
///  如果该型号 校验失败，则会直接回调失败
/// @param ip ip地址
/// @param modelName 型号名字
/// @param completion 回调
- (void)connectWifiWithIp:(NSString * _Nonnull)ip
                modelName:(NSString * _Nonnull)modelName
               completion:(void(^_Nullable)(BOOL isSuccess, NSError * _Nullable error))completion;


#pragma mark 获取打印机、标签信息

/// 查询打印机信息, 将过滤不支持的信息查询
///  考虑到 有些指令必须最后放，不然可能被吃掉，这个逻辑需要 App自行处理
/// 1.大部分的打印机支持所有的信息查询
/// 2.其他的打印机只支持少量的查询，譬如TSPL的机器不支持电量查询
/// 3.回调一个 map，key 是之前查询的指令枚举 value 是对应的值,
///     3 .1如果是超时或者其他查询情况会回调一个 NSError 对象
///     3.2
/// 3.回调是最有一个的时候，@"last" : YES 
/// @param instructions ,需参考 QYDeviceInstructionType  中的定义。
/// @param timeout 如果查询的数据，有任意一条没正常 返回，会回调一个正常的值
/// @param completion 回调
- (void)queryPrinterInfoWithInstructions:(NSArray*_Nonnull)instructions
                                 timeout:(int)timeout
                              completion:(void(^_Nullable)(NSDictionary * _Nullable printInfo,NSError * _Nullable error))completion;

/**
 * @brief 获取当前连接的打印机信息
 */
- (QYPrinterInfo *_Nullable)connectedPrinterInfo;


/**
 * @brief 打印机是否连接
 * 如下发打印/固件升级数据，需要先判断打印机是否已经连接
 * 可能存在断开蓝牙，或者打印机关机导致的打印机
 */
- (BOOL)printerIsConnect;

#pragma mark 设置打印机信息

/**
 * @brief 设置纸张类型（临时修改，本次打印生效）
 * 如果打印机不支持设置的纸张类型，修改为间隙纸
 * @param parperType 纸张类型
 */
- (void)setPrintParperType:(QYPaperType)parperType;

/**
 * @brief 设置打印浓度（临时修改，本次打印生效）
 * 值范围为0-15，如果小于0，则设置为0，大于15则设置为15
 * 值为0的时候，跟随打印机
 * @param concentration 浓度
 */
- (void)setPrintConcentration:(int)concentration;

/**
 * @brief 设置打印速度（临时修改，本次打印生效）
 * 值范围为0-5，如果小于0则设置为0，大于5则设置为5
 * 值为0的时候，跟随打印机
 * @param speed 速度
 */
- (void)setPrintSpeed:(int)speed;

/**
 * @brief 设置自动关机时间（设置1为5分钟，2为10分钟，依次类推）
 * 值范围0-255，如果小于0则设置为0，大于255则设置为255
 * @param time 时间
 */


/// 设置关机时间，按照配置文件，存在两种设置方式，请留意
///  单位分钟数
/// @param time 分钟数
- (void)setAutoShutdownTime:(int)time;


/// 设置远程host
/// @param remoteHost host
- (void)setRemoteHost:(NSString*_Nonnull)remoteHost;

/**
* @brief 设置打印浓度（永久修改，不建议频繁使用，会损坏打印机寿命）
* 值范围为0-15，如果小于0，则设置为0，大于15则设置为15
* 值为0的时候，跟随打印机
* @param concentration 浓度
*/
- (void)setPrintConcentrationForever:(int)concentration;

/**
* @brief 设置打印速度（永久修改，不建议频繁使用，会损坏打印机寿命）
* 值范围为0-5，如果小于0则设置为0，大于5则设置为5
* 值为0的时候，跟随打印机
* @param speed 速度
*/
- (void)setPrintSpeedForever:(int)speed;

/**
 * @brief 打印设备信息，即打印自检页
 */
- (void)printDeviceInfo;
#pragma mark 打印

/// 打印图片
/// @param images 打印图片
/// @param params 任意一张的打印参数
/// @param progress 总的张数，和当前完成的张数
/// @param completion 回调 height 表示打印高度，单位毫米
- (void)printImages:(NSArray<UIImage*> * _Nonnull)images
             params:(QYPrintParams* _Nonnull)params
           progress:(void(^_Nullable)(int totoal,int current))progress
         completion:(void(^_Nullable)(BOOL isSuccess,float height,NSError * _Nullable error))completion;


/// 生成打印数据
/// @param image 打印图片
/// @param params 打印参数
/// @param completion 回调 
- (void)handleImages:(NSArray<UIImage *> *_Nonnull)images
             params:(QYPrintParams * _Nonnull)params
          completion:(void (^)(BOOL,NSError*_Nullable,NSArray<NSData*>*_Nullable))completion;




/// 按照当前连接
/// @param image <#image description#>
- (CGFloat)imageHeightWithImage:(UIImage*_Nonnull)image;


/**
 * @brief 取消打印
 */
- (void)cancelPrint;

#pragma mark 固件升级
/**
 * @brief 固件升级
 * @param zipFilePath 固件zip包路径
 * @param completion 返回闭包，固件升级是否成功
 */
- (void)updateFirmware:(NSString * _Nullable)zipFilePath
            completion:(void(^_Nullable)(QYUpdateFirmwareResult result,NSError *_Nullable error))completion;



/// 发送固件升级
/// @param data 固件升级二进制
/// @param completion 升级是否成功
- (void)sendFirmwareData:(NSData* _Nonnull)data;

/**
 * @brief 取消固件升级
 */
- (void)cancelUpdateFirmware;



/// 添加异常的回调处理
/// @param compltetion 异常回调方法
- (void)addExceptionBlock:(void(^_Nonnull)(QYActiveInstructionType exception))compltetion;


/// 当前连接的设备信息
@property(nonatomic, strong,readonly)QYPrinterInfo  * _Nullable connectedPrinterInfo;

/// 当前的连接状态
@property(nonatomic,readonly)QYPrinterConnectedState connectedState;


/// 是否打印中的状态
@property(nonatomic, assign, readonly)BOOL isPrinting;

/// 正在更新固件
@property(nonatomic, assign, readonly)BOOL isUpdatingFirmware;
@end
