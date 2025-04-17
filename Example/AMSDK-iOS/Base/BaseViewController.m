//
//  BaseViewController.m
//  LMAPITest
//
//  Created by YFB-CDS on 2020/8/17.
//  Copyright © 2020 YFB-CDS. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat height = UIScreen.mainScreen.nativeBounds.size.height;
    if (height == 2436 || height == 1792 || height == 2688 || height == 1624) {
        _X_NavHeight = 88;
    }else {
        _X_NavHeight = 64;
    }
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.hideNavigationBar ){
        self.navigationItem.leftBarButtonItem = nil;
    }else {
        UIImage *backImg = [[UIImage imageNamed:@"nav_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
}

- (void)setHideNavigationBar:(BOOL)hideNavigationBar {
    _hideNavigationBar = hideNavigationBar;
    
    if(_hideNavigationBar ){
        self.navigationItem.leftBarButtonItem = nil;
    }else {
        UIImage *backImg = [[UIImage imageNamed:@"nav_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
