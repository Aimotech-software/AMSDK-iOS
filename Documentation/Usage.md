* [Introduction](#introduction)
* [Initialize the Printer Instance](#initialize-the-printer-instance)
* [Scan BLE Printer](#scan-ble-printer)
* [Connect BLE Printer](#connect-ble-printer)
* [Print Images](#print-images)
* [OTA Upgrade](#ota-upgrade)
* [Wifi Connection](#wifi-connection)
    - [Config Wifi](#config-wifi)
    - [Connect Wifi](#connect-wifi)
* [Other](#other)
    - [Handle Exceptional/Error States](#handle-exceptional-states)


# Using Alamofire

## Introduction
The AMSDK-iOS provides functions such as BLE scanning, connection, and printing. (Some devices also support functions like WiFi network configuration, connection, and printing. Whether a specific model of the device supports these functions or not, the SDK offers the corresponding query capabilities. You can also contact the staff of AIMO Inc. to confirm.)


## Initialize the Printer Instance
Initialization requires passing two variables, AppKey and AppToken, which are provided to developers by AiMO's business team. During the initialization process, we will use these two variables to request the corresponding configuration information. This configuration information includes details about the devices that the developer can connect to. Therefore, devices not included in this configuration will not trigger callbacks during the scanning process.
```swift
[[QYPrinter sharedInstall]registerWithAppKey:@"xxxxxx" appToken:@"xxxxxx"];
```


## Scan BLE Printer

The AIMOSDK currently only supports scanning for BLE (Bluetooth Low Energy) devices and does not yet support classic Bluetooth. When calling the scan method, it will return a list of QYBLEDevice objects, which will later be used to complete the connection and printing operations.
```swift
- (void)scanPrinterWithTimeout:(int)timeout
         additionalDeviceNames:(NSArray*)additionalDeviceNames
                   compoletion:(void (^_Nullable)( NSArray<QYBLEDevice *> * _Nullable , NSError * _Nullable))completion;
```
Note that our callback targets are filtered—we do not callback all BLE devices. If additionalDeviceNames is null, we will callback the registered devices. If specific Bluetooth names are provided, we will also callback QYBLEDevice, though this object only contains basic information. Generally, passing null for additionalDeviceNames is sufficient.

Stop scan:
```swift
- (void)stopScan;
```


## Connect BLE Printer

To connect to a Bluetooth device, you need to use the QYBLEDevice object returned from the scan. This object encapsulates the peripheral device provided by the iOS system, and the AIMO SDK will handle all callback logic related to the peripheral.
Once the connection is established, QYPrinter will hold a Channel object and can initiate the printing process.
```swift
- (void)connectPrinterWithDevice:(QYBLEDevice *_Nonnull)device
                      completion:(void(^_Nullable)(BOOL isSuccess,NSError * _Nullable error))completion;
```

Disconnect device
```swift
- (void)disConnectPrinter:(void(^_Nullable)(BOOL isSuccess,BOOL isBLE))completion;
```


## Print Images 

First, it is necessary to input image content, and multiple images can be passed at once. Then, parameters need to be provided, some of which have default values, while others are mandatory, such as paper type, print density, paper width and length, etc. (Different printers may vary slightly, and it is unclear which parameters are mandatory. You may contact AIMO Inc. for clarification.)

During the execution of the method, the images will first be processed to the appropriate size based on the parameters. Then, the images will be encoded, combined with the print parameters, and added to the print queue. Finally, the queue will be consumed sequentially to print the data.

```swift
- (void)printImages:(NSArray<UIImage*> * _Nonnull)images
             params:(QYPrintParams* _Nonnull)params
           progress:(void(^_Nullable)(int totoal,int current))progress
         completion:(void(^_Nullable)(BOOL isSuccess,float height,NSError * _Nullable error))completion;
```

Cancel Print: 
The data that has not yet been consumed (processed) can be canceled from printing.

```swift
- (void)cancelPrint;
```

## OTA Upgrade 
During OTA (Over-The-Air) updates, a compressed package is sent to the printer. After AIMO SDK and the printer verify the file, a success callback is triggered. However, this only indicates that the firmware has received the OTA file. The user must reboot the printer for the upgrade to take full effect.

```swift
- (void)updateFirmware:(NSString * _Nullable)zipFilePath
            completion:(void(^_Nullable)(QYUpdateFirmwareResult result,NSError *_Nullable error))completion;
```

Cancel upgrade:

```swift
- (void)cancelUpdateFirmware;
```


##  Wifi Connection 
Some devices support Wi-Fi connection. If the machine you are developing does not have the capability of Wi-Fi, there is no need for you to read this part of the content.

### Scan Wifi
The AIMO SDK sends a command to the printer to scan for available Wi-Fi networks. If successful, it returns a list of Wi-Fi names (SSIDs).

```swift
- (void)scanWifi:(void(^_Nullable)(NSArray<WifiInfo *> * _Nullable wifiArray))completion;
```

###  Config Wifi

To establish a connection:
* The Wi-Fi name (SSID) and password must match.
* Upon successful connection, the SDK will callback with the printer's IP address

```swift
- (void)setupNetwork:(NSString * _Nonnull)wifiName
            password:(NSString * _Nonnull)password
          completion:(void(^_Nonnull)(NSString * _Nullable ip, NSError * _Nullable error))completion;
```
Note: An IP address like 0.0.0.0 is not a valid address.


### Connect Wifi
```swift
- (void)connectWifiWithIp:(NSString * _Nonnull)ip
                modelName:(NSString * _Nonnull)modelName
               completion:(void(^_Nullable)(BOOL isSuccess, NSError * _Nullable error))completion;
```


## Other

### Handle Exceptional States
Monitor the printer's exception/error state callbacks and notify users or trigger other logical handling when appropriate.
(For example, when the battery level is low, remind the user to charge the device.)

```swift
- (void)addExceptionBlock:(void(^_Nonnull)(QYActiveInstructionType exception))compltetion;
```
The definition of abnormal/exception states includes the following:
```swift
typedef NS_ENUM(NSInteger,QYActiveInstructionType){
    QYActiveInstructionType_OutOfPaper = 1,    // Paper out
    QYActiveInstructionType_IntoPaper,     // Paper loaded
    QYActiveInstructionType_CoverOpen,     // Cover opened
    QYActiveInstructionType_CoverClose,     // Cover closed
    QYActiveInstructionType_TempWarning,            // Print head temperature warning
    QYActiveInstructionType_RemoveTempWarning,      // Print head temperature warning cleared
    QYActiveInstructionType_LowPower_10,      // Battery below 10%
    QYActiveInstructionType_LowPower_5,       // Battery below 5%
    QYActiveInstructionType_LowPower_WillShutDown, // Will shutdown soon
    QYActiveInstructionType_RFIDException,   // RFID exception
    QYActiveInstructionType_LowPower,        // Dry battery low power
    QYActiveInstructionType_CancelPrint,     // Print canceled
    QYActiveInstructionType_Disconnect,       // Printer disconnected
    
    /** Cutter pressed - Exclusive to P1000 */
    QYActiveInstructionType_CutePress,
    QYActiveInstructionType_CuteLossen,
    
    QYActiveInstructionType_TTFError, // Ribbon exception
    QYActiveInstructionType_OutTTF, // Ribbon exhausted
    QYActiveInstructionType_PaperError, // Paper exception
    QYActiveInstructionType_PaperInsufficient, // Insufficient paper remaining
    QYActiveInstructionType_TapeError,   // Tape error
    QYActiveInstructionType_OutOffTape,  // Insufficient tape
};
```
