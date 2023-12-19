//
//  GTDataTimeCounter.m
//  GTSDK
//
//  Created by smwl on 2023/11/15.
//

#import "GTDataTimeCounter.h"

#define GTDataTimeCounterTypePrefix @"GTDataTimeCounterTypePrefix"

#define GTDataTimeCounterLocalStorageKey @"kGTDataTimeCounterLocalStorageKey"

void *GTDataTimeCounterQueueTag = &GTDataTimeCounterQueueTag;

@interface GTDataTimeCounter()

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@property (nonatomic, strong) NSMutableDictionary *timeCounter;

@property (nonatomic, assign) bool applicationWillResignActive;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GTDataTimeCounter

+(instancetype)sharedInstance {
    static GTDataTimeCounter *__instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        __instance = [[GTDataTimeCounter alloc] init];
    });
    
    return __instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *label = [NSString stringWithFormat:@"com.sensorsdata.analytics.mini.GTDataTimeCounter.%p",self];
        self.serialQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(self.serialQueue, GTDataTimeCounterQueueTag, &GTDataTimeCounterQueueTag, NULL);
        
        self.timeCounter = [NSMutableDictionary dictionary];
        
        self.applicationWillResignActive = NO;
        
        [self addNotification];
        
        [self startTimer];
    }
    return self;
}

-(void)registerAction:(GTDataTimeUpAction)timeUpAction
                 type:(GTDataTimeCounterType)type
                DEPRECATED_MSG_ATTRIBUTE("改为内部上报，这个回调将不再调用") {
//    if (![self.timeCounter.allKeys containsObject:type]) {
//        return;
//    }
//    GTDataTimeModel *model = [self.timeCounter objectForKey:type];
//    model.timeUpAction = timeUpAction;
}

-(GTDataTimeCounterType)start:(NSString *)customUniqueId {
    return [self start:customUniqueId externParam:nil];
}

-(GTDataTimeCounterType)start:(NSString *)customUniqueId externParam:(NSDictionary * __nullable)externParam {
    if (!customUniqueId || customUniqueId.length < 0) {
        return @"";
    }
    
    GTDataTimeCounterType type = [NSString stringWithFormat:@"%@_%@", GTDataTimeCounterTypePrefix, customUniqueId];

    // 创建的时候会强制覆盖原有的；
    if ([self.timeCounter.allKeys containsObject:type]) {
        [self.timeCounter removeObjectForKey:type];
    }
    
    GTDataTimeModel *model = [[GTDataTimeModel alloc] initWithType:type externParam:externParam];
    [self.timeCounter setObject:model forKey:type];
    
    return type;
}


-(void)stop:(BOOL)isStop type:(GTDataTimeCounterType)type {
    if (![self.timeCounter.allKeys containsObject:type]) {
        return;
    }
    
    [self stopPrivate:isStop type:type isFromUser:YES isEnd:NO];
}

-(void)end:(GTDataTimeCounterType)type {
    if (![self.timeCounter.allKeys containsObject:type]) {
        return;
    }
    
    [self stopPrivate:YES type:type isFromUser:YES isEnd:YES];
    [self.timeCounter removeObjectForKey:type];
}

#pragma mark - Notification
-(void)addNotification {
    // 监听 App 启动或结束事件
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(applicationDidBecomeActive:)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(applicationWillResignActive:)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(applicationDidEnterBackground:)
                               name:UIApplicationDidEnterBackgroundNotification
                             object:nil];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (_applicationWillResignActive) {
        _applicationWillResignActive = NO;
        return;
    }
    _applicationWillResignActive = NO;
    
    [self startTimer];
    
    for (GTDataTimeCounterType type in self.timeCounter.allKeys) {
        [self stopPrivate:NO type:type isFromUser:NO isEnd:NO];
    }
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    _applicationWillResignActive = YES;
    
    [self stopTimer];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    _applicationWillResignActive = NO;

    for (GTDataTimeCounterType type in self.timeCounter.allKeys) {
        [self stopPrivate:YES type:type isFromUser:NO isEnd:NO];
    }
}

#pragma mark - Timer
-(void)startTimer {
    [self stopTimer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timerAction)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    });
}

-(void)stopTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.timer) {
            [self.timer invalidate];
        }
        self.timer = nil;
    });
}

-(void)timerAction {
    for (GTDataTimeCounterType type in self.timeCounter.allKeys) {
        GTDataTimeModel *model = [self.timeCounter objectForKey:type];
        [model timeUpCheckUpload];
    }
    
    [self storageToLocal];
}

#pragma mark -  Private
-(void)addQueueTask:(dispatch_block_t)task {
    if (task) {
        dispatch_async(self.serialQueue, task);
    }
}

-(void)stopPrivate:(BOOL)isStop type:(GTDataTimeCounterType)type isFromUser:(BOOL)isFromUser isEnd:(BOOL)isEnd {
    if (![self.timeCounter.allKeys containsObject:type]) {
        return;
    }
    GTDataTimeModel *model = [self.timeCounter objectForKey:type];
    
    [model changeStopModeWithIsStop:isStop isFromUser:isFromUser isEnd:isEnd];
}

#pragma mark - 奔溃与本地化处理，思路为：实时存储本地，下次重启再上报
-(void)storageToLocal {
    if (self.timeCounter && self.timeCounter.allKeys.count > 0) {
        NSMutableDictionary *tmpToStore = [NSMutableDictionary new];
        for (GTDataTimeCounterType type in self.timeCounter.allKeys) {
            GTDataTimeModel *model = [self.timeCounter objectForKey:type];
            NSDictionary *dict = [GTDataTimeModel modelToDict:model];
            if (dict) {
                [tmpToStore setObject:dict forKey:type];
            }
        }
        
        if (tmpToStore.allKeys.count > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:tmpToStore forKey:GTDataTimeCounterLocalStorageKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

+(void)findLocalDataToUploadWhenSensorInit {
    NSDictionary *localData = [[NSUserDefaults standardUserDefaults] objectForKey:GTDataTimeCounterLocalStorageKey];
    if (!localData || localData.allKeys.count <= 0) return;
    
    NSMutableDictionary *tmpToDealWith = [NSMutableDictionary new];
    for (NSString *type in localData.allKeys) {
        NSDictionary *dict = [localData objectForKey:type];
        if (dict) {
            GTDataTimeModel *model = [GTDataTimeModel dictToModel:dict];
            if (model) {
                [model changeStopModeWithIsStop:YES isFromUser:YES isEnd:YES];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GTDataTimeCounterLocalStorageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)sensorUserLogout {
    if (self.timeCounter && self.timeCounter.count > 0) {
        for (GTDataTimeCounterType type in self.timeCounter.allKeys) {
            GTDataTimeModel *model = [self.timeCounter objectForKey:type];
            [model userLogoutCheckUpload];
        }
    }
}

@end
