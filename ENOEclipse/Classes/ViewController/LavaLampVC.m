//
//  LavaLampVC.m
//  Eclipse
//
//  Created by QS on 2016/12/18.
//  Copyright © 2016年 QS. All rights reserved.
//  彩光+自定义

#import "LavaLampVC.h"

@interface LavaLampVC ()<UIAlertViewDelegate> {
    UIView *setView;
    NSArray *colorList;
    UIView *colorView;
    
    UIButton *currButton;
}

@end

@implementation LavaLampVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //#ED1D24   #9E1F63  #1C75BC  #00A79E   #00A651  #FFF200  #000000
    colorList = @[[UIColor colorWithHex:0xED1D24],[UIColor colorWithHex:0x9E1F63],[UIColor colorWithHex:0x1C75BC],[UIColor colorWithHex:0x00A79E],[UIColor colorWithHex:0x00A651],[UIColor colorWithHex:0xFFF200],[UIColor colorWithHex:0x000000]];
    
    //功能按钮
    NSInteger w = (widthView-4*VIEW_MARGIN)/2;
    NSInteger h = (heightView-60-4*VIEW_MARGIN)/2;
    for (int i=0; i<4; i++) {
        int row = i/2;
        int sec = i%2;
        CGRect rect = CGRectMake(VIEW_MARGIN+(VIEW_MARGIN*2+w)*sec, VIEW_MARGIN+(VIEW_MARGIN*2+h)*row, w, h);
        
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorMainLight].CGColor;
        view.layer.cornerRadius = w/10;
        [self.view addSubview:view];
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        [bt setTitle:[NSString stringWithFormat:@"PRESENT FUNCTION #%d",i] forState:UIControlStateNormal];
        if (i == 3) {//
            [bt setTitle:[NSString stringWithFormat:@"BUILD YOUR OWN MODE"] forState:UIControlStateNormal];
        }
        [bt setTitleColor:[UIColor colorMainLight] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorGrag] forState:UIControlStateHighlighted];
        bt.titleLabel.numberOfLines = 2;
        bt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = i+10000;
        [view addSubview:bt];
    }
    
    //速度
    [self addSpeedSlider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedButton:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 10003) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"To Build your own Lava Lamp,simply tap on each of the 6 LED's to rotate and select your favorite colors.You can adjust your preferred speed blew." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"Not cennected light"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        int setViewH = heightView-60;
        setView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthView, setViewH)];
        setView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:setView];
        //选择颜色
        colorView = [[UIView alloc] initWithFrame:CGRectMake(VIEW_MARGIN*2, 20, widthView-VIEW_MARGIN*4, 60)];
        [setView addSubview:colorView];
        NSInteger count = colorList.count;
        int colorWidth = (CGRectGetWidth(colorView.frame)-(count-1)*VIEW_MARGIN)/count;
        for(int j=0; j<count; j++){
            CGRect rect = CGRectMake((VIEW_MARGIN+colorWidth)*j, 0, colorWidth, colorWidth);
            UIButton *bt = [[UIButton alloc] initWithFrame:rect];
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = [UIColor colorMainLight].CGColor;
            bt.layer.cornerRadius = colorWidth/2;
            bt.backgroundColor = colorList[j];
            [bt addTarget:self action:@selector(clickedColorButton:) forControlEvents:UIControlEventTouchUpInside];
            bt.tag = j;
            [colorView addSubview:bt];
        }
        colorView.hidden = YES;
        
        //设置按钮
        int w = widthView/6;
        int marginX = w/3.4;
        int marginY = setViewH/20;
        for (int i=0; i<6; i++) {
            int row = i/2;
            int sec = i%2;
            
            int x;
            if (row == 0 || row == 2) {
                if (sec == 0) {
                    x = (int)(widthView/2-(w/2+marginX));
                }
                else {
                    x = (int)(widthView/2+(w/2+marginX));
                }
            }
            else if (row == 1) {
                if (sec == 0) {
                    x = w+w/2;
                }
                else {
                    x = (int)(widthView-(w+w/2));
                }
            }

            int y;
            if (row == 0) {
                y = (int)(setViewH/2+marginY-w-marginX);
            }
            else if (row == 1) {
                y = (int)(setViewH/2+marginY);
            }
            else {
                y = (int)(setViewH/2+marginY+w+marginX);
            }
            
            CGRect rect = CGRectMake(0, 0, w, w);
            UIButton *bt = [[UIButton alloc] initWithFrame:rect];
            bt.center = CGPointMake(x, y);
            bt.layer.borderWidth = 0.5;
            bt.layer.borderColor = [UIColor colorMainLight].CGColor;
            bt.layer.cornerRadius = w/2;
            [bt addTarget:self action:@selector(clickedSetButton:) forControlEvents:UIControlEventTouchUpInside];
            bt.tag = i+10000;
            [setView addSubview:bt];
        }
        //中间大圆
        CGRect rect = CGRectMake(0, 0, w*1.4, w*1.4);
        UIButton *bt = [[UIButton alloc] initWithFrame:rect];
        bt.center = CGPointMake(widthView/2, (int)(setViewH/2+marginY));
        bt.layer.borderWidth = 0.5;
        bt.layer.borderColor = [UIColor colorMainLight].CGColor;
        bt.layer.cornerRadius = w*1.4/2;
        bt.backgroundColor = [UIColor blackColor];
//        [bt addTarget:self action:@selector(clickedSetButton:) forControlEvents:UIControlEventTouchUpInside];
        [setView addSubview:bt];
    }
}

- (void)clickedColorButton:(UIButton *)sender {
    if (currButton) {
        currButton.backgroundColor = colorList[sender.tag];
        colorView.hidden = YES;
    }
}

- (void)clickedSetButton:(UIButton *)sender {
    currButton = sender;
    colorView.hidden = NO;
}

@end
