//
//  QYPrintActionViewController.h
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYPrintActionViewController : UIViewController

@property(nonatomic, assign)BOOL isText;
@property(nonatomic, strong)UIImage *image;

@property (weak, nonatomic) IBOutlet UIView *topContainer;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;

- (NSArray*)printImage;

- (UIView*)contentView;
@end

NS_ASSUME_NONNULL_END
