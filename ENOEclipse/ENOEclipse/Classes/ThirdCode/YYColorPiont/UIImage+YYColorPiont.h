//
//  UIImage+YYColorPiont.h
//  YYImageColor
//
//  Created by Fedora on 2017/4/16.
//  Copyright © 2017年 opq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YYColorPiont)

- (UIColor *)colorAtPixel:(CGPoint)point;

- (NSString *)hexColorAtPixel:(CGPoint)point;

@end
