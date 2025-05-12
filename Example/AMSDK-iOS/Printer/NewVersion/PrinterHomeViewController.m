//
//  PrinterHomeViewController.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "PrinterHomeViewController.h"
#import "QYImageActionViewController.h"
#import "QYTextActionViewController.h"
#import "QYInfoTableViewCell.h"
#import  "QYPrintSDK/QYPrinter.h"
#define titleIdentify @"titleIdentify"
#define actionIdentify @"actionIdentify"
#define imageIdentify @"imageIdentify"
#import "QYPrinterListViewController.h"
#import "XHudManager.h"
#import "QYPrintActionViewController.h"
#import "XSingleView.h"
#import "QYModeSelectViewController.h"
#import "QYWifiSelectViewController.h"
#import "QYFrameActionViewController.h"
#import "I18nManager.h"
@interface PrinterHomeViewController ()<UITableViewDelegate,UINavigationControllerDelegate,UITableViewDataSource,UIImagePickerControllerDelegate>
@property(nonatomic, strong)UITableView *infoTableView;
@property(nonatomic, strong)UIView *bottomContainer;

@property(nonatomic, strong)UIView *configView;       //配网容器
@property(nonatomic, strong)UIView *printContainer;   //打印容器
@property(nonatomic, strong)UIButton *disconnectButton; //断开连接按钮

@property(nonatomic, strong)NSArray *actionArray;
@property(nonatomic, strong)NSArray *contentArray;
@property(nonatomic, strong)NSArray *sectionArray;

@property(nonatomic, strong)NSString*ip;
@end

@implementation PrinterHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self tryConnectDirectory];
//    });
    
}

#define Button(text,sel)\
do{\
textButton = [UIButton buttonWithType:UIButtonTypeCustom];\
textButton.backgroundColor = UIColor.darkGrayColor;\
[textButton setTitle:text forState:UIControlStateNormal];\
[textButton addTarget:self\
               action:@selector(sel)\
     forControlEvents:UIControlEventTouchUpInside];\
textButton.frame = CGRectMake(left,0 , width, height);\
\
}while(0);
- (void)setup {
    self.title = [I18nManager stringWithKey:@"首页"];
    self.view.backgroundColor = UIColor.lightGrayColor;
    //float tabbarHeight = self.tabBarController.tabBar.frame.size.height;
    [self.view addSubview:self.bottomContainer];
    int viewWidth = self.view.frame.size.width;
    self.bottomContainer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;{
        
        
        UIButton *textButton;
        self.configView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, viewWidth, 50)];
        [self.bottomContainer addSubview:self.configView];
        int width = (self.view.frame.size.width - 60) / 2;
        int left = 20,top = 10,height = 40;
        Button([I18nManager stringWithKey:@"配网"], clickConfigNet)
        [self.configView addSubview:textButton];
        left += width + 20;
        Button([I18nManager stringWithKey:@"局域网连接"], clickConnectWifi)
        [self.configView addSubview:textButton];
        
        
        
        
        left = 20;
        width = (self.view.frame.size.width - 40);
        Button([I18nManager stringWithKey:@"断开连接"], clickDisconnect)
        textButton.frame =  CGRectMake(left, 60, width, height);
        self.disconnectButton = textButton;
        [self.bottomContainer addSubview:textButton];
        
        
        self.printContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 110, viewWidth, 100)];
        [self.bottomContainer addSubview:self.printContainer];
        
        width = (self.view.frame.size.width - 80) / 3;
        Button([I18nManager stringWithKey:@"打印文本"], clickText)
        textButton.frame = CGRectMake(textButton.frame.origin.x, 0,textButton.frame.size.width , textButton.frame.size.height);
        [self.printContainer addSubview:textButton];
        left += width + 20;
        Button([I18nManager stringWithKey:@"打印图片"], clickImage)
        textButton.frame = CGRectMake(textButton.frame.origin.x, 0,textButton.frame.size.width , textButton.frame.size.height);
        [self.printContainer addSubview:textButton];
        left += width + 20;
        Button([I18nManager stringWithKey:@"打印边框"], clickFrame)
        textButton.frame = CGRectMake(textButton.frame.origin.x, 0,textButton.frame.size.width , textButton.frame.size.height);
        [self.printContainer addSubview:textButton];
        
        float bottomHeight = 160;
        
        
        self.bottomContainer.frame =  CGRectMake(0, self.view.frame.size.height - bottomHeight , self.view.frame.size.width, bottomHeight);
    }
    self.actionArray = @[@{@"title":[I18nManager stringWithKey:@"连接打印机"],@"action":[I18nManager stringWithKey:@"立刻连接"],@"sel":@"clickConnect"},@{}];
    self.contentArray = @[[I18nManager stringWithKey:@"设备名称"],
                          [I18nManager stringWithKey:@"固件版本号"],
                          [I18nManager stringWithKey:@"SN"],
                          [I18nManager stringWithKey:@"MAC地址"],
                          [I18nManager stringWithKey:@"剩余电量"],
                          [I18nManager stringWithKey:@"RFID余量"],
                          [I18nManager stringWithKey:@"RFID信息"],
                          [I18nManager stringWithKey:@"关机时间"],
                          [I18nManager stringWithKey:@"纸张状态"],
                          [I18nManager stringWithKey:@"开盖/关盖"],
                          [I18nManager stringWithKey:@"切刀状态"],
                          [I18nManager stringWithKey:@"硬件版本"],
                          [I18nManager stringWithKey:@"通讯版本"],
                          [I18nManager stringWithKey:@"可压缩数据包大小"],
                          [I18nManager stringWithKey:@"芯片类型"],
                          [I18nManager stringWithKey:@"碳带状态"],
                          [I18nManager stringWithKey:@"wifi名字"],
                          [I18nManager stringWithKey: @"ip"],
                          [I18nManager stringWithKey:@"工作状态"],
                          [I18nManager stringWithKey:@"远程域名"],
                          [I18nManager stringWithKey:@"蓝牙交互方式"]];
    self.sectionArray   = @[self.actionArray,self.contentArray];
    
    
   
    if (@available(iOS 11.0, *)) {
        self.infoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    }
    self.infoTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.rowHeight =  UITableViewAutomaticDimension;
    self.infoTableView.estimatedRowHeight = 100;
    self.infoTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bottomContainer.frame.origin.y);
    self.infoTableView.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.infoTableView];
    
    [self.infoTableView registerClass:QYInfoTableViewCell.class forCellReuseIdentifier:titleIdentify];
    [self.infoTableView registerClass:QYConnectTableViewCell.class forCellReuseIdentifier:actionIdentify];
    [self.infoTableView registerClass:QYImageCell.class forCellReuseIdentifier:imageIdentify];
    
    [QYPrinter.sharedInstance addExceptionBlock:^(QYActiveInstructionType exception) {
        if(exception == QYActiveInstructionType_Disconnect) {
            self.ip = nil;
            [self refreshView];
        }
        [self.infoTableView reloadData];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshView];
    });  
}




