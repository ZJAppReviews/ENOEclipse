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
    NSArray *colorValues;
    NSMutableDictionary *inputColors;
    
    UIView *colorView;
    
    UIButton *currButton;
}

@end

@implementation LavaLampVC

- (void)viewDidLoad {
    [super viewDidLoad];
    inputColors = [[NSMutableDictionary alloc] init];
    //红：FF0000，紫色：FF00FF，蓝：0000FF，青：00FFFF，绿：00FF00，黄：FFFF00，黑：000000
    colorList = @[[UIColor colorWithHex:0xFF0000],[UIColor colorWithHex:0xFF00FF],[UIColor colorWithHex:0x0000FF],[UIColor colorWithHex:0x00FFFFE],[UIColor colorWithHex:0x00FF00],[UIColor colorWithHex:0xFFFF00],[UIColor colorWithHex:0x000000]];
    colorValues = @[@"FF0000",@"FF00FF",@"0000FF",@"00FFFF",@"00FF00",@"FFFF00",@"000000"];
    
    //功能按钮
    NSInteger w = (widthView-4*VIEW_MARGIN)/2;
    NSInteger h = (heightView-60-4*VIEW_MARGIN)/2;
    for (int i=0; i<4; i++) {
        int row = i/2;
        int sec = i%2;
        CGRect rect = CGRectMake(VIEW_MARGIN+(VIEW_MARGIN*2+w)*sec, VIEW_MARGIN+(VIEW_MARGIN*3+h)*row, w, h);
        
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor colorMainLight].CGColor;
        view.layer.cornerRadius = w/10;
        [self.view addSubview:view];
        
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        [bt setTitle:[NSString stringWithFormat:@"PRESENT\nFUNCTION #%d",i+1] forState:UIControlStateNormal];
        if (i == 3) {//
            [bt setTitle:[NSString stringWithFormat:@"BUILD YOUR\nOWN MODE"] forState:UIControlStateNormal];
        }
        [bt setTitleColor:[UIColor colorMainLight] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorGrag] forState:UIControlStateHighlighted];
        bt.titleLabel.numberOfLines = 2;
        bt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = i+1;
        [view addSubview:bt];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedButton:(UIButton *)sender {
    int tag = (int)sender.tag;
    if (tag == 4) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"To Build your own Lava Lamp,simply tap on each of the 6 LED's to rotate and select your favorite colors.You can adjust your preferred speed blew." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//        [alertView show];
        [self showCutomeView];
    }
    else {
        if ([self isCennectedLight]) {
            //发出指令
            [[BLEService sharedInstance] setBLEWithType:BLEOrderTypeFixed value:[NSString stringWithFormat:@"020%d",tag]];
        }
    }
}

- (void)showCutomeView {
    if (setView) {
        [setView removeFromSuperview];
    }
    int setViewH = heightView-60;
    setView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthView, heightView)];
    setView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:setView];
    //选择颜色
    colorView = [[UIView alloc] initWithFrame:CGRectMake(VIEW_MARGIN*2, 0, widthView-VIEW_MARGIN*4, 75)];
    colorView.layer.borderWidth = 0.5;
    colorView.layer.borderColor = [UIColor colorCutLine].CGColor;
    colorView.layer.cornerRadius = 8;
    [setView addSubview:colorView];
    UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, widthView-VIEW_MARGIN*4, 20)];
    lb_title.text = @"Pick you color";
    lb_title.textColor = [UIColor darkGrayColor];
    lb_title.textAlignment = NSTextAlignmentCenter;
    [colorView addSubview:lb_title];
    CGFloat lb_y = CGRectGetMaxY(lb_title.frame)+15;
    
    NSInteger count = colorList.count;
    int colorWidth = (CGRectGetWidth(colorView.frame)-(count+1)*VIEW_MARGIN)/count;
    for(int j=0; j<count; j++){
        CGRect rect = CGRectMake(VIEW_MARGIN+(VIEW_MARGIN+colorWidth)*j, lb_y, colorWidth, colorWidth);
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
            y = (int)((setViewH-50)/2+marginY-w-marginX);
        }
        else if (row == 1) {
            y = (int)((setViewH-50)/2+marginY);
        }
        else {
            y = (int)((setViewH-50)/2+marginY+w+marginX);
        }
        
        CGRect rect = CGRectMake(0, 0, w, w);
        UIButton *bt = [[UIButton alloc] initWithFrame:rect];
        bt.center = CGPointMake(x, y);
        bt.layer.borderWidth = 0.5;
        bt.layer.borderColor = [UIColor colorMainLight].CGColor;
        bt.layer.cornerRadius = w/2;
        [bt addTarget:self action:@selector(clickedSetButton:) forControlEvents:UIControlEventTouchUpInside];
        int tag = i;
        switch (i) {
            case 2:
                tag = 5;
                break;
            case 3:
                tag = 2;
                break;
            case 4:
                tag = 4;
                break;
            case 5:
                tag = 3;
                break;
            default:
                break;
        }
        bt.tag = tag;
        [setView addSubview:bt];
    }
    //中间大圆
    CGRect rect = CGRectMake(0, 0, w*1.4, w*1.4);
    UIButton *bt = [[UIButton alloc] initWithFrame:rect];
    bt.center = CGPointMake(widthView/2, (int)((setViewH-50)/2+marginY));
    bt.layer.borderWidth = 0.5;
    bt.layer.borderColor = [UIColor colorMainLight].CGColor;
    bt.layer.cornerRadius = w*1.4/2;
    bt.backgroundColor = [UIColor blackColor];
    //        [bt addTarget:self action:@selector(clickedSetButton:) forControlEvents:UIControlEventTouchUpInside];
    [setView addSubview:bt];
    //保存按钮
    CGRect saveFrame = CGRectMake(widthView/4, heightView-70, widthView/2, 50);
    UIButton *bt_save = [UIButton buttonWithType:UIButtonTypeCustom];
    bt_save.frame = saveFrame;
    bt_save.layer.borderWidth = 0.5;
    bt_save.layer.borderColor = [UIColor colorCutLine].CGColor;
    bt_save.layer.cornerRadius = 5;
    
    [bt_save setTitle:@"SAVE CURRENT" forState:UIControlStateNormal];
    [bt_save setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bt_save addTarget:self action:@selector(clickedSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [setView addSubview:bt_save];
    
    //速度
    [self addSpeedSlider:0.1 max:0.6];
    CGRect rectSpeed = speedSlider.frame;
    speedSlider.frame = CGRectMake(rectSpeed.origin.x, heightView-115, rectSpeed.size.width, rectSpeed.size.height);
    
}



- (void)didPresentAlertView:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSLog(@"present is %@",textField.text);
    
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSString * name = tf.text;
        NSLog(@"name is %@",name);
        if (name.length>0) {
            [self saveColosWithName:name];
        }
        else {
            [SVProgressHUD showInfoWithStatus:@"Please input name"];
        }
    }
}

