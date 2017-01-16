//
//  PickColorVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//  彩光+呼吸模式

#import "PickColorVC.h"
#import "YYAshapelGradientView.h"

@interface PickColorVC ()

@end

@implementation PickColorVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    YYAshapelGradientView *view = [[YYAshapelGradientView alloc] initWithFrame:CGRectMake(40, 40, widthView-80, widthView-80)];
//    view.progressLineWidth = 20;//最大是45
//    view.startAngle = -240;
//    view.endAngle = 60;
//    view.value = 1;
//    [self.view addSubview:view];
    //选择颜色栏
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthView*0.85, widthView*0.85/630*427)];
    imgView.image = [UIImage imageNamed:@"color_pick"];
    imgView.center = CGPointMake(widthView/2, heightView/3);
    [self.view addSubview:imgView];
    
    //按钮
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, widthView*0.5, widthView*0.5)];
    bt.center = CGPointMake(widthView/2, heightView*0.45);
    [bt setImage:[UIImage imageNamed:@"bt_random"] forState:UIControlStateNormal];
    [bt setImage:[UIImage imageNamed:@"bt_random_light"] forState:UIControlStateHighlighted];
    [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    UIButton *bt_pick = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, widthView*0.05, widthView*0.05)];
    bt_pick.center = CGPointMake(widthView/2, heightView*0.2);
    [bt_pick setBackgroundImage:[UIImage imageNamed:@"color_pick_selected"] forState:UIControlStateNormal];
    [bt_pick addTarget:self action:@selector(clickedPickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt_pick];
    
    
    //亮度
    [self addLanternSlider];
    //速度
    [self addSpeedSlider];
}
     

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedButton:(UIButton *)sender {
    
}
     
- (void)clickedPickButton:(UIButton *)sender {
    
}

- (void)sliderChangeLantern:(UISlider *)sender {
    CGFloat value = sender.value*10;
    NSLog(@"%f", value);
    
    [SVProgressHUD showInfoWithStatus:@"Not cennected light"];
}

- (void)sliderChangeSpeed:(UISlider *)sender {
    CGFloat value = sender.value;
    NSLog(@"%f", value);
    [SVProgressHUD showInfoWithStatus:@"Not cennected light"];
}

@end
