//
//  QYPrintActionViewController.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "QYPrintActionViewController.h"
#import "QYPrintModel.h"
#import "QYClickEditCell.h"
#import "QYSetSelectCell.h"
#import "QYClickSelectCell.h"
#import  <QYPrintSDK/QYPrinter.h>
#import "XHudManager.h"
#import "XSingleView.h"
#import <QYPrintSDK/QYBLEDevice.h>
#import "I18nManager.h"

const NSString *unknown =  @"unknown";

typedef NS_ENUM(NSInteger,CellType){
    CellType_Material,
    CellType_Angle,
    CellType_Con,
    CellType_ConCoi,
    CellType_Speed,
    CellType_HorizonOffset,
    CellType_VerticalOffset,
    CellType_ImageMan,
    CellType_PaperFormat,
    CellType_Copy,
    CellType_ColorScale,
    CellType_Ciphertext, //加密
    CellType_Location,
    CellType_VerticleLocation, //垂直方向对齐
    CellType_PerPaper,  //是否分页打印
    CellType_AntiTinkle,  //抗皱模式
    CellType_PicHandle,  //图片算法
    CellType_CompressData  //压缩
};
@interface QYPrintActionViewController ()<UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *widthTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightTextfiled;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong)NSMutableDictionary *modelDictionary;

@property(nonatomic, strong)NSArray *dataList;
@property(nonatomic, assign)BOOL showSetting;


//
@property(nonatomic, assign) int contentW_mm;
@property(nonatomic, assign) int contentH_mm;
@property(nonatomic, assign) int contentW_dot;
@property(nonatomic, assign) int contentH_dot;
@end

@implementation QYPrintActionViewController


- (UIImage *)QRotateImage:(UIImage *)image
                   angle:(CGFloat)angle {
    CGAffineTransform t = CGAffineTransformMakeRotation(angle);
    CGRect sizeRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGRect destRect = CGRectApplyAffineTransform(sizeRect, t);
    CGSize destinationSize = CGSizeMake((int)destRect.size.width, (int)destRect.size.height);
    UIGraphicsBeginImageContextWithOptions(destinationSize, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, destinationSize.width/2, destinationSize.height/2);
    CGContextRotateCTM(context, angle);
    [image drawInRect:CGRectMake(-image.size.width/2, -image.size.height/2, image.size.width, image.size.height)];
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
    
}



