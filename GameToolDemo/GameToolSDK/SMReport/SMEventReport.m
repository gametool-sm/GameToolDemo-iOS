//
//  SMReport.m
//  GTSDK
//
//  Created by smwl on 2023/11/14.
//

#import "SMEventReport.h"
#import "GTNetworkManager+CPReport.h"
#define LOG_LEVEL_ALL
#import "SMLog.h"
@interface SMEventReport()

@property(nonatomic,copy)NSString *durationId;

@property(nonatomic,assign)NSTimeInterval lastResetTime;
@property(nonatomic,assign)NSTimeInterval beginInterval;//开始计时时间
@property(nonatomic,assign)NSTimeInterval totalHoldInterval;//暂停总时长
@property(nonatomic,assign)NSTimeInterval pauseInterval;//暂停时间

@property(nonatomic,assign)NSTimeInterval leftInterval;
@property(nonatomic,assign)CPEventStatus eventStatus;

@property(nonatomic,assign)int countdown_time;//倒计时
@property(nonatomic,assign)int countdown_time_original;//初始倒计时

@property(nonatomic,strong)NSTimer *timer;


@end

static NSTimeInterval durationUpdateInterval = 60.0;

@implementation SMEventReport

-(instancetype)init{
    if(self=[super init]){
    }
    return self;
}
-(instancetype)initWithEventName:(NSString *)eventName{
    if(self=[super init]){
        self.eventName = eventName;
    }
    return self;
}
#pragma mark--publlic Api

+(void)toolStartupReport:(ToolType)toolType{
    NSDictionary * params = [self getEncryptParams:@{
        @"toolType":[NSString stringWithFormat:@"%ld",toolType]
    }];
    NSString * url = [self urlWithPath:GTSDKAPI_ToolStartup];
    [[GTNetworkManager shareManager] CPPOST:url parameters:params success:^(id  _Nullable responseObject) {
        LOGDebug(@"工具启动上报 toolType=%@ responseObject=>%@", [self toolTypeDesc:toolType],responseObject)
    } failure:^(NSError * _Nullable error) {
        LOGError(@"工具启动上报 toolType=%@ error=>%@", [self toolTypeDesc:toolType],error)
    }];
}

-(void)startReport:(ToolType)toolType params:(NSDictionary *)params{
    
    NSTimeInterval startTime = round([[NSDate date] timeIntervalSince1970]);
    self.countdown_time = [[params valueForKey:@"countdown_time"] intValue];
    self.countdown_time_original = self.countdown_time;
    NSDictionary * requests = [self getEncryptParams:@{
        @"toolType":[NSString stringWithFormat:@"%ld",toolType],
        @"startTime":[NSString stringWithFormat:@"%.0f",startTime]
    }];
    NSString * url = [self urlWithPath:GTSDKAPI_DurationStart];
    @WeakObj(self)
    [[GTNetworkManager shareManager] CPPOST:url parameters:requests success:^(id  _Nullable responseObject) {
        NSNumber *durationId = [responseObject valueForKey:@"durationId"];
        selfWeak.durationId = [NSString stringWithFormat:@"%@",durationId];
        if(durationId){
            LOGInfo(@"开始时长上报 toolType=%@\nparams=>%@\nresponseObject=>%@", [self toolTypeDesc:toolType],params,responseObject)
        }else{
            LOGError(@"开始时长上报 toolType=%@\nparams=>%@\nresponseObject=>%@", [self toolTypeDesc:toolType],params,responseObject)
        }
    } failure:^(NSError * _Nullable error) {
        LOGError(@"error=>%@",error)
    }];
    self.lastResetTime = [[NSDate date] timeIntervalSince1970];
    self.beginInterval = selfWeak.lastResetTime;
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:durationUpdateInterval]];
    self.eventStatus = CPEventStatusRuning;
    
}

-(void)pauseReport{
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    self.pauseInterval = nowInterval;
    
    self.leftInterval = durationUpdateInterval - (nowInterval - self.lastResetTime);
    LOGDebug(@"暂停记时时剩余的等待的时间 %f",self.leftInterval)
    [self.timer setFireDate:[NSDate distantFuture]];
    self.eventStatus = CPEventStatusPaused;
    
}
-(void)continueReport{
    NSTimeInterval continueInterval = [[NSDate date] timeIntervalSince1970];
    NSInteger interval = continueInterval - self.pauseInterval;
    self.lastResetTime += interval;
    self.totalHoldInterval += interval;
    LOGDebug(@"继续记时前需要等待的时间 %f 暂停了:%ld 总暂停时长:%f",self.leftInterval,(long)interval,self.totalHoldInterval)
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.leftInterval]];
    self.eventStatus = CPEventStatusRuning;
    
}

-(void)finishReport{
    if(self.eventStatus == CPEventStatusPaused){
        NSTimeInterval continueInterval = [[NSDate date] timeIntervalSince1970];
        NSInteger interval = continueInterval - self.pauseInterval;
        self.lastResetTime += interval;
        self.totalHoldInterval += interval;
        LOGDebug(@"结束时处于暂停状态 暂停了:%ld 总暂停时长:%f",(long)interval,self.totalHoldInterval)
    }
    [self durationUpdateReport];
    [self.timer invalidate];
    self.timer = nil;
    
    self.eventStatus = CPEventStatuseEnded;
    
}

#pragma mark--Private Api
+(NSDictionary *)getBaseParams{
    return @{
        @"appKey": [GTSDKConfig getAppkey],
        @"userId": [GTSDKConfig getUserID],
        @"deviceId":[GTSDKConfig getDeviceId],
    };
}
-(NSDictionary *)getBaseParams{
    return [[self class] getBaseParams];
    
}
+(NSDictionary *)getEncryptParams:(NSDictionary *)otherParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *baseParams = [self getBaseParams];
    [params addEntriesFromDictionary:baseParams];
    [params addEntriesFromDictionary:otherParams];
    return [SMEncryptUtil getEncryptParameWithOriginDic:params];
}

