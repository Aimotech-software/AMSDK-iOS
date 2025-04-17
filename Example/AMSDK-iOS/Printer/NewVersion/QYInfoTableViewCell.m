//
//  QYInfoTableViewCell.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/3/15.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "QYInfoTableViewCell.h"

@implementation QYInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setup {
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = -1;
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:18];
    self.contentLabel.numberOfLines = -1;
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0];
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10.0];
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80];
    [self.titleLabel addConstraint:contraint3];
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
    
    
    NSLayoutConstraint *contraint5 = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0];
    NSLayoutConstraint *contraint6 = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0];
    NSLayoutConstraint *contraint7 = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10];
    NSLayoutConstraint *contraint8 = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
    
    [self.contentView addConstraints:@[
        contraint1,contraint2,contraint4,
        contraint5,contraint6,contraint7,contraint8
    ]];
}

@end

@implementation QYConnectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = UIColor.grayColor;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, self.contentView.frame.size.height)];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.numberOfLines = -1;
    
 
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.frame = CGRectMake(self.contentView.frame.size.width - 100, 10, 80, self.contentView.frame.size.height -20);
    self.contentLabel.font   = [UIFont systemFontOfSize:15];
    
    self.contentLabel.textColor = UIColor.systemBlueColor;
    self.contentLabel.layer.borderColor = UIColor.systemBlueColor.CGColor;
    self.contentLabel.layer.borderWidth = 1.0f;
   // self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.numberOfLines = -1;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint *contraint01 = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0];
    NSLayoutConstraint *contraint02 = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:10.0];
    NSLayoutConstraint *contraint03 = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    NSLayoutConstraint *contraint031 = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40];
    [self.iconImageView addConstraint:contraint03];
    [self.iconImageView addConstraint:contraint031];
    
    NSLayoutConstraint *contraint04 = [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
    
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0];
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5.0];
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200];
    [self.titleLabel addConstraint:contraint3];
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
    
    
    NSLayoutConstraint *contraint5 = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0];
    NSLayoutConstraint *contraint6 = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100];
    [self.contentLabel addConstraint:contraint6];
    NSLayoutConstraint *contraint7 = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-10];
    NSLayoutConstraint *contraint8 = [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];
    
    [self.contentView addConstraints:@[
        contraint01,contraint02,contraint04,
        contraint1,contraint2,contraint4,
        contraint5,contraint7,contraint8
    ]];
}

@end

@implementation QYImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.contentImageView = [[UIImageView alloc] init];
    self.contentImageView.backgroundColor = UIColor.grayColor;
    [self.contentView addSubview:self.contentImageView];
    self.contentImageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:self.contentImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5.0];
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:self.contentImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0];
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:self.contentImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:NULL attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:150.0];
    [self.contentImageView addConstraint:contraint4];
    
    NSLayoutConstraint *contraint5 = [NSLayoutConstraint constraintWithItem:self.contentImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.contentView addConstraints:@[
        contraint1,contraint2,contraint5
    ]];

    
    
}
@end
