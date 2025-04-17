//
//  QYPrinter+Internal.h
//  QYPrintSDK
//
//  Created by aimo on 2024/7/2.
//

#import <Foundation/Foundation.h>
#import "QYPrinter.h"


NS_ASSUME_NONNULL_BEGIN

@interface QYPrinter (Customer)

/// 启动调用初始化方法，加载配置
/// - Parameters:
///   - appType: app 类型
///   - path: 本地bundle 路径
+ (void)setup;
@end

NS_ASSUME_NONNULL_END
