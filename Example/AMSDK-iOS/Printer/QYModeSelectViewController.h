//
//  QYModeSelectViewController.h
//  QYPrintSDK_Example
//
//  Created by aimo on 2023/11/15.
//  Copyright © 2023 pengbi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DidSelectType)(int type);
@interface QYModeSelectViewController : UIViewController
@property(nonatomic, strong)DidSelectType didSelectType;
@end

NS_ASSUME_NONNULL_END