- (QYPrintModel*)paperTypeModel {
    QYPrintModel *model1 =   [[QYPrintModel alloc] init];
    model1.title = @"纸张类型";
    model1.style = CellStyle_Select;
    
    QYBLEDevice *device = QYPrinter.sharedInstance.connectedPrinterInfo.device;
    
    NSDictionary *dictinary = @{@(QYPaperType_Continuous) : [I18nManager stringWithKey:@"连续纸"],
                                @(QYPaperType_LocationHole) : [I18nManager stringWithKey:@"定孔位"],
                                @(QYPaperType_Interval) : [I18nManager stringWithKey:@"间隙纸"],
                                @(QYPaperType_BlackLabel) : [I18nManager stringWithKey:@"黑标纸"],
                                @(QYPaperType_FoldPaper) : [I18nManager stringWithKey:@"折叠纸"],
                                @(QYPaperType_Tatto) : [I18nManager stringWithKey:@"纹身纸"],
                                @(QYPaperType_SinglePage) : [I18nManager stringWithKey:@"单张纸"],
                                
    };
    NSArray *paperTypeArray = @[[I18nManager stringWithKey:@"连续纸"],
                                [I18nManager stringWithKey:@"定孔位"],
                                [I18nManager stringWithKey:@"间隙纸"],
                                [I18nManager stringWithKey:@"黑标纸"],
                                [I18nManager stringWithKey:@"折叠纸"],
                                [I18nManager stringWithKey:@"纹身纸"],
                                [I18nManager stringWithKey:@"单张纸"]];
    if (paperTypeArray.count == 0) {
        model1.content = unknown;
    }
    else {
        model1.content = paperTypeArray.firstObject;
    }
    model1.selectScope = paperTypeArray;
    model1.content = paperTypeArray.firstObject;
    return model1;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(clickHidden)];
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer: tap];
 
    
    QYBLEDevice *device = QYPrinter.sharedInstance.connectedPrinterInfo.device;
    {
        QYPrintModel *model1 = [self paperTypeModel];
        
        
        
        QYPrintModel *model12 = [[QYPrintModel alloc] init];
        model12.title = [I18nManager stringWithKey:@"纸张规格"];
        model12.content = unknown;
        model12.style = CellStyle_Select;
        model12.selectScope = @[unknown];
        {
            int selectIndex = model1.selectIndex;
            if(selectIndex == 0
               && [model1.content isEqualToString:unknown]){
                model12.selectScope = @[];
                self.widthTextField.text = nil;
                self.heightTextfiled.text = nil;
                return;
            }
            

            NSArray *array_paperName = @[@"A4",@"A5",@"B5",@"53mm",@"80mm",@"110mm"];
            model12.selectScope = array_paperName;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                QYPaperItem *item = [self paperFormatModelWithIndex:model12.selectIndex];
                self.widthTextField.text = [NSString stringWithFormat:@"%d",item.width];
                self.heightTextfiled.text = [NSString stringWithFormat:@"%d",item.height];
            });
            
        }
        
        
        
        
        QYPrintModel *model11 = [[QYPrintModel alloc] init];
        model11.title = [I18nManager stringWithKey:@"旋转角度"];
        model11.content = @"0";
        model11.style = CellStyle_Select;
        model11.selectScope = @[@"0",@"90",@"270"];
        
        QYPrintModel *model2 =  nil;
        {
            model2 = [[QYPrintModel alloc] init];
            model2.title = [I18nManager stringWithKey:@"打印浓度"];
            model2.style = CellStyle_Select;
            
            {
                int selectIndex = 0;
                NSMutableArray  *levels  = [[NSMutableArray alloc] init];
                int sub_index = 0;
                for (NSString *info in @[@"2",@"4",@"6"]) {
                    [levels addObject:info];
                    sub_index ++;
                }
                model2.selectScope = levels;
                model2.selectIndex = 0;
            }
        }
       
        
        QYPrintModel *model3 = nil;
        QYSpeedInfo *info =  device.speedInfo;
        if(info){
            model3 = [[QYPrintModel alloc] init];
            model3.title = [I18nManager stringWithKey:@"打印速度"];
            model3.style = CellStyle_Select;
            model3.selectIndex = 5;
            model3.selectScope = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"]; {
                NSMutableArray *scope = [NSMutableArray array];
                int selectIndex = 0, sub_index = 0;
                for (int index = info.startValue;index <= info.endValue; index++) {
                    [scope addObject:[NSString stringWithFormat:@"%d",index]];
                    if(index == info.defaultValue){
                        selectIndex = sub_index;
                    }
                    sub_index++;
                }
                model3.selectIndex = selectIndex;
                model3.selectScope = scope;
            }
            
        }
        
        
        QYPrintModel *model4 = [[QYPrintModel alloc] init];
        model4.title = [I18nManager stringWithKey:@"左右偏移调整"];
        model4.style = CellStyle_Edit;
        model4.canNeg = YES;
        
        QYPrintModel *model5 = [[QYPrintModel alloc] init];
        model5.title = [I18nManager stringWithKey:@"上下偏移调整"];
        model5.canNeg = YES;
        model5.style = CellStyle_Edit;
        
        QYPrintModel *model51 = [[QYPrintModel alloc] init];
        model51.title = [I18nManager stringWithKey:@"图片处理"];
        model51.content = [I18nManager stringWithKey:@"剪裁"];
        model51.style = CellStyle_Select;
        model51.selectScope = @[[I18nManager stringWithKey:@"剪裁"],[I18nManager stringWithKey:@"缩放"]];
        
        QYPrintModel *model52 = [[QYPrintModel alloc] init];
        model52.title = [I18nManager stringWithKey:@"水平对齐方式"];
        model52.selectIndex = 1;
        model52.style = CellStyle_Select;
        model52.selectScope = @[[I18nManager stringWithKey:@"居左"],[I18nManager stringWithKey:@"居中"],[I18nManager stringWithKey:@"居右"]];
        
        QYPrintModel *model53 = [[QYPrintModel alloc] init];
        model53.title = [I18nManager stringWithKey:@"垂直对齐方式"];
        model53.selectIndex = 1;
        model53.style = CellStyle_Select;
        model53.selectScope = @[[I18nManager stringWithKey:@"居上"],[I18nManager stringWithKey:@"居中"],[I18nManager stringWithKey:@"居下"]];
        
    
        
        QYPrintModel *model6 = [[QYPrintModel alloc] init];
        model6.title = [I18nManager stringWithKey:@"打印份数"];
        model6.clickValue = 1;
        model6.style = CellStyle_Edit;
        
        QYPrintModel *model61 = [[QYPrintModel alloc] init];
        model61.title = [I18nManager stringWithKey:@"连续纸是否分页打印"];
        model61.selectIndex = 0;
        model61.selectScope = @[[I18nManager stringWithKey:@"连续"],[I18nManager stringWithKey:@"分页"]];
        model61.style = CellStyle_Select;
        
        NSArray *scales =  device.supportedColorScale;
        QYPrintModel *model7 =  [[QYPrintModel alloc] init];
        model7.title = [I18nManager stringWithKey:@"打印阶数"];
        model7.selectIndex = 0;
        model7.style = CellStyle_Select;
        NSMutableArray *scalesArray = [NSMutableArray array];
        for (NSNumber *numer  in scales) {
            [scalesArray  addObject: [NSString stringWithFormat:[I18nManager stringWithKey:@"%d阶"],numer.intValue]];
        }
        model7.selectScope = scalesArray;
        
        
        
        QYPrintModel *model8 = [[QYPrintModel alloc] init];
        model8.title = [I18nManager stringWithKey:@"是否加密"];
        model8.selectIndex = 0;
        model8.style = CellStyle_Select;
        model8.selectScope = @[[I18nManager stringWithKey:@"不加密"],[I18nManager stringWithKey:@"加密"]];
        
        QYPrintModel *model81 = nil;
        BOOL supportCompress = device.isSupportCompress;
        if(supportCompress) {
            model81 = [[QYPrintModel alloc] init];
            model81.title = [I18nManager stringWithKey:@"是否压缩"];
            model81.selectIndex = 0;
            model81.style = CellStyle_Select;
            model81.selectScope = @[[I18nManager stringWithKey:@"不压缩"],[I18nManager stringWithKey:@"压缩"]];
        }
        
        QYPrintModel *model9 = nil ;
        if(device.isSupportAntiwrinkle){
            model9 =  [[QYPrintModel alloc] init];
            model9.title = [I18nManager stringWithKey:@"抗皱模式"];
            model9.selectIndex = 0;
            model9.style = CellStyle_Select;
            model9.selectScope = @[[I18nManager stringWithKey:@"关闭"],[I18nManager stringWithKey:@"弱"],[I18nManager stringWithKey:@"强"]];
        }
     
        
        QYPrintModel *model10 = [[QYPrintModel alloc] init];
        model10.title = [I18nManager stringWithKey:@"图片算法"];
        model10.selectIndex = 0;
        model10.style = CellStyle_Select;
        model10.selectScope = @[[I18nManager stringWithKey:@"抖动"],[I18nManager stringWithKey:@"230分割"],[I18nManager stringWithKey:@"127分割"]];
        
        self.modelDictionary = @{
            @(CellType_Material): model1,
            @(CellType_Angle): model11,
            @(CellType_HorizonOffset): model4,
            @(CellType_VerticalOffset): model5,
            @(CellType_ImageMan): model51,
            @(CellType_Location): model52,
            @(CellType_VerticleLocation): model53,
            @(CellType_Copy): model6,
            @(CellType_PerPaper): model61,
            @(CellType_PaperFormat):model12,
            @(CellType_ColorScale):model7,
            @(CellType_Ciphertext):model8,
            @(CellType_PicHandle) :model10,
        }.mutableCopy;
        model2  ? (self.modelDictionary[@(CellType_Con)] = model2) : 0x0;
        model3  ? (self.modelDictionary[@(CellType_Speed)] = model3) : 0x0;
        model81 ? (self.modelDictionary[@(CellType_CompressData)] = model81) : 0x0;
        model9 ? (self.modelDictionary[@(CellType_AntiTinkle)] = model9) : 0x0;
        
        NSMutableArray *section2 = @[model11].mutableCopy;
        if(model2) [section2 addObject:model2];
        if(model3) [section2 addObject:model3];
        [section2 addObjectsFromArray:@[model4,
                                        model5,
                                        model51,model52,model53,model10]];
        
        NSMutableArray *section3 = @[model6,model61,model7,model8].mutableCopy;
        if(model81) [section3 addObject:model81];
        if(model9) [section3 addObject:model9];
        
        
        self.dataList = @[@[model1,
                            model12],
                           section2,section3];
        [self.tableView registerNib:[UINib nibWithNibName:@"QYClickEditCell" bundle:nil] forCellReuseIdentifier:@"QYClickEditCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"QYClickSelectCell" bundle:nil] forCellReuseIdentifier:@"QYClickSelectCell"];
    }
    
    if ([QYPrinter sharedInstance].connectedPrinterInfo.device.maxPrintWidthInDot >= 384) {
        self.contentW_mm = 40;
        self.contentH_mm = 30;
    }else {
        self.contentW_mm = 40;
        self.contentH_mm = 20;
    }
    
    self.contentW_dot = _contentW_mm*8;
    self.contentH_dot = _contentH_mm*8;
    

    
    self.bottomContainer.frame = CGRectMake(0, self.view.frame.size.height - self.bottomContainer.frame.size.height, self.view.frame.size.width, self.bottomContainer.frame.size.height);
    int bottom = self.bottomContainer.frame.origin.y + self.bottomContainer.frame.size.height;
    self.tableView.frame = CGRectMake(0, bottom, self.tableView.frame.size.width,self.tableView.frame.size.height);
    self.tableView.backgroundColor = UIColor.clearColor;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clickSetting:nil];
    });
    
  
    

    // Do any additional setup after loading the view from its nib.
}





