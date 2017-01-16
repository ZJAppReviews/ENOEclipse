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

@interface BaseViewController : UIViewController {
    CGRect rectView;
    int widthView;
    int heightView;
}

- (instancetype)initWithFrame:(CGRect)frame;


//亮度
- (void)addLanternSlider;

//速度
- (void)addSpeedSlider;

@end
