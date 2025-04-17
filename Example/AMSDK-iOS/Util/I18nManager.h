//
//  I18nManager.h
//  AMSDK-iOS_Example
//
//  Created by aimo on 2025/4/17.
//  Copyright © 2025 pengbi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface I18nManager : NSObject

/// 切换语言
+ (void)switchLanguage;

+ (NSString*)stringWithKey:(NSString*)key;
@end

NS_ASSUME_NONNULL_END
