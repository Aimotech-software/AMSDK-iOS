//
//  OpenCVWrapper.h
//  QPrinter
//
//  Created by Chris on 2018/10/31.
//  Copyright © 2018 QuYin8. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef  NS_ENUM(NSInteger,QYImageScaleType){ //改变大小方式
    QYImageScaleType_Zoom = 0,//缩放
    QYImageScaleType_Tail = 1,//裁剪
};


typedef  NS_ENUM(NSInteger,QYClipType){ //改变大小方式
    QYClipType_LeftTop = 0,// 左上
    QYClipType_Center  = 1,// 居中
};



@interface OpenCVWrapper : NSObject
/**
 图片是否有Alpha通道
 */
+ (BOOL)hasAlpha:(UIImage *)image;

/// 根据图片获取打印数据
/// @param image 图片资源
/// @param reversePrint 是否反相打印
+ (NSData*)getForPrintWith:(UIImage*)image reverse:(BOOL)reversePrint;

/// 半色调处理
/// @param image 图片
+ (UIImage*)halftone:(UIImage*)image;


/// 抖动处理
/// @param image 图片
+ (UIImage*)dithering:(UIImage*)image;

/// 抖动处理
+ (UIImage*)stuckiDithering:(UIImage*)image;


+ (UIImage*)StuckiDithering16Lvel:(UIImage*)image withWidth:(float)width;

/// 灰度处理
/// @param image 图片
/// @param width 灰度后需要的宽度
/// @param thresh 灰度阀值，通常是127/128
/// @param alphaExist 是否包含alpha通道
+ (UIImage*)gray:(UIImage*)image width:(float)width thresh:(int)thresh  alphaExist:(bool)alphaExist;


/// 根据红黑双色图获取NSData
/// @param image 图片
+ (NSData*)getForPrintRedBlackDataWith:(UIImage*)image;
+ (UIImage*) rotate:(UIImage*)image rType: (int) type;

+ (NSData *)getDataForPrintWith:(UIImage *)image MaxSize:(CGSize)maxSize addBottom:(int)addBottom isEnCode:(bool)isEnCode;



///  误差扩散 + 二值化一起做了
/// - Parameters:
///   - image: 图片
///   - addBottom: 底部高度
///   - isEnCode: 是否压缩
+ (NSData *)getDataForPrintWith:(UIImage *)image  addBottom:(int)addBottom isEnCode:(bool)isEnCode;


/// 处理图片
/// - Parameters:
///   - image: 图片内容
///   - stuckiDithering: 是否是抖动（误差扩散）
///   - maxSize: 最大图片尺寸
///   - addBottom: 底部补白高度
///   - isEnCode: 是否压缩
+ (NSData *)getDataForPrintWith:(UIImage *)image isStuckiDithering:(bool)stuckiDithering MaxSize:(CGSize)maxSize addBottom:(int)addBottom isEnCode:(bool)isEnCode;
+ (NSData *)getDataForPrintWith:(UIImage *)image isStuckiDithering:(bool)stuckiDithering  addBottom:(int)addBottom isEnCode:(bool)isEnCode;


+ (UIImage*)reSize:(UIImage*)image withWidth:(float)width;
+ (UIImage*)StuckiDithering:(UIImage*)image withWidth:(float)width;


+ (UIImage*)covertToGrayScale:(UIImage*)image withWidth:(float)width thresh:(int)thresh  alphaExist:(bool)alphaExist;





/// 边缘补白
/// - Parameters:
///   - image: 图片
///   - edge: 边缘
+ (UIImage*)AddWhiteColor:(UIImage*)image edge: (UIEdgeInsets) edge;



/// 如果大于宽度就右边剪掉，小于就补白右边
/// - Parameters:
///   - originImage: 图片
///   - width: 宽度
+ (UIImage*)clipImagWithOriginImage:(UIImage*)originImage width:(float)width;


+ (NSData*)getForPrint16LevelWith:(UIImage*)image;


/// 剪裁图片
/// - Parameters:
///   - image: 图片
///   - clipType: 剪裁类型
///      - toSize:  剪裁的目标尺寸
+ (UIImage*)clipImageWithOriginImage:(UIImage*)image clipType:(QYClipType)clipType toSize:(CGSize)toSize;


+ (NSData *)getBitmapImageDataWith:(UIImage *)image isStuckiDithering:(bool)stuckiDithering addBottom:(int)addBottom;


@end

NS_ASSUME_NONNULL_END

