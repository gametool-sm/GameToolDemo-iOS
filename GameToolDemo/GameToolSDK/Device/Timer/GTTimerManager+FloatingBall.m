//
//  GTTimerManager+FloatingBall.m
//  GTSDK
//
//  Created by shangmi on 2023/6/23.
//

#import "GTTimerManager+FloatingBall.h"

@implementation GTTimerManager (FloatingBall)

//悬浮球贴边开始计时
- (void)startFloatingBallBeginWeltWithExtinguishComplete:(ExtinguishTimerTimeOutCompleteBlock)extinguishComplete hideHalfComplete:(HideHalfTimerTimeOutCompleteBlock)hideHalfComplete {
    self.extinguishBlock = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        extinguishComplete();
    });
    self.hidehalfBlock =  dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        hideHalfComplete();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), self.extinguishBlock);
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5*NSEC_PER_SEC)), dispatch_get_main_queue(), self.hidehalfBlock);
}



//悬浮球重新变为点亮状态
- (void)restartFloatingBallStateWithLightedComplete:(LightedTimerTimeOutCompleteBlock)lightedComplete {
    if (lightedComplete) {
        lightedComplete();
    }
    if (self.extinguishBlock) {
        dispatch_block_cancel(self.extinguishBlock);
    }
    if (self.hidehalfBlock) {
        dispatch_block_cancel(self.hidehalfBlock);
    }
}

@end
