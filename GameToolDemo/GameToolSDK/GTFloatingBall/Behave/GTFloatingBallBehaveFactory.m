//
//  GTFloatingBallBehaveFactory.m
//  GTSDK
//
//  Created by shangmi on 2023/9/14.
//

#import "GTFloatingBallBehaveFactory.h"
#import "GTFloatingBallBehave.h"
#import "GTFloatingBallManager.h"
#import "GTFloatingBallBehaveDefault.h"
#import "GTFloatingBallBehaveSimpleControl.h"

@interface GTFloatingBallBehaveFactory ()

@property (nonatomic, strong) GTFloatingBallBehave *ballBahave;

@property (nonatomic, strong) NSTimer *hideHalfTimer;
@property (nonatomic, strong) NSTimer *darkTimer;

@end


@implementation GTFloatingBallBehaveFactory

- (instancetype)init {
    self = [super init];
    if (self) {
        switch ([GTFloatingBallManager shareInstance].floatingBallStyle) {
            case FloatingBallStyleDefault:
                self.ballBahave = [GTFloatingBallBehaveDefault new];
                break;
            case FloatingBallStyleSimpleControl:
            case FloatingBallStyleControl:
                self.ballBahave = [GTFloatingBallBehaveSimpleControl new];
                break;
            default:
                break;
        }
    }
    return self;
}

//移动范围
- (CGPoint)floatingBallMoveArea:(CGPoint)movePoint {
    return [self.ballBahave floatingBallMoveArea:movePoint];
}

//自动靠边
- (void)floatingBallWeltWithSpeed:(double)speed completion:(void (^ __nullable)(void))completion {
    [self.ballBahave floatingBallWeltWithSpeed:speed completion:completion];
}

//贴边隐藏一半
- (void)floatingBallHideHalfWithCompletion:(void (^ __nullable)(void))completion {
    [self.ballBahave floatingBallHideHalfWithCompletion:completion];
}

//弹出
- (void)floatinngBallPopUpWithCompletion:(void (^)(void))completion {
    [self.ballBahave floatinngBallPopUpWithCompletion:completion];
}

//熄灭
- (void)floatingBallDarkWithCompletion:(void (^ __nullable)(void))completion {
    [self.ballBahave floatingBallDarkWithCompletion:completion];
}

//点亮
- (void)floatingBallLightWithCompletion:(void (^ __nullable)(void))completion {
    [self.ballBahave floatingBallLightWithCompletion:completion];
}

#pragma mark - 隐藏一半计时器
//隐藏一半
//开始倒计时
- (void)startFloatingBallHideHalfTimer {
    // 每次启动计时器前先停止之前的计时器
    [self.hideHalfTimer invalidate];

    // 创建一个1秒钟的计时器
    self.hideHalfTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(hideHalfTimerExpired) userInfo:nil repeats:NO];
}

//移除隐藏一半的计时器
- (void)removeFloatingBallHideHalfTimer {
    [self.hideHalfTimer invalidate];
    self.hideHalfTimer = nil;
}

- (void)hideHalfTimerExpired {
    //定时启动隐藏一半
    [self floatingBallHideHalfWithCompletion:^{
        [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateHideHalf;
        [self startFloatingBallDarkTimer];
    }];
}

#pragma mark - 熄灭悬浮球计时器
//熄灭悬浮球
//开始倒计时
- (void)startFloatingBallDarkTimer {
    // 每次启动计时器前先停止之前的计时器
    [self.darkTimer invalidate];

    // 创建一个1秒钟的计时器
    self.darkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(darkTimerExpired) userInfo:nil repeats:NO];
}

//移除悬浮球熄灭的计时器
- (void)removeFloatingBallDarkTimer {
    [self.darkTimer invalidate];
    self.darkTimer = nil;
}

- (void)darkTimerExpired {
    //定时启动悬浮球熄灭
    [self floatingBallDarkWithCompletion:^{
        [GTFloatingBallManager shareInstance].floatingBallLuminance = FloatingBallLuminanceDark;
    }];
}

@end
