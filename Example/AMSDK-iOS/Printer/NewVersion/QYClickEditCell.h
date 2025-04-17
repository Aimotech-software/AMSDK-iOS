//
//  QYClickEditCell.h
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYPrintModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QYClickEditCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property(nonatomic, weak)UIViewController *controller;
@property(nonatomic, strong)QYPrintModel *model;

- (void)configModel:(QYPrintModel*)model;
@end

NS_ASSUME_NONNULL_END