- (void)saveColosWithName:(NSString *)name {
    BOOL isAuto = NO;
    if (!name) {
        isAuto = YES;
        name = @"Last";
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [dic setObject:[self getColorListSting] forKey:@"color"];
    [dic setObject:[NSDate date] forKey:@"date"];
    [dic setObject:name forKey:@"name"];
    [dic setObject:[NSNumber numberWithInteger:speedValue] forKey:@"speed"];
    [UserDefaultsHelper saveOneSurrent:dic isAuto:isAuto];
}

- (void)clickedSaveButton:(UIButton *)sender {
    if (inputColors.count==6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Name" message:@" " delegate:self
                                              cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
        alert.alertViewStyle  = UIAlertViewStylePlainTextInput;
        [alert show];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"Please selected six light"];
    }
}

- (NSString *)getColorListSting {
    NSString *strResult = [[NSString alloc] init];
    for (int i=0; i<6; i++) {
        strResult = [strResult stringByAppendingString:[inputColors objectForKey:[NSString stringWithFormat:@"%d",i]]];
    }
    return strResult;
}

- (void)clickedColorButton:(UIButton *)sender {
    if (currButton) {
        int tag = (int)sender.tag;
        currButton.backgroundColor = colorList[tag];
        colorView.hidden = YES;
        
        NSString *value = colorValues[tag];
        int lightTag = (int)currButton.tag;
        [inputColors setObject:value forKey:[NSString stringWithFormat:@"%d",lightTag]];
        
        [self dealOrder];
    }
}

- (void)dealOrder {
    if (inputColors.count==6) {
        if ([self isCennectedLight]) {
            NSString *strResult = [self getColorListSting];
            [self saveColosWithName:nil];
            
            //发出指令
            NSString *str1 = [NSString stringWithFormat:@"0307%@",[strResult substringToIndex:28]];
            [[BLEService sharedInstance] setBLEPageWithType:BLEOrderTypeCustom value:str1 pageNum:1];
            [self performSelector:@selector(delayMethod:) withObject:strResult afterDelay:0.2];
        }
    }
}

- (void)delayMethod:(NSString *)strResult{
    if (speedValue == 0) {
        speedValue = 1;
    }
    NSString *str2 = [NSString stringWithFormat:@"0308%@0%d",[strResult substringFromIndex:28],speedValue];
    [[BLEService sharedInstance] setBLEPageWithType:BLEOrderTypeCustom value:str2 pageNum:2];
}

- (void)clickedSetButton:(UIButton *)sender {
    currButton = sender;
    colorView.hidden = NO;
}

- (void)resetColorSet {
    if (setView) {
        setView.hidden = YES;
    }
}

- (void)sliderChangeSpeed:(UISlider *)sender {
    [super sliderChangeSpeed:sender];
    [self dealOrder];
}

- (void)handUpateView {
    if (setView) {
        [inputColors removeAllObjects];
        [setView removeFromSuperview];
        [speedSlider removeFromSuperview];
    }
}

@end