- (void)clickHidden {
    self.tableView.editing = false;
    [self.widthTextField resignFirstResponder];
    [self.heightTextfiled resignFirstResponder];
    [[self.view subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:UIPickerView.class]) {
            [obj removeFromSuperview];
        }
    }];
}



- (IBAction)clickSetting:(id)sender {
    if(self.showSetting) {
        self.showSetting = NO;
        int bottom = self.bottomContainer.frame.origin.y + self.bottomContainer.frame.size.height;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.tableView.frame = CGRectMake(0, bottom, self.tableView.frame.size.width,self.tableView.frame.size.height);
          } completion:nil];
        
    }
    else {
        self.showSetting = YES;
        int bottom = self.bottomContainer.frame.origin.y;
        int top = self.contentView.frame.origin.y + self.contentView.frame.size.height;
        int maxHeight = bottom - top;
        float tableViewHeight = self.tableView.contentSize.height <  maxHeight ? self.tableView.contentSize.height :  maxHeight;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.tableView.frame = CGRectMake(0, bottom-tableViewHeight, self.tableView.frame.size.width,tableViewHeight);
          } completion:nil];
    }
}

- (QYPaperType)paperTypeWithIndex:(int)type  {
    return type + 1;
}

- (CGSize)paperFormatWithIndex:(int)type  {
    if(type <= 0){
        return CGSizeZero;
    }
    
    QYPaperItem *item = [self paperFormatModelWithIndex:type];
    return CGSizeMake(item.width, item.height);
}

