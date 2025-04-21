//
//  UIImage+Transform.h
//  QYPrintSDK
//
//  Created by aimo on 2023/11/13.
//

#import <UIKit/UIKit.h>
#import "QYConstants.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Transform)
+ (UIImage *)maxWidthImage:(UIImage *)image
               maxWidthDot:(CGFloat)maxWidthDot
                 direction:(QDrawDirection)direction;

/**
 * @brief 将图片绘制为最大打印机高度
 * @param maxHeightDot 最大高度
 * @return 图片
 */
+ (UIImage *)maxHeightImage:(UIImage *)image
               maxHeightDot:(CGFloat)maxHeightDot;



- (UIImage*)mirrorImage;



/// 图片处理
/// - Parameter processType: <#processType description#>
- (UIImage*)imageWithProcessType:(QYImageProcessType)processType;




/// 处理图片数据 即 图片头部数据 + 二值化 （抖动）等等
/// - Parameters:
///   - processType: 处理类型
///   - maxSize: 最大尺寸，和补的高度有关，暂时认为是正确的。
///   - addBottom: 底部的高度
///   - isEnCode: 是否压缩
- (NSData *)getDataWithProcessType:(QYImageProcessType)processType
                      addBottom:(int)addBottom
                       isEnCode:(bool)isEnCode;
@end

NS_ASSUME_NONNULL_END
