//
//  GTDataTimeModel.m
//  GTSDK
//
//  Created by smwl on 2023/11/15.
//

#import "GTDataTimeModel.h"
#import "GTDataConfig.h"

#define GTDataTimeCounterInterval 60
#define GTDataTimePresetCountDownKey @"kPresetCountdownTime"
#define GTDataTimeEventName @"kEventName"
#define GTDataTimeProperties @"kProperties"

@interface GTDataTimeModel()

@end

@implementation GTDataTimeModel

-(instancetype)initWithType:(GTDataTimeCounterType)type externParam:(NSDictionary * _Nullable)externParam {
    self = [super init];
    if (self) {
        self.type = type;
        _initTime = [[NSDate date] timeIntervalSince1970] * 1000; // 毫秒
        _useTime = 0;
        _countdownTime = 0;
        
        _presetCountdownTime = 0; //default setting
        _shouldUploadCountdown = FALSE;
        _eventName = @"";
        _properties = [NSDictionary new];
        if (externParam) {
            if ([externParam objectForKey:GTDataTimePresetCountDownKey]) {
                NSNumber *num = [externParam objectForKey:GTDataTimePresetCountDownKey];
                if ([num isKindOfClass:[NSNumber class]]) {
                    _presetCountdownTime = num.longValue;
                    if (_presetCountdownTime >= 0) {
                        _shouldUploadCountdown = YES;
                    }
                }
            }
            if ([externParam objectForKey:GTDataTimeEventName]) {
                NSString *eventName = [externParam objectForKey:GTDataTimeEventName];
                if ([eventName isKindOfClass:[NSString class]]) {
                    _eventName = eventName;
                }
            }
            if ([externParam objectForKey:GTDataTimeProperties]) {
                NSDictionary *properties = [externParam objectForKey:GTDataTimeProperties];
                if ([properties isKindOfClass:[NSDictionary class]]) {
                    _properties = [NSDictionary dictionaryWithDictionary:properties];
                }
            }
        }

        _StopMode = GTDataTimeModelStopModeRunning;
        _lastStopMode = _StopMode;
    }
    
    return self;
}

-(void)changeStopModeWithIsStop:(BOOL)isStop isFromUser:(BOOL)isFromUser isEnd:(BOOL)isEnd {
    if (_StopMode == GTDataTimeModelStopModeEnd) {
        return;
    }
    
    if (isEnd) {
        _lastStopMode = _StopMode;
        _StopMode = GTDataTimeModelStopModeEnd;
    } else {
        if (isFromUser) {
            _lastStopMode = _StopMode;
            _StopMode = isStop ? GTDataTimeModelStopModeStopByUser : GTDataTimeModelStopModeRunning;
        } else {
            if (_StopMode == GTDataTimeModelStopModeStopByUser) { // 如果当前是被用户暂停的，那么通过非用户的running，无法恢复
                return;
            }
            
            _lastStopMode = _StopMode;
            _StopMode = isStop ? GTDataTimeModelStopModeStopBySystemAuto : GTDataTimeModelStopModeRunning;
        }
    }
    
    // end load
    if (_lastStopMode != GTDataTimeModelStopModeEnd && _StopMode == GTDataTimeModelStopModeEnd) {
        //上报, 这个时候不需要校验60秒；
        [self pUpload];
    }
}

-(void)timeUpCheckUpload {
    if (_StopMode != GTDataTimeModelStopModeRunning) {
        return;
    }
    
    _useTime += 1;
#ifdef DEBUG
    NSLog(@"GTDataTimeModel>> type(%@), _useTime(%ld)", _type, _useTime);
#endif
    if (_useTime >= GTDataTimeCounterInterval) {
        [self pUpload];
        // 重置为0
        _useTime = 0;
    }
}

-(void)userLogoutCheckUpload {
//    [self pUpload];
//    // 重置为0
//    _useTime = 0;
    
    //直接当做结束
    [self changeStopModeWithIsStop:YES isFromUser:YES isEnd:YES];
}

#pragma mark - upload
// 上报到神策
-(void)pUpload {
    if (_eventName.length > 0 && _initTime > 0) {
        [self calculateCountdownTimeBeforeUpload];
        
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        if (_properties) {
            [properties addEntriesFromDictionary:_properties];
        }
        if (_shouldUploadCountdown) {
            [properties addEntriesFromDictionary:@{
                @"initial_time":@(_initTime),
                @"usetime":@(_useTime),
                @"countdown_time": @(_countdownTime)
            }];
        } else {
            [properties addEntriesFromDictionary:@{
                @"initial_time":@(_initTime),
                @"usetime":@(_useTime)}
            ];
        }
        
#ifdef DEBUG
        NSLog(@"GTDataTimeModel>> upload sensor event: %@", _eventName);
        NSLog(@"GTDataTimeModel>> initial_time: %ld", _initTime);
        NSLog(@"GTDataTimeModel>> usetime: %ld", _useTime);
        NSLog(@"GTDataTimeModel>> countdown_time: %ld", _countdownTime);
#endif
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:_eventName
                                                   andProperties:properties
                                                     shouldFlush:YES];
    }
}

