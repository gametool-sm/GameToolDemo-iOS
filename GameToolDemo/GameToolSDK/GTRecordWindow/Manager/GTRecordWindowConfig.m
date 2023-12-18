//
//  GTRecordWindowConfig.m
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import "GTRecordWindowConfig.h"

@implementation GTRecordWindowConfig

#pragma mark - 录制悬浮窗宽高
//连点器移动时距离边距
CGFloat const recordWindow_distance = 10;
//开始录制的宽高
CGFloat const recordWindow_begin_width = 48;
//录制中的宽
CGFloat const recordWindow_record_time_width = 156;
//录制中的高
CGFloat const recordWindow_record_time_height = 48;
//录制中熄灭状态的宽
CGFloat const recordWindow_record_time_dark_width = 111;
//录制中熄灭状态的高
CGFloat const recordWindow_record_time_dark_height = 30;

//播放录制轨迹，无限循环的宽高
CGFloat const recordWindow_infinite_width = 189;
CGFloat const recordWindow_infinite_height = 48;
//播放录制轨迹，有限循环的宽高
CGFloat const recordWindow_finite_width = 225;
CGFloat const recordWindow_finite_height = 48;

@end
