//
//  XHudManager.m
//  LMAPITest
//
//  Created by YFB-CDS on 2020/8/13.
//  Copyright © 2020 YFB-CDS. All rights reserved.
//

#import "XHudManager.h"
#import "Constant.h"

@interface XHudManager()

@property(nonatomic, strong) UIImageView *imgV;
@property(nonatomic, strong) UILabel *messageLb;

@end

@implementation XHudManager


/**
 * @brief 创建单例
 */
+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(X_Width*0.32, X_Height*(0.5-0.18), X_Width*0.36, X_Width*0.36)];
        _imgV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _imgV.layer.cornerRadius = 10;
        [self addSubview:_imgV];
        
        _messageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgV.frame.size.height/2-25, _imgV.frame.size.width, 50)];
        _messageLb.textAlignment = NSTextAlignmentCenter;
        _messageLb.textColor = UIColor.whiteColor;
        _messageLb.numberOfLines = 0;
        _messageLb.font = [UIFont systemFontOfSize:15];
        [_imgV addSubview:_messageLb];
    }
    return self;
}


/**
 * @brief 显示
 * @param message 信息
 */
- (void)show:(NSString *)message {
    
    self.messageLb.text = message;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
}

/**
 * @brief 隐藏
 */
- (void)hidden {
    [self removeFromSuperview];
}
@end