- (void)refreshView {
    if(!QYPrinter.sharedInstance.printerIsConnect){
        self.bottomContainer.hidden = YES;
        return;
    }
    self.bottomContainer.hidden = NO;
    self.disconnectButton.hidden = NO;
    
    BOOL connectBLE =  QYPrinter.sharedInstance.connectedState == QYPrinterConnectedState_BLE;
    QYPrinterInfo *info = QYPrinter.sharedInstance.connectedPrinterInfo;
    switch (info.device.transmitType) {
        case QYTransmitType_Wifi:{
            self.configView.hidden = !connectBLE;
            self.printContainer.hidden = connectBLE;
        }break;
        case QYTransmitType_BLEWifi:{
            self.configView.hidden = !connectBLE;
            self.printContainer.hidden = NO;
        }break;
        default:{
            self.printContainer.hidden = NO;
            self.configView.hidden = YES;
        }break;
    }
    
    
}

- (void)clickText {
    QYTextActionViewController *imagePicker = [[QYTextActionViewController alloc] initWithNibName:@"QYPrintActionViewController" bundle:nil];
    imagePicker.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:imagePicker animated:YES];
}

- (void)clickImage {
    QYImageActionViewController *imagePicker = [[QYImageActionViewController alloc] initWithNibName:@"QYPrintActionViewController" bundle:nil];
    imagePicker.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:imagePicker animated:YES];
}

- (void)clickFrame {
    QYFrameActionViewController *imagePicker = [[QYFrameActionViewController alloc] initWithNibName:@"QYPrintActionViewController" bundle:nil];
    imagePicker.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:imagePicker animated:YES];
}

