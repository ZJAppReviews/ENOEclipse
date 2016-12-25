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
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthView*0.6, widthView*0.6)];
    imgView.image = [UIImage imageNamed:@"mm_emergency_light"];
    imgView.center = CGPointMake(widthView/2, heightView/2);
    [self.view addSubview:imgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