-(NSDictionary *)getEncryptParams:(NSDictionary *)otherParams{
    
    return [[self class] getEncryptParams:otherParams];
}
+(NSString *)urlWithPath:(NSString *)path{
    NSString * urlStr = [SMEncryptUtil getEncryptResquestUrlWithOriginUrl:path andApi:@""];
    NSString * url = [NSString stringWithFormat:@"%@/gt.c/%@",GTSDKAPI_DOMMAIN,urlStr];
    return url;
}
-(NSString *)urlWithPath:(NSString *)path{
    return [[self class] urlWithPath:path];
}

-(void)durationUpdateReport{
    if(!self.durationId) {
        LOGWarn(@"durationId 为空")
        return;
    };
    NSDictionary * params = [self getDurationUpdateReportParams];
    [self durationReport:params];
    
}
-(void)durationReport:(NSDictionary *)params{
    NSString * url = [self urlWithPath:GTSDKAPI_DurationUpdate];
    NSDictionary *request = [self getEncryptParams:params];
    @WeakObj(self)
    [[GTNetworkManager shareManager] CPPOST:url parameters:request success:^(id  _Nullable responseObject) {
        
        LOGInfo(@"更新时长 eventName=>%@ params=>%@ responseObject=>%@",selfWeak.eventName,params,responseObject)
    } failure:^(NSError * _Nullable error) {
        LOGError(@"更新时长 eventName=>%@ params=>%@ error=>%@",selfWeak.eventName,params,error)
    }];
    NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    LOGDebug(@"定时间实际执行间隔 %f",nowTimeInterval-self.lastResetTime)
    
    self.lastResetTime = nowTimeInterval;
}
-(void)localSave{
    NSDictionary * params = [self getDurationUpdateReportParams];
    LOGDebug(@"localSave eventName=>%@ params=>%@",self.eventName,params)
    [[NSUserDefaults standardUserDefaults] setObject:params forKey:self.eventName];
    
}
-(void)localReport{
    NSDictionary * params = [[NSUserDefaults standardUserDefaults] objectForKey:self.eventName];
    if(!params)return;
    LOGDebug(@"localReport eventName=>%@ params=>%@",self.eventName,params)
    [self durationReport:params];
    [self localRemove];
   
}
-(void)localRemove{
    LOGDebug(@"localRemove eventName=>%@",self.eventName)
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.eventName];
    
}

#pragma mark--getter/setter

/// 计算运行时间和时间间隔
-(NSDictionary *)getDurationUpdateReportParams{
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval actureInterval = nowInterval - self.lastResetTime;//两次上报之间实际时间间隔
    NSTimeInterval totalInterval = nowInterval - self.beginInterval - self.totalHoldInterval;//开始到现在的总时长
    float updateInterval = MIN(actureInterval, durationUpdateInterval);
    NSInteger duration = durationUpdateInterval;
    self.countdown_time=self.countdown_time_original - actureInterval;
    NSTimeInterval interval = totalInterval - self.countdown_time_original;//总时长和总倒计时时长的差值
    int countdown_time = 0;
    if(interval<0){//纯倒计时阶段
        duration = 0.0;
        countdown_time = round(updateInterval);
    }else if (interval>=0&&interval<updateInterval){//倒计时+部分运行阶段
        duration = round(interval);//运行时长
        countdown_time = round(updateInterval-duration);
    }else{//纯运行阶段
        duration = actureInterval;
        countdown_time = 0;
    }
    
    LOGDebug(@"CP运行总时长:%f 总倒计时时长:%d 距离上次上报实际间隔:%f 计数间隔:%f 运行时长:%ld 倒计时时长:%d",totalInterval,self.countdown_time_original,actureInterval,updateInterval,(long)duration,countdown_time);
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:@{
        @"durationId":self.durationId,
        @"duration":[NSString stringWithFormat:@"%ld",(long)duration],
        @"lastResetTime":[NSString stringWithFormat:@"%.0f",nowInterval]
    }];
    
    NSDictionary *extendField = @{@"countDownTime":[NSString stringWithFormat:@"%d",MAX(countdown_time, 0)]};
    [params addEntriesFromDictionary:@{@"extendField":[extendField modelToJSONString]}];
    
    return [params copy];
}

-(NSString *)toolTypeDesc:(ToolType)toolType{
    return [[self class] toolTypeDesc:toolType];
}
+(NSString *)toolTypeDesc:(ToolType)toolType{
    switch(toolType){
        case ToolTypeClicker:
            return @"ToolTypeClicker";
        case ToolTypeSpeedup:
            return @"ToolTypeSpeedup";
        default:
            return @"";
    }
}

-(NSTimer *)timer{
    if(!_timer){
        @WeakObj(self)
        _timer = [NSTimer scheduledTimerWithTimeInterval:durationUpdateInterval block:^(NSTimer * _Nonnull timer) {
            //每隔durationUpdateInterval秒上报一次
            [selfWeak durationUpdateReport];
        } repeats:YES];
    }
    return _timer;
}
-(void)setLastResetTime:(NSTimeInterval)lastResetTime{
    LOGDebug(@"重置lastResetTime %f=>%f 变化值 %f",_lastResetTime,lastResetTime,lastResetTime-_lastResetTime)
    _lastResetTime = lastResetTime;
}
-(void)dealloc{
    LOGDealloc(@"%@",self)
}

@end
#undef LOG_LEVEL_ALL
