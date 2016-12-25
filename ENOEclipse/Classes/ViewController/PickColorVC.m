//
//  PickColorVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//  彩光+呼吸模式

#import "PickColorVC.h"

@interface PickColorVC ()

@end

@implementation PickColorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = CGRectMake(0, 0, widthView, widthView*0.8);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    
    //亮度
    [self addLanternSlider];
    //速度
    [self addSpeedSlider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
