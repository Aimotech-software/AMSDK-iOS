//
//  QYFrameActionViewController.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/4/22.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "QYFrameActionViewController.h"

@interface QYFrameActionViewController ()
@property(nonatomic, strong)UIView *frameView;
@end

@implementation QYFrameActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float  width = self.view.frame.size.width / 2;
    self.frameView = [[UIView alloc]init];
    [self.view addSubview:self.frameView];
    self.frameView.backgroundColor = UIColor.whiteColor;
    self.frameView.frame = CGRectMake(width / 2,self.topContainer.frame.size.height + self.topContainer.frame.origin.y, width,width );
    self.frameView.layer.borderColor = UIColor.blackColor.CGColor;
    self.frameView.layer.borderWidth = 24;
    
    // Do any additional setup after loading the view.
}

- (NSArray *)printImage {
    UIGraphicsBeginImageContext(self.frameView.frame.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [self.frameView.layer renderInContext:ref];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return @[ret];
}

- (UIView *)contentView {
    return self.frameView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
