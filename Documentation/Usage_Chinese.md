

* [简介](#简介)
* [初始化打印机实例](#初始化打印机实例)
* [扫描蓝牙低功耗（BLE）打印机](#扫描蓝牙低功耗ble打印机)
* [连接蓝牙低功耗（BLE）打印机](#连接蓝牙低功耗ble打印机)
* [打印图像](#打印图像)
* [无线（OTA）升级](#无线ota升级)
* [Wi-Fi 连接](#wi-fi-连接)
    - [配置 Wi-Fi](#配置-wi-fi)
    - [连接 Wi-Fi](#连接-wi-fi)
* [其他](#其他)
    - [处理异常状态](#处理异常状态)

# 使用  AIMOSDK
## 简介
AMSDK-iOS 提供了诸如蓝牙低功耗（BLE）扫描、连接以及打印等功能。（部分设备还支持像 Wi-Fi 网络配置、连接和打印等功能。特定型号的设备是否支持这些功能，SDK 提供了相应的查询能力。你也可以联系 AIMO 公司的工作人员进行确认。）

## 初始化打印机实例
初始化需传入两个变量：SecretKey和Env，其中SecretKey由AiMO商务团队提供给开发者。在初始化过程中，我们将使用这两个变量请求对应的配置信息。该配置信息包含开发者可连接设备的相关详情，因此未包含在此配置中的设备在扫描过程中将不会触发回调。
变量Env表示您需要请求的域名环境：
* 若请求非中国地区服务，请使用 QYEnv_Production_Global
* 若请求中国地区服务，请使用 QYEnv_Production_Chinese
```swift
[[QYPrinter sharedInstall]registerWithAppKey:@"xxxxxx" env:env_];
```

## 扫描蓝牙低功耗（BLE）打印机
AIMOSDK 当前仅支持扫描蓝牙低功耗（BLE）设备，尚不支持经典蓝牙设备。调用扫描方法时，它将返回一个 QYBLEDevice 对象列表，后续可用于完成连接和打印操作。
```swift
- (void)scanPrinterWithTimeout:(int)timeout
         additionalDeviceNames:(NSArray*)additionalDeviceNames
                   compoletion:(void (^_Nullable)( NSArray<QYBLEDevice *> * _Nullable , NSError * _Nullable))completion;
```
请注意，我们的回调目标是经过筛选的——并非所有的 BLE 设备都会触发回调。如果 `additionalDeviceNames` 为 null，我们将对已注册的设备进行回调。如果提供了特定的蓝牙名称，我们也会对 QYBLEDevice 进行回调，不过这个对象仅包含基本信息。一般来说，将 `additionalDeviceNames` 设为 null 就足够了。

停止扫描：
```swift
- (void)stopScan;
```

## 连接蓝牙低功耗（BLE）打印机
要连接蓝牙设备，你需要使用扫描返回的 QYBLEDevice 对象。该对象封装了 iOS 系统提供的外设设备，并且 AIMO SDK 将处理与该外设相关的所有回调逻辑。
一旦建立连接，QYPrinter 将持有一个 Channel 对象，并可以启动打印过程。
```swift
- (void)connectPrinterWithDevice:(QYBLEDevice *_Nonnull)device
                      completion:(void(^_Nullable)(BOOL isSuccess,NSError * _Nullable error))completion;
```

断开设备连接：
```swift
- (void)disConnectPrinter:(void(^_Nullable)(BOOL isSuccess,BOOL isBLE))completion;
```

## 打印图像
首先，需要输入图像内容，并且可以一次传入多个图像。然后，需要提供参数，其中一些参数有默认值，而另一些是必填的，例如纸张类型、打印密度、纸张宽度和长度等。（不同的打印机可能会略有差异，并且不清楚哪些参数是必填的。你可以联系 AIMO 公司进行澄清。）

在方法执行过程中，图像将首先根据参数处理为合适的尺寸。然后，图像将被编码，与打印参数相结合，并添加到打印队列中。最后，队列将被依次处理以打印数据。

```swift
- (void)printImages:(NSArray<UIImage*> * _Nonnull)images
             params:(QYPrintParams* _Nonnull)params
           progress:(void(^_Nullable)(int totoal,int current))progress
         completion:(void(^_Nullable)(BOOL isSuccess,float height,NSError * _Nullable error))completion;
```

取消打印：
尚未处理（已处理的不能取消）的数据可以取消打印。

```swift
- (void)cancelPrint;
```

## 无线（OTA）升级
在无线（OTA）更新期间，会向打印机发送一个压缩包。AIMO SDK 和打印机验证文件后，将触发成功回调。然而，这仅表示固件已接收到 OTA 文件。用户必须重启打印机才能使升级完全生效。

```swift
- (void)updateFirmware:(NSString * _Nullable)zipFilePath
            completion:(void(^_Nullable)(QYUpdateFirmwareResult result,NSError *_Nullable error))completion;
```

取消升级：

```swift
- (void)cancelUpdateFirmware;
```

## Wi-Fi 连接
部分设备支持 Wi-Fi 连接。如果您正在开发的设备不具备 Wi-Fi 功能，则无需阅读此部分内容。

### 扫描 Wi-Fi
AIMO SDK 会向打印机发送命令以扫描可用的 Wi-Fi 网络。如果成功，它将返回一个 Wi-Fi 名称（SSID）列表。

```swift
- (void)scanWifi:(void(^_Nullable)(NSArray<WifiInfo *> * _Nullable wifiArray))completion;
```

### 配置 Wi-Fi
要建立连接：
* Wi-Fi 名称（SSID）和密码必须匹配。
* 连接成功后，SDK 将通过回调返回打印机的 IP 地址

```swift
- (void)setupNetwork:(NSString * _Nonnull)wifiName
            password:(NSString * _Nonnull)password
          completion:(void(^_Nonnull)(NSString * _Nullable ip, NSError * _Nullable error))completion;
```
注意：像 0.0.0.0 这样的 IP 地址是无效地址。

### 连接 Wi-Fi
```swift
- (void)connectWifiWithIp:(NSString * _Nonnull)ip
                modelName:(NSString * _Nonnull)modelName
               completion:(void(^_Nullable)(BOOL isSuccess, NSError * _Nullable error))completion;
```

## 其他

### 处理异常状态
监控打印机的异常/错误状态回调，并在适当时通知用户或触发其他逻辑处理。
（例如，当电量低时，提醒用户给设备充电。）

```swift
- (void)addExceptionBlock:(void(^_Nonnull)(QYActiveInstructionType exception))compltetion;
```
异常/错误状态的定义包括以下内容：
```swift
typedef NS_ENUM(NSInteger,QYActiveInstructionType){
    QYActiveInstructionType_OutOfPaper = 1,    // 缺纸
    QYActiveInstructionType_IntoPaper,     // 装入纸张
    QYActiveInstructionType_CoverOpen,     // 盖子打开
    QYActiveInstructionType_CoverClose,     // 盖子关闭
    QYActiveInstructionType_TempWarning,            // 打印头温度警告
    QYActiveInstructionType_RemoveTempWarning,      // 打印头温度警告解除
    QYActiveInstructionType_LowPower_10,      // 电量低于 10%
    QYActiveInstructionType_LowPower_5,       // 电量低于 5%
    QYActiveInstructionType_LowPower_WillShutDown, // 即将关机
    QYActiveInstructionType_RFIDException,   // RFID 异常
    QYActiveInstructionType_LowPower,        // 干电池电量低
    QYActiveInstructionType_CancelPrint,     // 打印取消
    QYActiveInstructionType_Disconnect,       // 打印机断开连接
    
    /** 切刀按下 - P1000 专属 */
    QYActiveInstructionType_CutePress,
    QYActiveInstructionType_CuteLossen,
    
    QYActiveInstructionType_TTFError, // 色带异常
    QYActiveInstructionType_OutTTF, // 色带用尽
    QYActiveInstructionType_PaperError, // 纸张异常
    QYActiveInstructionType_PaperInsufficient, // 剩余纸张不足
    QYActiveInstructionType_TapeError,   // 胶带错误
    QYActiveInstructionType_OutOffTape,  // 胶带不足
};
``` 
