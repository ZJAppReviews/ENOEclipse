//
//  SleepTimeVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "SleepTimeVC.h"
#import "YYAshapelGradientView.h"

@interface SleepTimeVC ()

@end

@implementation SleepTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    YYAshapelGradientView *view = [[YYAshapelGradientView alloc] initWithFrame:CGRectMake(40, 40, widthView-80, widthView-80)];
//    view.progressLineWidth = 20;//最大是45
//    view.startAngle = -240;
//    view.endAngle = 60;
//    [self.view addSubview:view];
    
    
    //进度条
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthView*0.85, widthView*0.85)];
    imgView.image = [UIImage imageNamed:@"time_circle"];
    imgView.center = CGPointMake(widthView/2, heightView*0.45);
    [self.view addSubview:imgView];
    
    //按钮
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, widthView*0.3, widthView*0.14)];
    bt.center = CGPointMake(widthView/2, heightView*0.75);
    bt.layer.borderWidth = 0.5;
    bt.layer.borderColor = [UIColor colorMainLight].CGColor;
    bt.layer.cornerRadius = widthView*0.07;
    [bt setTitle:@"START" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor colorMainLight] forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor colorGrag] forState:UIControlStateHighlighted];
    bt.titleLabel.font = [UIFont systemFontOfSize:24];
    
    [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    //时间
    UILabel *lb_time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, widthView/2, 75)];
    lb_time.center = CGPointMake(widthView/2, heightView*0.4);
    lb_time.textColor = [UIColor colorMainLight];
    lb_time.font = [UIFont systemFontOfSize:100];
    lb_time.text = @"29";
    lb_time.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lb_time];
    
    UILabel *lb_unit = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, widthView/2, 30)];
    lb_unit.center = CGPointMake(widthView/2, heightView*0.4+60);
    lb_unit.textColor = [UIColor colorMainLight];
    lb_unit.font = [UIFont systemFontOfSize:20];
    lb_unit.text = @"MINUTES";
    lb_unit.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lb_unit];
    
    //游标
    UIButton *bt_pick = [[UIButton alloc] initWithFrame:CGRectMake(widthView*0.05, widthView*0.5, widthView*0.09, widthView*0.09)];
    [bt_pick setBackgroundImage:[UIImage imageNamed:@"time_circle_selected"] forState:UIControlStateNormal];
    [bt_pick addTarget:self action:@selector(clickedPickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt_pick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedButton:(UIButton *)sender {
    
}

- (void)clickedPickButton:(UIButton *)sender {
    
}

@end