- (void)clickConfigNet { //点击配网
    if(!QYPrinter.sharedInstance.printerIsConnect ){
        [XSingleView.sharedInstance show:@"未连接"];
        return;
    }
    QYBLEDevice *device = QYPrinter.sharedInstance.connectedPrinterInfo.device;
    switch (device.transmitType) {
        case QYTransmitType_BLE:{
            [XSingleView.sharedInstance show:[I18nManager stringWithKey:@"只能蓝牙连接,不能配网"]];
        }break;
        case QYTransmitType_BLEWifi:
        case QYTransmitType_Wifi:{
            [QYPrinter.sharedInstance openSetupNetModel:^(BOOL success,NSError *error) { //进入配网状态回调
                if(success){
                    [XSingleView.sharedInstance show:[I18nManager stringWithKey:@"进入配网成功"]];
                    QYWifiSelectViewController *wifiSelectViewController = [[QYWifiSelectViewController alloc] init];
                    wifiSelectViewController.hidesBottomBarWhenPushed = YES;
                    __weak PrinterHomeViewController *weakSelf = self;
                    wifiSelectViewController.didGetIp = ^(NSString * _Nonnull ip) {
                        [XSingleView.sharedInstance show:[I18nManager stringWithKey:@"获得Ip"]];
                        weakSelf.ip = ip;
                    };
                    [self.navigationController pushViewController:wifiSelectViewController animated:YES];
                }
                else {
                    [XSingleView.sharedInstance show:[I18nManager stringWithKey:@"配网失败"]];
                }
            }];
        }break;
        default:{}
    }
}

- (void)clickConnectWifi { //点击链接Wi-Fi
//    if(!QYPrinter.sharedInstance.printerIsConnect ){
//        [XSingleView.sharedInstance show:@"未连接"];
//        return;
//    }
#if DEBUG
    self.ip = @"192.168.31.128";
#endif
    if(!self.ip){
        [XSingleView.sharedInstance show:[I18nManager stringWithKey:@"需要先配网"]];
        return;
    }
    NSString *modelName =  QYPrinter.sharedInstance.connectedPrinterInfo.device.modelName;
    NSString *ip = self.ip;
    
    [QYPrinter.sharedInstance connectWifiWithIp:ip
                                      modelName:modelName ? : @"S823"
                                     completion:^(BOOL isSuccess, NSError *error) { //连接成功
        
        if(isSuccess){
            [XSingleView.sharedInstance show:[I18nManager stringWithKey:@"连接成功"]];
            [self.navigationController popViewControllerAnimated:YES];
            
            [QYPrinter.sharedInstance queryPrinterInfoWithInstructions:@[@(QYQueryInstructionType_WorkState)]
                                                               timeout:10 completion:^(NSDictionary *printInfo, NSError *error) {
                NSLog([I18nManager stringWithKey:@"工作状态%@"],printInfo);
            }];
        }
        else {
            [XSingleView.sharedInstance show:[I18nManager stringWithKey:@"连接失败"]];
        }
        [self refreshView];
        [self.infoTableView reloadData];
    }];
}

- (void)clickDisconnect { //点击断开连接
    [QYPrinter.sharedInstance disConnectPrinter:^(BOOL isSuccess, BOOL isBLE) {
        [XSingleView.sharedInstance show:isSuccess ? [I18nManager stringWithKey:@"断开连接成功"] : [I18nManager stringWithKey:@"断开连接失败"]];
        self.ip = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.infoTableView reloadData];
            [self refreshView];
        });
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYPrintActionViewController *viewController = [[QYPrintActionViewController alloc] init];
            viewController.image = image;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        });
    }];
}


- (void)clickConnect {
    QYPrinterListViewController* printerListViewController = [[QYPrinterListViewController alloc] init];
    printerListViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:printerListViewController animated:NO];
    printerListViewController.didClickConnectDevice = ^(QYBLEDevice * _Nonnull device) {
        [QYPrinter.sharedInstance connectPrinterWithDevice:device
                                                completion:^(BOOL isSuccess,NSError *error) {
            if (isSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
                [XHudManager.sharedInstance hidden];
            }else {
                [XSingleView.sharedInstance show:[I18nManager stringWithKey:@"连接失败"]];
            }
        }];
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)(self.sectionArray[section])).count;
}
#define setCotent(index,property)\
do{\
if(row == index) {\
    property ? content = property : 0x0;\
}\
}while(0);

