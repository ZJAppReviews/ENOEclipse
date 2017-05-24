//
//  PickColorVC.m
//  ENOEclipse
//
//  Created by QS on 2016/12/20.
//  Copyright © 2016年 QS. All rights reserved.
//  彩光+呼吸模式

#import "PickColorVC.h"
#import "YYAshapelGradientView.h"
#import "UIImage+YYColorPiont.h"

@interface PickColorVC () {
    UIImageView *imgView;
    UIImageView *imgPick;
    CGRect imgRect;
    
    UIImage *imageColor;
    NSString *hexColor;
    //
    CGPoint centerPoint;
    int min;
    int max;
    
    UIButton *bt_random;
}

@end

@implementation PickColorVC

-(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //选择颜色栏
    CGFloat width = widthView*0.85;
    imgRect = CGRectMake(0, 0, width, width/630*427);
    imgView = [[UIImageView alloc] initWithFrame:imgRect];
    imageColor = [self OriginImage:[UIImage imageNamed:@"color_pick"] scaleToSize:CGSizeMake(width, width/630*427)] ;
    imgView.image = imageColor;
    imgView.center = CGPointMake(widthView/2, heightView/2.6);
    imgView.userInteractionEnabled = YES;
    [self.view addSubview:imgView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [imgView addGestureRecognizer:tapGesture];
    
    imgPick = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthView*0.05, widthView*0.05)];
    imgPick.center = CGPointMake(width/2, heightView*0.1);
    imgPick.image = [UIImage imageNamed:@"color_pick_selected"];
    [imgView addSubview:imgPick];
    
    hexColor = [imageColor hexColorAtPixel:imgPick.center];
    
    //按钮
    CGFloat btWidth = widthView*0.28;
    bt_random = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btWidth, btWidth)];
    bt_random.layer.cornerRadius = btWidth/2;
    bt_random.center = CGPointMake(widthView/2, heightView*0.51);
    [bt_random setBackgroundImage:[UIImage imageNamed:@"bt_random"] forState:UIControlStateNormal];
    [bt_random setBackgroundImage:[UIImage imageNamed:@"bt_random_light"] forState:UIControlStateHighlighted];
    [bt_random addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt_random];
    [self setButtonBackgroudColor:imgPick.center];
    
    centerPoint = CGPointMake(CGRectGetWidth(imgView.frame)/2, CGRectGetHeight(imgView.frame)*0.76);
//    imgPick.center = centerPoint;
    min = width*0.25;
    max = width/2;
    //亮度
//    [self addLanternSlider:0.1 max:0.5];
    //速度
    [self addSpeedSlider:0.1 max:0.7];
    CGRect rect = speedSlider.frame;
    speedSlider.frame = CGRectMake(rect.origin.x, CGRectGetMaxY(imgView.frame)+heightView*0.1, rect.size.width, rect.size.height);
}

//修改按钮背景颜色
- (void)setButtonBackgroudColor:(CGPoint)point {
    UIColor *color = [imageColor colorAtPixel:point];
//    bt_random.backgroundColor = color;
}

//轻击手势触发方法
-(void)tapGesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:imgView];
    if ([self isImageContainWithPoint:point]) {
        [self setButtonBackgroudColor:point];
        imgPick.center = point;
        hexColor = [imageColor hexColorAtPixel:point];
        [self showLightWithHexColor];
    }
}
     

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickedButton:(UIButton *)sender {
    CGPoint point = [self getRandomPointWithRect:imgRect];
    imgPick.center = point;
    [self setButtonBackgroudColor:point];
    hexColor = [imageColor hexColorAtPixel:point];
    [self showLightWithHexColor];
}

- (CGPoint)getRandomPointWithRect:(CGRect) rect {
    CGPoint point;
    BOOL is = YES;
    do {
        CGFloat x = (float)([self getRandomNumber:0 to:100])/100.0 * CGRectGetWidth(rect);
        CGFloat y = (float)([self getRandomNumber:0 to:100])/100 * CGRectGetHeight(rect);
        //    int dis = [self getRandomNumber:min to:max];
        
        point = CGPointMake(x, y);
        is = [self isImageContainWithPoint:point];
    } while (!is);
    return point;
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
}

- (void)showLightWithHexColor {
    if ([self isCennectedLight]) {
        NSString *str = hexColor;
        NSString *strResult = [NSString stringWithFormat:@"%@%@%@%@%@%@",str,str,str,str,str,str];
        //发出指令
        NSString *str1 = [NSString stringWithFormat:@"0407%@",[strResult substringToIndex:28]];
        [[BLEService sharedInstance] setBLEPageWithType:BLEOrderTypeBreathe value:str1 pageNum:1];
        
        [self performSelector:@selector(delayMethod:) withObject:strResult afterDelay:0.2];
    }
}


- (void)delayMethod:(NSString *)strResult{
    NSString *str2 = [NSString stringWithFormat:@"0408%@0%d0%d",[strResult substringFromIndex:28],lightValue,speedValue];
    [[BLEService sharedInstance] setBLEPageWithType:BLEOrderTypeBreathe value:str2 pageNum:2];
}

- (void)sliderChangeLantern:(UISlider *)sender {
    [super sliderChangeLantern:sender];
    //redo
    [self showLightWithHexColor];
}


- (void)sliderChangeSpeed:(UISlider *)sender {
    [super sliderChangeSpeed:sender];
    //redo
    [self showLightWithHexColor];
}

//
- (BOOL)isImageContainWithPoint:(CGPoint) point {
    CGFloat distance = [self distanceBetweenPoints:centerPoint points:point];
    if (distance>min && distance<max) {
        return YES;
    }
    else {
        return NO;
    }
}

//两点间距离
- (CGFloat)distanceBetweenPoints:(CGPoint)first points:(CGPoint)second {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY);
}

@end
