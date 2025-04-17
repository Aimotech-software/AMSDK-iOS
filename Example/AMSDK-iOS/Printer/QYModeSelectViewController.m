//
//  QYModeSelectViewController.m
//  QYPrintSDK_Example
//
//  Created by aimo on 2023/11/15.
//  Copyright © 2023 pengbi. All rights reserved.
//

#import "QYModeSelectViewController.h"

@interface QYModeSelectViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *titleList;
@property(nonatomic, strong)NSDictionary *nameWI;
@end

@implementation QYModeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.frame = self.view.bounds;
    self.titleList = @[@"蓝牙连接",@"局域网连接"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.titleList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int type = indexPath.row;
    self.didSelectType(type);
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
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
