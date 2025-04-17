//
//  QYPrinterListViewController.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "QYPrinterListViewController.h"
#import "QYPrinterCell.h"
#import  <QYPrintSDK/QYPrinter.h>
#import "XHudManager.h"
#import "XSingleView.h"
#import "QYWifiSelectViewController.h"
#import "QYModeSelectViewController.h"
#import "I18nManager.h"
@interface QYPrinterListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *printerTableView;
@property (strong, nonatomic)  UIButton *scanButton;
@property (strong, nonatomic) NSArray *printerList;
@property(nonatomic, strong)QYPrinterInfo *printInfo;
@property(nonatomic, assign)BOOL BLECanUse;
@end

@implementation QYPrinterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    [self setup];
    self.printerTableView.dataSource = self;
    self.printerTableView.delegate = self;
    self.printerTableView.backgroundColor = UIColor.clearColor;
    [self.printerTableView  registerNib:[UINib nibWithNibName:@"QYPrinterCell" bundle:nil] forCellReuseIdentifier:@"QYPrinterCell"];
//    
//    [QYPrinter.sharedInstance setUpBLEStatusCallback:^(BLEStatus state) {
//        
//        self.BLECanUse = (state == BLEStatusPoweredOn) ? YES : NO;
//        if(self.BLECanUse) {
//            [self tryConnectDirectory];
//        }
//       
//    }];
    [self scan];
    
    [QYPrinter.sharedInstance addExceptionBlock:^(QYActiveInstructionType exception) {
        if(exception == QYActiveInstructionType_Disconnect){
//            self.printInfo = [QYPrinter sharedInstance].connectedPrinterInfo;
//            [self.tableView reloadData];
//            [self scan];
        }
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)tryConnectDirectory {
    NSArray<QYBLEDevice*> *lists = [QYPrinter.sharedInstance systemConnectedPeripherals];
    QYBLEDevice *device = lists.firstObject;
    if(device) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[I18nManager stringWithKey:@"有直连设备，是否连接"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:[I18nManager stringWithKey:@"连接"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [QYPrinter.sharedInstance connectPrinterWithDevice:device completion:^(BOOL isSuccess, NSError *error) {
                if (isSuccess) {
                    if(isSuccess){
                        [self.navigationController popViewControllerAnimated:YES];
                        NSLog([I18nManager stringWithKey:@"连接成功"]);
                    }
                    else {
                        NSLog([I18nManager stringWithKey:@"连接失败"]);
                    }
                }
            }];
        }];
        UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:[I18nManager stringWithKey:@"取消"] style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [alertController addAction:action_cancel];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (void)setup {
    self.printerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.printerTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.printerTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [QYPrinter.sharedInstance stopScan];
}

- (void)scan {
    
    [QYPrinter.sharedInstance scanPrinterWithTimeout:10
                                        additionalDeviceNames:@[@"D30"]
                                         compoletion:^(NSArray<QYBLEDevice *> *printers, NSError *error) {
        self.printerList = printers;
        [self.printerTableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.printerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYPrinterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYPrinterCell" forIndexPath:indexPath];
    QYBLEDevice *device = self.printerList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = device.isInternalDevice ? device.modelName : [NSString stringWithFormat:[I18nManager stringWithKey:@"%@-外部设备"],device.bluetoothName];
    cell.macLabel.text = device.mac;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QYBLEDevice *device = self.printerList[indexPath.row];
    self.didClickConnectDevice(device);
 
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
