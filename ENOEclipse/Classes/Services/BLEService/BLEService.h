//
//  BLEService.h
//  QianShanJY
//
//  Created by iosdev on 16/3/3.
//  Copyright © 2016年 chinasun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

typedef NS_ENUM(NSUInteger, BLEOrderType) {
    BLEOrderTypeOpen = -1,     //开灯--1
    BLEOrderTypeClose = 0,     //关灯-0
    BLEOrderTypeUrgency,       //紧急模式-5
    BLEOrderTypeGetMCU,        //查询MCU状态-F
};

typedef NS_ENUM(NSUInteger, BLEOrderTypeSet) {
    BLEOrderTypeLight = 0,  //开启白灯-1
    BLEOrderTypeFixed,      //固定模式-2
    BLEOrderTypeSleep,      //睡眠模式-6
};

typedef NS_ENUM(NSUInteger, BLEOrderTypeSetPage) {
    BLEOrderTypeCustom = 0,  //自定义模式-3
    BLEOrderTypeBreathe,     //呼吸模式-4
};

@interface BLEService : NSObject

@property(nonatomic,strong)BabyBluetooth *babyBluetooth;

+ (instancetype)sharedInstance;

@property(nonatomic,assign)int errorCode;

@property(nonatomic,assign)BOOL isConnected;

//开始扫描
- (void)startScanConnectBLE;
- (void)startScanBLETime:(NSInteger)time successBlock:(void (^)(CBPeripheral *peripheral, NSString *strMac))successBlock failBlock:(void (^)())failBlock;



//停止扫描
- (void)pauseScanBLE;
//断开所有连接
- (void)cancelAllBLEConnection;
//断开连接
-(void)cancelBLEConnection:(CBPeripheral *)peripheral;

/*下发指令到设备
 BLEOrderTypeOpen = -1,     //开灯--1
 BLEOrderTypeClose = 0,     //关灯-0
 BLEOrderTypeUrgency,       //紧急模式-5
 BLEOrderTypeGetMCU,        //查询MCU状态-F
 */
- (void)writeOrderWithType:(BLEOrderType)orderType;

/*设置参数
 BLEOrderTypeLight = 0,  //开启白灯-1
 BLEOrderTypeFixed,      //固定模式-2
 BLEOrderTypeSleep,      //睡眠模式-6
 */
- (void)setBLEWithType:(BLEOrderTypeSet)orderType value:(NSString *)string;

/*设置参数分包
 BLEOrderTypeCustom = 0,  //自定义模式-3
 BLEOrderTypeBreathe,     //呼吸模式-4
 */
- (void)setBLEPageWithType:(BLEOrderTypeSet)orderType value:(NSString *)string;

- (void)bloodPressureStartBlock:(void (^)(NSString *str))startBlock retuneValueBlock:(void (^)(int value))retuneValueBlock disConnectBlock:(void (^)())disConnectBlock failBlock:(void (^)(int errorCode))failBlock endBlock:(void (^)(int high,int low,int heart))endBlock;

//连接ble
- (void)connectPeripheral:(CBPeripheral *)peripheral successBlock:(void (^)())successBlock failBlock:(void (^)())failBlock startOrderBlock:(void (^)())startOrderBlock;
@end
