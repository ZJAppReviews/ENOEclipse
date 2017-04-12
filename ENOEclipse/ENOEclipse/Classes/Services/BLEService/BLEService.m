 //
//  BLEService.m
//  QianShanJY
//
//  Created by iosdev on 16/3/3.
//  Copyright © 2016年 chinasun. All rights reserved.
//

#import "BLEService.h"
#import "SVProgressHUD.h"

#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"

@interface BLEService (){
    NSMutableArray *orderValues;
    NSArray *orderNames;
    NSArray *orderSetNames;
    
    
    CBPeripheral *currPeripheral;
    CBCharacteristic *notifiyCharacteristic;
    CBCharacteristic *writeCharacteristic;
    
    //
    NSString *strHead;
}
//搜索
@property (nonatomic, copy) void (^scanFailBlock)();
@property (nonatomic, copy) void (^scanSuccessBlock)();

//连接
@property (nonatomic, copy) void (^connectBlock)();
@property (nonatomic, copy) void (^connectFailBlock)();
@property (nonatomic, copy) void (^startOrderBlock)();
//测量
@property (nonatomic, copy) void (^startBlock)();
@property (nonatomic, copy) void (^retuneValueBlock)();
@property (nonatomic, copy) void (^disConnectBlock)();
@property (nonatomic, copy) void (^failBlock)();
@property (nonatomic, copy) void (^endBlock)();

@end


@implementation BLEService

static BLEService *_instance = nil;

/*下发指令到设备,格式：AA55+长度+校验和+命令码+00*15
 BLEOrderTypeOpen = -1,     //开灯--1
 BLEOrderTypeClose = 0,     //关灯-0
 BLEOrderTypeUrgency,       //紧急模式-5
 BLEOrderTypeGetMCU,        //查询MCU状态-F
 */
- (void)initFidedOrderValues {
    orderNames = @[@"开灯",@"关灯",@"紧急模式",@"查询MCU状态"];
    orderSetNames = @[@"开启白灯",@"固定模式",@"自定义模式",@"呼吸模式",@"睡眠模式"];
    //公用的数据
    strHead = @"AA55";
    NSString *strTail = @"000000000000000000000000000000";//
    
    //00
    NSString *strOrder = [NSString stringWithFormat:@"%@050500%@",strHead,strTail];
    NSData *data1 = [BabyToy convertHexStrToData:strOrder];
    
    //05
    strOrder = [NSString stringWithFormat:@"%@050a05%@",strHead,strTail];
    NSData *data2 = [BabyToy convertHexStrToData:strOrder];
    
    //0F
    strOrder = [NSString stringWithFormat:@"%@05040F%@",strHead,strTail];
    NSData *data3 = [BabyToy convertHexStrToData:strOrder];
    
    orderValues = [[NSMutableArray alloc] initWithObjects:data1, data2, data3, nil];
}

//得到验证码,http://www.cnblogs.com/Jeamine/p/5210890.html
- (NSString *)getCodeWithLength:(NSString *)strLength data:(NSString *)strData {
    NSString *allData = [NSString stringWithFormat:@"%@%@",strLength,strData];
    NSData *tempData = [BabyToy convertHexStrToData:allData];
    int length = (int)tempData.length;
    Byte *bytes = (unsigned char *)[tempData bytes];
    Byte sum = 0;
    for (int i = 0; i<length; i++) {
        sum += bytes[i];
    }
//    int sumT = sum+[BabyToy convertHexStrToInt:strLength];
    int at = sum%256;
    NSData *data = [BabyToy ConvertIntToData:at];
    NSString *code = [BabyToy convertDataToHexStr:data];
    
    return [code substringToIndex:2];
}

/*设置参数
 BLEOrderTypeLight = 0,  //开启白灯-1
 BLEOrderTypeFixed,      //固定模式-2
 BLEOrderTypeSleep,      //睡眠模式-6
 */
