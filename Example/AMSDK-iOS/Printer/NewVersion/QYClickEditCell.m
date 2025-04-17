//
//  QYClickEditCell.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "QYClickEditCell.h"

@implementation QYClickEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftButton.layer.borderColor = UIColor.systemGray2Color.CGColor;
    self.leftButton.layer.borderWidth = 1;
    self.rightButton.layer.borderColor = UIColor.systemGray2Color.CGColor;
    self.rightButton.layer.borderWidth = 1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickLeft:(id)sender {
    if(self.model.clickValue == 0 && self.model.canNeg) {
        
    }
    if(self.model.canNeg) {
        self.model.clickValue -= 1;
    }
    else{
        if(self.model.clickValue > 0){
            self.model.clickValue -= 1;
        }
    }
    self.contentLabel.text = [NSString stringWithFormat:@"%d",self.model.clickValue];
}

- (IBAction)clickRight:(id)sender {
    self.model.clickValue += 1;
    self.contentLabel.text = [NSString stringWithFormat:@"%d",self.model.clickValue];
}

- (void)configModel:(QYPrintModel *)model {
    self.model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text =[NSString stringWithFormat:@"%d",self.model.clickValue];;
}
@end
