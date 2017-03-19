//
//  YYCircleSlider.h
//  YYCircleSlider
//
//  Created by Fedora on 2017/1/16.
//  Copyright © 2017年 opq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYCircleSlider : UIControl

@property (nonatomic,assign) int lineWidth;
@property (nonatomic,setter=changeAngle:) int angle;


//开始的角度数
@property (nonatomic,assign)CGFloat startAngle;
//结束的角度数
@property (nonatomic,assign)CGFloat endAngle;

@end
