//
//  LavaLampVC.m
//  Eclipse
//
//  Created by QS on 2016/12/18.
//  Copyright © 2016年 QS. All rights reserved.
//  彩光+自定义

#import "LavaLampVC.h"

@interface LavaLampVC ()

@end

@implementation LavaLampVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //功能按钮
    NSInteger w = (widthView-4*VIEW_MARGIN)/2;
    NSInteger h = (heightView-60-4*VIEW_MARGIN)/2;
    for (int i=0; i<4; i++) {
        int row = i/2;
        int sec = i%2;
        CGRect rect = CGRectMake(VIEW_MARGIN+(VIEW_MARGIN*2+w)*sec, VIEW_MARGIN+(VIEW_MARGIN*2+h)*row, w, h);
        
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorMainLight].CGColor;
        view.layer.cornerRadius = w/10;
        [self.view addSubview:view];
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        [bt setTitle:[NSString stringWithFormat:@"PRESENT FUNCTION #%d",i] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorMainLight] forState:UIControlStateNormal];
        bt.titleLabel.numberOfLines = 2;
        bt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = i+10000;
        [view addSubview:bt];
    }
    
    //速度
    [self addSpeedSlider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)clickedButton:(UIButton *)sender {
    NSInteger tag = sender.tag;
    
}

@end
