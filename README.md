![AIMOSDK](https://raw.githubusercontent.com/Aimotech-software/AMSDK-iOS/master/AIMOSDKLogo.png)

AIMO SDK, developed by Aimo Inc, is a software development kit for printers. It offers convenient interfaces for developers to easily implement various printing functions and meet diverse needs. 

- [Features](#features)
- [Requirements](#requirements)
  + [Dependency](#dependency)
- [Installation](#installation)
- [List of Mobile SDK Supported Models](#list-of-mobile-sdk-supported-models)
- [Usage](https://github.com/Aimotech-software/AMSDK-iOS/blob/master/Documentation/Usage.md)
- [FAQ](#faq)
- [Credits](#credits)
- [Donations](#donations)
- [License](#license)

## Features

- [x] Scan Device with BLE
- [x] Connect Device with BLE 
- [x] Configure the Wi-Fi network
- [x] Connect Device with  WiFI
- [x] Print Images
- [x] Upgrade OTA 

## Requirements

| Platform                                             | Minimun XCode Version | Installation                                                                                                         
| ---------------------------------------------------- | --------------------- | -------------------------------------------------------------------------------------------------------------------- 
| iOS 10.0+ /                                          | Xcode 16.0            | [CocoaPods](#cocoapods)


### Dependency

We use OpenCV to crop or scale images. Currently, the version of OpenCV we depend on is shown in the following figure.

| AIMO SDK Version                                     | OpenCV Version 
| ---------------------------------------------------- | --------------------- 
| 1.0.x                                                | 3.4.6         


### List of Mobile SDK Supported Models

| Serias                                               | Suppported Models  
| ---------------------------------------------------- | --------------------- 
| M Serias                                             | M102      



## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate AIMOSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'AIMOSDK-iOS'
```


## License

[See LICENSE](https://github.com/Aimotech-software/AMSDK-ios/blob/master/LICENSE) for details.
