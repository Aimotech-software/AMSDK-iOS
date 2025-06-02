![AIMOSDK](https://raw.githubusercontent.com/Aimotech-software/AMSDK-iOS/master/AIMOSDKLogo.png)

英文(./README.md) | 中文

AIMO SDK 由 Aimo 公司开发，是一款用于打印机的软件开发工具包。它为开发者提供了便捷的接口，使其能够轻松实现各种打印功能并满足多样化需求。

- [功能特性](#功能特性)
- [要求](#要求)
  + [依赖项](#依赖项)
- [安装](#安装)
- [移动 SDK 支持的型号列表](#移动-sdk-支持的型号列表)
- [使用方法](https://github.com/Aimotech-software/AMSDK-iOS/blob/master/Documentation/Usage.md)
- [常见问题](#常见问题)
- [许可证](#许可证)

## 功能特性

- [x] 通过蓝牙低功耗（BLE）扫描设备
- [x] 通过蓝牙低功耗（BLE）连接设备
- [x] 配置 Wi-Fi 网络
- [x] 通过 Wi-Fi 连接设备
- [x] 打印图像
- [x] 无线（OTA）升级

## 要求

| 平台                                             | 最低 XCode 版本 | 安装方式                                                                                                         
| ---------------------------------------------------- | --------------------- | -------------------------------------------------------------------------------------------------------------------- 
| iOS 10.0 及以上                                            | Xcode 15.0            | [CocoaPods](#cocoapods)


### 依赖项

我们使用 OpenCV 来裁剪或缩放图像。目前我们依赖的 OpenCV 版本如下表所示。

| AIMO SDK 版本                                     | OpenCV 版本 
| ---------------------------------------------------- | --------------------- 
| 1.0.x                                                | 3.4.6         


### 移动 SDK 支持的型号列表

| 系列                                               | 支持的型号  
| ---------------------------------------------------- | --------------------- 
| M 系列                                             | M102      



## 安装

### CocoaPods

[CocoaPods](https://cocoapods.org) 是用于 Cocoa 项目的依赖项管理器。有关使用和安装说明，请访问其网站。要使用 CocoaPods 将 AIMOSDK 集成到您的 Xcode 项目中，请在您的 `Podfile` 中指定：

```ruby
pod 'AIMOSDK-iOS'
```

## 常见问题
以下是我们目前针对移动 SDK 常见问题的解答。在您通过电子邮件向我们提问之前，请先查看以下内容。
### 本网站上的 SDK 是否免费提供？
是的，从 GitHub 和 CocoaPods 获得的 SDK 是免费的。但是，您无法直接扫描和连接 AIMO 打印机。您必须联系 AIMO 公司的工作人员获取相应的令牌和密钥，才能正确使用该 SDK。

## 许可证

有关详细信息，请查看 [许可证](https://github.com/Aimotech-software/AMSDK-ios/blob/master/LICENSE)。
