//
//  QYKeychainWrapper.h
//  QYPrintSDK
//
//  Created by aimo on 2024/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYKeychainWrapper : NSObject
- (void)saveDataToKeychainWithService:(NSString *)service account:(NSString *)account data:(NSData *)data;
- (NSData *)retrieveDataFromKeychainWithService:(NSString *)service account:(NSString *)account;
- (void)deleteDataFromKeychainWithService:(NSString *)service account:(NSString *)account;
@end

NS_ASSUME_NONNULL_END
