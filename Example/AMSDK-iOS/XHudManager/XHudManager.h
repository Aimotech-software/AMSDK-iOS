//
//  XHudManager.h
//  LMAPITest
//
//  Created by YFB-CDS on 2020/8/13.
//  Copyright © 2020 YFB-CDS. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface XHudManager : UIView

/**
 * @brief 创建单例
 */
+ (instancetype)sharedInstance;

/**
 * @brief 显示
 * @param message 信息
 */
- (void)show:(NSString *)message;


/**
 * @brief 隐藏
 */
- (void)hidden;
@end

