//
//  GTClickerWindowAnimation.m
//  GTSDK
//
//  Created by shangmi on 2023/8/17.
//

#import "GTClickerWindowAnimation.h"
#import "GTClickerWindowBehave.h"

@implementation GTClickerWindowAnimation

#pragma mark - ClickerWindowStateNowReady

/**
 启动方式：立即
 状态：now ready -> now start
 执行/暂停方案
 */
+ (void)clickerWindowNowReadyToNowStartAnimationWithCompletion:(void (^)(void))completion {
    if ([GTClickerWindowManager shareInstance].clickerWinWindow.center.x < SCREEN_WIDTH/2) {
        [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 0;
        [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView];
        //添加蒙层
        __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(clickerWindow_ready_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
        [[GTClickerWindowManager shareInstance].clickerWinWindow addSubview:shadowImg];
        
        [UIView animateWithDuration:0.24 animations:^{
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y, clickerWindow_now_start_width * WIDTH_RATIO, clickerWindow_now_start_height * WIDTH_RATIO);
            
            shadowImg.frame = CGRectMake(clickerWindow_now_start_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
            
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView.alpha = 0;
        } completion:^(BOOL finished) {
            [shadowImg removeFromSuperview];
            shadowImg = nil;
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView removeFromSuperview];
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView.alpha = 1;
        }];
        
        [UIView animateWithDuration:0.08 delay:0.16 options:UIViewAnimationOptionCurveLinear animations:^{
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else {
        [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 0;
        [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView];
        //添加蒙层
        __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_right_img"];
        [[GTClickerWindowManager shareInstance].clickerWinWindow addSubview:shadowImg];
        
        [UIView animateWithDuration:0.24 animations:^{
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x + clickerWindow_ready_width * WIDTH_RATIO - clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                       clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                       clickerWindow_now_start_height * WIDTH_RATIO);
            
            shadowImg.frame = CGRectMake(0,
                                         0,
                                         clickerWindow_animation_mask_width * WIDTH_RATIO,
                                         clickerWindow_animation_mask_height * WIDTH_RATIO);
            
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView.alpha = 0;
        } completion:^(BOOL finished) {
            [shadowImg removeFromSuperview];
            shadowImg = nil;
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView removeFromSuperview];
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView.alpha = 1;
        }];
        
        [UIView animateWithDuration:0.08 delay:0.16 options:UIViewAnimationOptionCurveLinear animations:^{
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - ClickerWindowStateFutureReady

/**
 启动方式：定时，倒计时
 状态：future ready ->future start
 执行/暂停方案
 */
+ (void)clickerWindowFutureReadyToFutureStartAnimationWithCompletion:(void (^)(void))completion {
    [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 0;
    [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView];
    
    //添加蒙层
    __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(clickerWindow_ready_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
    shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
    [[GTClickerWindowManager shareInstance].clickerWinWindow addSubview:shadowImg];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x,
                                                                                   [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y, clickerWindow_future_start_width * WIDTH_RATIO, clickerWindow_future_start_height * WIDTH_RATIO);

        shadowImg.frame = CGRectMake(clickerWindow_future_start_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        
    } completion:^(BOOL finished) {
        [shadowImg removeFromSuperview];
        shadowImg = nil;
        
        [[GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView removeFromSuperview];
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView.alpha = 1;
        
        completion();
    }];
    
//    [UIView animateWithDuration:0.12 animations:^{
//        [GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView.alpha = 0;
//    }];
//
    [UIView animateWithDuration:0.12 delay:0.08 options:UIViewAnimationOptionCurveLinear animations:^{
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - ClickerWindowStateNowStart

/**
 启动方式：立即
 状态：start -> ready
 执行/暂停方案
 */
+ (void)clickerWindowNowStartToNowReadyAnimationWithCompletion:(void (^)(void))completion {
    if ([GTClickerWindowManager shareInstance].clickerWinWindow.center.x < SCREEN_WIDTH/2) {
        [GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView.alpha = 0;
        [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView];
        //添加蒙层
        __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(clickerWindow_now_start_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
        [[GTClickerWindowManager shareInstance].clickerWinWindow addSubview:shadowImg];
        
        [UIView animateWithDuration:0.24 animations:^{
            
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                       clickerWindow_ready_width * WIDTH_RATIO,
                                                                                       clickerWindow_ready_height * WIDTH_RATIO);
            
            shadowImg.frame = CGRectMake(clickerWindow_ready_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
//            shadowImg.transform = CGAffineTransformMakeTranslation(clickerWindow_ready_width * WIDTH_RATIO - clickerWindow_now_start_width * WIDTH_RATIO, 0);
            
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 0;
        } completion:^(BOOL finished) {
            [shadowImg removeFromSuperview];
            shadowImg = nil;
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView removeFromSuperview];
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 1;
        }];
        
        [UIView animateWithDuration:0.08 animations:^{
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView.alpha = 1;
        } completion:nil];
    }else {
        [GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView.alpha = 0;
        [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView];
        //添加蒙层
        __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(clickerWindow_now_start_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_right_img"];
        [[GTClickerWindowManager shareInstance].clickerWinWindow addSubview:shadowImg];
        
        [UIView animateWithDuration:0.24 animations:^{
            
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x - clickerWindow_ready_width * WIDTH_RATIO + clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                       clickerWindow_ready_width * WIDTH_RATIO,
                                                                                       clickerWindow_ready_height * WIDTH_RATIO);
            
            shadowImg.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x - clickerWindow_ready_width * WIDTH_RATIO + clickerWindow_now_start_width * WIDTH_RATIO,
                                         [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                         clickerWindow_animation_mask_width * WIDTH_RATIO,
                                         clickerWindow_animation_mask_height * WIDTH_RATIO);
            
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 0;
        } completion:^(BOOL finished) {
            [shadowImg removeFromSuperview];
            shadowImg = nil;
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView removeFromSuperview];
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 1;
        }];
        
        [UIView animateWithDuration:0.08 animations:^{
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView.alpha = 1;
        } completion:nil];
    }
}

/**
 启动方式：预约，倒计时
 状态：now start -> future ready
 执行/暂停方案
 */
+ (void)clickerWindowNowStartToFutureReadyAnimationWithCompletion:(void (^)(void))completion {
    if ([GTClickerWindowManager shareInstance].clickerWinWindow.center.x < SCREEN_WIDTH/2) {
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView.alpha = 0;
        [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView];
        //添加蒙层
        __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(clickerWindow_now_start_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_right_img"];
        [[GTClickerWindowManager shareInstance].clickerWinWindow addSubview:shadowImg];
        
        [UIView animateWithDuration:0.24 animations:^{
            
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                       clickerWindow_ready_width * WIDTH_RATIO,
                                                                                       clickerWindow_ready_height * WIDTH_RATIO);
            
            shadowImg.frame = CGRectMake(clickerWindow_ready_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
            
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 0;
        } completion:^(BOOL finished) {
            [shadowImg removeFromSuperview];
            shadowImg = nil;
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView removeFromSuperview];
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 1;
        }];
        
        [UIView animateWithDuration:0.08 delay:0.16 options:UIViewAnimationOptionCurveLinear animations:^{
            [GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView.alpha = 1;
        } completion:nil];
    }else {
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView.alpha = 0;
        [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView];
        //添加蒙层
        __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(clickerWindow_now_start_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
        [[GTClickerWindowManager shareInstance].clickerWinWindow addSubview:shadowImg];
        
        [UIView animateWithDuration:0.24 animations:^{
            
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x - clickerWindow_ready_width * WIDTH_RATIO + clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                       clickerWindow_ready_width * WIDTH_RATIO,
                                                                                       clickerWindow_ready_height * WIDTH_RATIO);
            
            shadowImg.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x - clickerWindow_ready_width * WIDTH_RATIO + clickerWindow_now_start_width * WIDTH_RATIO,
                                         [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                         clickerWindow_animation_mask_width * WIDTH_RATIO,
                                         clickerWindow_animation_mask_height * WIDTH_RATIO);
            
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 0;
        } completion:^(BOOL finished) {
            [shadowImg removeFromSuperview];
            shadowImg = nil;
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView removeFromSuperview];
            [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 1;
        }];
        
        [UIView animateWithDuration:0.08 delay:0.16 options:UIViewAnimationOptionCurveLinear animations:^{
            [GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView.alpha = 1;
        } completion:nil];
    }
}

#pragma mark - ClickerWindowStateFutureStart

/**
 启动方式：倒计时、预约
 状态：future start -> future ready
 执行/暂停方案
 */
+ (void)clickerWindowFutureStartToFutureReadyAnimationWithCompletion:(void (^)(void))completion {
    [GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView.alpha = 0;
    [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView];
    
    //添加蒙层
    __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(clickerWindow_future_start_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
    shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
    [[GTClickerWindowManager shareInstance].clickerWinWindow addSubview:shadowImg];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x,
                                                                                   [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y, clickerWindow_ready_width * WIDTH_RATIO, clickerWindow_ready_height * WIDTH_RATIO);
        
        shadowImg.frame = CGRectMake(clickerWindow_ready_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 0;
    } completion:^(BOOL finished) {
        [shadowImg removeFromSuperview];
        shadowImg = nil;
        
        [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView removeFromSuperview];
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView = nil;
    }];
    
    [UIView animateWithDuration:0.12 delay:0.08 options:UIViewAnimationOptionCurveLinear animations:^{
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView.alpha = 1;
    } completion:nil];
}

/**
 启动方式：定时，倒计时
 状态：future start -> now start
 预约、倒计时结束，切换为now start状态
 */
+ (void)clickerWindowFutureStartToNowStartAnimationWithCompletion:(void (^)(void))completion {
    [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 0;
    [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView];
    
    //添加蒙层
    __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(clickerWindow_future_start_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
    shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
    [[GTClickerWindowManager shareInstance].clickerWinWindow addSubview:shadowImg];
    
    [UIView animateWithDuration:0.5 animations:^{
        
//        [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x,
//                                                                                   [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y, clickerWindow_now_start_width * WIDTH_RATIO, clickerWindow_now_start_height * WIDTH_RATIO);
        
        [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(-clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                   [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                   clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                   clickerWindow_future_dark_height * WIDTH_RATIO);
        
        shadowImg.frame = CGRectMake(clickerWindow_now_start_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        [GTClickerWindowManager shareInstance].clickerWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
        
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 0;
    } completion:^(BOOL finished) {
        [shadowImg removeFromSuperview];
        shadowImg = nil;
        
        [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView removeFromSuperview];
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 1;
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView = nil;
        
        [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(-clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                   [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                   clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                   clickerWindow_now_start_height * WIDTH_RATIO);
        
        [UIView animateWithDuration:0.24 animations:^{
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(0,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                       clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                       clickerWindow_now_start_height * WIDTH_RATIO);
        }];
    }];
    
    [UIView animateWithDuration:0.12 delay:0.08 options:UIViewAnimationOptionCurveLinear animations:^{
        [GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView.alpha = 1;
    } completion:nil];
}

/**
 启动方式：定时，倒计时
 状态：future start -> future dark
 1s内不操作，倒计时或预约启动切换为熄灭状态
 */
+ (void)clickerWindowFutureStartToFutureDarkAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTClickerWindowManager shareInstance].clickerWinWindow.center.x < SCREEN_WIDTH/2) {
        [UIView animateWithDuration:0.04 animations:^{
            [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 0.6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(- clickerWindow_future_start_width * WIDTH_RATIO,
                                                                                           [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                           clickerWindow_future_start_width * WIDTH_RATIO,
                                                                                           clickerWindow_future_start_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 1;
                
                [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(- clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                           [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y + (clickerWindow_future_start_height * WIDTH_RATIO - clickerWindow_future_dark_height * WIDTH_RATIO)/2,
                                                                                           clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                           clickerWindow_future_dark_height * WIDTH_RATIO);
                [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.frame = CGRectMake(0,
                                                                                                          0,
                                                                                                          clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                                          clickerWindow_future_dark_height * WIDTH_RATIO);
                [GTClickerWindowManager shareInstance].clickerWinWindow.layer.cornerRadius = 0;
                
                [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureDark;
                
                [UIView animateWithDuration:0.24 animations:^{
                    [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(0,
                                                                                               [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                               clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                               clickerWindow_future_dark_height * WIDTH_RATIO);
                }];
            }];
        }];
    }else {
        [UIView animateWithDuration:0.04 animations:^{
            [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 0.6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                           [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                           clickerWindow_future_start_width * WIDTH_RATIO,
                                                                                           clickerWindow_future_start_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 1;
                
                [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                           [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y + (clickerWindow_future_start_height * WIDTH_RATIO - clickerWindow_future_dark_height * WIDTH_RATIO)/2,
                                                                                           clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                           clickerWindow_future_dark_height * WIDTH_RATIO);
                [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.frame = CGRectMake(0,
                                                                                                          0,
                                                                                                          clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                                          clickerWindow_future_dark_height * WIDTH_RATIO);
                [GTClickerWindowManager shareInstance].clickerWinWindow.layer.cornerRadius = 0;
                
                [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureDark;
                
                [UIView animateWithDuration:0.24 animations:^{
                    [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(SCREEN_WIDTH - clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                               [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                               clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                               clickerWindow_future_dark_height * WIDTH_RATIO);
                }];
            }];
        }];
    }
}

#pragma mark - ClickerWindowStateFutureDark

/**
 启动方式：定时，倒计时
 状态：future dark -> future start
 熄灭状态被唤醒为倒计时、预约开启状态
 */
+ (void)clickerWindowFutureDarkToFutureStartAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTClickerWindowManager shareInstance].clickerWinWindow.center.x < SCREEN_WIDTH/2) {
        [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake([GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.x,
                                                                                   [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                   clickerWindow_future_start_width * WIDTH_RATIO,
                                                                                   clickerWindow_future_start_height * WIDTH_RATIO);
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.frame = CGRectMake(0,
                                                                                                  0,
                                                                                                  clickerWindow_future_start_width * WIDTH_RATIO,
                                                                                                  clickerWindow_future_start_height * WIDTH_RATIO);
        [GTClickerWindowManager shareInstance].clickerWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
        
        [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureStart;
    }else {
        [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(SCREEN_WIDTH - clickerWindow_future_start_width * WIDTH_RATIO,
                                                                                   [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                   clickerWindow_future_start_width * WIDTH_RATIO,
                                                                                   clickerWindow_future_start_height * WIDTH_RATIO);
        [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.frame = CGRectMake(0,
                                                                                                  0,
                                                                                                  clickerWindow_future_start_width * WIDTH_RATIO,
                                                                                                  clickerWindow_future_start_height * WIDTH_RATIO);
        [GTClickerWindowManager shareInstance].clickerWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
        
        [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureStart;
    }
}

/**
 启动方式：定时，倒计时
 状态：future dark -> future ready
 熄灭状态点击结束切换为倒计时、预约未开启状态
 */
+ (void)clickerWindowFutureDarkToFutureReadyAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTClickerWindowManager shareInstance].clickerWinWindow.center.x < SCREEN_WIDTH/2) {
        [UIView animateWithDuration:0.24 animations:^{
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(- clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                       clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                       clickerWindow_future_dark_height * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView removeFromSuperview];
            [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView = nil;
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView];
            
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(- clickerWindow_ready_width * WIDTH_RATIO,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y - (clickerWindow_ready_height * WIDTH_RATIO - clickerWindow_future_dark_height * WIDTH_RATIO)/2,
                                                                                       clickerWindow_ready_width * WIDTH_RATIO,
                                                                                       clickerWindow_ready_height * WIDTH_RATIO);
            [GTClickerWindowManager shareInstance].clickerWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureReady;
            
            [UIView animateWithDuration:0.24 animations:^{
                [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(10 * WIDTH_RATIO,
                                                                                           [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                           clickerWindow_ready_width * WIDTH_RATIO,
                                                                                           clickerWindow_ready_height * WIDTH_RATIO);
            }];
        }];
    }else {
        [UIView animateWithDuration:0.24 animations:^{
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                       clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                       clickerWindow_future_dark_height * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView removeFromSuperview];
            [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView = nil;
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView];
            
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y - (clickerWindow_ready_height * WIDTH_RATIO - clickerWindow_future_dark_height * WIDTH_RATIO)/2,
                                                                                       clickerWindow_ready_width * WIDTH_RATIO,
                                                                                       clickerWindow_ready_height * WIDTH_RATIO);
            [GTClickerWindowManager shareInstance].clickerWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureReady;
            
            [UIView animateWithDuration:0.24 animations:^{
                [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(SCREEN_WIDTH - clickerWindow_ready_width * WIDTH_RATIO - 10 * WIDTH_RATIO,
                                                                                           [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                           clickerWindow_ready_width * WIDTH_RATIO,
                                                                                           clickerWindow_ready_height * WIDTH_RATIO);
            }];
        }];
    }
}

/**
 启动方式：定时，倒计时
 状态：future dark -> now start
 熄灭状态倒计时结束切换为开启状态
 */
+ (void)clickerWindowFutureDarkToNowStartAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTClickerWindowManager shareInstance].clickerWinWindow.center.x < SCREEN_WIDTH/2) {
        [UIView animateWithDuration:0.2 animations:^{
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(-clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                       clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                       clickerWindow_future_dark_width * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(-clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y - (clickerWindow_now_start_height * WIDTH_RATIO - clickerWindow_future_dark_height * WIDTH_RATIO)/2,
                                                                                       clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                       clickerWindow_now_start_height * WIDTH_RATIO);
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView removeFromSuperview];
            [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 1;
            [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView = nil;
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView];
            [GTClickerWindowManager shareInstance].clickerWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateNowStart;
            
            [UIView animateWithDuration:0.16 animations:^{
                [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(10 * WIDTH_RATIO,
                                                                                           [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                           clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                           clickerWindow_now_start_height * WIDTH_RATIO);
            }];
        }];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                       clickerWindow_future_dark_width * WIDTH_RATIO,
                                                                                       clickerWindow_future_dark_width * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y - (clickerWindow_now_start_height * WIDTH_RATIO - clickerWindow_future_dark_height * WIDTH_RATIO)/2,
                                                                                       clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                       clickerWindow_now_start_height * WIDTH_RATIO);
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView removeFromSuperview];
            [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.alpha = 1;
            [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView = nil;
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.nowStartView];
            [GTClickerWindowManager shareInstance].clickerWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateNowStart;
            
            [UIView animateWithDuration:0.16 animations:^{
                [GTClickerWindowManager shareInstance].clickerWinWindow.frame = CGRectMake(SCREEN_WIDTH - clickerWindow_now_start_width * WIDTH_RATIO - 10 * WIDTH_RATIO,
                                                                                           [GTClickerWindowManager shareInstance].clickerWinWindow.frame.origin.y,
                                                                                           clickerWindow_now_start_width * WIDTH_RATIO,
                                                                                           clickerWindow_now_start_height * WIDTH_RATIO);
            }];
        }];
    }
}

/**
 连点器悬浮窗点击增加触点动画（第一次,包含文字气泡）
 */
+ (void)clickerFirstAddPointWindow:(GTClickerPointWindow *)pointWindow  animationWithCompletion:(void (^ __nullable)(void))completion {
    //触点放大
    [UIView animateWithDuration:0.32 animations:^{
        pointWindow.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:^(BOOL finished) {
        //触点缩小
        [UIView animateWithDuration:0.28 animations:^{
            pointWindow.transform = CGAffineTransformMakeScale(1, 1);
        }completion:^(BOOL finished) {
            completion();
        }];
    }];
}

/**
 连点器悬浮窗点击增加触点动画（非第一次）
 */
+ (void)clickerNormalAddPointWindow:(GTClickerPointWindow *)pointWindow animationWithCompletion:(void (^ __nullable)(void))completion {
    //触点放大
    [UIView animateWithDuration:0.32 animations:^{
        pointWindow.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:^(BOOL finished) {
        //触点缩小
        [UIView animateWithDuration:0.28 animations:^{
            pointWindow.transform = CGAffineTransformMakeScale(1, 1);
        }];
        completion();
    }];
}


@end
