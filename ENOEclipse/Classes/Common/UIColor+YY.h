//
//  UIColor+YY.h
//  ENOEclipse
//
//  Created by Chinasunhealth on 2016/12/24.
//  Copyright © 2016年 QS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YY)

// 十六进制的颜色值直接转为ios可用的UIColor
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;

/*
 分割线颜色
 色值：0xdddddd
 用途：
 */
+ (UIColor *)colorCutLine;


/*
 灰度颜色
 色值：0xbbbbbb
 用途：
 */
+ (UIColor *)colorGrag;

/*
 灰度颜色
 色值：0xeeeeee
 用途：
 */
+ (UIColor *)colorGragLight;

/*
 棕色颜色
 色值：0xa65093
 用途：
 */
+ (UIColor *)colorMainLight;


@end
