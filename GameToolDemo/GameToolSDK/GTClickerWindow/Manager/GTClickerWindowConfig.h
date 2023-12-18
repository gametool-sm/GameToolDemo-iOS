//
//  GTClickerWindowConfig.h
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import <Foundation/Foundation.h>

//连点器悬浮窗启动方式
typedef NS_ENUM(NSUInteger, ClickerWindowStartMethod) {
    ClickerWindowStartMethodNow,                //立即
    ClickerWindowStartMethodPreset,             //定时
    ClickerWindowStartMethodCountdown,          //倒计时
};

//连点器悬浮窗状态
typedef NS_ENUM(NSUInteger, ClickerWindowState) {
    ClickerWindowStateNowReady,                     //立即启动未执行
    ClickerWindowStateFutureReady,                  //预约启动未执行（包含定时和倒计时）
    ClickerWindowStateNowStart,                     //立即启动正在执行
    ClickerWindowStateFutureStart,                  //预约启动正在执行（包含定时和倒计时）
    ClickerWindowStateFutureDark,                   //预约启动正在执行熄灭状态（包含定时和倒计时）
};

//连点器移动时距离边距
extern CGFloat const clickerWindow_distance;

#pragma mark - 连点器悬浮窗宽高
//连点器未执行状态的宽
extern CGFloat const clickerWindow_ready_width;
//连点器未执行状态的高
extern CGFloat const clickerWindow_ready_height;

//连点器执行状态的宽,立即
extern CGFloat const clickerWindow_now_start_width;
//连点器执行状态的高，立即
extern CGFloat const clickerWindow_now_start_height;

//连点器执行状态的宽，定时和倒计时
extern CGFloat const clickerWindow_future_start_width;
//连点器执行状态的高，定时和倒计时
extern CGFloat const clickerWindow_future_start_height;

//连点器熄灭状态的宽，定时和倒计时
extern CGFloat const clickerWindow_future_dark_width;
//连点器熄灭状态的高，定时和倒计时
extern CGFloat const clickerWindow_future_dark_height;

//动画中蒙层的宽，即图片"clicker_mask_rig _img"的宽
extern CGFloat const clickerWindow_animation_mask_width;
//动画中蒙层的高，即图片"clicker_mask_right_img"的高
extern CGFloat const clickerWindow_animation_mask_height;

#pragma mark - 触点宽高
//大号触点宽高
extern CGFloat const clickerWindow_point_large_width;
//中号触点宽高
extern CGFloat const clickerWindow_point_medium_width;
//小号触点宽高
extern CGFloat const clickerWindow_point_small_width;

NS_ASSUME_NONNULL_BEGIN

@interface GTClickerWindowConfig : NSObject

@end

NS_ASSUME_NONNULL_END
