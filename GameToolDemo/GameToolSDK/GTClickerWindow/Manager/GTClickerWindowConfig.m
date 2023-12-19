//
//  GTClickerWindowConfig.m
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTClickerWindowConfig.h"

//连点器移动时距离边距
CGFloat const clickerWindow_distance = 10;

#pragma mark - 连点器悬浮窗宽高
//连点器未执行状态的宽
CGFloat const clickerWindow_ready_width = 124;
//连点器未执行状态的高
CGFloat const clickerWindow_ready_height = 48;

//连点器执行状态的宽,立即
CGFloat const clickerWindow_now_start_width = 48;
//连点器执行状态的高，立即
CGFloat const clickerWindow_now_start_height = 48;

//连点器执行状态的宽，定时和倒计时
CGFloat const clickerWindow_future_start_width = 156;
//连点器执行状态的高，定时和倒计时
CGFloat const clickerWindow_future_start_height = 48;

//连点器熄灭状态的宽，定时和倒计时
CGFloat const clickerWindow_future_dark_width = 111;
//连点器熄灭状态的高，定时和倒计时
CGFloat const clickerWindow_future_dark_height = 30;

//动画中蒙层的宽，即图片"clicker_mask_right_img"的宽
CGFloat const clickerWindow_animation_mask_width = 40;
//动画中蒙层的高，即图片"clicker_mask_right_img"的高
CGFloat const clickerWindow_animation_mask_height = 48;

#pragma mark - 触点宽高
//大号触点宽高
CGFloat const clickerWindow_point_large_width = 34;
//中号触点宽高
CGFloat const clickerWindow_point_medium_width = 30;
//小号触点宽高
CGFloat const clickerWindow_point_small_width = 22;



@implementation GTClickerWindowConfig

@end
