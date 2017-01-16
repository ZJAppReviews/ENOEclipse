//
//  PickColorVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//  彩光+呼吸模式

#import "PickColorVC.h"
#import "YYAshapelGradientView.h"

@interface PickColorVC () {
    UIImageView *imgView;
    UIImageView *imgPick;
    CGRect imgRect;
}

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
    CGFloat width = widthView*0.85;
    imgRect = CGRectMake(0, 0, width, width/630*427);
    imgView = [[UIImageView alloc] initWithFrame:imgRect];
    imgView.image = [UIImage imageNamed:@"color_pick"];
    imgView.center = CGPointMake(widthView/2, heightView/3);
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [imgView addGestureRecognizer:tapGesture];
    
    imgPick = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthView*0.05, widthView*0.05)];
    imgPick.center = CGPointMake(width/2, heightView*0.1);
    imgPick.image = [UIImage imageNamed:@"color_pick_selected"];
    [imgView addSubview:imgPick];
    
    //按钮
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, widthView*0.5, widthView*0.5)];
    bt.center = CGPointMake(widthView/2, heightView*0.45);
    [bt setImage:[UIImage imageNamed:@"bt_random"] forState:UIControlStateNormal];
    [bt setImage:[UIImage imageNamed:@"bt_random_light"] forState:UIControlStateHighlighted];
    [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
//    UIButton *bt_pick = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, widthView*0.05, widthView*0.05)];
//    bt_pick.center = CGPointMake(widthView/2, heightView*0.2);
//    [bt_pick setBackgroundImage:[UIImage imageNamed:@"color_pick_selected"] forState:UIControlStateNormal];
//    [bt_pick addTarget:self action:@selector(clickedPickButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bt_pick];
    
    
    //亮度
    [self addLanternSlider];
    //速度
    [self addSpeedSlider];
}

//轻击手势触发方法
-(void)tapGesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    imgPick.center = point;
}
     

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedButton:(UIButton *)sender {
    CGPoint point = [self getRandomPointWithRect:imgRect];
    imgPick.center = point;
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

- (CGPoint)getRandomPointWithRect:(CGRect) rect {
    CGFloat x = (float)(1+arc4random()%24)/100 * CGRectGetWidth(rect);
    CGFloat y = (float)(1+arc4random()%99)/100 * CGRectGetHeight(rect);
    CGPoint point = CGPointMake(x, y);
    return point;
}


@end
