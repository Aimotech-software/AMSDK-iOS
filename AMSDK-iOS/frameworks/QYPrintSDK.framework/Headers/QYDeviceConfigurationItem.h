//
//  QYDeviceConfigurationItem.h
//  QYPrintSDK
//
//  Created by aimo on 2023/12/21.
//

#import <Foundation/Foundation.h>
#import "QYConstants.h"
NS_ASSUME_NONNULL_BEGIN


///蓝牙名称
@interface QYBtName : NSObject
/// 表示蓝牙名称的字符串
@property(nonatomic, strong) NSString * _Nonnull  name;
/// 表示蓝牙匹配方式，分为前缀匹配和精确匹配
@property(nonatomic)QYBtNameMatchType matchType;
@end

@interface QYContinuousPrint : NSObject
/// 连续打印指令
@property(assign)int instruction;

/// 额外走纸次数
@property(assign)int extraFeed;
@end


/// 浓度信息
@interface QYConcentrationInfo : NSObject
//给打印机传值
@property(nonatomic, assign)int value;
//当浓度值不等于1 ,则需要加上浓度系数
@property(nonatomic, assign)float coefficient;
//程度值，0代表适中
@property(nonatomic, assign)int level;
@end

/// 速度信息
@interface QYSpeedInfo : NSObject
//默认速度
@property(nonatomic, assign)int  defaultValue;
//最低速度
@property(nonatomic, assign)int startValue;
//最高速度
@property(nonatomic, assign)int endValue;
@end



/// 支持纸张变量
///  注意 如果有属性变更，一定要考虑NSCopying
///  注意 如果有属性变更，一定要考虑NSCopying
///  注意 如果有属性变更，一定要考虑NSCopying
@interface QYPaperItem : NSObject

/// 纸张名字
@property(nonatomic, copy)NSString  *name;
/// 纸张宽度
@property(assign)int width;
/// 纸张高度
@property(assign)int height;


@end

/// 支持纸张类型
///  注意 如果有属性变更，一定要考虑NSCopying
///  注意 如果有属性变更，一定要考虑NSCopying
///  注意 如果有属性变更，一定要考虑NSCopying
@interface QYSupportPaper : NSObject<
NSCopying
>
@property(nonatomic, copy)NSString  *paperName;
@property(assign)QYPaperType paperType;
/// 不同纸张类型下的不同尺寸的
@property(nonatomic, strong)NSArray<QYPaperItem*> *sizes;
@end

@interface QYMaterialTypes  : NSObject
@property(nonatomic, strong)NSString *sn;
@property(nonatomic, strong)NSArray<NSNumber*>* type;
@end

/// 配置列表中的属性，协议
@protocol QYDeviceConfigurationItem <NSObject>

/// 型号，具体定义看QYPrinterModel，主要是已知的型号定义，
/// 新增的型号，原则上无法定义
@property(nonatomic,readonly)QYPrinterModel model;

/// 型号名字，譬如 "D30"
@property(nonatomic,strong ,readonly)NSString* modelName;

/// 可以匹配的蓝牙名字列表
@property(nonatomic, strong, readonly)NSArray<QYBtName*> *btNames;

@property(nonatomic, readonly)QPrinterDPI dpi;
///// 最大打印宽度，单位mm
//@property(nonatomic, readonly)int maxWidth;
/// 最大打印高度，单位mm
@property(nonatomic, readonly)int maxHeight;
/// 最大的打印宽度 , 以点数为单位 
@property(nonatomic, readonly)int maxPrintWidthInDot;

/// 支持的色阶段
@property(nonatomic, strong, readonly)NSArray<NSNumber*> *supportedColorScale;

/// 结构补白，目前只是在上边的补白,表示打印头打不到的长度
@property(assign, readonly)int  structBlank;

/// 连续打印的相关信息
///  涉及到连续打印的指令和额外走纸指令
@property(nonatomic, strong, readonly)QYContinuousPrint *continuousPrint;


/// 打印速度信息
@property(nonatomic, strong, readonly)QYSpeedInfo *speedInfo;


/// 支持打印的连接方式 1.表示蓝牙 2.表示wifi
///  [1]表示只支持蓝牙打印，[1,2] 表示都支持  [2]表示只支持 wifi 打印
@property(nonatomic, strong, readonly)NSArray<NSNumber*> *supportedTransmit;


///供电方式， 1.插电 2.锂电池 3.干电池
@property(assign, readonly)int powerSupplyType;
///是否需要碳带
@property(assign, readonly)BOOL needRibbon;

@property(nonatomic,strong, readonly)NSArray<NSNumber*>* supportedQueryType; //支持查询的信息类型
///支持多份指令的纸张列表
@property(nonatomic,strong, readonly)NSArray<NSNumber*> *supportedCopiesInstructionPaper;
///支持多份关闭指令
@property(nonatomic, readonly)BOOL isSupportCopiesCloseInstruction;

///是否支持压缩图片
@property(nonatomic, assign)BOOL  isSupportCompress;

///是否支持抗皱模式
@property(nonatomic, readonly)BOOL isSupportAntiwrinkle;
///指令类型
@property(nonatomic, readonly)QYPrinterInstructionType instructionType;

/// 衍生自某个机型
@property(nonatomic, readonly)NSString *inherit;


/// 类型为布尔。 如果为true，表示有覆膜的时候翻转图片， 无覆膜则不翻转。 false 表示无覆膜翻转，有覆膜不翻转。
@property(nonatomic, assign)BOOL flipImage;


/// 支持查询耗材类型列表
@property(nonatomic, assign)NSArray<NSNumber*> *materialIdentify;


/// 打印位置, 左中右
@property(nonatomic, assign) QYPrintDirection printDirection;

/// 支架位置 左中右
@property(nonatomic, assign) QYBracketPosition bracketPosition;

@property(nonatomic, assign) QYOffTimeType offTimeType;

/// 传输方式，譬如蓝牙- Wi-Fi 双模机
@property(nonatomic, assign,readonly) QYTransmitType transmitType;

/// 是否衍生于某个型号
/// - Parameter model: 型号
- (BOOL)inheritFrom:(QYPrinterModel)model;


/// 印先森两寸机
- (BOOL)is2InchMachine;


///每毫米的点数
- (float)dotFormm;



//- (BOOL)isSupportWithPaperType:(QYPaperType)paperType;

- (BOOL)isSupportWithColorScale:(QYColorScale)colorScale;


- (BOOL)isSupportedQueryWithInstructionType:(QYQueryInstructionType)type;




- (BOOL)isSupportWithCon:(int)con;
@end

NS_ASSUME_NONNULL_END
