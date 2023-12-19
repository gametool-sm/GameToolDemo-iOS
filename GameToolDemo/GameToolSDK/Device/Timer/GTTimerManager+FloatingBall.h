//
//  GTTimerManager+FloatingBall.h
//  GTSDK
//
//  Created by shangmi on 2023/6/23.
//

#import "GTTimerManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTTimerManager (FloatingBall)
//悬浮球贴边开始计时
- (void)startFloatingBallBeginWeltWithExtinguishComplete:(ExtinguishTimerTimeOutCompleteBlock)extinguishComplete hideHalfComplete:(HideHalfTimerTimeOutCompleteBlock)hideHalfComplete;
//悬浮球重新变为点亮状态
- (void)restartFloatingBallStateWithLightedComplete:(LightedTimerTimeOutCompleteBlock)lightedComplete;

@end

NS_ASSUME_NONNULL_END
