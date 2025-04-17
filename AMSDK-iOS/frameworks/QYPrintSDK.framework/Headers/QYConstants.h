//
//  QYConstants.h
//  Pods
//
//  Created by aimo on 2023/11/13.
//

#ifndef QYConstants_h
#define QYConstants_h

#import <Foundation/Foundation.h>
#define SafeBlock(block,...)\
do{\
    block ? block(__VA_ARGS__) : 0x0;\
}while(0);

#define SafeBlock_setNil(block,...)\
do{\
    block ? block(__VA_ARGS__) : 0x0;\
    block = nil;\
}while(0);


typedef NS_ENUM(NSInteger,QYUpdateFirmwareResult){
    QYUpdateFirmwareResult_Success,
    QYUpdateFirmwareResult_Failed,
    QYUpdateFirmwareResult_Cancelled
};

/**当前的连接状态*/
typedef NS_ENUM(NSInteger,QYPrinterConnectedState){
    /**无连接*/
    QYPrinterConnectedState_None= 0,
    /**蓝牙连接*/
    QYPrinterConnectedState_BLE,
    /**Wifi连接*/
    QYPrinterConnectedState_Wifi,
};


///考虑到目前有请求指令和返回指令
typedef NS_ENUM(NSInteger,QYQueryInstructionType){
    QYQueryInstructionType_Unknow,
    
    ///参考 https://www.tapd.cn/44347038/documents/show/1144347038001000620?file_type=word
    /**注意：已经有数值的定义，不要变更枚举数值，这是和后端 11 字段一一对应**/
    QYQueryInstructionType_FirmwareVersion = 1, //固件版本
    QYQueryInstructionType_Battery = 2,         //电量
    QYQueryInstructionType_SN = 3,            //获取SN
    QYQueryInstructionType_ShutdownTime = 4,    //关机时间
    QYQueryInstructionType_PaperState = 5,      //纸张状态
    QYQueryInstructionType_CoverState = 6,      //开盖/关盖状态
    QYQueryInstructionType_PrinterHeadTemp = 7,        //打印头温度
    QYQueryInstructionType_LabelPaperWidth = 8,        //标签纸宽度
    QYQueryInstructionType_PaperType = 9,       //纸张类型
    QYQueryInstructionType_CutState = 10,            //切刀状态
    QYQueryInstructionType_mac = 11,     //mac地址
    QYQueryInstructionType_RFIDOverLength = 12,          //RFID主动余量
    QYQueryInstructionType_PrinterExceptionState = 13,          //打印机异常状态
    QYQueryInstructionType_RFID = 14,          //RFID信息
    QYQueryInstructionType_HardwareVersion = 15, //硬件版本
    QYQueryInstructionType_ComunicateVersion = 16, //通讯版本
    QYQueryInstructionType_CompressDataSize = 17, //可压缩数据包大小
    
    QYQueryInstructionType_BLEType = 18, //芯片类型，目前的意思就是查询是否jieli芯片
    /*
     1.查询是否杰里蓝牙(需要最后查询，部分不支持的机型会被该命令吃掉下一条指令)
     2.该指令需要在后边垫一条，不太重要的指令，否则导致其他的问题，譬如问题3
     3.遇到一个case是，查询芯片类型之后，无法正常打印，因为打印头被吃掉了。 表现为关机马上开机，马上打印，第一张有很大概率打印不出来，然后第二张它又行了。
    */
    
    
    
    QYQueryInstructionType_RibbonState = 19,   //碳带状态
    QYQueryInstructionType_Wifi = 20,          //Wifi名字
    QYQueryInstructionType_Ip = 21,             // IP
    QYQueryInstructionType_WorkState = 22,             // 工作状态
    
    QYQueryInstructionType_RemotePrintDomain = 23,    //远程打印域名
    QYQueryInstructionType_BLEInteractiveMode = 24,    //蓝牙交互方式
    QYQueryInstructionType_RFIDDetail = 25,            //RFID详细信息获取
    
    
    
    QYQueryInstructionType_SetInfo = 100,                //打印机设置信息,目前只是B246D中用
    QYQueryInstructionType_UpdateFirmware,       //更新固件版本指令
    
    
    
    /**注意：已经有数值的定义，不要变更枚举数值，这是和后端 11 字段一一对应**/
    
    

};

