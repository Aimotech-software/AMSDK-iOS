//
//  OpenCVWrapper_Dummy.h
//  CocoaAsyncSocket
//
//  Created by aimo on 2024/6/6.
//

#import <Foundation/Foundation.h>
#import "OpenCVWrapper.h"
NS_ASSUME_NONNULL_BEGIN


@interface OpenCVWrapper(Dummy)

/// 抖动图片
/// - Parameter image: 图片
+ (UIImage*)StuckiDithering:(UIImage*)image;



/// 抖动图片2
/// - Parameter image: 图片
+ (UIImage *)StuckiDithering2:(UIImage *)image;





/// 替换灰度图片
/// - Parameters:
///   - image: 图片
///   - thresh: 边界值，大于这只值为 255，小于这个值为 0
///   - alphaExist:  alphaExist
+ (UIImage*)covertToGrayScale:(UIImage*)image thresh:(int)thresh  alphaExist:(bool)alphaExist;


/// 16阶的抖动
/// - Parameter image: image
+ (UIImage*)StuckiDithering16Lvel:(UIImage*)image;


@end

NS_ASSUME_NONNULL_END
