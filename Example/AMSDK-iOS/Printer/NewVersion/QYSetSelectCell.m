//
//  QYSetSelectCell.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "QYSetSelectCell.h"
@interface QYSetSelectCell()
@end
@implementation QYSetSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectButton.titleEdgeInsets = UIEdgeInsetsMake(0, -self.selectButton.imageView.frame.size.width, 0, self.selectButton.imageView.frame.size.width);
    self.selectButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.selectButton.titleLabel.frame.size.width, 0, -self.selectButton.titleLabel.frame.size.width);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
