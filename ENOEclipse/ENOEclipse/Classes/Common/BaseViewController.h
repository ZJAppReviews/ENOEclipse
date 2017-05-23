//
//  BaseViewController.h
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDefined.h"
#import "UIColor+YY.h"
#import "BLEService.h"
#import "SVProgressHUD.h"
#import "UserDefaultsHelper.h"

#import "MJRefresh.h"

@interface BaseViewController : UIViewController {
    CGRect rectView;
    int widthView;
    int heightView;
    
    int lightValue;
    UISlider * speedSlider;
    int speedValue;
}

- (instancetype)initWithFrame:(CGRect)frame;


//亮度
- (void)addLanternSlider:(CGFloat)minValue max:(CGFloat)maxValue;

//速度
- (void)addSpeedSlider:(CGFloat)minValue max:(CGFloat)maxValue;

//判断连接状态
- (BOOL)isCennectedLight;

- (void)sliderChangeLantern:(UISlider *)sender;
- (void)sliderChangeSpeed:(UISlider *)sender;

- (void)handUpateView;


@end
