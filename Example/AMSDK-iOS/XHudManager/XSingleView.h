//
//  XSingleView.h
//  LMAPITest
//
//  Created by YFB-CDS on 2020/8/22.
//  Copyright © 2020 YFB-CDS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XSingleView : UIView

/**
 * @brief 创建单例
 */
+ (instancetype)sharedInstance;

/**
 * @brief 显示
 * @param message 信息
 */
- (void)show:(NSString *)message;


@end

NS_ASSUME_NONNULL_END
