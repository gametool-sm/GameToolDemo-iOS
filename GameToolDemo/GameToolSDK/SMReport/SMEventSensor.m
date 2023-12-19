//
//  SMEventSensor.m
//  GTSDK
//
//  Created by smwl on 2023/11/17.
//

#import "SMEventSensor.h"
#define LOG_LEVEL_ALL
#import "SMLog.h"
static SMEventSensor *eventSensor = nil;

@interface SMEventSensor()

@property(nonatomic,strong)NSMutableDictionary *sensorEvents;

@end

@implementation SMEventSensor

+(instancetype)eventSensor{
    if(!eventSensor){
        eventSensor = [self new];
    }
    return eventSensor;
}

+(void)toolShutdown:(ToolType)toolType event:(NSDictionary *)event{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(event){
        [params addEntriesFromDictionary:event];
    }
    LOGDebug(@"连点器使用toolType=>%ld event=>%@",toolType, event)
    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventAutoClickerRunTimes andProperties:params shouldFlush:YES];
}

+(void)toolStartup:(ToolType)toolType{
    //上报到CP端
    [SMEventReport toolStartupReport:toolType];
    //上报到神策-启动不上报，结束才上报
    //+(void)toolShutdown:(ToolType)toolType event:(NSDictionary *)event
    
}

+(void)startReport:(ToolType)toolType event:(NSString *)eventName params:(NSDictionary *)params{
    if(!eventName){
        LOGWarn(@"开始时长上报事件名为空 toolType=>%ld event=>%@ params=>%@",toolType, eventName,params)
        return;
    }
    
    if([eventName isEqualToString:AutoClickerRunDurationEvent]){
        //时长统计 CP端只统计连点器使用时长和录制使用时长
        [SMDurationEventReport startReport:toolType eventName:eventName params:params];
    }
    NSMutableDictionary *externParam = [NSMutableDictionary dictionary];
    if(params){
        NSMutableDictionary *paramsTemp = [params mutableCopy];
        id countdown_time = [params valueForKey:@"countdown_time"];
        if(countdown_time){//倒计时时长
            [externParam addEntriesFromDictionary:@{@"kPresetCountdownTime":countdown_time}];
            [paramsTemp removeObjectForKey:@"countdown_time"];
        }else{
            [externParam addEntriesFromDictionary:@{@"kPresetCountdownTime":@(0)}];
        }
        [externParam addEntriesFromDictionary:@{@"kProperties":[paramsTemp copy]}];
    }else{
        [externParam addEntriesFromDictionary:@{@"kPresetCountdownTime":@(0)}];
    }
    [externParam addEntriesFromDictionary:@{@"kEventName": eventName}];

    
    //上报到神策
    GTDataTimeCounterType dataTimeCounterType = [[GTDataTimeCounter sharedInstance] start:eventName externParam:externParam];
    [self addDataTimeCounterType:dataTimeCounterType event:eventName params:externParam];
   
}


+(void)pauseReport:(NSString *)eventName{
    
    //上报到CP端
    [SMDurationEventReport pauseReport:eventName];
    //上报到神策
    GTDataTimeCounterType dataTimeCounterType = [self dataTimeCounterTypeWithEvent:eventName];
    [[GTDataTimeCounter sharedInstance] stop:YES type:dataTimeCounterType];
    LOGDebug(@"暂停时长上报eventName=>%@ dataTimeCounterType=>%@",eventName,dataTimeCounterType)
}

+(void)continueReport:(NSString *)eventName{
    
    //上报到CP端
    [SMDurationEventReport continueReport:eventName];
    //上报到神策
    GTDataTimeCounterType dataTimeCounterType = [self dataTimeCounterTypeWithEvent:eventName];
    [[GTDataTimeCounter sharedInstance] stop:NO type:dataTimeCounterType];
    LOGDebug(@"继续时长上报eventName=>%@ dataTimeCounterType=>%@",eventName,dataTimeCounterType)

    
}

+(void)finishReport:(NSString *)eventName{

    //上报到CP端
    [SMDurationEventReport finishReport:eventName];
    //上报到神策
    GTDataTimeCounterType dataTimeCounterType = [self dataTimeCounterTypeWithEvent:eventName];
    [[GTDataTimeCounter sharedInstance] end:dataTimeCounterType];
    LOGDebug(@"结束时长上报eventName=>%@ dataTimeCounterType=>%@",eventName,dataTimeCounterType)
    
}
+(void)addDataTimeCounterType:(GTDataTimeCounterType)dataTimeCounterType event:(NSString *)eventName params:(NSDictionary *)params{
    [[self eventSensor] addDataTimeCounterType:dataTimeCounterType event:eventName params:params];
}
-(void)addDataTimeCounterType:(GTDataTimeCounterType)dataTimeCounterType event:(NSString *)eventName params:(NSDictionary *)params{
    if(!dataTimeCounterType)return;
    if(!eventName)return;
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    [event addEntriesFromDictionary:@{@"dataTimeCounterType":dataTimeCounterType}];
    if(params){
        [event addEntriesFromDictionary:@{@"params":params}];
    }
    [self.sensorEvents addEntriesFromDictionary:@{eventName:event}];
}
+(GTDataTimeCounterType)dataTimeCounterTypeWithEvent:(NSString *)eventName{
    return [[self eventSensor] dataTimeCounterTypeWithEvent:eventName];
}
-(GTDataTimeCounterType)dataTimeCounterTypeWithEvent:(NSString *)eventName{
    NSDictionary *event = [self.sensorEvents valueForKey:eventName];
    return [event valueForKey:@"dataTimeCounterType"];
}
+(NSDictionary *)paramsWtihEvent:(NSString *)eventName{
    return [[self eventSensor] paramsWtihEvent:eventName];
}
-(NSDictionary *)paramsWtihEvent:(NSString *)eventName{
    NSDictionary *event = [self.sensorEvents valueForKey:eventName];
    return [event valueForKey:@"params"];
}
-(NSMutableDictionary *)sensorEvents{
    if(!_sensorEvents){
        _sensorEvents = [NSMutableDictionary dictionary];
    }
    return _sensorEvents;
}
@end
#undef LOG_LEVEL_ALL
