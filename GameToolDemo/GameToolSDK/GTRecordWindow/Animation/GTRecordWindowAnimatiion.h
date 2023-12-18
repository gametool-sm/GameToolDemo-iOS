//
//  GTRecordWindowAnimatiion.h
//  GTSDK
//
//  Created by shangmi on 2023/10/17.
//

#import <Foundation/Foundation.h>
#import "GTRecordWindowManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTRecordWindowAnimatiion : NSObject

#pragma mark - RecordWindowStateStartRecord

/**
 状态：RecordWindowStateStartRecord -> RecordWindowStateRecordTime
 动作：开始录制 -> 录制中
 */
//暂时不用，点击开始录制直接跳转321倒计时
+ (void)recordWindowStartRecordToRecordTimeAnimationWithCompletion:(void (^ __nullable)(void))completion;

#pragma mark - RecordWindowStateRecordTime

/**
 状态：RecordWindowStateRecordTime -> RecordWindowStateRecordTimeDark
 动作：录制中 -> 录制中熄灭
 */
+ (void)recordWindowRecordTimeToRecordTimeDarkAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 状态：RecordWindowStateRecordTime -> RecordWindowStateStartRecord
 动作：录制中 -> 开始录制
 */
+ (void)recordWindowRecordTimeToStartRecordAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 状态：RecordWindowStateRecordTime -> RecordWindowStateNowInfinite
 动作：录制中 -> 立即回放无限循环
 */
+ (void)recordWindowRecordTimeToNowInfiniteAnimationWithCompletion:(void (^ __nullable)(void))completion;

#pragma mark - RecordWindowStateRecordTimeDark

/**
 状态：RecordWindowStateRecordTimeDark -> RecordWindowStateRecordTime
 动作：录制中熄灭 -> 录制中
 */

+ (void)recordWindowRecordTimeDarkToRecordTimeAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 状态：RecordWindowStateRecordTimeDark -> RecordWindowStateStartRecord
 动作：录制中熄灭 -> 开始录制
 */

+ (void)recordWindowRecordTimeDarkToStartRecordAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 状态：RecordWindowStateRecordTimeDark ->
 动作：录制中熄灭 -> 立即回放无限循环
 */

+ (void)recordWindowRecordTimeDarkToNowInfiniteAnimationWithCompletion:(void (^ __nullable)(void))completion;

#pragma mark - RecordWindowStateFutureFinite

/**
 状态：RecordWindowStateFutureFinite -> RecordWindowStateFutureCountdown
 动作：预约回放有限循环 -> 预约回放倒计时
 */

+ (void)recordWindowFutureFiniteToFutureCountdownAnimationWithCompletion:(void (^ __nullable)(void))completion;

#pragma mark - RecordWindowStateFutureInfinite

/**
 状态：RecordWindowStateFutureInfinite -> RecordWindowStateFutureCountdown
 动作：预约回放无限循环 -> 预约回放倒计时
 */

+ (void)recordWindowFutureInfiniteToFutureCountdownAnimationWithCompletion:(void (^ __nullable)(void))completion;

#pragma mark - RecordWindowStateFutureCountdown

/**
 状态：RecordWindowStateFutureCountdown -> RecordWindowStateFutureFinite
 动作：预约回放倒计时 -> 预约回放有限循环
 */

+ (void)recordWindowFutureCountdownToFutureFiniteAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 状态：RecordWindowStateFutureCountdown -> RecordWindowStateFutureInfinite
 动作：预约回放倒计时 -> 预约回放无限循环
 */

+ (void)recordWindowFutureCountdownToFutureInfiniteAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 状态：RecordWindowStateFutureCountdown -> RecordWindowStateFutureCountdownDark
 动作：预约回放倒计时 -> 预约回放倒计时熄灭状态
 */

+ (void)recordWindowFutureCountdownToFutureCountdownDarkAnimationWithCompletion:(void (^ __nullable)(void))completion;

#pragma mark - RecordWindowStateFutureCountdownDark

/**
 状态：RecordWindowStateFutureCountdownDark -> RecordWindowStateFutureCountdown
 动作：预约回放倒计时熄灭状态 -> 预约回放倒计时
 */

+ (void)recordWindowFutureCountdownDarkToFutureCountdownAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 状态：RecordWindowStateFutureCountdownDark -> RecordWindowStateFutureFinite
 动作：预约回放倒计时熄灭状态 -> 预约回放有限循环
 */

+ (void)recordWindowFutureCountdownDarkToFutureFiniteAnimationWithCompletion:(void (^ __nullable)(void))completion;

/**
 状态：RecordWindowStateFutureCountdownDark -> RecordWindowStateFutureInfinite
 动作：预约回放倒计时熄灭状态 -> 预约回放无限循环
 */

+ (void)recordWindowFutureCountdownDarkToFutureInfiniteAnimationWithCompletion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
