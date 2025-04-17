//
//  QYWifiSelectViewController.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2023/11/15.
//  Copyright © 2023 pengbi. All rights reserved.
//

#import "QYWifiSelectViewController.h"
#import  <QYPrintSDK/QYPrinter.h>
@interface QYWifiSelectViewController ()
<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UIButton *rightbutton;
@property(nonatomic, strong)NSString *currentWifi;

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *wifiArray;
/**当前手机的Wifi*/
@property(nonatomic, strong)NSMutableArray *currentArray;
/**扫描到的 wifi 列表*/
@property(nonatomic, strong)NSMutableArray *scanArray;
@end

@implementation QYWifiSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Wifi选择";
    [self.rightbutton addTarget:self action:@selector(refreshScan) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightbutton];
    [self refreshScan];
    
    self.currentArray = [[NSMutableArray alloc] init];
    [self.currentArray addObject:self.currentWifi];
    self.scanArray = [[NSMutableArray alloc] init];
    self.wifiArray = @[self.currentArray,self.scanArray];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.frame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)refreshScan {
    
    [QYPrinter.sharedInstance scanWifi:^(NSArray *wifiArray) {
        [self.scanArray removeAllObjects];
        [self.scanArray addObjectsFromArray:wifiArray];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                      withRowAnimation:UITableViewRowAnimationNone];
    }];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @{@0:@"我的网络",@1:@"可连接网络"}[@(section)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.wifiArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)self.wifiArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    id  wifi =  ((NSArray*)self.wifiArray[indexPath.section])[indexPath.row];
    if([wifi  isKindOfClass:NSString.class]){
        cell.textLabel.text = wifi;
    }
    else if ([wifi isKindOfClass:WifiInfo.class]){
        cell.textLabel.text = ((WifiInfo*)wifi).name;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入密码完成 wifi连接" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"密码";
    }];
    
    __weak UIAlertController *weakAlert = alertController;
    UIAlertAction *connectAction = [UIAlertAction actionWithTitle:@"连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *wifiName = @"";
        id  wifi =  ((NSArray*)self.wifiArray[indexPath.section])[indexPath.row];
        if([wifi  isKindOfClass:NSString.class]){
            wifiName = wifi;
        }
        else if ([wifi isKindOfClass:WifiInfo.class]){
            wifiName = ((WifiInfo*)wifi).name;
        }
        UITextField *passwordTextField = weakAlert.textFields.firstObject;
        [QYPrinter.sharedInstance setupNetwork:wifiName password:passwordTextField.text completion:^(NSString *ip, NSError *error) {
            if([ip isEqualToString:@"0.0.0.0"] || error){
                NSLog(@"配网失败");
            }
            else{
                self.didGetIp(ip);
                NSLog(@"配网成功");
                [self.navigationController popViewControllerAnimated:YES];
                return;
                NSString *modelName =  QYPrinter.sharedInstance.connectedPrinterInfo.device.modelName;
                [QYPrinter.sharedInstance disConnectPrinter:^(BOOL isSuccess, BOOL isBLE){
                    if(isSuccess){
                        [QYPrinter.sharedInstance connectWifiWithIp:ip
                                                          modelName:modelName
                                                         completion:^(BOOL isSuccess, NSError *error) { //连接成功
                            if(isSuccess){
                                NSLog(@"连接成功");
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else {
                                NSLog(@"连接失败%@",error);
                            }
                        }];
                    }
                                    
                }];
               
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:connectAction];
    [alertController addAction:cancelAction];
    [self  presentViewController:alertController animated:YES completion:nil];
}


-(UIButton *)rightbutton{
    if(!_rightbutton){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"刷新" forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 44, 44);
        _rightbutton = button;
    }
    return  _rightbutton;
}

- (UITableView *)tableView {
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

- (NSString *)currentWifi {
    if(!_currentWifi) {
        _currentWifi = [QYPrinter.sharedInstance getWifiName];
    }
    return _currentWifi;
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
