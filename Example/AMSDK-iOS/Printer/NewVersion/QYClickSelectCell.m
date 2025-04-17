//
//  QYClickSelectCell.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/18.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "QYClickSelectCell.h"
#import <UIKit/UIKit.h>
#import "Constant.h"
@interface QYClickSelectCell()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic, strong)UIPickerView *pickerView;
@end
@implementation QYClickSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectButton.layer.borderWidth = 1;
    self.selectButton.layer.borderColor = UIColor.lightGrayColor.CGColor;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //self.selectButtonTitle.text = self.model.selectScope[self.model.selectIndex];
        self.selectButtonTitle.text = self.model.selectIndex < self.model.selectScope.count ? self.model.selectScope[self.model.selectIndex] : @"";
    });
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickSelectButton:(id)sender {
    [self.pickerView removeFromSuperview];
    self.pickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(0, X_Height- 300, X_Width, 300)];
    self.pickerView.backgroundColor = UIColor.lightGrayColor;
    [self.controller.view addSubview:self.pickerView];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}


#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
 }
-(NSInteger)pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component{
    return [self.model.selectScope count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
 (NSInteger)row inComponent:(NSInteger)component{
    self.model.selectIndex = row;
    self.selectButtonTitle.text = self.model.selectScope[row];
    self.model.content = self.selectButtonTitle.text;
    [self.pickerView removeFromSuperview];
    self.didSelectPick ? self.didSelectPick() : 0x0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
  (NSInteger)row forComponent:(NSInteger)component{
    return [self.model.selectScope objectAtIndex:row];
}

- (void)configModel:(QYPrintModel *)model {
    self.model = model;
    self.titleLabel.text = model.title;
    if(self.model.selectIndex < self.model.selectScope.count) {
        self.selectButtonTitle.text = self.model.selectScope[self.model.selectIndex];
    }

}

@end
