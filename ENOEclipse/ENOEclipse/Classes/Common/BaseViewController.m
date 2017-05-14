//
//  BaseViewController.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () {
    UISlider * sliderCircle;
}

@end

@implementation BaseViewController

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super init]) {
        lightValue = 5;
        speedValue = 2;
        rectView = frame;
        widthView = CGRectGetWidth(rectView);
        heightView = CGRectGetHeight(rectView);
        self.view.frame = rectView;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//亮度
- (void)addLanternSlider:(CGFloat)minValue max:(CGFloat)maxValue {
    CGRect frame = CGRectMake(VIEW_MARGIN, heightView-105, widthView - VIEW_MARGIN*2, 20);
    sliderCircle = [[UISlider alloc] initWithFrame:frame];
    sliderCircle.minimumValue = minValue;
    sliderCircle.maximumValue = maxValue;
    sliderCircle.value = lightValue/10.0;
    sliderCircle.continuous = NO;//默认YES  如果设置为NO，则每次滑块停止移动后才触发事件
    [sliderCircle addTarget:self action:@selector(sliderChangeLantern:) forControlEvents:UIControlEventValueChanged];
    sliderCircle.minimumTrackTintColor = [UIColor colorMainLight];
    sliderCircle.maximumTrackTintColor = [UIColor colorGragLight];
    sliderCircle.thumbTintColor = [UIColor colorGrag];
    
    UIImage * image1 = [UIImage imageNamed:@"light_dark"];
    UIImage * image2 = [UIImage imageNamed:@"light_bright"];
    sliderCircle.minimumValueImage = image1;
    sliderCircle.maximumValueImage = image2;
    [self.view addSubview:sliderCircle];
}

- (void)sliderChangeLantern:(UISlider *)sender {
    CGFloat value = sender.value;
    NSLog(@"%f", value);
    lightValue = round(value*10);
    NSLog(@"LanternValue>>>>%d", lightValue);
    sender.value = lightValue/10.0;
}

//速度
- (void)addSpeedSlider:(CGFloat)minValue max:(CGFloat)maxValue {
    CGRect speedFrame = CGRectMake(VIEW_MARGIN, heightView-50, widthView - VIEW_MARGIN*2, 20);
    UISlider * speedSlider = [[UISlider alloc] initWithFrame:speedFrame];
    speedSlider.minimumValue = minValue;
    speedSlider.maximumValue = maxValue;
    speedSlider.value = speedValue/10.0;
    speedSlider.continuous = NO;//默认YES  如果设置为NO，则每次滑块停止移动后才触发事件
    [speedSlider addTarget:self action:@selector(sliderChangeSpeed:) forControlEvents:UIControlEventValueChanged];
    speedSlider.minimumTrackTintColor = [UIColor colorMainLight];
    speedSlider.maximumTrackTintColor = [UIColor colorGragLight];
    speedSlider.thumbTintColor = [UIColor colorGrag];
    
    UIImage * image3 = [UIImage imageNamed:@"speed_snow"];
    UIImage * image4 = [UIImage imageNamed:@"speed_fast"];
    speedSlider.minimumValueImage = image3;
    speedSlider.maximumValueImage = image4;
    [self.view addSubview:speedSlider];
}

- (void)sliderChangeSpeed:(UISlider *)sender {
    CGFloat value = sender.value;
    NSLog(@"%f", value);
    speedValue = round(value*10);
    NSLog(@"speedValue>>>>%d", speedValue);
    sender.value = speedValue/10.0;
}

- (BOOL)isCennectedLight {
    BOOL isCen = [BLEService sharedInstance].isConnected;
    if (!isCen) {
        [SVProgressHUD showInfoWithStatus:@"Not cennected light"];
    }
    return isCen;
}

- (void)handUpateView {
    
}

@end
