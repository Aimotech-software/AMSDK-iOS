//
//  AppDelegate.m
//  LMAPITest
//
//  Created by YFB-CDS on 2020/7/16.
//  Copyright © 2020 YFB-CDS. All rights reserved.
//

#import "AppDelegate.h"
#import <QYPrintSDK/QYPrinter.h>
//#import "QYPrinter+Internal.h"
#import <QYPrintSDK/QYBLEDeviceConfiguration.h>
#import "Constant.h"
#import "XHudManager.h"
#import "QYLocationManager.h"
#import "QYLocalNetworkAuthorization.h"
#import "PrinterHomeViewController.h"
#import "PrinterSetViewController.h"
#import <QYPrintSDK/QYPrinter+Customer.h>
#import "I18nManager.h"
@interface AppDelegate ()

@property(nonatomic, strong)QYLocalNetworkAuthorization *localNetworkRequester;
@property(nonatomic, strong)QYLocationManager *locationManager;
@end

@implementation AppDelegate


- (void)setNavigationController:(UINavigationController*)navigationController  {
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName:UIColor.darkGrayColor,
                                                     NSFontAttributeName:[UIFont systemFontOfSize:17]};

    if (@available(iOS 13.0, *)) {
           UINavigationBarAppearance *standardAppearance = [navigationController.navigationBar.standardAppearance copy];
           standardAppearance.titleTextAttributes = titleTextAttributes;
           //设置此参数将覆盖`BarTintColor`
        standardAppearance.backgroundColor = UIColor.darkGrayColor;
           //透明
        standardAppearance.backgroundImage = UIImage.new;
        standardAppearance.backgroundEffect = nil;
        navigationController.navigationBar.standardAppearance = standardAppearance;
    } else {
           //标题颜色
        navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
           //背景色
           [navigationController.navigationBar setBarTintColor:UIColor.darkGrayColor];
           //透明(key code)
           [navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

- (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)size

{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}


- (NSString*)cachePath {
//    let dstPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
//    return (dstPath as NSString).appendingPathComponent("AreaCodeCache")
//
    NSString *path =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [path stringByAppendingPathComponent:@"config"];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.coverIsOpen = YES;
    self.outofPaper = YES;
    self.cancelPrint = NO;
    int(^ sumOfNumbers)(int a, int b) = ^(int a, int b) {
        NSLog(@"%d\n",a+b);
            return a + b;
        };
    
    SafeBlock(sumOfNumbers, 1,2)
    sumOfNumbers = nil;
    SafeBlock(sumOfNumbers, 1,2)
        
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = UIColor.whiteColor;
//    PrinterListViewController *rootVC = [[PrinterListViewController alloc] init];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    //[QYPrinter registWithAppKey:QYAppType_YXS bundlePath:NULL];
    
    [QYPrinter setup];
    
    
    PrinterHomeViewController *homeVC = [[PrinterHomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:[I18nManager stringWithKey:@"首页"] image:nil selectedImage:nil];
    [homeNav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    homeNav.navigationBar.translucent = NO;
    homeNav.navigationBar.shadowImage = [self imageFromColor:UIColor.blackColor withSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, 2)];
    
    [self setNavigationController:homeNav];
    
    PrinterSetViewController *setVC = [[PrinterSetViewController alloc] init];
    UINavigationController *setNav = [[UINavigationController alloc] initWithRootViewController:setVC];
    setNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:[I18nManager stringWithKey:@"设置"] image:nil selectedImage:nil];
    [setNav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    setVC.hideNavigationBar = YES;
    setNav.navigationBar.translucent = NO;
    setNav.navigationBar.tintColor = UIColor.darkGrayColor;
    [self setNavigationController:setNav];
    setNav.navigationBar.shadowImage = [self imageFromColor:UIColor.blackColor withSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width, 2)];
    
    UITabBarController *tabbarController =  [[UITabBarController alloc] init];
    tabbarController.viewControllers = @[homeNav,setNav];
    tabbarController.tabBar.translucent = NO;
    tabbarController.tabBar.barTintColor = UIColor.whiteColor;

    
    self.window.rootViewController = tabbarController;
    
    self.locationManager =  [[QYLocationManager alloc] init];
    [self.locationManager requestLocation];
    QYLocalNetworkAuthorization *localNetRequester = [[QYLocalNetworkAuthorization alloc] init];
    [localNetRequester requestAuthorization];
    self.localNetworkRequester = localNetRequester;
    
    [QYPrinter.sharedInstance addExceptionBlock:^(QYActiveInstructionType exception) {
        if (exception == QYActiveInstructionType_OutOfPaper) {
            self.outofPaper = YES;
            [self alter:[I18nManager stringWithKey:@"打印机缺纸"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_IntoPaper) {
            self.outofPaper = NO;
            [self alter:[I18nManager stringWithKey:@"打印机上纸/有纸"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_CoverOpen) {
            self.coverIsOpen = YES;
            [self alter:[I18nManager stringWithKey:@"打印机开盖"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_CoverClose) {
            self.coverIsOpen = NO;
            [self alter:[I18nManager stringWithKey:@"打印机关盖"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_TempWarning) {
            [self alter:[I18nManager stringWithKey:@"打印机温度过高"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_RemoveTempWarning) {
            [self alter:[I18nManager stringWithKey:@"打印机高温解除"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_LowPower_10) {
            [self alter:[I18nManager stringWithKey:@"打印机电量低于10%"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_LowPower_5) {
            [self alter:[I18nManager stringWithKey:@"打印机电量低于5%"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_LowPower_WillShutDown) {
            [self alter:[I18nManager stringWithKey:@"打印机即将关机"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_CancelPrint) {
            self.cancelPrint = YES;
            [self alter:[I18nManager stringWithKey:@"打印机取消打印"] type:exception];
            [XHudManager.sharedInstance hidden];
            return;
        }
        if (exception == QYActiveInstructionType_CutePress) {
            [self alter:[I18nManager stringWithKey:@"打印机切刀被触碰"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_CuteLossen) {
            [self alter:[I18nManager stringWithKey:@"打印机切刀松开"] type:exception];
            return;
        }
        
        if (exception == QYActiveInstructionType_TTFError) {
            [self alter:[I18nManager stringWithKey:@"打印机碳带识别异常"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_OutTTF) {
            [self alter:[I18nManager stringWithKey:@"打印机碳带耗尽"] type:exception];
            return;
        }
        
        if (exception == QYActiveInstructionType_PaperError) {
            [self alter:[I18nManager stringWithKey:@"打印机纸张识别异常"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_OutOfPaper) {
            [self alter:[I18nManager stringWithKey:@"打印机纸张余量不足"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_TapeError) {
            [self alter:[I18nManager stringWithKey:@"打印机色带识别异常"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_OutOffTape) {
            [self alter:[I18nManager stringWithKey:@"打印机色带耗尽"] type:exception];
            return;
        }
        if (exception == QYActiveInstructionType_Disconnect) {
            [self alter:[I18nManager stringWithKey:@"打印机断开连接"] type:exception];
            return;
        }
    }];
    
    return YES;
}


- (void)alter:(NSString *)title type:(QYActiveInstructionType)responseType {
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:[I18nManager stringWithKey:@"确定"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alter dismissViewControllerAnimated:YES completion:nil];
    }];
    [alter addAction:confirm];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (UIApplication.sharedApplication.keyWindow.rootViewController.presentedViewController) {
            
            [UIApplication.sharedApplication.keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
                [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
            }];

        }else {
            [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
        }
        
        
    });
    
    
    
}



@end