- (QYPaperItem*)paperFormatModelWithIndex:(int)type  {
    
    QYPrintModel *materialModel = self.modelDictionary[@(CellType_Material)];
    if(!materialModel) {
        return nil;
    }
    BOOL continuous = NO;
    if(materialModel.selectIndex == 0) {
        continuous = YES;
    }
    //NSArray *array_paperName = @[@"A4",@"A5",@"B5",@"53mm",@"80mm",@"110mm"];
    
    QYPaperItem *paperItem = [[QYPaperItem alloc] init];
    paperItem.width = 0;
    paperItem.height = 0;
    if(type == 0) {
        paperItem.width = 210;
        paperItem.height = 297;
    }
    else if (type == 1) {
        paperItem.width = 176;
        paperItem.height = 250;
    }
    else if (type ==2) {
        paperItem.width = 148;
        paperItem.height = 210;
    }
    else if (type == 3) {
        paperItem.width = 53;
    }
    else if (type == 4) {
        paperItem.width = 80;
    }
    else if (type == 5) {
        paperItem.width = 110;
    }
    if (continuous) {
        paperItem.height = 0;
    }
    return paperItem;
}


- (IBAction)clickPrint:(id)sender {
    if(!QYPrinter.sharedInstance.printerIsConnect) {
        [[XHudManager sharedInstance] show:[I18nManager stringWithKey:@"打印机未连接"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [XHudManager.sharedInstance hidden];
        });
        return;
    }
    if(QYPrinter.sharedInstance.connectedPrinterInfo.coverIsOpen) {
        [[XHudManager sharedInstance] show:[I18nManager stringWithKey:@"打印机开盖"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [XHudManager.sharedInstance hidden];
        });
        return;
    }
    
    if(QYPrinter.sharedInstance.connectedPrinterInfo.outofPaper) {
        [[XHudManager sharedInstance] show:@"打印机缺纸"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [XHudManager.sharedInstance hidden];
        });
        return;
    }
    
    QYPrintModel *materialModel = self.modelDictionary[@(CellType_Material)];
    QYPrintModel *angleModel = self.modelDictionary[@(CellType_Angle)];
    QYPrintModel *compressModel = self.modelDictionary[@(CellType_CompressData)];
    QYPrintModel *speedModel = self.modelDictionary[@(CellType_Speed)];
    QYPrintModel *horizonOffsetModel = self.modelDictionary[@(CellType_HorizonOffset)];
    QYPrintModel *verticalOffsetModel = self.modelDictionary[@(CellType_VerticalOffset)];
    QYPrintModel *copiesModel = self.modelDictionary[@(CellType_Copy)];
    QYPrintModel *perPageModel = self.modelDictionary[@(CellType_PerPaper)];
    QYPrintModel *imageManModel = self.modelDictionary[@(CellType_ImageMan)];
    QYPrintModel *paperFormatModel = self.modelDictionary[@(CellType_PaperFormat)];
    QYPrintModel *colorScaleModel = self.modelDictionary[@(CellType_ColorScale)];
    QYPrintModel *cipherModel = self.modelDictionary[@(CellType_Ciphertext)];
    QYPrintModel *locationModel = self.modelDictionary[@(CellType_Location)];
    QYPrintModel *verticleLocationModel = self.modelDictionary[@(CellType_VerticleLocation)];
    QYPrintModel *antiTinkleModel = self.modelDictionary[@(CellType_AntiTinkle)];
    QYPrintModel *picHandleModel = self.modelDictionary[@(CellType_PicHandle)];
    QYPrintModel *conModel = self.modelDictionary[@(CellType_Con)];
    
    QYBLEDevice *device = QYPrinter.sharedInstance.connectedPrinterInfo.device;
