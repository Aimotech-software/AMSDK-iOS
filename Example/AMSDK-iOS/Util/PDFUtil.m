//
//  PDFUtil.m
//  LMAPITest
//
//  Created by YFB-CDS on 2022/6/16.
//  Copyright © 2022 YFB-CDS. All rights reserved.
//

#import "PDFUtil.h"

@implementation PDFUtil
/**PDF转图片
 @param path PDF路径
 @param width 图片宽度
 @param pageNumber 页码
 @return UIImage 图片
 */
+ (UIImage *)toImage:(NSString *)path width:(int)width pageNumber:(int)pageNumber {
    
    NSURL *url = [NSURL fileURLWithPath:path];
    CFURLRef ref = (__bridge CFURLRef)url;
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL(ref);
    CFRelease(ref);
    CGPDFPageRef page = CGPDFDocumentGetPage(pdf, pageNumber);
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    pageRect.origin = CGPointZero;
    CGFloat wScale = width/pageRect.size.width;
    CGFloat height = pageRect.size.height*wScale;
    CGSize pageSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(pageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
//    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextTranslateCTM(context, 0.0, pageSize.height);
    CGContextScaleCTM(context, wScale, -wScale);
    CGContextSaveGState(context);
    CGContextDrawPDFPage(context, page);
    CGContextRestoreGState(context);
    UIImage *pdfImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pdfImage;
   
    
}


@end
