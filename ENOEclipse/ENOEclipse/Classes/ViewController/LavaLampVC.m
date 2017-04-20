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
    //#ED1D24   #9E1F63  #1C75BC  #00A79E   #00A651  #FFF200  #000000
    colorList = @[[UIColor colorWithHex:0xED1D24],[UIColor colorWithHex:0x9E1F63],[UIColor colorWithHex:0x1C75BC],[UIColor colorWithHex:0x00A79E],[UIColor colorWithHex:0x00A651],[UIColor colorWithHex:0xFFF200],[UIColor colorWithHex:0x000000]];
    colorValues = @[@"ED1D24",@"9E1F63",@"1C75BC",@"00A79E",@"00A651",@"FFF200",@"000000"];
    
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
        [bt setTitle:[NSString stringWithFormat:@"PRESENT FUNCTION #%d",i+1] forState:UIControlStateNormal];
        if (i == 3) {//
            [bt setTitle:[NSString stringWithFormat:@"BUILD YOUR OWN MODE"] forState:UIControlStateNormal];
        }
        [bt setTitleColor:[UIColor colorMainLight] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor colorGrag] forState:UIControlStateHighlighted];
        bt.titleLabel.numberOfLines = 2;
        bt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [bt addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = i+1;
        [view addSubview:bt];
    }
    
    //速度
    [self addSpeedSlider];
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
        setView.hidden = NO;
        return;
    }
    int setViewH = heightView-60;
    setView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthView, setViewH)];
    setView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:setView];
    //选择颜色
    colorView = [[UIView alloc] initWithFrame:CGRectMake(VIEW_MARGIN*2, 15, widthView-VIEW_MARGIN*4, 60)];
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
        bt.tag = i;
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
    CGRect saveFrame = CGRectMake(VIEW_MARGIN, heightView-120, widthView - VIEW_MARGIN*2, 44);
    UIButton *bt_save = [UIButton buttonWithType:UIButtonTypeCustom];
    bt_save.frame = saveFrame;
    bt_save.layer.borderWidth = 0.5;
    bt_save.layer.borderColor = [UIColor colorMainLight].CGColor;
    bt_save.layer.cornerRadius = 5;
    
    [bt_save setTitle:@"SAVE SURRENT" forState:UIControlStateNormal];
    [bt_save setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bt_save addTarget:self action:@selector(clickedSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [setView addSubview:bt_save];
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
        name = @"Latly Setting";
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
        [inputColors setObject:value forKey:[NSString stringWithFormat:@"%d",(int)currButton.tag]];
        
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
    NSString *str2 = [NSString stringWithFormat:@"03080%d%@",speedValue,[strResult substringFromIndex:28]];
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
        setView.hidden = YES;
    }
}

@end