#define setCotent_ins(index,property,ins)\
do{\
if(row == index) {\
    BOOL support = [device isSupportedQueryWithInstructionType:ins];\
    if(!support){ \
        content = [I18nManager stringWithKey:@"不支持"]; \
    } \
    else{property ? content = property : 0x0;}\
}\
}while(0);

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section, row =  indexPath.row;
    UITableViewCell *cell ;
    switch (section) {
        case 0:{
            if(row == 0) {
                NSDictionary *dic = self.actionArray[row];
                QYConnectTableViewCell *cell_ = ((QYConnectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:actionIdentify forIndexPath:indexPath]);
                cell_.titleLabel.text = dic[@"title"];
                if(QYPrinter.sharedInstance.printerIsConnect) {
                    cell_.titleLabel.text = [NSString stringWithFormat:[I18nManager stringWithKey:@"%@-(%@)"],QYPrinter.sharedInstance.connectedPrinterInfo.device.modelName,QYPrinter.sharedInstance.connectedState == QYPrinterConnectedState_BLE ? [I18nManager stringWithKey:@"蓝牙"] :@"wifi"];
                    cell_.contentLabel.text =  [I18nManager stringWithKey:@"已连接-点击进入连接其他机器"];
                }
                else{
                    cell_.contentLabel.text =  dic[@"action"];
                }
                //NSString *iconUrl =  QYPrinter.sharedInstance.connectedPrinterInfo.device.iconUrl;
                //[cell_.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
                cell = cell_;
            }
            else if (row == 1) {
                NSDictionary *dic = self.actionArray[row];
                QYImageCell *cell_ = ((QYImageCell*)[tableView dequeueReusableCellWithIdentifier:imageIdentify forIndexPath:indexPath]);
                //NSString *pictureUrl =  QYPrinter.sharedInstance.connectedPrinterInfo.device.pictureUrl;
                //[cell_.contentImageView sd_setImageWithURL:[NSURL URLWithString:pictureUrl]];
                cell = cell_;
            }
        }break;
        case 1:{
            /*@[@"设备名称",@"固件版本号",@"SN",@"MAC地址",@"剩余电量"];*/
            NSString *title = self.contentArray[row];
            QYInfoTableViewCell *cell_ = ((QYInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:titleIdentify forIndexPath:indexPath]);
            cell_.titleLabel.text = title;
            NSString *content = @"/";
            QYPrinterInfo *info = QYPrinter.sharedInstance.connectedPrinterInfo;
            QYBLEDevice *device = info.device;
            
            setCotent(0, info.device.modelName)
            setCotent_ins(1, info.firmwareVersion,QYQueryInstructionType_FirmwareVersion)
            setCotent_ins(2, info.sn,QYQueryInstructionType_SN)
            setCotent_ins(3, info.device.mac,QYQueryInstructionType_mac)
            if(row == 4) {
                BOOL support =  [device isSupportedQueryWithInstructionType:QYQueryInstructionType_Battery];
                if(support){
                    info.remainingBattery ?  content = [NSString stringWithFormat:@"%d%%",info.remainingBattery] : 0x0;
                }
                else {
                    content = [I18nManager stringWithKey:@"不支持"];
                }
            }
            setCotent_ins(5, info.rfidOverLengthInfoList.firstObject.description,QYQueryInstructionType_RFIDOverLength)
            
            if(row == 6) {
                BOOL support1 =  [device isSupportedQueryWithInstructionType:QYQueryInstructionType_RFID];
                BOOL support2 =  [device isSupportedQueryWithInstructionType:QYQueryInstructionType_RFIDDetail];
                if(!support1 && !support2) {
                    content = [I18nManager stringWithKey:@"不支持"];
                }
                else {
                    setCotent(6, info.rfidInfoList.firstObject.description)
                }
                
            }
            setCotent_ins(6, info.rfidInfoList.firstObject.description,QYQueryInstructionType_RFIDDetail)
            setCotent_ins(7, ([NSString stringWithFormat:[I18nManager stringWithKey:@"%d分钟"],info.shutdownTime]),QYQueryInstructionType_ShutdownTime)
            setCotent_ins(8, ([NSString stringWithFormat:@"%@",info.outofPaper ? [I18nManager stringWithKey:@"缺纸"]:[I18nManager stringWithKey:@"有纸"]]),QYQueryInstructionType_PaperState)
            setCotent_ins(9, ([NSString stringWithFormat:@"%@",info.coverIsOpen ? [I18nManager stringWithKey:@"开盖"]:[I18nManager stringWithKey:@"关盖"]]),QYQueryInstructionType_CoverState)
            setCotent_ins(10, ([NSString stringWithFormat:@"%@",info.coverIsOpen ? [I18nManager stringWithKey:@"按下"]:[I18nManager stringWithKey:@"松开"]]),QYQueryInstructionType_CutState) //切刀状态
            setCotent_ins(11, ([NSString stringWithFormat:@"%@",info.hardwareVersion ? :@"/"]),QYQueryInstructionType_HardwareVersion)//硬件版本，暂时没有
            setCotent_ins(12, ([NSString stringWithFormat:@"%@",info.communicateVersion ? :@"/"]),QYQueryInstructionType_ComunicateVersion)//通讯版本，暂时没有
            setCotent_ins(13, ([NSString stringWithFormat:[I18nManager stringWithKey:@"没处理"]]),QYQueryInstructionType_CompressDataSize)//可压缩数据包大小，暂时没有
            setCotent_ins(14, ([NSString stringWithFormat:@"%@",info.bleType == QYBLEType_JIELI ? [I18nManager stringWithKey:@"Jieli"]:[I18nManager stringWithKey:@"普通"]]),QYQueryInstructionType_BLEType);
            setCotent_ins(15, ([NSString stringWithFormat:@"%@",[self ribbonStateStr]]),QYQueryInstructionType_RibbonState); //碳带状态，暂时没有
            setCotent_ins(16, ([NSString stringWithFormat:@"%@",info.wifiName ?: @"/" ]),QYQueryInstructionType_Wifi); //wifi名字，暂时没有
            setCotent_ins(17, ([NSString stringWithFormat:@"%@",info.ip ? :  @"/"]),QYQueryInstructionType_Ip); //ip，暂时没有
            setCotent_ins(18, ([NSString stringWithFormat:@"/"]),QYQueryInstructionType_WorkState); //工作状态，暂时没有
            setCotent_ins(19, ([NSString stringWithFormat:@"%@",info.remoteDomain ? :@"/"]),QYQueryInstructionType_RemotePrintDomain); //远程域名
            setCotent_ins(20, ([NSString stringWithFormat:[I18nManager stringWithKey:@"%@支持一个令牌发多个包"],info.is6951Chip ? @"":[I18nManager stringWithKey:@"不"]]),QYQueryInstructionType_BLEInteractiveMode); //蓝牙交互方式
            
            cell_.contentLabel.text = content;
            cell = cell_;
            
        }break;
        default:
            break;
    }
    return cell;
}