- (NSData *)getBLEOrderType:(BLEOrderTypeSet)type value:(NSString *)string{
    NSString *strOrder;
    switch (type) {
        case BLEOrderTypeLight: {//01,格式：AA55+07+校验和+命令码+亮度+速度+00*13
            NSString *strL = @"07";
            NSString *code = [self getCodeWithLength:strL data:string];
//            NSString *code1 = [self getCodeWithLength:@"05" data:@"0000"];
//            NSString *code2 = [self getCodeWithLength:@"14" data:@"0307feb3683f7e6051f2f051462f4f00"];
            strOrder = [NSString stringWithFormat:@"%@%@%@%@00000000000000000000000000",strHead,strL,code,string];
        }
            break;
        case BLEOrderTypeFixed: {//02,格式：AA55+06+校验和+命令码+模式+00*14
            NSString *strL = @"06";
            NSString *code = [self getCodeWithLength:strL data:string];
            strOrder = [NSString stringWithFormat:@"%@%@%@%@0000000000000000000000000000",strHead,strL,code,string];
        }
            break;
        case BLEOrderTypeSleep: {//03,格式：AA55+06+校验和+命令码+时间+00*14
            NSString *strL = @"06";
            NSString *code = [self getCodeWithLength:strL data:string];
            strOrder = [NSString stringWithFormat:@"%@%@%@%@0000000000000000000000000000",strHead,strL,code,string];
        }
            break;
        default:
            break;
    }
    DLog(@"strOrder:%@",strOrder);
    NSData *data = [BabyToy convertHexStrToData:strOrder];
    return data;
}

/*设置参数分包
 BLEOrderTypeCustom       //自定义模式-3
 第一包：03,格式：AA55+20+校验和+03+07+【00-255】*14
 第二包：03,格式：AA55+11+校验和+03+08+【00-255】*4+速度+00*9
 
 BLEOrderTypeBreathe,     //呼吸模式-4
 第一包：04,格式：AA55+20+校验和+04+07+【00-255】*14
 第二包：04,格式：AA55+12+校验和+04+08+【00-255】*4+亮度+速度+00*8
 */
- (NSData *)getBLEOrderPageType:(BLEOrderTypeSetPage)type value:(NSString *)string pageNum:(int)page {
    NSString *strOrder ;
    switch (type) {
        case BLEOrderTypeCustom: {
            if (page == 1) {
                NSString *strL = @"14";
                NSString *code = [self getCodeWithLength:strL data:string];
                strOrder = [NSString stringWithFormat:@"%@%@%@%@",strHead,strL,code,string];
            }
            else {
                NSString *strL = @"0b";
                NSString *code = [self getCodeWithLength:strL data:string];
                strOrder = [NSString stringWithFormat:@"%@%@%@%@000000000000000000",strHead,strL,code,string];
            }
        }
            break;
        case BLEOrderTypeBreathe: {
            if (page == 1) {
                NSString *strL = @"14";
                NSString *code = [self getCodeWithLength:strL data:string];
                strOrder = [NSString stringWithFormat:@"%@%@%@%@",strHead,strL,code,string];
            }
            else {
                NSString *strL = @"0c";
                NSString *code = [self getCodeWithLength:strL data:string];
                strOrder = [NSString stringWithFormat:@"%@%@%@%@0000000000000000",strHead,strL,code,string];
            }
        }
            break;
        default:
            break;
    }
    NSData *data = [BabyToy convertHexStrToData:strOrder];
    return data;
}


+ (BLEService*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _isConnected = NO;
        //初始化BabyBluetooth 蓝牙库
        _babyBluetooth = [BabyBluetooth shareBabyBluetooth];
//        设置蓝牙委托
        [self babyDelegate];
        [self initFidedOrderValues];
    }
    return self;
}

- (void)startScanBLETime:(NSInteger)time successBlock:(void (^)(CBPeripheral *peripheral, NSString *strMac))successBlock failBlock:(void (^)())failBlock {
    self.scanSuccessBlock = successBlock;
    self.scanFailBlock = failBlock;
    [self startScanConnectBLE];
//    [self performSelector:@selector(scanBLEOverTime) withObject:nil afterDelay:time];
}

- (void)scanBLEOverTime {
    [self pauseScanBLE];
    self.scanFailBlock();
}

//开始扫描
- (void)startScanConnectBLE {
    //停止之前的连接
    [_babyBluetooth cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    _babyBluetooth.scanForPeripherals().begin();
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];//prefs:root=General&path=Bluetooth  prefs:root=Bluetooth
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

//停止扫描
- (void)pauseScanBLE {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scanBLEOverTime) object:nil];
    [_babyBluetooth cancelScan];
}