/**
非查询动作，触发的打印的返回指令，
当然查询也是App 来触发的，但是查询动作是需要配置，所以区别处理
 */
typedef NS_ENUM(NSInteger,QYTriggerInstructionType) {
    QYTriggerInstructionType_PrintSuccess,         //打印成功
    QYTriggerInstructionType_DidIntoAT,            //进入AT模式
    QYTriggerInstructionType_FirmwareCheckCode,      ///固件升级（数据发送完成后返回的校验码）
    QYTriggerInstructionType_FirmwareUpdateFinish    ///固件升级完成
    
};


//下面是打印机主动的回调,不需要去查询或者主动触发
typedef NS_ENUM(NSInteger,QYActiveInstructionType){

    QYActiveInstructionType_OutOfPaper = 1,    //缺纸
    QYActiveInstructionType_IntoPaper,     //上纸
    QYActiveInstructionType_CoverOpen,     //开盖
    QYActiveInstructionType_CoverClose,     //关盖
    QYActiveInstructionType_TempWarning,            //打印头温度警告
    QYActiveInstructionType_RemoveTempWarning,      //移除打印头高温警告
    QYActiveInstructionType_LowPower_10,      //电量低于10%
    QYActiveInstructionType_LowPower_5,       //电量低于5%
    QYActiveInstructionType_LowPower_WillShutDown, //即将关机
    QYActiveInstructionType_RFIDException,   //RFID异常状态
    QYActiveInstructionType_LowPower,        //干电池低电量
    QYActiveInstructionType_CancelPrint,     //取消打印
    QYActiveInstructionType_Disconnect,       //打印机断开链接
    
    /**切刀按下 ， P1000 独有*/
    QYActiveInstructionType_CutePress,
    QYActiveInstructionType_CuteLossen,
    
    
    /**以加密机器专属*/
    QYActiveInstructionType_TTFError, //碳带异常
    QYActiveInstructionType_OutTTF, //碳带耗尽
    QYActiveInstructionType_PaperError, //纸张异常
    QYActiveInstructionType_PaperInsufficient, //纸张余量不足
    QYActiveInstructionType_TapeError,   //色带错误
    QYActiveInstructionType_OutOffTape,  //色带不够
    /**以加密机器专属*/
};

/**RFID耗材类型*/
typedef NS_ENUM(NSInteger,QYRFIDMaterialType){
    QYRFIDMaterialType_Unknown = 0,
    /**色带*/
    QYRFIDMaterialType_Tape            = 3,
    /**碳带*/
    QYRFIDMaterialType_TTF = 2,
    /**纸张*/
    QYRFIDMaterialType_Paper  = 1,
};

/*
 （01不覆膜02覆膜03覆膜线缆）
 */
/**覆膜类型*/
typedef NS_ENUM(NSInteger,QYCoveringMembraneType){
    QYCoveringMembraneType_Unknown,
    /**不覆膜*/
    QYCoveringMembraneType_None            = 1,
    /**覆膜*/
    QYCoveringMembraneType_Be,
    /**覆膜线缆*/
    QYCoveringMembraneType_Line,
};


/**RFID异常类型*/
typedef NS_ENUM(NSInteger,QYRFIDExceptionType){
    QYRFIDExceptionTypeUnknow,
    /**碳带异常*/
    QYRFIDExceptionTypeTTFError            = 15,
    /**碳带耗尽*/
    QYRFIDExceptionTypeTapError           = 16,
    /**纸张异常*/
    QYRFIDExceptionTypePaperError          = 17,
};

