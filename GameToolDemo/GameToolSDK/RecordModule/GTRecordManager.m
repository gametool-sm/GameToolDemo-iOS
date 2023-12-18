//
//  GTRecordManager.m
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import "GTRecordManager.h"
#import <LinkerPlugin/SMRecordSDK.h>
#import "GTRecordWindowManager.h"
#import "NSString+Custom.h"

@interface GTRecordManager() <GTRecordViewDelegate>


@end

@implementation GTRecordManager

+ (GTRecordManager *)shareInstance {
   static GTRecordManager *manager = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       manager = [[GTRecordManager alloc]init];
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
    self.isRecord = NO;
    self.isPlayback = NO;
    self.isRu = NO;
    self.isComplete = NO;
}

- (void)startScheme:(NSString *)jsonString {
    
    [GTRecordView recordView].delegate = self;
    [[GTRecordView recordView] playbackWithSchemeModel:[GTRecordWindowManager shareInstance].schemeModel];
    
}

- (void)pauseScheme{
    [[GTRecordView recordView] pauseScheme];
}

- (void)continueScheme{
    [[GTRecordView recordView] continueScheme];
}

- (NSTimeInterval)timeIntervalBeforeFirstLineSchemeJsonStr:(NSString *)schemeJsonStr {
    return [GTRecordView timeIntervalBeforeFirstLineSchemeJsonStr:[[GTRecordWindowManager shareInstance].schemeModel modelToJSONString]];
}

#pragma mark - SMRecordSDKDelegate
//-(void)schemeSatusChanged:(ClickerSchemeSatus)status scheme:(SMClickSchemeModel *_Nullable)schemeModel error:(NSError *_Nullable)error {
//    switch (status) {
//        case ClickerSchemeSatusRunning: {
//            self.isRun = YES;
//            self.isComplete = NO;
//        }
//            break;
//        case ClickerSchemeSatusPaused: {
//            self.isRun = NO;
//            self.isComplete = NO;
//        }
//            break;
//        case ClickerSchemeSatusUnStarted: {
//            self.isRun = NO;
//            self.isComplete = NO;
//        }
//            break;
//        case ClickerSchemeSatusFailed: {
//            self.isRun = NO;
//            self.isComplete = NO;
//        }
//            break;
//        case ClickerSchemeSatusCompleted: {
//            self.isRun = NO;
//            self.isComplete = YES;
//            //如果类型是now start,则转换成准备状态
//            if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateNowStart) {
//                if ([GTClickerWindowManager shareInstance].schemeModel.startMethod == ClickerWindowStartMethodNow) {
//                    [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateNowReady;
//                    [GTClickerWindowAnimation clickerWindowNowStartToNowReadyAnimationWithCompletion:nil];
//                }else {
//                    [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureReady;
//                    [GTClickerWindowAnimation clickerWindowNowStartToFutureReadyAnimationWithCompletion:nil];
//                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowPauseNotification object:self userInfo:nil];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//}
//
//- (void)willClickPoint:(SMClickPointModel *)pointModel scriptCheakPoint:(SMClickPointModel *)scriptCheakPointModel {
//    GTClickerPointWindow *pointWindow = [GTClickerWindowManager shareInstance].pointWindowArray[(int)pointModel.index];
//
//    NSString *normalImg = @"";
//    NSString *lightImg = @"";
//    switch ([GTClickerWindowManager shareInstance].pointSetModel.pointSize) {
//        case ClickerWindowPointSizeOfSmall: {
//            normalImg = @"clicker_point_small_bg_img";
//            lightImg = @"clicker_point_small_bg_img_light";
//        }
//            break;
//        case ClickerWindowPointSizeOfMedium: {
//            normalImg = @"clicker_point_medium_bg_img";
//            lightImg = @"clicker_point_medium_bg_img_light";
//        }
//            break;
//        case ClickerWindowPointSizeOfLarge: {
//            normalImg = @"clicker_point_large_bg_img";
//            lightImg = @"clicker_point_large_bg_img_light";
//        }
//            break;
//        default:
//            break;
//    }
//
//    pointWindow.bgImg.image = [[GTThemeManager share] imageWithName:lightImg];
//
//    //判断触点显示规则
//    switch ([GTClickerWindowManager shareInstance].pointSetModel.pointShowType) {
//        case ClickerWindowPointShowNo: {
//            pointWindow.hidden = YES;
//            DELAYED((float)pointModel.pressDuration/1000, ^{
//                pointWindow.bgImg.image = [[GTThemeManager share] imageWithName:normalImg];
//            });
//        }
//            break;
//        case ClickerWindowPointShowAll: {
//            pointWindow.hidden = NO;
//            DELAYED((float)pointModel.pressDuration/1000, ^{
//                pointWindow.bgImg.image = [[GTThemeManager share] imageWithName:normalImg];
//            });
//        }
//            break;
//        case ClickerWindowPointShowExecute: {
//            pointWindow.hidden = NO;
//            DELAYED((float)pointModel.pressDuration/1000, ^{
//                pointWindow.hidden = YES;
//                pointWindow.bgImg.image = [[GTThemeManager share] imageWithName:normalImg];
//            });
//        }
//            break;
//        default:
//            break;
//    }
//
//
//
//
//
//}

