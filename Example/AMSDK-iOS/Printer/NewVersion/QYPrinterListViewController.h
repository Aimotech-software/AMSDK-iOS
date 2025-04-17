//
//  QYPrinterListViewController.h
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class  QYBLEDevice;
NS_ASSUME_NONNULL_BEGIN

@interface QYPrinterListViewController : BaseViewController

@property(nonatomic, strong)void (^didClickConnectDevice)(QYBLEDevice* device);
@end

NS_ASSUME_NONNULL_END
