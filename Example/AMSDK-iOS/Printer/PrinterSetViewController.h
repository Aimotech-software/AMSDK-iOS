//
//  PrinterSetViewController.h
//  LMAPITest
//
//  Created by YFB-CDS on 2020/8/21.
//  Copyright © 2020 YFB-CDS. All rights reserved.
//

#import "BaseViewController.h"
#import  <QYPrintSDK/QYPrinter.h>
NS_ASSUME_NONNULL_BEGIN

@interface PrinterSetViewController : BaseViewController

@property(nonatomic, strong) QYPrinterInfo *printerInfo;

@end

NS_ASSUME_NONNULL_END
