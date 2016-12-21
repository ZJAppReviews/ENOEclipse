//
//  MainMenuVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "MainMenuVC.h"

#import "LanternVC.h"
#import "LavaLampVC.h"
#import "PickColorVC.h"
#import "EmergencyVC.h"

#import "PowerSwicth.h"
#import "SleepTimeVC.h"
#import "FavoritesVC.h"
#import "BLEConnectVC.h"

@interface MainMenuVC () {
    NSArray *imgList;
    UIView *midView;
    UIView *frontView;
}


@end

#define BUTTON_HEIGHT 80

@implementation MainMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];

    imgList = @[@"mm_lantern",@"mm_laval",@"mm_pick",@"mm_emergency",@"mm_power",@"mm_sleep",@"mm_favorites",@"mm_connect"];
    
    CGRect rect = self.view.frame;
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    //设置导航栏图片
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_logo"] forBarMetrics:UIBarMetricsDefault];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 331/2, 52/2)];
    imgView.center = CGPointMake(width/2, 44/2+20);
    imgView.image = [UIImage imageNamed:@"nav_logo"];
    [self.navigationController.view addSubview:imgView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //中间展示
    midView = [[UIView alloc] initWithFrame:CGRectMake(0, BUTTON_HEIGHT+64, width, height-2*BUTTON_HEIGHT-64)];
    midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midView];
    
    CGRect rectMid = CGRectMake(0, 0, width, height-2*BUTTON_HEIGHT-64);
    //白光+呼吸模式
    LanternVC *lanternVC = [[LanternVC alloc] initWithFrame:rectMid];
    [self addChildViewController:lanternVC];
    
    //彩光+自定义
    LavaLampVC *lavaLampVC = [[LavaLampVC alloc] initWithFrame:rectMid];
    [self addChildViewController:lavaLampVC];
    
    //彩光+呼吸模式
    PickColorVC *pickColorVC = [[PickColorVC alloc] initWithFrame:rectMid];
    [self addChildViewController:pickColorVC];
    
    //紧急模式
    EmergencyVC *emergencyVC = [[EmergencyVC alloc] initWithFrame:rectMid];
    [self addChildViewController:emergencyVC];
    
    //开关
    PowerSwicth *powerSwicth = [[PowerSwicth alloc] initWithFrame:rectMid];
    [self addChildViewController:powerSwicth];
    
    //睡眠模式
    SleepTimeVC *sleepTimeVC = [[SleepTimeVC alloc] initWithFrame:rectMid];
    [self addChildViewController:sleepTimeVC];
    
    //收藏
    FavoritesVC *favoritesVC = [[FavoritesVC alloc] initWithFrame:rectMid];
    [self addChildViewController:favoritesVC];
    
    //蓝牙连接
    BLEConnectVC *bLEConnectVC = [[BLEConnectVC alloc] initWithFrame:rectMid];
    [self addChildViewController:bLEConnectVC];
    
    [self showVc:0];
    
    //八个功能按钮
    CGFloat w = width/4;
    for (int i=0; i<8; i++) {
        int row = i;
        CGFloat y = 64;
        if (i > 3) {
            row -= 4;
            y = height - BUTTON_HEIGHT;
        }
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(row*w, y, w, BUTTON_HEIGHT)];
        NSString *strImg = imgList[i];
        [bt setImage:[UIImage imageNamed:strImg] forState:UIControlStateNormal];
        [bt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_light",strImg]] forState:UIControlStateHighlighted];
        [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = i;
        [self.view addSubview:bt];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedButton:(UIButton *)sender {
    NSInteger tag = sender.tag;
    [self showVc:tag];
}

-(void)showVc:(NSInteger)index
{
    if (index>=self.childViewControllers.count) {
        return;
    }
    
    UIViewController *vc = self.childViewControllers[index];
    UIView *view = vc.view;
    [midView addSubview:view];
    return;
    if (vc.isViewLoaded) {
        [view bringSubviewToFront:frontView];
    }
    else {
        [midView addSubview:view];
    }
    frontView = view;
    //    vc.view.frame = CGRectMake(offsetX, 0, self.contentScrollView.bounds.size.width, self.contentScrollView.bounds.size.height);
    
    
}


@end
