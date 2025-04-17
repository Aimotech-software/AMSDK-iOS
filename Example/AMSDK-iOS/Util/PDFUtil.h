//
//  PDFUtil.h
//  LMAPITest
//
//  Created by YFB-CDS on 2022/6/16.
//  Copyright © 2022 YFB-CDS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDFUtil : NSObject

/**PDF转图片
 @param path PDF路径
 @param width 图片宽度
 @param pageNumber 页码
 @return UIImage 图片
 */
+ (UIImage *)toImage:(NSString *)path width:(int)width pageNumber:(int)pageNumber;

@end

NS_ASSUME_NONNULL_END