// 上报前需要调用；
//
// @discussion
// 如果有剩余的presetCountdownTime，需要转换为_countdownTime去上报；
-(void)calculateCountdownTimeBeforeUpload {
    _countdownTime = 0;// 每次上报前必须清空_countdownTime
    
    // 处理presetCountdownTime的转化；
    if (_presetCountdownTime > 0) {
        long lastUseTime = _useTime;
        long lastPresetCountdownTime = _presetCountdownTime;
        
        if (_presetCountdownTime >= _useTime) { // 比如现在有presetCountdownTime为90，上报_useTime为50，那么上报实际_useTime需要转为0，_countdownTime转为50，presetCountdownTime设置为40
            _countdownTime = lastUseTime;
            _useTime = 0;
            _presetCountdownTime = lastPresetCountdownTime - _countdownTime;
        } else { // 比如如果有presetCountdownTime为30，上报_useTime为50，那么上报实际_useTime需要转为20，_countdownTime转为30，_countdownTime设置为0；
            _useTime = lastUseTime - lastPresetCountdownTime;
            _countdownTime = lastPresetCountdownTime;
            _presetCountdownTime = 0;
        }
    }
}


#pragma mark - convert
/**
 @property (nonatomic, strong, nonnull) GTDataTimeCounterType type;
 @property (nonatomic, assign) long presetCountdownTime;
 @property (nonatomic, assign) bool shouldUploadCountdown;
 @property (nonatomic, assign) long initTime;
 @property (nonatomic, assign) long useTime;
 @property (nonatomic, assign) long countdownTime;
 @property (nonatomic, assign) GTDataTimeModelStopMode StopMode;
 @property (nonatomic, assign) GTDataTimeModelStopMode lastStopMode;
 @property (nonatomic, strong, nonnull) NSString *eventName;
 @property (nonatomic, strong, nullable) NSDictionary *properties;
 */
+(NSDictionary * __nullable)modelToDict:(GTDataTimeModel *)model {
    if (!model) return nil;
    
    return @{
        @"_type": model.type?:@"",
        @"_presetCountdownTime": @(model.presetCountdownTime),
        @"_shouldUploadCountdown": @(model.shouldUploadCountdown),
        @"_initTime": @(model.initTime),
        @"_useTime": @(model.useTime),
        @"_countdownTime": @(model.countdownTime),
        @"_StopMode": @(model.StopMode),
        @"_lastStopMode": @(model.lastStopMode),
        @"_eventName": model.eventName ? : @"",
        @"_properties": model.properties ? : [NSDictionary new]
    };
}

+(GTDataTimeModel *  __nullable)dictToModel:(NSDictionary *)dict {
    if (!dict) return nil;
    NSString *type = [dict objectForKey:@"_type"];
    NSNumber *presetCountdownTime = [dict objectForKey:@"_presetCountdownTime"];
    NSNumber *shouldUploadCountdown = [dict objectForKey:@"_shouldUploadCountdown"];
    NSNumber *initTime = [dict objectForKey:@"_initTime"];
    NSNumber *useTime = [dict objectForKey:@"_useTime"];
    NSNumber *countdownTime = [dict objectForKey:@"_countdownTime"];
    NSNumber *StopMode = [dict objectForKey:@"_StopMode"];
    NSNumber *lastStopMode = [dict objectForKey:@"_lastStopMode"];
    NSString *eventName = [dict objectForKey:@"_eventName"];
    NSDictionary *properties = [dict objectForKey:@"_properties"];
    if (!type || ![type isKindOfClass:[NSString class]]
        || !presetCountdownTime || ![presetCountdownTime isKindOfClass:[NSNumber class]]
        || !shouldUploadCountdown || ![shouldUploadCountdown isKindOfClass:[NSNumber class]]
        || !initTime || ![initTime isKindOfClass:[NSNumber class]]
        || !useTime || ![useTime isKindOfClass:[NSNumber class]]
        || !countdownTime || ![countdownTime isKindOfClass:[NSNumber class]]
        || !StopMode || ![StopMode isKindOfClass:[NSNumber class]]
        || !lastStopMode || ![lastStopMode isKindOfClass:[NSNumber class]]
        || !eventName || ![eventName isKindOfClass:[NSString class]]
        || !properties || ![properties isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    GTDataTimeModel *model = [[GTDataTimeModel alloc] init];
    model.type = type;
    model.presetCountdownTime = presetCountdownTime.longValue;
    model.shouldUploadCountdown = presetCountdownTime.boolValue;
    model.initTime = initTime.longValue;
    model.useTime = useTime.longValue;
    model.countdownTime = countdownTime.longValue;
    model.StopMode = StopMode.intValue;
    model.lastStopMode = lastStopMode.intValue;
    model.eventName = eventName;
    model.properties = properties;
    
    return model;
}
@end