/**电池余量类型*/
typedef NS_ENUM(NSInteger,QYBatteryState){
    QYBatteryStateUnknow,
    /**10% 电量*/
    QYBatteryStateLow_10,
    /**5% 电量*/
    QYBatteryStateLow_5,
    /**将要关机*/
    QYBatteryStateLow_WillShutDown,
    /**干电池专属，低电量*/
    QYBatteryStateLow,
};



/**打印机型号*/
typedef  NS_ENUM(NSInteger,QYPrinterModel){ //打印机类型
    QYPrinterModel_UnKnown = 0,
/*=小标支持的类型=*/
    QYPrinterModel_D30,
    QYPrinterModel_D30S,
    QYPrinterModel_D30Pro,
    QYPrinterModel_D35,
    QYPrinterModel_D20,
    QYPrinterModel_D10,
    QYPrinterModel_D50,
    QYPrinterModel_Q30,
    QYPrinterModel_Q32,
    QYPrinterModel_Q30S,
    QYPrinterModel_Q31,
    QYPrinterModel_D31,
    QYPrinterModel_D32,
    QYPrinterModel_A30,
    QYPrinterModel_M110,
    QYPrinterModel_M110C,
    QYPrinterModel_JP02,
    QYPrinterModel_M108,
    QYPrinterModel_M105,
    QYPrinterModel_M109,
    QYPrinterModel_M108_Z,
    QYPrinterModel_M200,
    QYPrinterModel_M200C,
    QYPrinterModel_M206,
    QYPrinterModel_M208,
    QYPrinterModel_M209,
    QYPrinterModel_M220,
    QYPrinterModel_M220S,
    QYPrinterModel_M220C,
    QYPrinterModel_M219,
    QYPrinterModel_M221,
    QYPrinterModel_M120,
    QYPrinterModel_M126,
    QYPrinterModel_M120C,
    QYPrinterModel_M102,
    QYPrinterModel_P12,
    QYPrinterModel_M150,
    
    QYPrinterModel_P12Pro,
    QYPrinterModel_E6000,
    QYPrinterModel_P1000,
    QYPrinterModel_P3100D,
    QYPrinterModel_P3100DJ,
    QYPrinterModel_P3200,
    QYPrinterModel_P3200D,
    QYPrinterModel_LT12,
    QYPrinterModel_LM1600,
    
    QYPrinterModel_M950,
    QYPrinterModel_M960,
    QYPrinterModel_M960D,
    QYPrinterModel_D1600,
    QYPrinterModel_D1600D,
    QYPrinterModel_D480BT,
    QYPrinterModel_D480BTPRO,
    QYPrinterModel_P780,
    QYPrinterModel_P780BT,
    QYPrinterModel_P780BTPRO,
    QYPrinterModel_P24,
    QYPrinterModel_P580,
    QYPrinterModel_D680BT,
    QYPrinterModel_B246D,
    QYPrinterModel_T200,
    QYPrinterModel_T310,
    QYPrinterModel_D550BT,
    QYPrinterModel_CT200,
    QYPrinterModel_CT310BT,
    QYPrinterModel_JY2024,
    QYPrinterModel_PM201,
/*=小标支持类型=*/
    /*=印先生支持的类型 ，含国内和海外=*/
    QYPrinterModel_m02,
    QYPrinterModel_m02x,
    QYPrinterModel_m02l,
    QYPrinterModel_m02xl,
    QYPrinterModel_m02s,
    QYPrinterModel_m02d,
    QYPrinterModel_m02c,
    
    //QYPrinterModel_t02,
    
    QYPrinterModel_m03,
    QYPrinterModel_m03a,
    QYPrinterModel_m03ah,
    
    QYPrinterModel_m04s,
    QYPrinterModel_m04ah,
    QYPrinterModel_m04as,
    
    QYPrinterModel_m822,
    QYPrinterModel_m821,
    QYPrinterModel_m08f,
    QYPrinterModel_t08FS,
    QYPrinterModel_h831,
    
    QYPrinterModel_m02Pro,
    /*=印先生支持的类型，含国内和海外=*/
    
    /*=国内印先生支持的类型=*/
    QYPrinterModel_m02a,
    QYPrinterModel_m02h,
    QYPrinterModel_m02sh,
    QYPrinterModel_m02f,
    QYPrinterModel_y02s,
    QYPrinterModel_y04s,
    QYPrinterModel_m08,
    QYPrinterModel_aSL301,
    QYPrinterModel_aSL301s,
    QYPrinterModel_m03as,
    QYPrinterModel_m03s,
    QYPrinterModel_kP_Q1,
    QYPrinterModel_mr2,
    QYPrinterModel_s821,
    QYPrinterModel_s821x,
    QYPrinterModel_s821k,
    QYPrinterModel_p831,
    QYPrinterModel_jp01_s,
    QYPrinterModel_p831max,
    QYPrinterModel_p832,
    QYPrinterModel_p833,
    QYPrinterModel_r831,
    QYPrinterModel_r831bg,
    QYPrinterModel_r831tk,
    QYPrinterModel_r831yc,
    QYPrinterModel_t831,
    QYPrinterModel_q300,
    QYPrinterModel_q301,
    QYPrinterModel_q302,
    QYPrinterModel_m832,
    QYPrinterModel_m833,
    QYPrinterModel_m836,
    QYPrinterModel_m831,
    QYPrinterModel_aM_X2,
    QYPrinterModel_aM_X1,
    QYPrinterModel_s822,
    QYPrinterModel_s823,
    QYPrinterModel_cs300,
    /*=国内印先生支持的类型=*/
    /*=海外印先生支持的类型=*/
    QYPrinterModel_m02e,
    QYPrinterModel_t02,
    QYPrinterModel_p3100,
    /**这是印先生 p3100d*/
    //QYPrinterModel_p3100d_yxs,
    //QYPrinterModel_p3100dj_yxs,
    /*=海外印先生支持的类型=*/
    QYPrinterModel_tp81,
    QYPrinterModel_tp82,
    QYPrinterModel_m08e,
    QYPrinterModel_sp20,
};


