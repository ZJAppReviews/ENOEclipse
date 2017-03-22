//
//  UserDefaultsHelper.m
//  ENOEclipse
//
//  Created by iosdev on 2017/3/21.
//  Copyright © 2017年 QS. All rights reserved.
//

#import "UserDefaultsHelper.h"

#define USER_DEFALTS [NSUserDefaults standardUserDefaults]

@implementation UserDefaultsHelper

+ (void)saveOneSurrent:(NSDictionary *)dic isAuto:(BOOL)isAuto{
    NSMutableArray *temps = [NSMutableArray arrayWithArray:[self getSurrentList]];
    NSInteger count = temps.count;
    if (isAuto) {
        if (count == 0) {
            [temps addObject:dic];
        }
        else {
            [temps replaceObjectAtIndex:0 withObject:dic];
        }
    }
    else {
        if (count<6 && count>=0) {
            [temps addObject:dic];
        }
        else {
            [temps removeObjectAtIndex:1];
            [temps addObject:dic];
        }
    }
    [USER_DEFALTS setObject:temps forKey:@"Surrent_List"];
}
+ (NSArray *)getSurrentList {
    return [USER_DEFALTS objectForKey:@"Surrent_List"];
}

@end
