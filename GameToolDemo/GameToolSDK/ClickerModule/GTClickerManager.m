//
//  GTClickerManager.m
//  GTSDK
//
//  Created by shangmi on 2023/8/31.
//

#import "GTClickerManager.h"
#import "GTClickerWindowManager.h"

#import <LinkerPlugin/SMClickPointModel.h>
#import <LinkerPlugin/SMLinkerSDK.h>
#import "GTClickerWindowAnimation.h"
#import "SMEventSensor.h"
//#import "SMLinkerSDK.h"




@interface GTClickerManager () <SMLinkClickerDelegate>

@property (nonatomic, strong) SMLinkerSDK *linkerSDK;

@end

@implementation GTClickerManager

+ (GTClickerManager *)shareInstance {
   static GTClickerManager *manager = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       manager = [[GTClickerManager alloc]init];
   });
   return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

- (void)setUp {
    //初始化
    self.linkerSDK = [SMLinkerSDK shareSDK];
    self.linkerSDK.delegate = self;
    self.linkerSDK.preventScriptCheakEnable = NO;
    
    self.isRun = NO;
    self.isComplete = NO;
}

- (BOOL)startScheme:(NSString *)jsonString {
    [SMEventSensor toolStartup:ToolTypeClicker];
    return [self.linkerSDK startClickWithSchemeJsonStr:jsonString];
}

- (BOOL)pauseScheme {
    
    NSDictionary *event = [self getClickFinishEvent];
    //连点器运行次数 Sensor Only 结束运行
    [SMEventSensor toolShutdown:ToolTypeClicker event:event];
    //连点器使用时长
    [SMEventSensor finishReport:AutoClickerRunDurationEvent];
    return [self.linkerSDK pauseScheme];
}
-(NSDictionary *)getClickFinishEvent{
    if(self.isRun||self.isComplete){
        GTClickerSchemeModel *schemeModel = [GTClickerWindowManager shareInstance].schemeModel;
        int plan_id = [self getPlanId];
        NSInteger circle_way = schemeModel.cycleIndex == 0?2:1;
        NSInteger set_circle_times = schemeModel.cycleIndex;
        NSInteger real_circle_times = self.linkerSDK.cycleNum;
        if([GTClickerManager shareInstance].isRun){
            real_circle_times+=1;
        }
        
        NSDictionary *event = @{
            @"plan_id":@(plan_id),
            @"circle_way":@(circle_way),
            @"set_circle_times":@(set_circle_times),
            @"real_circle_times":@(real_circle_times)
        };
        return event;
    }
    return nil;

}

//- (BOOL)continueScheme {
//    return [self.linkerSDK continueScheme];
//}

- (BOOL)isPause {
    return self.linkerSDK.isPaused;
}

#pragma mark - SMLinkClickerDelegate
-(void)schemeSatusChanged:(ClickerSchemeSatus)status scheme:(SMClickSchemeModel *_Nullable)schemeModel error:(NSError *_Nullable)error {
    switch (status) {
        case ClickerSchemeSatusRunning: {
            self.isRun = YES;
            self.isComplete = NO;
        }
            break;
        case ClickerSchemeSatusPaused: {
            self.isRun = NO;
            self.isComplete = NO;
        }
            break;
        case ClickerSchemeSatusUnStarted: {
            self.isRun = NO;
            self.isComplete = NO;
        }
            break;
        case ClickerSchemeSatusFailed: {
            self.isRun = NO;
            self.isComplete = NO;
        }
            break;
        case ClickerSchemeSatusCompleted: {
            self.isRun = NO;
            self.isComplete = YES;
            //如果类型是now start,则转换成准备状态
            if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateNowStart) {
                if ([GTClickerWindowManager shareInstance].schemeModel.startMethod == ClickerWindowStartMethodNow) {
                    [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateNowReady;
                    [GTClickerWindowAnimation clickerWindowNowStartToNowReadyAnimationWithCompletion:nil];
                }else {
                    [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureReady;
                    [GTClickerWindowAnimation clickerWindowNowStartToFutureReadyAnimationWithCompletion:nil];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowPauseNotification object:self userInfo:nil];
            }
            
            NSDictionary *event = [self getClickFinishEvent];
            //连点器运行次数 Sensor Only 方案执行完毕
            [SMEventSensor toolShutdown:ToolTypeClicker event:event];
        }
            break;
        default:
            break;
    }
}

- (void)willClickPoint:(SMClickPointModel *)pointModel scriptCheakPoint:(SMClickPointModel *)scriptCheakPointModel {
    GTClickerPointWindow *pointWindow = [GTClickerWindowManager shareInstance].pointWindowArray[(int)pointModel.index];
    
    NSString *normalImg = @"";
    NSString *lightImg = @"";
    switch ([GTClickerWindowManager shareInstance].pointSetModel.pointSize) {
        case ClickerWindowPointSizeOfSmall: {
            normalImg = @"clicker_point_small_bg_img";
            lightImg = @"clicker_point_small_bg_img_light";
        }
            break;
        case ClickerWindowPointSizeOfMedium: {
            normalImg = @"clicker_point_medium_bg_img";
            lightImg = @"clicker_point_medium_bg_img_light";
        }
            break;
        case ClickerWindowPointSizeOfLarge: {
            normalImg = @"clicker_point_large_bg_img";
            lightImg = @"clicker_point_large_bg_img_light";
        }
            break;
        default:
            break;
    }
    
    pointWindow.bgImg.image = [[GTThemeManager share] imageWithName:lightImg];
    
    //判断触点显示规则
    switch ([GTClickerWindowManager shareInstance].pointSetModel.pointShowType) {
        case ClickerWindowPointShowNo: {
            pointWindow.hidden = YES;
            DELAYED((float)pointModel.pressDuration/1000, ^{
                pointWindow.bgImg.image = [[GTThemeManager share] imageWithName:normalImg];
            });
        }
            break;
        case ClickerWindowPointShowAll: {
            pointWindow.hidden = NO;
            DELAYED((float)pointModel.pressDuration/1000, ^{
                pointWindow.bgImg.image = [[GTThemeManager share] imageWithName:normalImg];
            });
        }
            break;
        case ClickerWindowPointShowExecute: {
            pointWindow.hidden = NO;
            DELAYED((float)pointModel.pressDuration/1000, ^{
                pointWindow.hidden = YES;
                pointWindow.bgImg.image = [[GTThemeManager share] imageWithName:normalImg];
            });
        }
            break;
        default:
            break;
    }
    
    
    
    
    
}
-(int)getPlanId{
    NSString *schemeJsonString = [GTClickerWindowManager shareInstance].schemeJsonString;
    if(schemeJsonString.length==0){
        return 0;
    }
    return -2;
    
}

@end