/// 是否wifi打印机
/// - Parameter model: 打印机类型
extern BOOL isWifiDevice(QYPrinterModel model);

/// 是否双模打印机
/// - Parameter model: 打印机类型
extern BOOL isWifiBleDevice(QYPrinterModel model);

/**
 * 蓝牙状态
 */
typedef NS_OPTIONS(NSUInteger, BLEStatus) {
    /**未知*/
    BLEStatusUnknown = 1,
    /**重置中*/
    BLEStatusResetting,
    /**未支持*/
    BLEStatusUnsupported,
    /**未授权*/
    BLEStatusUnauthorized,
    /**已开启*/
    BLEStatusPoweredOff,
    /**已关闭*/
    BLEStatusPoweredOn,
};



/**设备传输方式*/
typedef  NS_ENUM(NSInteger,QYTransmitType){
    QYTransmitType_Unknown = 0,
    /**仅蓝牙传输*/
    QYTransmitType_BLE = 1,
    /**仅Wifi传输*/
    QYTransmitType_Wifi,
    /**蓝牙和Wifi双模传输*/
    QYTransmitType_BLEWifi,
};

/**蓝牙类型*/
typedef  NS_ENUM(NSInteger,QYBLEType){
    QYBLEType_Unknown = -1,
    /**默认蓝牙*/
    QYBLEType_Normal,
    /**JIELI蓝牙*/
    QYBLEType_JIELI,   
};

/**配网方式*/
typedef  NS_ENUM(NSInteger,QYConfigureNetType){
    QYConfigureNetType_Unknown,
    QYConfigureNetType_Direct, //直接配网
    QYConfigureNetType_Declare //进入配网状态前发确认指令到打印机
};