//    /*
//     QYPaperType_Continuous     = 1,
//     /**间隙纸*/
//     QYPaperType_Interval       = 2,
//     /**定位孔*/
//     QYPaperType_LocationHole   = 3,
//     /**黑标纸*/
//     QYPaperType_BlackLabel     = 4,
//
//     /// 折叠纸
//     QYPaperType_FoldPaper = 5,
//
//     /**单张纸*/
//     QYPaperType_SinglePage = 6,
//
//     //纹身纸
//     QYPaperType_Tatto = 7,
//
//     */
    int type  = materialModel.selectIndex; //@[@"unknown",@"连续纸",@"定位孔",@"间隙纸",@"黑标纸",@"黑标卡纸",@"折叠纸",@"卡片纸"];
    QYPaperType paperType = [self paperTypeWithIndex:type];
    
    
    int angle = angleModel.selectIndex;
    
//速度
    int speed_index  = speedModel.selectIndex;
    NSString* value = speedModel.selectScope[speed_index];
    int speed = value.intValue;
    
    //浓度
    int con_index  = conModel.selectIndex;
    NSString* con_value = conModel.selectScope[con_index];
    int con = con_value.intValue;
    
    
    
    BOOL isCipher = cipherModel.selectIndex == 1;
    
    int paperHeight = self.heightTextfiled.text.intValue;
    int paperWidth  = self.widthTextField.text.intValue;
    
    
    int copies = copiesModel.clickValue;
    int imageMan = imageManModel.selectIndex;
    
    NSMutableArray *images = [self printImage].copy;
    NSMutableArray * images_ = images.copy;
    if(angle ==1){ //90度，
        images = [NSMutableArray array];
        [images_ enumerateObjectsUsingBlock:^(UIImage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj =  [self  QRotateImage:obj angle:M_PI*0.5];
            [images addObject:obj];
        }];

    }
    else if (angle == 2) {
        images = [NSMutableArray array];
        [images_ enumerateObjectsUsingBlock:^(UIImage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj =  [self  QRotateImage:obj angle:M_PI*1.5];
            [images addObject:obj];
        }];
    }
    
    
    CGSize paperSize = [self paperFormatWithIndex:paperFormatModel.selectIndex];
    BOOL isValidPaperSize = !CGSizeEqualToSize(CGSizeZero, paperSize);
    int paperWidth_ = isValidPaperSize ?  paperSize.width : paperWidth;
    int paperHeight_ = isValidPaperSize ?  paperSize.height: paperHeight;
    
    QYPrintParams *params = [[QYPrintParams alloc] initWithPaperType:paperType paperWidth:paperWidth_ paperHeight:paperHeight_];

    params.con  = con;
    params.speed = speed;
    params.copies  = copies;
    params.scaleImage = imageMan == 0? QYScaleImage_Tail : QYScaleImage_Zoom;
    
    
    params.horizonOffset = horizonOffsetModel.clickValue;
    params.verticalOffset = verticalOffsetModel.clickValue;

    params.colorScale = colorScaleModel.selectIndex == 1 ? QYColorScale_16 : QYColorScale_2;
    params.isCiphertext = isCipher;
    
    if(compressModel){ //是否压缩，对象可能不存在
        params.compressData = compressModel.selectIndex == 1;
    }
    
    params.isSplitPrinting = perPageModel.selectIndex == 1;
    
    if(locationModel.selectIndex == 0) {
        params.userPrintHorizonPosition = QYUserPrintHorizonPostion_Left;
    }else if(locationModel.selectIndex == 1) {
        params.userPrintHorizonPosition = QYUserPrintHorizonPostion_Center;
    }else if(locationModel.selectIndex == 2) {
        params.userPrintHorizonPosition = QYUserPrintHorizonPostion_Right;
    }
    
    if(verticleLocationModel.selectIndex == 0) {
        params.userPrintVerticalPosition = QYUserPrintVerticalPostion_Top;
    }else if(verticleLocationModel.selectIndex == 1) {
        params.userPrintVerticalPosition = QYUserPrintVerticalPostion_Center;
    }else if(verticleLocationModel.selectIndex == 2) {
        params.userPrintVerticalPosition = QYUserPrintVerticalPostion_Bottom;
    }
    
    if(antiTinkleModel ){ //抗皱对象可能不存在
        if(antiTinkleModel.selectIndex == 0) {
            params.antiwrinkleLevel = QYAntiwrinkleLevel_Close;
        } else if(antiTinkleModel.selectIndex == 1) {
            params.antiwrinkleLevel = QYAntiwrinkleLevel_Weak;
        } else if(antiTinkleModel.selectIndex == 2) {
            params.antiwrinkleLevel = QYAntiwrinkleLevel_Strong;
        }
    }
  
    /// M832  QYImageProcessType_Dithering
    /// P3100  QYImageProcessType_AvgGray
    ///  多图和一 QYImageProcessType_Dithering
    if(picHandleModel.selectIndex == 0) {
        params.processType =  QYImageProcessType_Dithering;
    }
    else if (picHandleModel.selectIndex == 1) {
        params.processType = QYImageProcessType_GrayScale;
    }
    else if (picHandleModel.selectIndex == 2) {
        params.processType = QYImageProcessType_AvgGray;
    }
    
    if(!(params.paperType != QYPaperType_Unknown)
       && [QYPrinter sharedInstance].connectedPrinterInfo.device.maxPrintWidthInDot == 0
       && params.paperWidth == 0
       ) {
        [XSingleView.sharedInstance show:@"纸张类型、纸张规格和最大打印点数，纸张宽度数据有误，无法打印"];
        return;
    }
    
    [QYPrinter.sharedInstance printImages:images
                                   params:params
                                 progress:^(int totoal, int current) {
        NSString *string = [NSString stringWithFormat:@"第%d张，总%d张",current,totoal];
        [XSingleView.sharedInstance show:string];
    }
                               completion:^(BOOL isSuccess,float height,NSError *error) {
        if(isSuccess){
            NSString* msg = [NSString stringWithFormat:@"打印完成,高度%f毫米",height];
            [XSingleView.sharedInstance show:msg];
        }
        else {
            [XSingleView.sharedInstance show:error.userInfo[NSLocalizedDescriptionKey]];
        }}];
}