#pragma mark--GTRecordViewDelegate

/// 录制方案状态变化
/// - Parameter recordSchemeSatus: 录制方最新案状态
-(void)recordSchemeSatuschanged:(RecordSchemeSatus)recordSchemeSatus {
    switch (recordSchemeSatus) {
        case RecordSchemeSatusRunning: {
            self.isRu = YES;
            self.isComplete = NO;
        }
            break;
        case RecordSchemeSatusPaused: {
            self.isRu = NO;
            self.isComplete = NO;
        }
            break;
        case RecordSchemeSatusNotStarted: {
            self.isRu = NO;
            self.isComplete = NO;
        }
            break;
        case RecordSchemeSatusFailed: {
            self.isRu = NO;
            self.isComplete = NO;
        }
            break;
        case RecordSchemeSatusCompleted: {
            self.isRu = NO;
            self.isComplete = YES;
            
            self.isPlayback = NO;
            //录制悬浮窗转换成结束状态
            switch ([GTRecordWindowManager shareInstance].recordWindowState) {
                case RecordWindowStateNowFinite:
                case RecordWindowStateFutureFinite: {
                    //连点器运行次数埋点
                    if ([[GTRecordWindowManager shareInstance].schemeJsonString isEqualToString:@""]) {
                        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventAutoClickerRunTimes andProperties:@{
                            @"plan_id" : [NSNumber numberWithInt:0],
                            @"circle_way" : [NSNumber numberWithInt:1],
                            @"set_circle_times" : [NSNumber numberWithInt:[GTRecordWindowManager shareInstance].schemeModel.cycleIndex],
                            @"real_circle_times" :  [NSNumber numberWithInt:[GTRecordWindowManager shareInstance].recordWindowVC.finiteView.loopNum]
                        } shouldFlush:YES];
                    }else {
                        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventAutoClickerRunTimes andProperties:@{
                            @"plan_id" : [NSNumber numberWithInt:-3],
                            @"circle_way" : [NSNumber numberWithInt:1],
                            @"set_circle_times" : [NSNumber numberWithInt:[GTRecordWindowManager shareInstance].schemeModel.cycleIndex],
                            @"real_circle_times" :  [NSNumber numberWithInt:[GTRecordWindowManager shareInstance].recordWindowVC.finiteView.loopNum]
                        } shouldFlush:YES];
                    }
                    //结束方案
                    [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView finishScheme];
                }
                    break;
                case RecordWindowStateNowInfinite:
                case RecordWindowStateFutureInfinite: {
                    [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView finishScheme];
                }
                    break;
                default:
                    break;
            }
            
            
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKRecordWindowQuitSchemeNotification object:self userInfo:nil];
        }
            break;
        default:
            break;
    }
}


/// 将在interval后执行索引为lineIndex这条线
/// - Parameters:
///   - lineIndex: 线的索引
///   - interval: 等待时间
-(void)willRecordLine:(NSInteger)lineIndex interval:(NSTimeInterval)interval {
    if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateNowFinite ||
        [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureFinite) {
        
        [GTRecordWindowManager shareInstance].recordWindowVC.finiteView.waitTime = [[NSString stringWithFormat:@"%.3f", interval] floatValue];
        [GTRecordWindowManager shareInstance].recordWindowVC.finiteView.waitTimeDetailLabel.text = [NSString millisecondConversionTime:[GTRecordWindowManager shareInstance].recordWindowVC.finiteView.waitTime];
        [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView startWaitTimer];
        
    }else if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateNowInfinite ||
              [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureInfinite) {
        
        [GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.waitTime = [[NSString stringWithFormat:@"%.3f", interval] floatValue];
        [GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.waitTimeDetailLabel.text = [NSString millisecondConversionTime:[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.waitTime];
        [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView startWaitTimer];
        
    }
}


/// 方案执行次数变化
/// - Parameter cycleNum: 当前次数
-(void)recordSchemeCycleNumChanged:(NSInteger)cycleNum {
    if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateNowFinite ||
        [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureFinite) {
        
        [GTRecordWindowManager shareInstance].recordWindowVC.finiteView.loopNum = (int)cycleNum;
        [GTRecordWindowManager shareInstance].recordWindowVC.finiteView.loopDetailLabel.text = [NSString stringWithFormat:@"%d/%d", (int)cycleNum, [GTRecordWindowManager shareInstance].schemeModel.cycleIndex];
        
//        if (cycleNum == 4) {
//            NSString *str = [@"123" substringToIndex:6];
//        }
        
        
    }else {
        [GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.loopNum = (int)cycleNum;
    }
}


@end