- (NSString*)ribbonStateStr {
    QYPrinterInfo *info = QYPrinter.sharedInstance.connectedPrinterInfo;
    switch (info.ribbonState) {
        case QYRibbonState_Exit:
            return [I18nManager stringWithKey:@"有碳带"];
        case QYRibbonState_Error:
            return [I18nManager stringWithKey:@"碳带状态异常"];
        case QYRibbonState_Remaining:
            return [I18nManager stringWithKey:@"碳带有余量"];
        default:
            break;
    }
    return    [I18nManager stringWithKey:@"碳带状态未知"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section, row =  indexPath.row;
    if(section == 0) {
        NSDictionary *dic = self.actionArray[row];
        NSString *sel = dic[@"sel"];
        if(sel) {
            [self performSelector:NSSelectorFromString(sel)];
        }
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(QYPrinter.sharedInstance.printerIsConnect){
//        [XHudManager.sharedInstance show:@"正在查询配置支持的设备信息"];
//        QYBLEDevice *device = QYPrinter.sharedInstance.connectedPrinterInfo.device;
//        NSArray *arrays =  device.supportedQueryType;
//        [QYPrinter.sharedInstance queryPrinterInfoWithInstructions:arrays
//                                                           timeout:4
//                                                        completion:^(NSDictionary *printInfo, NSError *error) {
//            
//            NSLog(@"printinfo:%@",printInfo);
//            NSLog(@"error:%@",error);
//                    
//        }];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [XHudManager.sharedInstance hidden];
//            [self.infoTableView reloadData];
//        });
        
        //self.connectView.hidden = false;
    }
    else {
        //self.connectView.hidden = YES;
    }
    [self refreshView];
    [self.infoTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
     
}

- (UITableView *)infoTableView {
    if(!_infoTableView){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _infoTableView =tableView;
    }
    return _infoTableView;
}

- (UIView *)bottomContainer {
    if(!_bottomContainer) {
        _bottomContainer = [[UIView alloc] init];
    }
    return _bottomContainer;
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
