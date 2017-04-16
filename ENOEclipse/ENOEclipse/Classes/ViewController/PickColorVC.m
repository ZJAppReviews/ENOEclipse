//
//  PickColorVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//  彩光+呼吸模式

#import "PickColorVC.h"
#import "YYAshapelGradientView.h"
#import "UIImage+YYColorPiont.h"

@interface PickColorVC () {
    UIImageView *imgView;
    UIImageView *imgPick;
    CGRect imgRect;
    
    UIImage *imageColor;
    NSString *hexColor;
}

@end

@implementation PickColorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //选择颜色栏
    CGFloat width = widthView*0.85;
    imgRect = CGRectMake(0, 0, width, width/630*427);
    imgView = [[UIImageView alloc] initWithFrame:imgRect];
    imageColor = [UIImage imageNamed:@"color_pick"];
    imgView.image = imageColor;
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
    
    hexColor = [imageColor hexColorAtPixel:imgPick.center];
    
    //按钮
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, widthView*0.5, widthView*0.5)];
    bt.center = CGPointMake(widthView/2, heightView*0.45);
    [bt setImage:[UIImage imageNamed:@"bt_random"] forState:UIControlStateNormal];
    [bt setImage:[UIImage imageNamed:@"bt_random_light"] forState:UIControlStateHighlighted];
    [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];

    //亮度
    [self addLanternSlider];
    //速度
    [self addSpeedSlider];
}

//轻击手势触发方法
-(void)tapGesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    imgPick.center = point;
    
    hexColor = [imageColor hexColorAtPixel:point];
    [self showLightWithHexColor];
}
     

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedButton:(UIButton *)sender {
    CGPoint point = [self getRandomPointWithRect:imgRect];
    imgPick.center = point;
    
    hexColor = [imageColor hexColorAtPixel:point];
    [self showLightWithHexColor];
}

- (CGPoint)getRandomPointWithRect:(CGRect) rect {
    CGFloat x = (float)(1+arc4random()%24)/100 * CGRectGetWidth(rect);
    CGFloat y = (float)(1+arc4random()%99)/100 * CGRectGetHeight(rect);
    CGPoint point = CGPointMake(x, y);
    return point;
}

- (void)showLightWithHexColor {
    NSString *str = hexColor;
    NSString *strResult = [NSString stringWithFormat:@"%@%@%@%@%@%@",str,str,str,str,str,str];
    //发出指令
    NSString *str1 = [NSString stringWithFormat:@"0407%@",[strResult substringToIndex:28]];
    [[BLEService sharedInstance] setBLEPageWithType:BLEOrderTypeBreathe value:str1 pageNum:1];
    
    [self performSelector:@selector(delayMethod:) withObject:strResult afterDelay:0.2];
}


- (void)delayMethod:(NSString *)strResult{
    NSString *str2 = [NSString stringWithFormat:@"04080%d0%d%@",speedValue,lightValue,[strResult substringFromIndex:28]];
    [[BLEService sharedInstance] setBLEPageWithType:BLEOrderTypeBreathe value:str2 pageNum:2];
}

- (void)sliderChangeLantern:(UISlider *)sender {
    [super sliderChangeLantern:sender];
    //redo
    [self showLightWithHexColor];
}


- (void)sliderChangeSpeed:(UISlider *)sender {
    [super sliderChangeSpeed:sender];
    //redo
    [self showLightWithHexColor];
}

@end
