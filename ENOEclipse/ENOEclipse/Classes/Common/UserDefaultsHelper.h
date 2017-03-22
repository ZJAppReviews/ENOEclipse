//
//  UserDefaultsHelper.h
//  ENOEclipse
//
//  Created by iosdev on 2017/3/21.
//  Copyright © 2017年 QS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsHelper : NSObject

+ (void)saveOneSurrent:(NSDictionary *)dic isAuto:(BOOL)isAuto;
+ (NSArray *)getSurrentList;

@end