/**电源类型*/
typedef  NS_ENUM(NSInteger,QYPowerType){
    QYPowerType_Unknown,
    QYPowerType_Charge,     //充电
    QYPowerType_Battery,    //干电池
    QYPowerType_Plugin,    //插电工作
};


/**
 * DPI
 */
typedef NS_OPTIONS(int, QPrinterDPI) {
    /**180DPI*/
    PrinterDPI_180 = 180,
    /**200DPI*/
    PrinterDPI_203 = 203,
    /**300DPI*/
    PrinterDPI_300 = 300,
#warning PENGBI  这里不对不能用于计算最大打印点数
    /**高清*/
    PrinterDPI_hd  = 0,
    
};
/**
 * 绘制方向
 */
typedef NS_OPTIONS(int, QDrawDirection) {
    /**靠左*/
    DrawDirectionInLeft     = 1,
    /**靠右*/
    DrawDirectionInRight    = 2,
    /**居中*/
    DrawDirectionInCenter   = 3,
    
};



/**
 * 纸张类型
 */
typedef NS_OPTIONS(int, QYPaperType) {
    QYPaperType_Unknown = 0,
    /**连续纸*/
    QYPaperType_Continuous     = 1,
    /**间隙纸*/
    QYPaperType_Interval       = 2,
    /**定位孔*/
    QYPaperType_LocationHole   = 3,
    /**黑标纸*/
    QYPaperType_BlackLabel     = 4,
    
    /// 折叠纸
    QYPaperType_FoldPaper = 5,
    
    /**单张纸*/
    QYPaperType_SinglePage = 6,
    
    //纹身纸
    QYPaperType_Tatto = 7,
    
    
    

    
    
};

typedef NS_ENUM(NSInteger,QYAntiwrinkleLevel){
    QYAntiwrinkleLevel_Close = 0, //关闭
    QYAntiwrinkleLevel_Weak,
    QYAntiwrinkleLevel_Strong
};




#pragma mark 元素位置信息


/**指令类型*/
typedef NS_ENUM(NSInteger,QYPrinterInstructionType){
    QYPrinterInstructionType_Unknown,
    QYPrinterInstructionType_ESC = 1,
    QYPrinterInstructionType_TSPL,
    QYPrinterInstructionType_ZPL,
    
};

/**图像处理色阶*/
typedef NS_ENUM(NSInteger,QYColorScale){
    QYColorScale_None = -1,
    QYColorScale_2 = 2, //2阶
    QYColorScale_16 = 16 //16阶
};

/**图像处理类型*/
typedef NS_ENUM(NSInteger,QYImageProcessType){
    QYImageProcessType_None = 0,    //不处理
    QYImageProcessType_Dithering,   //抖动
    QYImageProcessType_GrayScale,   //230分割
    QYImageProcessType_AvgGray,     //127分割
    QYImageProcessType_Dithering2, //新版本抖动算法，张师傅说没更多的含义，就是对老版本的优化，所以无法给新的定义
    
};


/**设备设置指令*/
typedef NS_ENUM(NSUInteger, QPrinterSetOrder) {
    /**设置关机时间*/
    PrinterSetOrderSetShutdownTime         = 0,
    /**设置纸张类型*/
    PrinterSetOrderSetParperType           = 1,
    /**设置打印浓度*/
    PrinterSetOrderSetDarkness             = 2,
    /**设置打印速度*/
    PrinterSetOrderSetPrintSpeed           = 3,
    /**永久设置打印浓度*/
    PrinterSetOrderSetDarknessForever      = 4,
    /**永久设置打印速度*/
    PrinterSetOrderSetPrintSpeedForever    = 5,
    /**设置打印浓度系数 */
    PrinterSetOrderSetPrintConcentrationCoefficient = 6,
    /**设置远程域名*/
    PrinterSetRemoteHost= 7,
};

