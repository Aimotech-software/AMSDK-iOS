//
//  QYClickSelectCell.h
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/18.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYPrintModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QYClickSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *selectButtonTitle;
@property (weak, nonatomic) IBOutlet UIImageView *selectButtonIcon;
@property(nonatomic, assign)int pickIndex ;
@property(nonatomic, strong)QYPrintModel *model;
@property(nonatomic, weak)UIViewController *controller;
@property (nonatomic, copy) void (^didSelectPick)();
- (void)configModel:(QYPrintModel *)model;
@end

NS_ASSUME_NONNULL_END