- (void)refreshTableView {
    QYBLEDevice *device = QYPrinter.sharedInstance.connectedPrinterInfo.device;
    NSMutableArray *scope = [NSMutableArray array];
    for (NSString *info  in @[@"2",@"4",@"6"]) {
        [scope addObject:info];
    }
    QYPrintModel *conModel = self.modelDictionary[@(CellType_Con)];
    conModel.selectScope = scope;
    
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 2){
        return 10;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)(self.dataList)[section]).count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *array = self.dataList[indexPath.section];
    QYPrintModel *model = array[indexPath.row];
    UITableViewCell *cell = nil;
    if(model.style == CellStyle_Select) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"QYClickSelectCell" forIndexPath:indexPath];
        QYClickSelectCell *clickSelectCell = (QYClickSelectCell*)cell;
        [clickSelectCell configModel:model];
        clickSelectCell.controller = self;
        clickSelectCell.didSelectPick = ^{
            //处理选择完纸张之后，可选的纸张规格
            if(indexPath.section == 0 && indexPath.row == 0){
                
                QYPrintModel *paperType = array[0];//纸张类型
                int selectIndex = paperType.selectIndex;
                
                QYPrintModel *paperSize = array[1];//纸张规格
                if(selectIndex == 0
                   && [paperType.content isEqualToString:unknown]){
                    NSMutableArray *array_paperName = [NSMutableArray array];
                    [array_paperName addObject:unknown];
                    paperSize.selectScope = array_paperName;
                    paperSize.selectIndex  = 0;
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                    return;
                }
                
                
                QYPaperItem *item = [self paperFormatModelWithIndex:paperSize.selectIndex];
                self.widthTextField.text = [NSString stringWithFormat:@"%d",item.width];
                self.heightTextfiled.text = [NSString stringWithFormat:@"%d",item.height];
            }
            if(indexPath.section == 0 && indexPath.row == 1) {
        
                QYPrintModel *paperSize = array[1];//纸张规格
                QYPaperItem *item = [self paperFormatModelWithIndex:paperSize.selectIndex];
                self.widthTextField.text = [NSString stringWithFormat:@"%d",item.width];
                self.heightTextfiled.text = [NSString stringWithFormat:@"%d",item.height];
                
            }
        };
    }
    else if(model.style == CellStyle_Edit) {
        cell =  [tableView dequeueReusableCellWithIdentifier:@"QYClickEditCell" forIndexPath:indexPath];
        QYClickEditCell *clickSelectCell = (QYClickEditCell*)cell;
        [clickSelectCell configModel:model];
        
    }
    
    return cell;
}









@end
