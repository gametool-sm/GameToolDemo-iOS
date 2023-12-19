//
//  GTSensorEvent.h
//  GTSDK
//
//  Created by smwl on 2023/11/13.
//

#import <Foundation/Foundation.h>
#import "GTDataTimeModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *kGTSensorEvent NS_STRING_ENUM;

FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventTestLocal;
//SDK启动成功
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventSDKSuccessStart;
//工具箱深色模式切换
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventToolBoxDarkModeSwitch;
//悬浮球隐藏
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventFloatBallHide;
//工具箱元素点击
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventToolBoxElementClick;
//悬浮球移动
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventFloatBallMove;
//工具箱开关切换
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventToolBoxOpenCloseSwitch;
//加速器使用时长
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventGameSpeedUseDuration;
//加速器倍率调整
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventGameSpeedRateAdjust;
//连点器运行次数
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventAutoClickerRunTimes;
//连点器启动时长
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventAutoClickerStartDuration;
//连点器使用时长
FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventAutoClickerRunDuration;

FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventAutoClickerRunTimes;

FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventAutoClickerStartDuration;

FOUNDATION_EXPORT kGTSensorEvent const GTSensorEventAutoClickerRunDuration;

//接收返回的任务ID

FOUNDATION_EXPORT GTDataTimeCounterType GTSensorEventGameSpeedUseDurationID;

FOUNDATION_EXPORT GTDataTimeCounterType GTSensorEventAutoClickerStartDurationID;

FOUNDATION_EXPORT GTDataTimeCounterType GTSensorEventAutoClickerRunDurationID;

NS_ASSUME_NONNULL_END
