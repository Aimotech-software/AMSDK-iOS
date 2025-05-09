//
//  QYPrinter+Internal.h
//  QYPrintSDK
//
//  Created by aimo on 2024/7/2.
//

#import <Foundation/Foundation.h>
#import "QYPrinter.h"
#import "QYConfigRequestor.h"


NS_ASSUME_NONNULL_BEGIN

@interface QYPrinter (Internal)

/// 启动调用初始化方法，会自动去拉取配置
/// - Parameters:
///   - appType: app 类型
///   - path: 本地bundle 路径
+ (void)registWithAppKey:(NSString *)secretKey env:(QYEnv)env;
@end

NS_ASSUME_NONNULL_END
