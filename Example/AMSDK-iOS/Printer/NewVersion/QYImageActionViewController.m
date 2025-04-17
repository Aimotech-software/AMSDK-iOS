//
//  QYImageActionViewController.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2024/4/10.
//  Copyright © 2024 pengbi. All rights reserved.
//

#import "QYImageActionViewController.h"
#import "I18nManager.h"
@interface QYImageView : UIImageView
@property(nonatomic, strong)UIButton *button;
@property(nonatomic, strong)void (^clickRemove)();
@end


@implementation QYImageView
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self addSubview:self.button];
    self.button.frame = CGRectMake(frame.size.width - 40, 0, 40, 40);
    self.userInteractionEnabled = YES;
}

- (void)clickRemove_ {
    self.clickRemove ? self.clickRemove() : 0x0;
}

- (UIButton *)button {
    if(!_button) {
        _button  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"-" forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:30];
        _button.backgroundColor = UIColor.grayColor;
        [_button addTarget:self action:@selector(clickRemove_) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end

@interface QYImageActionViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)NSMutableArray<UIView*> *subviews;
@property(nonatomic, strong)UIButton *addButton;
@property(nonatomic, strong)NSMutableArray *imageArray;
@end

@implementation QYImageActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}

- (void)setup {
    self.imageArray = [NSMutableArray array];
    self.scrollView = [[UIScrollView alloc] init];
    float imageHeight = 200;
    float width = self.view.frame.size.width;
    self.scrollView.frame =   CGRectMake(0, self.topContainer.frame.size.height + self.topContainer.frame.origin.y, self.view.frame.size.width, imageHeight);
    [self.view addSubview:self.scrollView];
    self.scrollView.showsVerticalScrollIndicator = YES;
    
    self.subviews = [NSMutableArray array];
    {
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.layer.borderColor = UIColor.grayColor.CGColor;
        self.addButton.layer.borderWidth = 2;
        [self.addButton setTitle:[I18nManager stringWithKey:@"添加图片"] forState:UIControlStateNormal];
        [self.addButton setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        self.addButton.frame = CGRectMake(0, 0, width/4, 200);
        [self.addButton addTarget:self action:@selector(clickImage) forControlEvents:UIControlEventTouchUpInside];
        [self.subviews addObject:self.addButton];
    }
    [self configScrollView];

}

- (void)configScrollView {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj,
                                                NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    float imageHeight = 200;
    float width = self.view.frame.size.width  / 4;
    int row  = 0 ;
    int col = 0;
    for (UIView *view in self.subviews) {
        [self.scrollView addSubview:view];
        view.frame = CGRectMake(col * width, row * 200, width , 200);
        col ++;
        if(col == 4){
            row ++; 
            col = 0;
        }
    }
    int rowCount =  self.subviews.count  / 4;
    if(self.subviews.count % 4 != 0){
        rowCount = rowCount + 1;
    }
    if(rowCount == 0) {
        rowCount = 1;
    }
    self.scrollView.contentSize = CGSizeMake(width * 4 ,rowCount * imageHeight);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.scrollView setContentOffset:CGPointMake(0, (rowCount - 1)*imageHeight) animated:YES];
    });
}

- (void)resetScrollViewSubView {
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.subviews removeAllObjects];
    
    for (UIImage *image in self.imageArray) {
        QYImageView *imageView = [[QYImageView alloc] init];
        __weak QYImageActionViewController *weakSelf = self;
        imageView.clickRemove = ^{
            [weakSelf.imageArray removeObject:image];
            [weakSelf resetScrollViewSubView];
        };
        imageView.image = image;
        [self.subviews addObject:imageView];
    }
    [self.subviews addObject:self.addButton];
    
    [self configScrollView];
}

- (void)clickImage {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.imageArray addObject:image];
            [self  resetScrollViewSubView];
        });
    }];
}

- (NSArray *)printImage {
    return self.imageArray;
}

- (UIView *)contentView {
    return self.scrollView;
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
