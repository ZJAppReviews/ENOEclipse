//
//  SleepTimeVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "SleepTimeVC.h"
#import "YYAshapelGradientView.h"

@interface SleepTimeVC ()

@end

@implementation SleepTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor darkGrayColor];
    
    YYAshapelGradientView *view = [[YYAshapelGradientView alloc] initWithFrame:CGRectMake(40, 100, 300, 300)];
    //    view.progressLineWidth = 90;//最大是45
    //    view.startAngle = -210;
    //    view.endAngle = 30;
    //    view.biggerTitle = @"属性居中，字体大小和颜色可以改变，自身大小为半径减去线宽，最好是 字少一些";
    view.biggerLabel.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
