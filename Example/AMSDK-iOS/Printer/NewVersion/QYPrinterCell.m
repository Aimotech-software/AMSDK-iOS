//
//  QYPrinterCell.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "QYPrinterCell.h"
#import "I18nManager.h"
@implementation QYPrinterCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clickConnectButton.text = [I18nManager stringWithKey:@"点击连接"];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clickConnectButton.text = [I18nManager stringWithKey:@"点击连接"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
