//
//  BLEConnectVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "BLEConnectVC.h"

@interface BLEConnectVC ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *baseTableView;
    NSMutableArray *bleList;
}

@end

@implementation BLEConnectVC

- (void)scanBloodPressure {
    [[BLEService sharedInstance] startScanBLETime:20.0 successBlock:^(CBPeripheral *peripheral, NSString *strMac) {
        if (![bleList containsObject:peripheral]) {
            [bleList addObject:peripheral];
            [baseTableView reloadData];
        }
    }failBlock:^(){
        [SVProgressHUD showInfoWithStatus:@"Scan ENOEclipse Fail"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    bleList = [[NSMutableArray alloc] init];
    [self scanBloodPressure];
    
    baseTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
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
    CBPeripheral *peripheral = bleList[row];
    NSString *name = peripheral.name;
    if (!name) {
        name = @"NO Name";
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",name];
    cell.textLabel.textColor = [UIColor colorMainLight];
    cell.textLabel.font = [UIFont systemFontOfSize:26];
    
    //按钮
    CGRect rect = CGRectMake(widthView-140-VIEW_MARGIN, 20, 140, 60);
    UIButton *bt = [[UIButton alloc] initWithFrame:rect];
    bt.tag = row;
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
    CBPeripheral *selPer = [bleList objectAtIndex:sender.tag];
    if (!sender.selected) {
        [[BLEService sharedInstance] connectPeripheral:selPer successBlock:^() {
            if (!sender.selected) {
                sender.selected = YES;
                [sender setTitle:@"DISCONNECT" forState:UIControlStateSelected];
            }
        } failBlock:^() {
            [SVProgressHUD showInfoWithStatus:@"Connect ENOEclipse Fail"];
        } startOrderBlock:^() {
            //初始化完成，加载指令
            
            //测量过程
            //[self dealBLEData];
        }];
    }
    else {
        sender.selected = NO;
        [sender setTitle:@"CONNECT" forState:UIControlStateNormal];
        [[BLEService sharedInstance] cancelBLEConnection:selPer];
    }
}

@end
