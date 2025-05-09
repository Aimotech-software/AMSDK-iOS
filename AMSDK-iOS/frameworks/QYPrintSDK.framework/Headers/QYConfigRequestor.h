//
//  QYConfigRequestor.h
//  QYPrintSDK
//
//  Created by aimo on 2024/7/2.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,QYEnv){
    QYEnv_Test = 0,           //测试环境
    QYEnv_Production_Chinese, // 正式国内
    QYEnv_Production_Global   //正式海外
};

NS_ASSUME_NONNULL_BEGIN
@interface QYConfigRequestor : NSObject
- (void)requestConfigWithSecret:(NSString*)secretKey
                         version:(NSString*)version
                             env:(QYEnv)env
                          handle:(void(^)(NSDictionary*))handle;
@end

NS_ASSUME_NONNULL_END
