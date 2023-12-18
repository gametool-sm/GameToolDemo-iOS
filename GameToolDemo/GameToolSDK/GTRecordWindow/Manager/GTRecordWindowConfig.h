//
//  GTRecordWindowConfig.h
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import <Foundation/Foundation.h>

//录制悬浮窗状态
typedef NS_ENUM(NSUInteger, RecordWindowState) {
    RecordWindowStateStartRecord,                   //开始录制
    RecordWindowStateRecordTime,                    //录制中倒计时
    RecordWindowStateRecordTimeDark,                //录制中计时熄灭状态
    
    RecordWindowStateNowFinite,                     //立即回放有限循环次数方案悬浮球
    RecordWindowStateFutureFinite,                  //预约回放有限循环次数方案悬浮球
    RecordWindowStateNowInfinite,                   //立即回放无限循环次数方案悬浮球
    RecordWindowStateFutureInfinite,                //预约回放无限循环次数方案悬浮球
    RecordWindowStateFutureCountdown,               //预约回放倒计时
    RecordWindowStateFutureCountdownDark,           //预约回放倒计时熄灭状态
};

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 录制悬浮窗宽高
//连点器移动时距离边距
extern CGFloat const recordWindow_distance;
//开始录制的宽高
extern CGFloat const recordWindow_begin_width;
//录制中的宽
extern CGFloat const recordWindow_record_time_width;
//录制中的高
extern CGFloat const recordWindow_record_time_height;
//录制中熄灭状态的宽
extern CGFloat const recordWindow_record_time_dark_width;
//录制中熄灭状态的高
extern CGFloat const recordWindow_record_time_dark_height;

//播放录制轨迹，无限循环的宽高
extern CGFloat const recordWindow_infinite_width;
extern CGFloat const recordWindow_infinite_height;
//播放录制轨迹，有限循环的宽高
extern CGFloat const recordWindow_finite_width;
extern CGFloat const recordWindow_finite_height;

@interface GTRecordWindowConfig : NSObject

@end

NS_ASSUME_NONNULL_END
