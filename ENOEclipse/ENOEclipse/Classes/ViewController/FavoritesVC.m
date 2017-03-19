//
//  FavoritesVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "FavoritesVC.h"

@interface FavoritesVC ()<UITableViewDelegate,UITableViewDataSource> {
    NSArray *bleList;
    NSArray *detailList;
}


@end

@implementation FavoritesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //按钮
    CGRect rect = CGRectMake(VIEW_MARGIN*2, 20, widthView-VIEW_MARGIN*4, 80);
    UIButton *bt = [[UIButton alloc] initWithFrame:rect];
    bt.layer.borderWidth = 0.5;
    bt.layer.borderColor = [UIColor colorMainLight].CGColor;
    bt.layer.cornerRadius = 40;
    [bt setTitleColor:[UIColor colorMainLight] forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor colorGrag] forState:UIControlStateHighlighted];
    [bt setTitle:@"SAVE SURRENT" forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:26];
    [bt addTarget:self action:@selector(clickeSave:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    bleList = @[@"Custom Name A",@"Custom Name B",@"Custom Name C"];
    detailList = @[@"Oct 10, 2016",@"Date",@"Date"];
    
    CGRect rectTable = CGRectMake(0, 130, widthView, heightView-130);
    UITableView *baseTableView = [[UITableView alloc] initWithFrame:rectTable style:UITableViewStyleGrouped];
    baseTableView.backgroundColor = [UIColor whiteColor];
    baseTableView.delegate = self;
    baseTableView.dataSource = self;
    [self.view addSubview:baseTableView];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickeSave:(UIButton*)sender {
    
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
    
    cell.detailTextLabel.text = detailList[row];
    cell.detailTextLabel.textColor = [UIColor colorMainLight];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    
    //按钮
    CGRect rect = CGRectMake(widthView-120-VIEW_MARGIN, 20, 120, 60);
    UIButton *bt = [[UIButton alloc] initWithFrame:rect];
    bt.layer.borderWidth = 0.5;
    bt.layer.borderColor = [UIColor colorMainLight].CGColor;
    bt.layer.cornerRadius = 30;
    [bt setTitleColor:[UIColor colorMainLight] forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor colorGrag] forState:UIControlStateHighlighted];
    [bt setTitle:@"LOAD" forState:UIControlStateNormal];
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
    [SVProgressHUD showInfoWithStatus:@"Not cennected light"];
//    if (sender.selected) {
//        [sender setTitle:@"DISCONNECT" forState:UIControlStateSelected];
//    }
//    else {
//        [sender setTitle:@"CONNECT" forState:UIControlStateNormal];
//    }
}



@end
