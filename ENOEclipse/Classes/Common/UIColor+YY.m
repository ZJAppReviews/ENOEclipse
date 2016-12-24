//
//  UIColor+YY.m
//  ENOEclipse
//
//  Created by Chinasunhealth on 2016/12/24.
//  Copyright © 2016年 QS. All rights reserved.
//

#import "UIColor+YY.h"

@implementation UIColor (YY)

// 十六进制的颜色值直接转为ios可用的UIColor
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*) colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (NSString *) hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

/*
 分割线颜色
 色值：0xf5f5f5
 用途：
 */
+ (UIColor *)colorCutLine {
    return [UIColor colorWithHex:0xf5f5f5];
}

/*
 灰度颜色
 色值：0xbbbbbb
 用途：
 */
+ (UIColor *)colorGrag {
    return [UIColor colorWithHex:0xbbbbbb];
}

/*
 灰度颜色
 色值：0xeeeeee
 用途：
 */
+ (UIColor *)colorGragLight {
    return [UIColor colorWithHex:0xeeeeee];
}

/*
 棕色颜色
 色值：0xa65093
 用途：
 */
+ (UIColor *)colorMainLight {
    return [UIColor colorWithHex:0xa65093];
}

@end
