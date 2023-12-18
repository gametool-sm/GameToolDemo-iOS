//
//  GTTimerManager.m
//  GTSDK
//
//  Created by 童威 on 2023/6/18.
//

#import "GTTimerManager.h"

/**
 
 童
 暂时先写一起，后期可能用匿名协议来重写,保证可以对外实现对接
 
 */

static float const extinguishTime = 5;
static float const hideHalfTime = 1.5;

@interface GTTimerManager ()

@end

@implementation GTTimerManager

+ (GTTimerManager *)shareManager {
    static GTTimerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GTTimerManager alloc]init];
        
        [manager setUp];
    });
    return manager;
}

- (void)setUp {
//    self.extinguishTimerTimeOutCompleteBlock = nil;
//    self.hideHalfTimerTimeOutCompleteBlock = nil;
}

- (dispatch_source_t)extinguishTimer {
    if (!_extinguishTimer) {
        dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
        _extinguishTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_extinguishTimer, dispatch_walltime(0, extinguishTime), extinguishTime * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_extinguishTimer, ^{
            if (self.extinguishTimerTimeOutCompleteBlock) {
                self.extinguishTimerTimeOutCompleteBlock();
            }
            NSLog(@"1");
        });
    }
    return _extinguishTimer;
}

- (dispatch_source_t)hideHalfTimer {
    if (!_hideHalfTimer) {
        dispatch_queue_t  queue = dispatch_get_global_queue(0, 0);
        _hideHalfTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_hideHalfTimer, DISPATCH_TIME_NOW, hideHalfTime * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_hideHalfTimer, ^{
            if (self.hideHalfTimerTimeOutCompleteBlock) {
                self.hideHalfTimerTimeOutCompleteBlock();
            }
        });
    }
    return _hideHalfTimer;
}

//开始计时器
- (void)initiate:(dispatch_source_t)timer {
    dispatch_resume(timer);
}

//暂停计时器
- (void)pause:(dispatch_source_t)timer {
    if (timer) {
        dispatch_suspend(timer);
    }
}

//重置计时器
- (void)reset:(dispatch_source_t)timer {
    if (timer) {
        dispatch_cancel(timer);
        timer = nil;
    }
}

//移除计时器
- (void)remove:(dispatch_source_t)timer {}



@end
