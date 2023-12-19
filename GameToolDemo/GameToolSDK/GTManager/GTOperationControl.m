//
//  GTOperationControl.m
//  GTSDK
//
//  Created by shangmi on 2023/6/15.
//

#import "GTOperationControl.h"
#import "GTFloatingBallManager.h"
#import "GTFloatingWindowManager.h"
#import "GTClickerWindowManager.h"
#import "GTRecordWindowManager.h"
#import "GTDialogWindowManager.h"
#import "GTFloatingBallDefaultView.h"
#import "GTSpeedUpManager.h"
#import "SMDurationEventReport.h"
@interface GTOperationControl () 

@end

@implementation GTOperationControl

+ (GTOperationControl *)shareInstance {
    static GTOperationControl *control = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[GTOperationControl alloc]init];
    });
    return control;
}

- (void)setUpWithInfo:(NSDictionary *)info {
    if (@available(iOS 13.0, *)) {
        GTSDKThemeType themeStyle = [GTSDKUtils getSDKThemeType];
        UIUserInterfaceStyle style = [UIApplication sharedApplication].windows.firstObject.traitCollection.userInterfaceStyle;
        switch (themeStyle) {
            case GTSDKThemeTypeLight:
                [GTThemeManager share].theme = GTSDKThemeTypeLight;
                break;
            case GTSDKThemeTypeDark:
                [GTThemeManager share].theme = GTSDKThemeTypeDark;
                break;
            case GTSDKThemeTypeFollowSystem: {
                if (style == UIUserInterfaceStyleLight) {
                    [GTThemeManager share].theme = GTSDKThemeTypeLight;
                }else {
                    [GTThemeManager share].theme = GTSDKThemeTypeDark;
                }
            }
                break;
            default:
                break;
        }
    }else {
        [GTThemeManager share].theme = GTSDKThemeTypeLight;
    }
    
    //初始化各功能模块
    //加速功能模块
    [self initSpeedupModule];
    //悬浮球模块
    [self initFloatingBall];
    //悬浮弹窗模块
    [self initFloatingWindow];
    //弹窗模块
    [self initDialogWindow];
    //连点悬浮窗模块
    [self initClickerWindow];
    //录制悬浮窗模块
    [self initRecordWindow];
    //获取sdk类型
    switch ([[GTSDKUtils getGTSDKStyle] intValue]) {
        case 0: {
            self.gtSDKStyle = GTSDKStyleDefault;
            [[GTFloatingBallManager shareInstance] floatingBallShow];
        }
            break;
        case 1: {
            self.gtSDKStyle = GTSDKStyleCustomFloatingBall;
        }
            break;
        case 2:
            self.gtSDKStyle = GTSDKStyleCustomFloatingWindow;
            break;
        case 3:
            self.gtSDKStyle = GTSDKStyleCustom;
            break;
        default:
            break;
    }
    
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
    
    //上报上一次的连点录制的运行次数
    [self uploadRecordCircleTimes];
    
    //上报本地缓存数据
    [SMDurationEventReport defaultReport];
    //异常监听
    installughtExceptionHandler();
    registerSignalHandlerRecord();
}

- (void)uploadRecordCircleTimes {
    NSDictionary *parDict = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@", GTSensorEventAutoClickerRunTimes]];
    if (parDict) {
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventAutoClickerRunTimes andProperties:parDict shouldFlush:YES];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GTSensorEventAutoClickerRunTimes];
}

#pragma mark - Noti

-(void)appDidEnterBackGround:(NSNotificationCenter *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKAbnormalExitNotification object:[GTOperationControl shareInstance] userInfo:nil];
}

-(void)appWillEnterForeGround:(NSNotificationCenter *)notification{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GTSensorEventAutoClickerRunTimes];
}

-(void)appWillTerminate:(NSNotificationCenter *)notification{
//    [self uploadRecordCircleTimes];
}

#pragma mark--异常监听

//信号异常监听
void registerSignalHandlerRecord(void) {
    signal(SIGHUP, signalHandlerRecord);
    signal(SIGINT, signalHandlerRecord);
    signal(SIGQUIT, signalHandlerRecord);
    signal(SIGABRT, signalHandlerRecord);
    signal(SIGILL, signalHandlerRecord);
    signal(SIGSEGV, signalHandlerRecord);
    signal(SIGFPE, signalHandlerRecord);
    signal(SIGBUS, signalHandlerRecord);
    signal(SIGPIPE, signalHandlerRecord);
}

void signalHandlerRecord(int signal) {
    //异常退出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKAbnormalExitNotification object:[GTOperationControl shareInstance] userInfo:nil];
}

void installughtExceptionHandler(void) {
    NSSetUncaughtExceptionHandler( &handleughtException );
}

void handleughtException(NSException *exception) {
    //异常退出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKAbnormalExitNotification object:[GTOperationControl shareInstance] userInfo:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:[GTOperationControl shareInstance]];
}

#pragma mark - 初始化各个模块

//加速功能
- (void)initSpeedupModule {
    [GTSpeedUpManager speedupInitWithSuccess:^{
        NSLog(@"加速器初始化成功");
        [GTSpeedUpManager disableSpeed:![GTSDKConfig getIsSpeedUpFeature]];
    } failure:^(NSString * _Nonnull str) {
        NSLog(@"加速器初始化失败");
    }];
}

//悬浮球
- (void)initFloatingBall {
    [GTFloatingBallManager shareInstance].ballWindow.hidden = YES;
}

//悬浮弹窗
- (void)initFloatingWindow {
    NSLog(@"%@",NSStringFromCGSize([UIScreen mainScreen].bounds.size));
    [GTFloatingWindowManager shareInstance].windowWindow.hidden = YES;
}

//连点器悬浮窗
- (void)initClickerWindow {
    [GTClickerWindowManager shareInstance].clickerWinWindow.hidden = YES;
}

//连点器悬浮窗
- (void)initRecordWindow {
    [GTRecordWindowManager shareInstance].recordWinWindow.hidden = YES;
}

//提示弹窗
- (void)initDialogWindow {
    [GTDialogWindowManager shareInstance].dialogWindow.hidden = YES;
}


@end