//断开所有连接
- (void)cancelAllBLEConnection {
    [_babyBluetooth cancelAllPeripheralsConnection];
}

//断开连接
-(void)cancelBLEConnection:(CBPeripheral *)peripheral{
    [_babyBluetooth cancelPeripheralConnection:peripheral];
}

//连接ble
- (void)connectPeripheral:(CBPeripheral *)peripheral successBlock:(void (^)())successBlock failBlock:(void (^)())failBlock startOrderBlock:(void (^)())startOrderBlock {
    self.connectBlock = successBlock;
    self.connectFailBlock = failBlock;
    self.startOrderBlock = startOrderBlock;
    currPeripheral = peripheral;
    [self connectPeripheral];
}

- (void)connectPeripheral {
    _babyBluetooth.having(currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}



#pragma mark -蓝牙配置和操作
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate {
    __weak typeof(self) weakSelf = self;
    [_babyBluetooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            DLog(@"设备打开成功，开始扫描设备");
        }
        else if (central.state == CBCentralManagerStatePoweredOff) {
            DLog(@"设备关闭");
        }
        else {
            
        }
    }];

    //设置扫描到设备的委托
    [_babyBluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSString *uuidStr = peripheral.identifier.UUIDString;
//        DLog(@"搜索到了设备:%@:%@，信号强度：%@",peripheral.name,uuidStr,advertisementData);
        if (weakSelf.scanSuccessBlock) {
            weakSelf.scanSuccessBlock(peripheral,[advertisementData objectForKey:@"kCBAdvDataManufacturerData"]);
        }
    }];
    
    //设置发现设备的Services的委托
    [_babyBluetooth setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            DLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
    }];
    //设置发现设service的Characteristics的委托
    [_babyBluetooth setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        DLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            DLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [_babyBluetooth setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        DLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [_babyBluetooth setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        DLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            DLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [_babyBluetooth setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        DLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置查找设备的过滤器
    [_babyBluetooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        return YES;
//        DLog(@"name:%@",peripheralName);
//        设置查找规则是名称大于1 ， the search rule is peripheral.name length > 2
//        if (peripheralName.length<10) {// || [peripheralName isEqualToString:@"BleSeriaPort"] || [peripheralName isEqualToString:@"TianjuSmart     "]
//            return YES;
//        }
//        else{
//            return NO;
//        }
    }];
    
    
    [_babyBluetooth setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        DLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [_babyBluetooth setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        DLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    /*设置babyOptions
     
     参数分别使用在下面这几个地方，若不使用参数则传nil
     - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
     - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
     - [peripheral discoverServices:discoverWithServices];
     - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
     
     该方法支持channel版本:
     [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [_babyBluetooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    //连接
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [_babyBluetooth setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
//        [weakSelf pauseScanBLE];
        DLog(@"设备：%@--连接成功",peripheral.name);
        if (weakSelf.connectBlock) {
//            [SVProgressHUD showInfoWithStatus:@"connected BLE succeed"];
//            _isConnected = YES;
            weakSelf.connectBlock();
        }
    }];  
    //设置设备连接失败的委托
    [_babyBluetooth setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        DLog(@"设备：%@--连接失败",peripheral.name);
        if (weakSelf.connectFailBlock) {
            _isConnected = NO;
            weakSelf.connectFailBlock();
        }
    }];
    
    //设置设备断开连接的委托
    [_babyBluetooth setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        DLog(@"设备：%@--断开连接",peripheral.name);
        if (weakSelf.disConnectBlock) {
            _isConnected = NO;
            weakSelf.disConnectBlock();
        }
    }];
    
    //设置发现设备的Services的委托
    [_babyBluetooth setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        
        [rhythm beats];
    }];
    
    //设置发现设service的Characteristics的委托
    [_babyBluetooth setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        
        NSString *strUUID = service.UUID.UUIDString;
        DLog(@"===service name:%@:%@",service.UUID,strUUID);
        if ([strUUID isEqualToString:@"FFE0"]) {
            for (int row=0;row<service.characteristics.count;row++) {
                CBCharacteristic *c = service.characteristics[row];
                NSString *strCUUID = c.UUID.UUIDString;
                DLog(@"===Characteristic name:%@:%@",c.UUID,strCUUID);
                if ([strCUUID isEqualToString:@"FFE2"]) {
                    notifiyCharacteristic = c;
                    [weakSelf setNotifiy];
                }
                else if ([strCUUID isEqualToString:@"FFE1"]) {
                    writeCharacteristic = c;
                }
                if (notifiyCharacteristic && writeCharacteristic) {
                    if (weakSelf.startOrderBlock) {
                        _isConnected = YES;
                        weakSelf.startOrderBlock();
                    }
                }
            }
        }
    }];
//    //设置读取characteristics的委托
//    [_babyBluetooth setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//        DLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
//    }];
//    //设置发现characteristics的descriptors的委托
//    [_babyBluetooth setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
//        DLog(@"===characteristic name:%@",characteristic.service.UUID);
//        for (CBDescriptor *d in characteristic.descriptors) {
//            DLog(@"CBDescriptor name is :%@",d.UUID);
//        }
//    }];
//    //设置读取Descriptor的委托
//    [_babyBluetooth setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
//        DLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
//    }];
//    
//    //读取rssi的委托
//    [_babyBluetooth setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
//        DLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
//    }];
//    
//    
//    //设置beats break委托
//    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
//        DLog(@"setBlockOnBeatsBreak call");
//        
//        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
//        //        if (<#condition#>) {
//        //            [bry beatsOver];
//        //        }
//        
//    }];
//    
//    //设置beats over委托
//    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
//        DLog(@"setBlockOnBeatsOver call");
//    }];
    
    //设置写数据成功的block
    [_babyBluetooth setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        DLog(@">>>>>>>>>WriteValue characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
    }];
    
    [_babyBluetooth setBlockOnDidWriteValueForDescriptor:^(CBDescriptor *descriptor,NSError *error){
        DLog(@">>>>>>>>> OnDidWriteValue characteristic:%@ and new value:%@",descriptor.UUID, error);
    }];
    //设置通知状态改变的block
    [_babyBluetooth setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        DLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    }];
}

//订阅一个值，监听通知通道
- (void)setNotifiy {
    [_babyBluetooth notify:currPeripheral
  characteristic:notifiyCharacteristic
           block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
               DLog(@"监听通知通道,读取的值:%@",characteristics.value);
               return;
//               [self dealReadData:characteristics.value];
    }];
}

//下发指令到设备
- (void)writeOrderWithType:(BLEOrderType)orderType {
    if (!writeCharacteristic) {
        [SVProgressHUD showInfoWithStatus:@"Write characteristic is nil"];
        //redo 需要重新连接
        return;
    }
    NSData *data = [orderValues objectAtIndex:orderType];
    if (data) {
        NSString *str = [NSString stringWithFormat:@"下发指令-%@:%@", orderNames[orderType],[BabyToy convertDataToHexStr:data]];
        if (self.startBlock) {
            self.startBlock(str);
        }
    }
    [currPeripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

//设置参数
- (void)setBLEWithType:(BLEOrderTypeSet)orderType value:(NSString *)string{
    if (!writeCharacteristic) {
        [SVProgressHUD showInfoWithStatus:@"cennected light fail"];
        //redo 需要重新连接
        return;
    }
    NSData *data = [self getBLEOrderType:orderType value:string];
    if (data) {
        NSString *str = [NSString stringWithFormat:@"下发指令-%@:%@", orderSetNames[orderType],[BabyToy convertDataToHexStr:data]];
        if (self.startBlock) {
            self.startBlock(str);
        }
    }
    [currPeripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

//设置参数分包
- (void)setBLEPageWithType:(BLEOrderTypeSetPage)orderType value:(NSString *)string pageNum:(int)page {
    NSData *data = [self getBLEOrderPageType:orderType value:string pageNum:page ];
    if (data) {
        NSString *str = [NSString stringWithFormat:@"下发指令-%@:%@", orderSetNames[orderType],[BabyToy convertDataToHexStr:data]];
        if (self.startBlock) {
            self.startBlock(str);
        }
    }
    [currPeripheral writeValue:data forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}


- (void)dealReadData:(NSData *)readData {
    DLog(@"读取的值:%@",readData);
    if (readData) {
        NSString *str = [BabyToy convertDataToHexStr:readData];
        if (self.startBlock) {
            self.startBlock(str);
        }
    }
    
    //1转字符
    Byte *bytes = (Byte *)[readData bytes];
    //    DLog(@"读取的值:%s",bytes);
    //    for(int i=0;i<[readData length];i++)
    //    {
    //        UInt16 hInt = bytes[i];
    //        DLog(@"------16进制-------%x",hInt);
    //        int iValue = bytes[i];
    //        DLog(@"------10进制-------%d",iValue);
    //    }
    int length = (int)readData.length;
    if (length<5) {
        return;
    }
    //开始位
    NSData *startData = [readData subdataWithRange:NSMakeRange(0, 2)];
    DLog(@"开始位:%@",startData);
    //长度码
    int count = bytes[2];
    DLog(@"长度码:%d",count);
//    if (length == 17 && count == 5) {//处理数据返回不对的问题
//        readData = [readData subdataWithRange:NSMakeRange(7, 10)];
//        bytes = (Byte *)[readData bytes];
//        count = bytes[2];
//        length = (int)readData.length;
//    }
    if (count != length-2) {
        DLog(@"长度不对");
        return;
    }
    //校验码
    int index = 4;
    if (count > 3) {
        int hInt = bytes[3];
        DLog(@"校验码:%d",hInt);
    }
//    else{
//        index = 3;
//        DLog(@"没有校验码");
//        //开始:0x53-开始测量，结束:0x56-测量结束
//        int hInt = bytes[3];
//        if (hInt == 83) {
////            [SVProgressHUD showInfoWithStatus:@"血压测量开始"];
//            if (self.startBlock) {
//                self.startBlock();
//                self.startBlock = nil;
//            }
//            _errorCode = 0;
//        }
//        else if (hInt == 86) {
////            [SVProgressHUD showInfoWithStatus:@"血压测量结束"];
//            self.endBlock();
//            _errorCode = 1000;
//        }
//        return;
//    }
    
    /*命令码，
     测量中类型:
        1.0x50-开始测量命令后，自身气压"归零"
        2.0x53-血压计模組确认测量中止，放气停止测量回到省電状态。并发送0x53给上位机
        2.x54-测量中的返回值，
        3.0x55-测量结果的返回值，
        4.0x56-测量出错，
     
     设置/读取时间
        1.0xB0-设置时间成功
        2.0xB1-读取时间成功
     
     设置/读取参数
        1.0xB2-设置参数成功
        2.0xB3-读取参数成功
     
     读取/清除记录
        1.0xB4-读取记录成功
        2.0xB5-清除记录成功
     
     */
    //    UInt16 hOrder = bytes[index];
    //    DLog(@"命令码:%char",bytes[index]);
    //    DLog(@"命令码:%x",hOrder);
    
    NSData *oderData = [readData subdataWithRange:NSMakeRange(index, 1)];
    DLog(@"命令码:%@",oderData);
    
    //数据位
    int dataLength = length-index-1;
    if (dataLength>0) {
        int oderCode = [BabyToy ConvertDataToInt:oderData];
        //xiangfeng redo 解决收不到开始的数据
//        if (self.startBlock) {
//            self.startBlock();
//            self.startBlock = nil;
//        }
        switch (oderCode) {
            case 80: {//0x50-开始测量命令后，自身气压"归零"
                DLog(@"------开始测量------");
            }
                break;
            case 83:{//0x53-血压计模組确认测量中止，放气停止测量回到省電状态。并发送0x53给上位机
                DLog(@"------结束测量------");
            }
                break;
            case 84:{//0x54-测量中的返回值
                NSData *value = [readData subdataWithRange:NSMakeRange(index+1+1, 1)];
                int currValue = [BabyToy ConvertDataToInt:value];
                DLog(@"数据位:%@---%d",value,currValue);
                if (self.retuneValueBlock) {
                    self.retuneValueBlock(currValue);
                }
            }
                break;
            case 85:{//0x55-测量完的返回值
                _errorCode = 0;
                DLog(@"------测量完成------");
                //收缩压
                NSData *valueH = [readData subdataWithRange:NSMakeRange(index+1, 2)];
                int high = [self dealBloodData:valueH];
                DLog(@"高压:%@---%d",valueH,high);
                //舒张压
                NSData *valueL = [readData subdataWithRange:NSMakeRange(index+2+1, 2)];
                int low = [self dealBloodData:valueL];
                DLog(@"低压:%@---%d",valueL,low);
                //心率
                NSData *valueHeart = [readData subdataWithRange:NSMakeRange(index+2+2+1, 1)];
                int heart = [BabyToy ConvertDataToInt:valueHeart];
                DLog(@"心率:%@---%d",valueHeart,heart);
                if (self.endBlock) {
                    self.endBlock(high, low, heart);
                }
            }
                break;
            case 86:{//0x56-测量出错
                DLog(@"------测量出错------");
                NSData *bleData = [readData subdataWithRange:NSMakeRange(index+1, 1)];
                DLog(@"数据位:%@",bleData);
                int errorCode = [BabyToy ConvertDataToInt:bleData];
                if (self.failBlock) {
                    self.failBlock(errorCode);
                }
            }
                break;
            case 176:{//0xB0-设置时间
                DLog(@"设置时间成功");
            }
                break;
            case 177:{//0xB1-读取时间
                
            }
                break;
            case 178:{//0xB2-设置参数
                DLog(@"设置参数成功");
            }
                break;
            case 179:{//0xB3-读取参数
                
            }
                break;
            case 180:{//0xB4-读取记录
                DLog(@"------读取记录------");
                
                //记录条数
                index += 1;
                NSData *valueNo = [readData subdataWithRange:NSMakeRange(index, 1)];
                int no = [BabyToy ConvertDataToInt:valueNo ];
                DLog(@"记录条数:%@---%d",valueNo,no);
                //错误码
                index += 1;
                NSData *valueError = [readData subdataWithRange:NSMakeRange(index, 1)];
                int error = [BabyToy ConvertDataToInt:valueError];
                DLog(@"错误码:%@---%d",valueError,error);
                if (error == 0) {
                    //收缩压
                    index += 1;
                    NSData *valueH = [readData subdataWithRange:NSMakeRange(index, 2)];
                    int high = [self dealBloodData:valueH];
                    DLog(@"收缩压:%@---%d",valueH,high);
                    //舒张压
                    index += 2;
                    NSData *valueL = [readData subdataWithRange:NSMakeRange(index, 2)];
                    int low = [self dealBloodData:valueL];
                    DLog(@"舒张压:%@---%d",valueL,low);
                    //心率
                    index += 2;
                    NSData *valueHeart = [readData subdataWithRange:NSMakeRange(index, 1)];
                    int heart = [BabyToy ConvertDataToInt:valueHeart];
                    DLog(@"心率:%@---%d",valueHeart,heart);
                    //时间
                    index += 1;
                    NSData *valueTime = [readData subdataWithRange:NSMakeRange(index, 7)];
                    NSString *strTime = [BabyToy convertDataToHexStr:valueTime];
                    DLog(@"时间:%@---%@",valueHeart,strTime);
                }
            }
                break;
            case 181:{//0xB5-清除记录
                DLog(@"清除记录成功");
            }
                break;
            case 182:{//0xB6-版本信息
                DLog(@"版本信息");
            }
                break;
            case 204:{//0xCC-参数错误
                DLog(@"命令参数错误或者格式错误");
            }
                break;
            default:
                break;
        }
    }
    else {
        DLog(@"没有数据位");
    }
}

- (void)bloodPressureStartBlock:(void (^)(NSString *str))startBlock retuneValueBlock:(void (^)(int value))retuneValueBlock disConnectBlock:(void (^)())disConnectBlock failBlock:(void (^)(int errorCode))failBlock endBlock:(void (^)(int high,int low,int heart))endBlock {
    self.startBlock = startBlock;
    self.retuneValueBlock = retuneValueBlock;
    self.disConnectBlock = disConnectBlock;
    self.failBlock = failBlock;
    self.endBlock = endBlock;
//    [self writeOrderWithType:BLEOrderTypeBegin];
}

- (int)dealBloodData:(NSData *)data {
    int result;
    NSString *string = [BabyToy convertDataToHexStr:data];
    if (![[string substringToIndex:1] isEqualToString:@"0"]) {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"0"];
    }
    result = [BabyToy convertHexStrToInt:string];
    return result;
}

@end