typedef NS_ENUM(NSInteger,QYBtNameMatchType){
    QYBtNameMatchType_Unknown = 0 ,
    QYBtNameMatchType_Prefix,  ///前缀匹配
    QYBtNameMatchType_Exact,  ///精确匹配
};


typedef NS_ENUM(NSInteger,QYPrintDirection){
    QYPrintDirection_Unknown,
    /**打印方向从左开始*/
    QYPrintDirection_Left,
    /*居中打*/
    QYPrintDirection_Center,
    /**打印方向从右开始打*/
    QYPrintDirection_Right,
};
typedef NS_ENUM(NSInteger,QYBracketPosition){
    QYBracketPosition_Unknown,
    /**支架位置 左*/
    QYBracketPosition_Left,
    /**支架位置 中*/
    QYBracketPosition_Center,
    /**支架位置 右*/
    QYBracketPosition_Right,
};

typedef NS_ENUM(NSInteger,QYOffTimeType){
    QYOffTimeType_Unknown = -1,
    QYOffTimeType_NoAutoShutOff = 0,
    /**计算方式*/
    QYOffTimeType_Calculate,
    /**查表方式*/
    QYOffTimeType_Lookup,
};


@class QYBLEDevice;
extern BOOL notSupportPrintSuccess(QYBLEDevice* device);
extern BOOL notSupportPrintSuccess_model(QYPrinterModel model);

///是否A4纸张
///参数是毫米
BOOL isA4Paper(int width,int height);
///是否LTR纸张
///参数是毫米
BOOL isLetterPaper(int width,int height);
///是否A5纸张
///参数是毫米
#ifdef __cplusplus
extern "C"  BOOL isA5Paper(int width,int height);
#else
BOOL isA5Paper(int width,int height);
#endif
///是否B5纸张
///参数是毫米
BOOL isB5Paper(int width,int height);

///是否B5W纸张
///参数是毫米
BOOL isB5WPaper(int width,int height);

///是否53mm毫米纸
BOOL is53MMPaper(int width,int height);
///是否80mm毫米纸
BOOL is80MMPaper(int width,int height);
///是否15mm毫米纸
BOOL is15MMPaper(int width,int height);


BOOL isA4ContinuousPaper(QYPaperType type,int width,int height);

extern  BOOL isSmallSizePaper(int width,int height);
extern  BOOL isSmallSizeContinuousPaper(QYPaperType type,int width,int height);

BOOL isCardPaper(QYPaperType type,int width, int height);
#ifdef __cplusplus
extern "C" BOOL isSplitPrint(QYPaperType type,BOOL isContinuePaperSplit);
#else
BOOL isSplitPrint(QYPaperType type,BOOL isContinuePaperSplit);
#endif




