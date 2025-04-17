//
//  QYWifiSelectViewController.h
//  QYPrintSDK_Example
//
//  Created by aimo on 2023/11/15.
//  Copyright © 2023 pengbi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYWifiSelectViewController : UIViewController
@property(nonatomic, strong)void (^didGetIp)(NSString* ip);
@end

NS_ASSUME_NONNULL_END
