//
//  QYInfoTableViewCell.h
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYInfoTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *contentLabel;
@end

@interface QYConnectTableViewCell : UITableViewCell
@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *contentLabel;
@end

@interface QYImageCell : UITableViewCell
@property(nonatomic, strong)UIImageView *contentImageView;
@end




NS_ASSUME_NONNULL_END
