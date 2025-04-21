//
//  QYDataChannel.h
//  Pods
//
//  Created by aimo on 2023/11/9.
//

#ifndef QYDataChannel_h
#define QYDataChannel_h
#import "QYPrinterInfo.h"
#import "QYBLEDevice.h"
#import "QYPrintParams.h"
@class QYPrintAction;
@protocol QYGeneralOrderParserDelegate;
/**打印机状态回调*/
typedef void(^QYPrinterStateCallback)(QYActiveInstructionType response);

@protocol QYDataChannel <NSObject>


/// 打印机状态回调
@property(nonatomic, strong)QYPrinterStateCallback _Nullable stateCallback;

/// 连接的打印机信息
@property(nonatomic,strong)QYPrinterInfo *_Nullable connectedPrinterInfo;


@property(nonatomic, weak)id<QYGeneralOrderParserDelegate> _Nullable parserDelegate;


/// 是否取消打印
@property(assign)BOOL  isCancelledPrint;


- (instancetype _Nonnull )initWithParserDelegate:(id<QYGeneralOrderParserDelegate>_Nonnull)delegate;

/// 断开当前连接的打印机
/// @param completion 回调
- (void)disConnectPrinter:(void(^_Nullable)(BOOL isSuccess))completion;


/**
 * @brief 获取当前连接设备的信息
 * @param completion 打印机信息回调
 */
- (void)queryConnectPrinterInfoWithDevice:( QYBLEDevice * _Nullable )device
                             instructions:(NSArray*)instructions
                               completion:(void(^_Nullable)(QYPrinterInfo * _Nullable))completion;


/**
 * @brief 打印机异常回调
 * @param compltetion 异常类型
 */
- (void)printerActiveCallback:(void(^_Nullable)(QYActiveInstructionType exception))compltetion;




/// 发送一个打印动作
/// @param action 打印动作
/// @param completion 完成回调
- (void)sendPrintAction:(QYPrintAction*  _Nonnull)action
         completion:(void(^_Nonnull)(BOOL isSuccess))completion;


/**
 * @brief 取消打印
 */
- (void)cancelPrint;


/**
 * @brief 打印设备信息，即自检页
 */
- (void)printDeviceInfo;
/**
 * @brief 固件升级
 * @param data 固件升级数据
 * @param completion 是否成功
 */
- (void)sendUpdateFirmware:(NSData *_Nullable)data
                completion:(void(^_Nonnull)(BOOL isSuccess, NSString*  _Nullable crcCode))completion;


/**
 * @brief 取消固件升级
 */
- (void)cancelUpdateFirmware;



/// 设置固件升级确定制定
/// @param data 固件升级确定指令
- (void)sendConfirmFirmWareData:(NSData*_Nonnull)data;



/// 发送任意的数据
/// @param data 数据
- (void)sendData:(NSData* _Nonnull)data;

@end

#endif /* QYDataChannel_h */
