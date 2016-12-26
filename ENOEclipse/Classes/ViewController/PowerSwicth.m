//
//  PowerSwicth.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "PowerSwicth.h"

@interface PowerSwicth ()

@end

@implementation PowerSwicth

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, widthView-VIEW_MARGIN*2, 30)];
    lb.center = CGPointMake(widthView/2, heightView/2);
    lb.text = @"ENO ECLIPSE SWITCH";
    lb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
