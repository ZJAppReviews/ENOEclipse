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
    bleList = @[@"ENO Eclipse #1",@"ENO Eclipse #2",@"ENO Eclipse #3",@"ENO Eclipse #4",@"ENO Eclipse #5",@"ENO Eclipse #6",@"ENO Eclipse #7"];
    
    UITableView *baseTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    baseTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSInteger row = indexPath.row;
    
    cell.textLabel.text = bleList[row];
    cell.textLabel.textColor = [UIColor colorMainLight];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
}

@end
