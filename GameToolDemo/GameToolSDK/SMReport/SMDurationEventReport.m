//
//  SMDurationReport.m
//  GTSDK
//
//  Created by smwl on 2023/11/14.
//

#import "SMDurationEventReport.h"
#import "GTClickerManager.h"
#import "GTDataTimeModel.h"
#define LOG_LEVEL_ALL
#import "SMLog.h"
static SMDurationEventReport *_durationReport = nil;

@interface SMDurationEventReport()

@property(nonatomic,strong) NSMutableDictionary *events;


@end


@implementation SMDurationEventReport

#pragma mark--Public Api
+(instancetype)defaultReport{
    if(!_durationReport){
        _durationReport = [self new];
    }
    return _durationReport;
}
+(void)startReport:(ToolType)toolType eventName:(NSString *)eventName params:(NSDictionary *)params{
    SMEventReport *eventReport = [self getEvent:eventName];
    if(eventReport){//没有这一步代码逻辑也不会有问题，为了体现业务流程
        [eventReport finishReport];
    }
    eventReport = [self addEvent:eventName];
    eventReport.eventName = eventName;
    [eventReport startReport:toolType params:params];
    
}
+(void)pauseReport:(NSString *)eventName{
    SMEventReport *eventReport = [self getEvent:eventName];
    [eventReport pauseReport];
    
}
+(void)continueReport:(NSString *)eventName{
    SMEventReport *eventReport = [self getEvent:eventName];
    [eventReport continueReport];
    
}
+(void)finishReport:(NSString *)eventName{
    SMEventReport *eventReport = [self getEvent:eventName];
    [eventReport finishReport];
    [self removeEvent:eventName];
}
#pragma mark--Private
+(SMEventReport *)addEvent:(NSString *)eventName{
    SMEventReport *eventReport = [SMEventReport new];
    [[SMDurationEventReport defaultReport].events addEntriesFromDictionary:@{
        eventName: eventReport
    }];
    return eventReport;
}
+(SMEventReport *)getEvent:(NSString *)eventName{
    SMEventReport *eventReport = [[SMDurationEventReport defaultReport].events valueForKey:eventName];
    return eventReport;
    
}
+(void)removeEvent:(NSString *)eventName{
    //    SMEventReport *eventReport = [self getEvent:eventName];
    [[SMDurationEventReport defaultReport].events removeObjectForKey:eventName];
}
-(instancetype)init{
    if(self==[super init]){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidEnterBackGround:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillEnterForeGround:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillTerminate:)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        
        installUncaughtExceptionHandler();
        registerSignalHandler();
        [self clickerRunTimesLocalReport];
        [self durationLocalReport];
    }
    return self;
}
-(void)appDidEnterBackGround:(NSNotificationCenter *)notification{
    NSLog(@"appEnterBackGround========>");
    //AutoClickerRunTimesEvent 连点器运行次数 先进入后台 从后台杀掉的情况监测不到 启用时上报
    [self clickerRunTimesLocalSave];
    [self durationLocalSave];
    [self pauseAllDurationReports];
}
-(void)appWillEnterForeGround:(NSNotificationCenter *)notification{
    NSLog(@"========>appEnterForeGround");
    //AutoClickerRunTimesEvent 连点器运行次数 先进入后台 从后台杀掉的情况监测不到
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self autoClickerRunTimesLocalKey]];
    [self durationLocalRemove];
    [self continueAllDurationReports];
}

-(void)appWillTerminate:(NSNotificationCenter *)notification{
    NSLog(@"appWillTerminate========>");
    [self allDurationReportsUpdate];
    //    [self clickerRunTimesLocalSave];
    //    [self durationLocalSave];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark--异常监听
void installUncaughtExceptionHandler(void) {
    NSSetUncaughtExceptionHandler( &handleUncaughtException );
}

void handleUncaughtException(NSException *exception) {
    //异常退出 连点器使用时长
    [[SMDurationEventReport defaultReport] clickerRunTimesLocalSave];
    [[SMDurationEventReport defaultReport] allDurationReportsUpdate];
    
}
//信号异常监听
void registerSignalHandler(void) {
    signal(SIGHUP, signalHandler);
    signal(SIGINT, signalHandler);
    signal(SIGQUIT, signalHandler);
    signal(SIGABRT, signalHandler);
    signal(SIGILL, signalHandler);
    signal(SIGSEGV, signalHandler);
    signal(SIGFPE, signalHandler);
    signal(SIGBUS, signalHandler);
    signal(SIGPIPE, signalHandler);
}
void signalHandler(int signal) {
   //异常退出 连点器使用时长
    [[SMDurationEventReport defaultReport] clickerRunTimesLocalSave];
    [[SMDurationEventReport defaultReport] allDurationReportsUpdate];
}
/// 手动关闭App 程序异常退出存储连点器运行次数本地化存储
-(void)clickerRunTimesLocalSave{
    NSDictionary *event = [[GTClickerManager shareInstance] getClickFinishEvent];
    if(event){
        [[NSUserDefaults standardUserDefaults] setObject:event forKey:[self autoClickerRunTimesLocalKey]];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self autoClickerRunTimesLocalKey]];
    }
    
}
-(NSString *)autoClickerRunTimesLocalKey{
    return [NSString stringWithFormat:@"%@Click",AutoClickerRunTimesEvent];
}
-(NSDictionary *)clickerRunTimesLocalRead{
    NSDictionary *event = [[NSUserDefaults standardUserDefaults] objectForKey:[self autoClickerRunTimesLocalKey]];
    return event;
}
-(void)clickerRunTimesLocalReport{
    NSDictionary *event = [self clickerRunTimesLocalRead];
    if(event){
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:AutoClickerRunTimesEvent andProperties:event shouldFlush:YES];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self autoClickerRunTimesLocalKey]];
    }
    
}
-(void)durationLocalSave{
    NSArray<SMEventReport *>*reports = [SMDurationEventReport defaultReport].events.allValues;
    for(SMEventReport *report in reports){
        [report localSave];
    }
    
}
-(void)durationLocalRemove{
    NSArray<SMEventReport *>*reports = [SMDurationEventReport defaultReport].events.allValues;
    for(SMEventReport *report in reports){
        [report localRemove];
    }
}
-(void)durationLocalReport{
    SMEventReport *clickerRunDurationReport = [[SMEventReport alloc] initWithEventName:AutoClickerRunDurationEvent];
    [clickerRunDurationReport localReport];
}
/// 更新所有时长类事件
-(void)allDurationReportsUpdate{
    NSArray<SMEventReport *>*reports = [SMDurationEventReport defaultReport].events.allValues;
    for(SMEventReport *report in reports){
        [report durationUpdateReport];
    }
}
-(void)pauseAllDurationReports{
    NSArray<SMEventReport *>*reports = [SMDurationEventReport defaultReport].events.allValues;
    for(SMEventReport *report in reports){
        [report pauseReport];
    }
}
-(void)continueAllDurationReports{
    NSArray<SMEventReport *>*reports = [SMDurationEventReport defaultReport].events.allValues;
    for(SMEventReport *report in reports){
        [report continueReport];
    }
}
#pragma mark--getter/setter
-(NSMutableDictionary *)events{
    if(!_events){
        _events = [NSMutableDictionary dictionary];
    }
    return _events;
}
@end
#undef LOG_LEVEL_ALL
