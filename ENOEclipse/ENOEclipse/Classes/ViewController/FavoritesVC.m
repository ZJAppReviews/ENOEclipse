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
    UITableView *baseTableView;
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
//    [self.view addSubview:bt];
    
    bleList = [[NSArray alloc] initWithArray:[UserDefaultsHelper getSurrentList]];
    
    CGRect rectTable = CGRectMake(0, 20, widthView, heightView-25);
    baseTableView = [[UITableView alloc] initWithFrame:rectTable style:UITableViewStyleGrouped];
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
    NSDictionary *tempDic = bleList[row];
    cell.textLabel.text = [tempDic objectForKey:@"name"];
    cell.textLabel.textColor = [UIColor colorMainLight];
    cell.textLabel.font = [UIFont systemFontOfSize:26];
    
    cell.detailTextLabel.text = [self getTimeFromDate:[tempDic objectForKey:@"date"]];
    cell.detailTextLabel.textColor = [UIColor colorMainLight];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    
    //按钮
    CGRect rect = CGRectMake(widthView-120-VIEW_MARGIN, 20, 120, 60);
    UIButton *bt = [[UIButton alloc] initWithFrame:rect];
    bt.tag = row;
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
    if ([self isCennectedLight]) {
        NSInteger row = sender.tag;
        NSDictionary *tempDic = bleList[row];
        NSString *strResult = [tempDic objectForKey:@"color"];
        //发出指令
        NSString *str1 = [NSString stringWithFormat:@"0307%@",[strResult substringToIndex:28]];
        [[BLEService sharedInstance] setBLEPageWithType:BLEOrderTypeCustom value:str1 pageNum:1];
        
        [self performSelector:@selector(delayMethod:) withObject:tempDic afterDelay:0.2];
    }
}

- (void)delayMethod:(NSDictionary *)tempDic{
    NSString *str2 = [NSString stringWithFormat:@"03080%@%@",[tempDic objectForKey:@"speed"],[[tempDic objectForKey:@"color"] substringFromIndex:28]];
    [[BLEService sharedInstance] setBLEPageWithType:BLEOrderTypeCustom value:str2 pageNum:2];
}


- (NSString *)getTimeFromDate:(NSDate *)date {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"MMM,yyyy,dd"];
    NSString *retStr = [outputFormatter stringFromDate:date];
    return retStr;
}

- (void)handUpateView {
    bleList = [[NSArray alloc] initWithArray:[UserDefaultsHelper getSurrentList]];
    [baseTableView reloadData];
}

@end
