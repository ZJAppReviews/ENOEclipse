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

@interface BaseViewController : UIViewController {
    CGRect rectView;
    CGFloat widthView;
    CGFloat heightView;
}

- (instancetype)initWithFrame:(CGRect)frame;


//亮度
- (void)addLanternSlider;

//速度
- (void)addSpeedSlider;

@end