extern NSString *QYPrintIsReadyKey;  //打印机准备好
extern NSString *QYPrintIntoPaperKey; //上纸
extern NSString *QYPrintCoverIsOpenKey;  //开盖
extern NSString *QYPrintOutofPaperKey ; //缺纸
extern NSString *QYPrintPaperTypeKey ; //纸张类型
extern NSString *QYPrintFirmwareVesionKey ; //固件版本
extern NSString *QYPrintTemWarningKey; //高温警告
extern NSString *QYPrintTemWarningRemoveKey;     //移除高温警告
extern NSString *QYPrintPrintSuccessKey ;     //打印成功
extern NSString *QYPrintPrintCancelKey;     //打印取消
extern NSString *QYPrintRFIDSerialKey;     //RFID 编号
extern NSString *QYPrintMaterialTypeKey;     //RFID 耗材类型，纸张，色带，碳带
extern NSString *QYPrintBackgroundColorKey;     //色带背景色
extern NSString *QYPrintContentColorKey;     //色带字色
extern NSString *QYPrintCoveringMembraneTypeKey;     //覆膜类型
extern NSString *QYPrintLabelWidthKey;     //标签宽度
extern NSString *QYPrintLabelLengthKey;     //标签长度
extern NSString *QYPrintBatteryStateKey;      //10%电量 5%电量，低电量....类型
extern NSString *QYPrintBatteryValueKey;          //10， 5 ，3
extern NSString *QYPrintShutdownTimeKey;     //自动关机时间
extern NSString *QYPrintRFIDOverLengthKey;     //RFID主动余量
extern NSString *QYPrintFirmwareCheckCodeKey;     //固件更新码
extern NSString *QYPrintSNKey;     //SN号
extern NSString *QYPrintIpKey;     //连接的Ip
extern NSString *QYPrintConnectedWifiNameKey;     //连接的Wifi名称
extern NSString *QYPrintSetArrayKey; //设置数据，目前只用于面单机
extern NSString *QYPrintRFIDExceptionTypeKey; //RFID异常类型
extern NSString *QYPrintBLEKey; //蓝牙类型
extern NSString *QYPrinterIsReadyKey; //wifi连接的情况下打印机是否可用
extern NSString *QYRibbonStateKey;    //碳带状态
extern NSString *QYMacKey;     //mac地址
extern NSString *QY6951ChipKey;     //是否6951Chip
extern NSString *QYPackageCountPerCreditKey; //每个令牌的包个数
extern NSString *QYCutIsPressKey; //切刀是否按下
extern NSString *QYRemoteDomainKey; //远程域名
extern NSString *QYPrintHardwareVesionKey; //硬件版本
extern NSString *QYPrintCommunicateVesionKey; //通讯版本
extern NSString *QYPrintHeadTempKey; //打印头温度
extern NSString *QYUpdateFirmwareSuccessKey; //打印头温度


extern  NSString *QYPrintSDKErrorDomain;

typedef NS_ENUM(NSInteger,QYErrorType){
    ///通用错误码
    QYErrorType_Unknown = -1,
    QYErrorType_Success = 0, //成功
    QYErrorType_Timeout = 1,
    QYErrorType_BluetoothUnavaliable = 2,
    QYErrorType_Disconnect = 3,
    QYErrorType_RemoteConnect = 4,
    QYErrorType_Busy = 5,
    
    //连接错误码
    QYErrorType_ConnectTypeUnavaliable = 201,
    QYErrorType_QueryNecessaryInfoFail = 202,
    QYErrorType_BlueToothMatchDeviceFail = 211,
    QYErrorType_BlueToothUnSupported = 212,         //
    QYErrorType_BlueToothConnectException = 213,    //蓝牙连接异常
    ///214, 215,216 是 Android 特有的设备
    QYErrorType_WifiIsConnected = 217, //wifi连接中
    
    QYErrorType_LanUnSupported = 221,       //不支持的型号
    QYErrorType_LanConnectException = 222,  //连接异常
    QYErrorType_RemoteNoAdapter = 231,      //未设置远程适配器
    QYErrorType_RemoteOffline = 232,        //未设置远程适配器
    
    //配网错误码
    QYErrorType_SendWifiError = 301, //发送wifi信息失败
    
    //固件升级
    QYErrorType_UpgradeUnsupported = 401,    //不支持升级
    QYErrorType_CRCCheckFail = 402,          //CRC 校验失败
    QYErrorType_UpgradeCanceled = 403,       //升级被取消
    QYErrorType_Upgrading = 404,       //正在升级中
    
    //打印
    QYErrorType_CannotPrint = 501,          //不可打印，譬如缺纸等
    QYErrorType_PrintContentEmpty = 502,    //打印内容为空
    QYErrorType_PrintParamsError = 503,     //打印参数错误
    QYErrorType_PrintCanceled = 504,        //打印被取消
    
};
typedef NS_ENUM(NSInteger,QYRibbonState){
    QYRibbonState_Unknown = 0,
    QYRibbonState_Exit = 1, //有碳带
    QYRibbonState_Error = 2, //异常
    QYRibbonState_Remaining = 3 //有余量
};
#endif /* QYConstants_h */
