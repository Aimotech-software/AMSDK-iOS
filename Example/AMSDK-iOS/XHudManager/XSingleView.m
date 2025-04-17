//
//  XSingleView.m
//  LMAPITest
//
//  Created by YFB-CDS on 2020/8/22.
//  Copyright © 2020 YFB-CDS. All rights reserved.
//

#import "XSingleView.h"
#import "Constant.h"

@interface XSingleView()

@property(nonatomic, strong) UILabel *messageLb;

@end

@implementation XSingleView

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
    self = [super initWithFrame:CGRectMake((X_Width-150)/2, (X_Height-40)/2, 150, 40)];
    if (self) {
        
        self.backgroundColor = UIColor.blackColor;
        self.layer.cornerRadius = 8;

        _messageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        _messageLb.textAlignment = NSTextAlignmentCenter;
        _messageLb.textColor = UIColor.whiteColor;
        _messageLb.numberOfLines = 0;
        _messageLb.font = [UIFont systemFontOfSize:15];
        [self addSubview:_messageLb];
        
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
    [self performSelector:@selector(hidden) withObject:nil afterDelay:2.5];
}

/**
 * @brief 隐藏
 */
- (void)hidden {
    [self removeFromSuperview];
}
@end
