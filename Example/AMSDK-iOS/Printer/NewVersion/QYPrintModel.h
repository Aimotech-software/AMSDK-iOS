//
//  QYPrintModel.h
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/18.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CellStyle){
    CellStyle_Select,
    CellStyle_Edit
};
NS_ASSUME_NONNULL_BEGIN

@interface QYPrintModel : NSObject
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, assign)CellStyle style;

/// 可以是是负数
@property(nonatomic, assign)BOOL canNeg;


@property(nonatomic, strong)NSArray *selectScope;

/// 选择的 Index
@property(nonatomic, assign)int selectIndex;
//  点击增加的值
@property(nonatomic, assign)int clickValue;
@end

NS_ASSUME_NONNULL_END
