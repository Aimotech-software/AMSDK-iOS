//
//  QYPrintParams.h
//  QYPrintSDK
//
//  Created by aimo on 2024/1/29.
//

#import <Foundation/Foundation.h>
#import "QYConstants.h"
#import "QYDeviceConfigurationItem.h"

NS_ASSUME_NONNULL_BEGIN
/**图片是裁剪还是缩放*/
typedef NS_ENUM(NSInteger,QYScaleImage){
    /**默认缩放*/
    QYScaleImage_Zoom = 0,
    QYScaleImage_Tail,
};

/**图片内容打印的水平位置，这个是用于剪裁的
 区别 QYUserPrintHorizonPostion 的定义*/
typedef NS_ENUM(NSInteger,QYUserPrintHorizonPostion){
    
    /**居中打*/
    QYUserPrintHorizonPostion_Center = 0,
    /**居左打*/
    QYUserPrintHorizonPostion_Left,
 
    /**靠右打*/
    QYUserPrintHorizonPostion_Right
};

/**图片内容打印的垂直位置
 区别 QYUserPrintHorizonPostion 的定义*/
typedef NS_ENUM(NSInteger,QYUserPrintVerticalPostion){
    /**居中打*/
    QYUserPrintVerticalPostion_Center = 0,
    /**居上打*/
    QYUserPrintVerticalPostion_Top,

    /**靠下打*/
    QYUserPrintVerticalPostion_Bottom
};

@class QYBLEDevice;
/// 打印参数
@interface QYPrintParams : NSObject

/// 打印份数
@property(assign,nonatomic)int copies;

///浓度值
@property(assign,nonatomic)int con;

///浓度系数
@property(nonatomic, assign)int conCoefficient;


/// 打印速度
@property(assign,nonatomic)int speed;


/// 调用方来决定是否需要合并图片
/// 印先森中机器中的小尺寸的连续纸，需要合并图片
@property(nonatomic, assign)BOOL needMergeImage;

/// 打印纸张类型
@property(assign,nonatomic ,readonly)QYPaperType paperType;


///抗皱模式级别
@property(assign,nonatomic)QYAntiwrinkleLevel antiwrinkleLevel;


/// 连续纸是否分页打印
@property(assign,nonatomic)BOOL isSplitPrinting;

/// 图像处理类型
@property(assign,nonatomic)QYImageProcessType processType;


/// 处理的色阶数, 16阶即灰阶
@property(assign,nonatomic)QYColorScale  colorScale;

/// 纸张宽度,单位是 mm
@property(assign,nonatomic,readonly)int paperWidth;

/// 纸张高度 单位是 mm
@property(assign,nonatomic,readonly)int paperHeight;

/// 是否红黑打印
@property(assign,nonatomic)BOOL isRedBlack;


/// 是否加密处理
@property(nonatomic, assign)BOOL  isCiphertext;


@property(nonatomic, strong,readonly)id<QYDeviceConfigurationItem> device;


/// 组装打印内容的时候携带的非通用的上下文信息，目前携带的内容如下（ 注意：仅仅是给非通用逻辑使用）
/// 1.B246D的中设置信息
@property(nonatomic, strong)NSMutableDictionary *context;


/// 处理到适合纸张大小的处理方式
@property(nonatomic, assign)QYScaleImage scaleImage;

/// 用户选择的水平打印位置
/// 左中右
@property(nonatomic, assign)QYUserPrintHorizonPostion  userPrintHorizonPosition;

/// 用户选择的垂直打印位置
///  上中下
@property(nonatomic, assign)QYUserPrintVerticalPostion userPrintVerticalPosition;


/// 水平方向偏移量  ,单位是毫米
///  负数是 往左边便宜， 正数向右边偏移
@property(nonatomic, assign)int  horizonOffset;


/// 垂直方向偏移
///  负数向上偏移，正数向下偏移
@property(nonatomic, assign)int  verticalOffset;


///  是否需要等待用户确认
@property(nonatomic, assign)BOOL needWaitReadySignal;

///  是否压缩打印数据
///  依赖于是否支持压缩，如果是支持压缩，就可以选择压缩或者不压缩
@property(nonatomic, assign)BOOL compressData;

///二值化的阈值，目前只在tspl设备上用
@property(nonatomic, assign)int binaryThreshold;


/// 只读属性，纸张宽度赋值的时候，这两个值跟着变化
@property(nonatomic, assign,readonly)int  validPaperWidth;
@property(nonatomic, assign,readonly)int  validPaperHeight;


/// 初始化
/// - Parameters:
///   - paperType: 纸张类型
///   - paperWidth: 纸张宽度
///   - paperHeight: 纸张高度
- (instancetype)initWithPaperType:(QYPaperType)paperType
                       paperWidth:(int)paperWidth
                      paperHeight:(int)paperHeight;



/// 暂未连接设备的时候，需要生成的设备数据
/// - Parameters:
///   - paperType: 纸张类型
///   - paperWidth: 纸张宽度
///   - paperHeight: 纸张高度
///   - bleName: 设备蓝牙名字
- (instancetype)initWithPaperType:(QYPaperType)paperType
                       paperWidth:(int)paperWidth
                      paperHeight:(int)paperHeight
                          bleName:(NSString*)bleName;


/// 纸张的有效的点数大小
/// 单位是点数
- (CGSize)paperSizeInDot;

- (float)floatDotFormm;


/// 纸张的真实
- (CGSize)truepaperSizeInDot;

///打印浓度
- (int)printCon;

///浓度系数
///只有当浓度系数 > 0 才使用，譬如 1.5
- (float)printConCoefficient;



/// 是否需要压缩
///  debug 情况下，qa 同学会测试是否压缩 + 支持压缩才能压缩，否则不压缩
///    release 情况下
- (BOOL)needCompress;




/// 是否A4纸张
- (BOOL)isA4Paper;

///是否A5纸张
///参数是毫米
- (BOOL) isA5Paper;
///是否B5纸张
///参数是毫米
- (BOOL)isB5Paper;

///是否B5纸张
///参数是毫米
- (BOOL)isB5WPaper;

///是否53mm毫米纸
- (BOOL)is53MMPaper;
///是否80mm毫米纸
- (BOOL)is80MMPaper;
///是否15mm毫米纸
- (BOOL) is15MMPaper;


/// 是否A4连续纸
- (BOOL) isA4ContinuousPaper;

/// 是否小尺寸连续纸
- (BOOL) isSmallSizeContinuousPaper;

/// 是否卡片纸
- (BOOL) isCardPaper;


/// 连续纸的分页打印
- (BOOL)isContinuousPaperSplitPrint;

@end

NS_ASSUME_NONNULL_END
