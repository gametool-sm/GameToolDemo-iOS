//
//  GTClickerWindowAnimation.h
//  GTSDK
//
//  Created by shangmi on 2023/8/17.
//

#import <Foundation/Foundation.h>
#import "GTClickerWindowManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTClickerWindowAnimation : NSObject


#pragma mark - ClickerWindowStateNowReady
/**
 启动方式：立即
 状态：now ready -> now start
 执行/暂停方案
 */
+ (void)clickerWindowNowReadyToNowStartAnimationWithCompletion:(void (^ __nullable)(void))completion;

#pragma mark - ClickerWindowStateFutureReady

/**
 启动方式：定时，倒计时
 状态：future ready ->future start
 执行/暂停方案
 */
+ (void)clickerWindowFutureReadyToFutureStartAnimationWithCompletion:(void (^ __nullable)(void))completion;


#pragma mark - ClickerWindowStateNowStart

/**
 启动方式：立即
 状态：now start -> now ready
 执行/暂停方案
 */

+ (void)clickerWindowNowStartToNowReadyAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 启动方式：预约，倒计时
 状态：now start -> future ready
 执行/暂停方案
 */
+ (void)clickerWindowNowStartToFutureReadyAnimationWithCompletion:(void (^ __nullable)(void))completion;

#pragma mark - ClickerWindowStateFutureStart

/**
 启动方式：立即
 状态：future start -> future ready
 执行/暂停方案
 */

+ (void)clickerWindowFutureStartToFutureReadyAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 启动方式：定时，倒计时
 状态：future start -> now start
 预约、倒计时结束，切换为now start状态
 */
+ (void)clickerWindowFutureStartToNowStartAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 启动方式：定时，倒计时
 状态：future start -> future dark
 1s内不操作，倒计时或预约启动切换为熄灭状态
 */
+ (void)clickerWindowFutureStartToFutureDarkAnimationWithCompletion:(void (^ __nullable)(void))completion;

#pragma mark - ClickerWindowStateFutureDark

/**
 启动方式：定时，倒计时
 状态：future dark -> future start
 熄灭状态被唤醒为倒计时、预约开启状态
 */
+ (void)clickerWindowFutureDarkToFutureStartAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 启动方式：定时，倒计时
 状态：future dark -> future ready
 熄灭状态点击结束切换为倒计时、预约未开启状态
 */
+ (void)clickerWindowFutureDarkToFutureReadyAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 启动方式：定时，倒计时
 状态：future dark -> now start
 熄灭状态倒计时结束切换为开启状态
 */
+ (void)clickerWindowFutureDarkToNowStartAnimationWithCompletion:(void (^ __nullable)(void))completion;

#pragma mark 悬浮窗动画

/**
 连点器悬浮窗点击增加触点动画（第一次,包含文字气泡）
 */
+ (void)clickerFirstAddPointWindow:(GTClickerPointWindow *)pointWindow animationWithCompletion:(void (^ __nullable)(void))completion;

/**
 连点器悬浮窗点击增加触点动画（非第一次）
 */
+ (void)clickerNormalAddPointWindow:(GTClickerPointWindow *)pointWindow animationWithCompletion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
