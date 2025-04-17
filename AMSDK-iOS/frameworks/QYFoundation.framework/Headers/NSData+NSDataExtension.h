//
//  NSData+NSDataExtension.h
//  Printmaster
//
//  Created by Hendrik on 2020/2/12.
//  Copyright © 2020 Hendrik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface NSData (NSDataExtension)

- (NSData *)getDataForPrintWith:(UIImage *)image;
- (NSData *)covertToGrayScaleWithImage:(UIImage *)image;

// 数据压缩
+(bool)lzo_init;
+(NSData*)minilzoEnCode:(NSData*)data;
+(NSData*)minilzoDeCode:(NSData*)data;
+ (NSData *)zlibCompressedData:(NSData *)data;

@end
