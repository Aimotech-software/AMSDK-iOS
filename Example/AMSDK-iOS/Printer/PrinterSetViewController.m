//
//  PrinterSetViewController.m
//  LMAPITest
//
//  Created by YFB-CDS on 2020/8/21.
//  Copyright © 2020 YFB-CDS. All rights reserved.
//

#import "PrinterSetViewController.h"
#import "XHudManager.h"
#import "XSingleView.h"
#import "AppDelegate.h"
#import <QYPrintSDK/QYBLEDeviceConfiguration.h>
#import "I18nManager.h"
@interface PrinterSetViewController()
<UITableViewDelegate,
UITableViewDataSource,
UIDocumentPickerDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource
>


@property(nonatomic, strong) UITableView *tab;

@property(nonatomic, strong) NSArray *titles;

@property(nonatomic, strong)UIPickerView *pickerView;
@property(nonatomic, strong)NSArray *updateApps;
@property(nonatomic, strong)NSString *selectApp;
@property(nonatomic, strong)UIButton *updateButton;
@property(nonatomic, strong)UIButton *cancelButton;

@end

@implementation PrinterSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.title = [I18nManager stringWithKey:@"设置"];
    
//    _titles = @[@"设置纸张类型（临时修改）", @"设置打印浓度（临时修改）", @"设置打印速度（临时修改）",
//                @"设置打印浓度（永久修改）", @"设置打印速度（永久修改）", @"设置关机时间", @"打印自检页", @"固件更新", @"重设IP",@"断开打印机连接"];
    
    _titles = @[[I18nManager stringWithKey:@"切换语言"]];
    
    _tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    _tab.tableFooterView = [UIView new];
    _tab.backgroundColor = UIColor.clearColor;
    _tab.delegate = self;
    _tab.dataSource = self;
    [_tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tab.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tab];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    int row = indexPath.row;
    
    if (row == 0) {
        [self alter:[I18nManager stringWithKey:@"切换语言，之后下次启动生效"]];
        
    }
    [tableView reloadData];
}



- (void)cancelAppConfig {
    [self.pickerView removeFromSuperview];
    [self.updateButton removeFromSuperview];
    [self.cancelButton removeFromSuperview];
}

- (NSString*)cachePath {
//    let dstPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
//    return (dstPath as NSString).appendingPathComponent("AreaCodeCache")
//
    NSString *path =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [path stringByAppendingPathComponent:@"config"];
}
    

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
 }
-(NSInteger)pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component{
    return [self.updateApps count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
 (NSInteger)row inComponent:(NSInteger)component{
    self.selectApp = self.updateApps[row];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
  (NSInteger)row forComponent:(NSInteger)component{
    NSString *title = self.updateApps[row];
    return title;
}

- (void)alter:(NSString *)title {
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:[I18nManager stringWithKey:@"确定"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [I18nManager switchLanguage];
        exit(0);
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
