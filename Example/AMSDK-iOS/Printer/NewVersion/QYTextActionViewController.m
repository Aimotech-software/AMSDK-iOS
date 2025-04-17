//
//  QYTextActionViewController.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/4/10.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "QYTextActionViewController.h"

@interface QYTextActionViewController ()
@property(nonatomic, strong)UILabel *textLabel;
@end

@implementation QYTextActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.text = @"珠海印趣科技有限公司";
    self.textLabel.backgroundColor = UIColor.whiteColor;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:32];
    [self.view addSubview:self.textLabel];
    self.textLabel.frame =   CGRectMake(0, self.topContainer.frame.size.height + self.topContainer.frame.origin.y, self.view.frame.size.width, 40);
    [self.view addSubview:self.textLabel];
    // Do any additional setup after loading the view.
}

- (NSArray *)printImage {
    UIGraphicsBeginImageContext(self.textLabel.frame.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [self.textLabel.layer renderInContext:ref];
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return @[ret];
}

- (UIView *)contentView {
    return self.textLabel;
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
