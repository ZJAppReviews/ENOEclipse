//
//  BLEConnectVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "BLEConnectVC.h"

@interface BLEConnectVC ()<UITableViewDelegate,UITableViewDataSource> {
    NSArray *bleList;
}

@end

@implementation BLEConnectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    bleList = @[@"ENO Eclipse #1",@"ENO Eclipse #2",@"ENO Eclipse #3"];
    
    UITableView *baseTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    baseTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    baseTableView.backgroundColor = [UIColor whiteColor];
    baseTableView.delegate = self;
    baseTableView.dataSource = self;
    [self.view addSubview:baseTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return bleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSInteger row = indexPath.row;
    cell.textLabel.text = bleList[row];
    cell.textLabel.textColor = [UIColor colorMainLight];
    cell.textLabel.font = [UIFont systemFontOfSize:26];
    
    //按钮
    CGRect rect = CGRectMake(widthView-140-VIEW_MARGIN, 20, 140, 60);
    UIButton *bt = [[UIButton alloc] initWithFrame:rect];
    bt.layer.borderWidth = 0.5;
    bt.layer.borderColor = [UIColor colorMainLight].CGColor;
    bt.layer.cornerRadius = 30;
    [bt setTitleColor:[UIColor colorMainLight] forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor colorGrag] forState:UIControlStateHighlighted];
    [bt setTitle:@"CONNECT" forState:UIControlStateNormal];
    
    [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:bt];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
}


- (void)clickedButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setTitle:@"DISCONNECT" forState:UIControlStateSelected];
    }
    else {
        [sender setTitle:@"CONNECT" forState:UIControlStateNormal];
    }
}

@end
