//
//  GTSensorEvent.m
//  GTSDK
//
//  Created by smwl on 2023/11/13.
//

#import "GTSensorEvent.h"

kGTSensorEvent const GTSensorEventTestLocal = @"IOSTestLocal";

//SDK启动成功
kGTSensorEvent const GTSensorEventSDKSuccessStart = @"SDKSuccessStart";

//工具箱深色模式切换
kGTSensorEvent const GTSensorEventToolBoxDarkModeSwitch = @"ToolBoxDarkModeSwitch";
//悬浮球隐藏
kGTSensorEvent const GTSensorEventFloatBallHide = @"FloatBallHide";
//工具箱元素点击
kGTSensorEvent const GTSensorEventToolBoxElementClick = @"ToolBoxElementClick";
//悬浮球移动
kGTSensorEvent const GTSensorEventFloatBallMove = @"FloatBallMove";
//工具箱开关切换
kGTSensorEvent const GTSensorEventToolBoxOpenCloseSwitch = @"ToolBoxOpenCloseSwitch";
//加速器使用时长
kGTSensorEvent const GTSensorEventGameSpeedUseDuration = @"GameSpeedUseDuration";
//加速器倍率调整
kGTSensorEvent const GTSensorEventGameSpeedRateAdjust = @"GameSpeedRateAdjust";
//连点器运行次数
kGTSensorEvent const GTSensorEventAutoClickerRunTimes = @"AutoClickerRunTimes";
//连点器启动时长
kGTSensorEvent const GTSensorEventAutoClickerStartDuration = @"AutoClickerStartDuration";
//连点器使用时长
kGTSensorEvent const GTSensorEventAutoClickerRunDuration = @"AutoClickerRunDuration";

GTDataTimeCounterType GTSensorEventGameSpeedUseDurationID = @"";
GTDataTimeCounterType GTSensorEventAutoClickerStartDurationID = @"";
GTDataTimeCounterType GTSensorEventAutoClickerRunDurationID = @"";
