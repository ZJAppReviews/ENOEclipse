//
//  EmergencyVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "EmergencyVC.h"

@interface EmergencyVC ()

@end

@implementation EmergencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, widthView*0.6, widthView*0.53)];
    [bt setBackgroundImage:[UIImage imageNamed:@"emergency_tips"] forState:UIControlStateNormal];
    bt.center = CGPointMake(widthView/2, heightView/2);
    [bt addTarget:self action:@selector(clickedButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedButton {
    if ([self isCennectedLight]) {
        //发出指令
        [[BLEService sharedInstance] writeOrderWithType:BLEOrderTypeUrgency];
    }
}

@end
