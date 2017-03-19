//
//  MainMenuVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "MainMenuVC.h"
#import "BLEService.h"

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
    
    UIButton *bt_selected;
}


@end


@implementation MainMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];

    imgList = @[@"mm_lantern",@"mm_laval",@"mm_pick",@"mm_emergency",@"mm_power",@"mm_sleep",@"mm_favorites",@"mm_connect"];
    
    CGRect rect = self.view.frame;
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    NSInteger bt_h = height/7;
    NSInteger bt_h_bottom = bt_h*0.75;
    
    //设置导航栏图片
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_logo"] forBarMetrics:UIBarMetricsDefault];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 331/2, 52/2)];
    imgView.center = CGPointMake(width/2, 44/2+20);
    imgView.image = [UIImage imageNamed:@"nav_logo"];
    [self.navigationController.view addSubview:imgView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //中间展示
    midView = [[UIView alloc] initWithFrame:CGRectMake(0, bt_h+64, width, height-bt_h-bt_h_bottom-64)];
    midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midView];
    
    CGRect rectMid = CGRectMake(0, 0, width, height-bt_h-bt_h_bottom-64);
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
    
    
    //八个功能按钮
    NSInteger w = width/4;
    NSInteger bottom_h = bt_h;
    for (int i=0; i<8; i++) {
        int row = i;
        CGFloat y = 64;
        
        //分割图
        if (i<3) {
            NSInteger h = bt_h*0.3;
            NSUInteger x = w/2+26 + row*w;
            NSUInteger y = 64+(bt_h-h)/2;
            NSUInteger w_line = w-51;
            CGRect rect1 = CGRectMake(x, y, w_line, h);
            UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:rect1];
            imgView1.image = [UIImage imageNamed:@"mm_line"];
            [self.view addSubview:imgView1];
        }
        
        
        if (i > 3) {
            row -= 4;
            bottom_h = bt_h_bottom;
            y = height - bottom_h;
            //分割线
            if (row>0) {
                UIView *cutLine = [[UIView alloc] initWithFrame:CGRectMake(row*w, y-0.5, 0.5, bottom_h)];
                cutLine.backgroundColor = [UIColor colorCutLine];
                [self.view addSubview:cutLine];
            }
        }
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(row*w, y, w, bottom_h)];
        NSString *strImg = imgList[i];
        [bt setImage:[UIImage imageNamed:strImg] forState:UIControlStateNormal];
        [bt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_light",strImg]] forState:UIControlStateHighlighted];
        [bt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_light",strImg]] forState:UIControlStateSelected];
        bt.backgroundColor = [UIColor clearColor];
        [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = i+10000;
        [self.view addSubview:bt];
        
    }
    //分割线
    UIView *cutLine = [[UIView alloc] initWithFrame:CGRectMake(0, height-bottom_h-0.5, width, 0.5)];
    cutLine.backgroundColor = [UIColor colorCutLine];
    [self.view addSubview:cutLine];
    
    //显示第一页
    [self showVc:10000];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedButton:(UIButton *)sender {
    NSInteger tag = sender.tag;
    [self showVc:tag];
}

-(void)showVc:(NSInteger)index {
    if (index == 10003) {
        if ([self isCennectedLight]) {
            //发出指令
            [[BLEService sharedInstance] writeOrderWithType:BLEOrderTypeUrgency];
        }
    }
    else if (index == 10004) {
        if ([self isCennectedLight]) {
            [[BLEService sharedInstance] writeOrderWithType:BLEOrderTypeClose];
        }
        return;
    }
    //切换按钮的高亮状态
    bt_selected.selected = NO;
    bt_selected = (UIButton *)[self.view viewWithTag:index];
    bt_selected.selected = YES;
    
    UIViewController *vc = self.childViewControllers[index-10000];
    UIView *view = vc.view;
    
    BOOL isContain = [[midView subviews] containsObject:view];
    if (isContain) {
        [midView bringSubviewToFront:view];
    }
    else {
        [midView addSubview:view];
    }
    frontView = view;
    if (index == 10006) {
        if ([self isCennectedLight]) {
            [[BLEService sharedInstance] writeOrderWithType:BLEOrderTypeGetMCU];
        }
    }
}


@end
