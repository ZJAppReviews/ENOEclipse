//
//  LanternVC.m
//  Eclipse
//
//  Created by QS on 2016/12/18.
//  Copyright © 2016年 QS. All rights reserved.
//  白光+呼吸模式

#import "LanternVC.h"

@interface LanternVC ()

@end

@implementation LanternVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGRect rect = CGRectMake(0, 0, widthView, widthView*0.8);
//    UIView *view = [[UIView alloc] initWithFrame:rect];
//    view.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:view];
    [self addCircle];
    
    //亮度
    [self addLanternSlider];
//    CGRect frame = CGRectMake(VIEW_MARGIN, CGRectGetMaxY(rect)+25, widthView - VIEW_MARGIN*2, 20);
//    [self addLanternSliderWithFrame:frame];
    
    //速度
    [self addSpeedSlider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCircle {
    /*
     *画实线圆
     */
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 2.0f ;
    solidLine.strokeColor = [UIColor colorMainLight].CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(widthView*0.2, widthView*0.1, widthView*0.6, widthView*0.6));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [self.view.layer addSublayer:solidLine];
}


////亮度
//- (void)addLanternSliderWithFrame:(CGRect)frame  {
//    UISlider * slider = [[UISlider alloc] initWithFrame:frame];
//    slider.minimumValue = 0;
//    slider.maximumValue = 1;
//    slider.value = 0.5;
//    slider.continuous = NO;//默认YES  如果设置为NO，则每次滑块停止移动后才触发事件
//    [slider addTarget:self action:@selector(sliderChangeLantern:) forControlEvents:UIControlEventValueChanged];
//    slider.minimumTrackTintColor = [UIColor colorMainLight];
//    slider.maximumTrackTintColor = [UIColor colorGragLight];
//    slider.thumbTintColor = [UIColor colorGrag];
//    
//    UIImage * image1 = [UIImage imageNamed:@"light_dark"];
//    UIImage * image2 = [UIImage imageNamed:@"light_bright"];
//    slider.minimumValueImage = image1;
//    slider.maximumValueImage = image2;
//    [self.view addSubview:slider];
//}
//
//- (void)sliderChangeLantern:(UISlider *)sender {
//    CGFloat value = sender.value;
//    NSLog(@"%f", value);
//}



@end
