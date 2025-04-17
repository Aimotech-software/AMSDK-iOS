//
//  AppDelegate.h
//  LMAPITest
//
//  Created by YFB-CDS on 2020/7/16.
//  Copyright © 2020 YFB-CDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic, strong) UIWindow *window;

@property(nonatomic, assign) BOOL coverIsOpen;

@property(nonatomic, assign) BOOL outofPaper;

@property(nonatomic, assign) BOOL cancelPrint;
@end

