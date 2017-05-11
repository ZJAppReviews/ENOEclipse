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
    
    CBPeripheral *curPeripheral;
}

@end

@implementation BLEConnectVC

- (void)scanBloodPressure {
    [[BLEService sharedInstance] pauseScanBLE];
//    if (bleList.count>0) {
//        [bleList removeAllObjects];
//        if (curPeripheral) {
//            [bleList addObject:curPeripheral];
//        }
//        [baseTableView reloadData];
//    }
    
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
    
    baseTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    baseTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    baseTableView.backgroundColor = [UIColor whiteColor];
    baseTableView.delegate = self;
    baseTableView.dataSource = self;
    [self.view addSubview:baseTableView];
    
    //
    [self addMJRefreshHeader];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self viewDidDisappear:animated];
    [[BLEService sharedInstance] pauseScanBLE];
}

- (void)handUpateView {
    if (![BLEService sharedInstance].isConnected) {
        [self scanBloodPressure];
    }
    [baseTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MJRefresh,上拉加载，下拉刷新
//添加下拉刷新
- (void)addMJRefreshHeader {
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.loadingView.color = [UIColor colorGragLight];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    //    [header beginRefreshing];
    // 设置header
    baseTableView.mj_header = header;
}

//添加上拉加载
- (void)addMJRefreshFooter {
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 当上拉刷新控件出现50%时（出现一半），就会自动刷新。这个值默认是1.0（也就是上拉刷新100%出现时，才会自动刷新）
    //    footer.triggerAutomaticallyRefreshPercent = 0.5;
    // 隐藏刷新状态的文字
    footer.loadingView.color = [UIColor colorGragLight];
    // 设置footer
    baseTableView.mj_footer = footer;
}

//下拉刷新数据
- (void)loadNewData{
    [self performSelector:@selector(endUpdate) withObject:self afterDelay:1.0];
    [self scanBloodPressure];
}

- (void)endUpdate {
    [baseTableView.mj_header endRefreshing];
}

//上拉加载更多数据
- (void)loadMoreData{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return bleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:@"cell"];
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
    cell.textLabel.font = [UIFont systemFontOfSize:22];
    
    //按钮
    CGRect rect = CGRectMake(widthView-140-VIEW_MARGIN, 20, 140, 60);
    UIButton *bt = [[UIButton alloc] initWithFrame:rect];
    bt.tag = row;
    bt.layer.borderWidth = 0.5;
    bt.layer.borderColor = [UIColor colorMainLight].CGColor;
    bt.layer.cornerRadius = 30;
    [bt setTitleColor:[UIColor colorMainLight] forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor colorGrag] forState:UIControlStateHighlighted];
    if (peripheral.state == CBPeripheralStateConnected) {
        [bt setTitle:@"DISCONNECT" forState:UIControlStateNormal];
    }
    else {
        [bt setTitle:@"CONNECT" forState:UIControlStateNormal];
    }
    
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
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, widthView, 40)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = [UIColor grayColor];
    lb.text = [NSString stringWithFormat:@"Version:%@", [[[NSBundle mainBundle]infoDictionary]valueForKey:@"CFBundleVersion"]];
    return lb;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
}


- (void)clickedButton:(UIButton *)sender {
    CBPeripheral *selPer = [bleList objectAtIndex:sender.tag];
    if (!sender.selected) {
        [SVProgressHUD showWithStatus:@"Connecting..."];
        [[BLEService sharedInstance] connectPeripheral:selPer successBlock:^() {
            [[BLEService sharedInstance] pauseScanBLE];
        } failBlock:^() {
            [SVProgressHUD showInfoWithStatus:@"Connect ENOEclipse Fail"];
        } startOrderBlock:^() {
            [SVProgressHUD showInfoWithStatus:@"Connect ENOEclipse succeed"];
            if (!sender.selected) {
                curPeripheral = [bleList objectAtIndex:sender.tag];
                sender.selected = YES;
                [sender setTitle:@"DISCONNECT" forState:UIControlStateSelected];
            }
        }];
    }
    else {
        sender.selected = NO;
        [sender setTitle:@"CONNECT" forState:UIControlStateNormal];
        [[BLEService sharedInstance] cancelAllBLEConnection];
    }
}

@end
