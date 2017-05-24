//
//  YYCircleSlider.m
//  YYCircleSlider
//
//  Created by Fedora on 2017/1/16.
//  Copyright © 2017年 opq. All rights reserved.
//

#import "YYCircleSlider.h"
#import "UIColor+YY.h"

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@interface YYCircleSlider () {
    
    CGFloat radius;
}

@end

@implementation YYCircleSlider

-(id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _lineWidth = 5;
        _angle = 180;
        _startAngle = -230;
        _endAngle = 50;
        radius = (self.frame.size.width - _lineWidth*8)/2;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //1.绘制灰色的背景
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, radius, ToRad(_startAngle), ToRad(_endAngle), 0);
    [[UIColor colorGragLight] setStroke];
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    
    
    //2.绘制进度
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2,radius,ToRad(_startAngle), ToRad(_startAngle-_angle), 0);
    [[UIColor colorMainLight] setStroke];
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    
    //3.绘制拖动小块
    CGPoint handleCenter =  [self pointFromAngle: (_startAngle-self.angle)];
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 3,[UIColor clearColor].CGColor);
    [[UIColor colorGrag] setStroke];
    CGContextSetLineWidth(context, _lineWidth);
    CGContextAddEllipseInRect(context, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth, _lineWidth));
    CGContextDrawPath(context, kCGPathStroke);
}

-(CGPoint)pointFromAngle:(int)angleInt{
    //中心点
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth/2, self.frame.size.height/2 - _lineWidth/2);
    
    //根据角度得到圆环上的坐标
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(angleInt)));
    
    return result;
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    return YES;
}


-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    //获取触摸点
    CGPoint lastPoint = [touch locationInView:self];
    //使用触摸点来移动小块
     [self movehandle:lastPoint];
    
    return YES;
}

-(void)movehandle:(CGPoint)lastPoint{
    //获得中心点
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2,
                                      self.frame.size.height/2);
    CGFloat distance = sqrt(pow((lastPoint.x - centerPoint.x), 2) + pow((lastPoint.y - centerPoint.y), 2));
    //中间不响应
    if (distance<radius-_lineWidth) {
        return;
    }
    
    //计算中心点到任意点的角度
    float currentAngle = AngleFromNorth(centerPoint,
                                        lastPoint,
                                        NO);
    int angleInt = floor(currentAngle);
    //判断不超过最大和最小角度
    if (angleInt>=_startAngle && angleInt<=_endAngle) {
        //保存新角度
        self.angle = _startAngle-angleInt;
        
        //重新绘制
        [self setNeedsDisplay];
        
        //发送值改变事件
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

-(void)changeAngle:(int)angle{
    _angle = angle;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

//从苹果是示例代码clockControl中拿来的函数
//计算中心点到任意点的角度
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
//    NSLog(@"result#:%f",result);
    return (result >= 50 ? result-360 : result);
//    return (result >=0  ? result : result + 360.0);
}

@end
