//
//  GTRecordWindowAnimatiion.m
//  GTSDK
//
//  Created by shangmi on 2023/10/17.
//

#import "GTRecordWindowAnimatiion.h"

@implementation GTRecordWindowAnimatiion

#pragma mark - RecordWindowStateRecordTime

/**
 状态：RecordWindowStateRecordTime -> RecordWindowStateRecordTimeDark
 动作：录制中 -> 录制中熄灭
 */
+ (void)recordWindowRecordTimeToRecordTimeDarkAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
        [UIView animateWithDuration:0.04 animations:^{
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.alpha = 0.6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_record_time_width * WIDTH_RATIO,
                                                                                         [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_record_time_width * WIDTH_RATIO,
                                                                                         recordWindow_record_time_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.alpha = 1;
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                         [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y + (recordWindow_record_time_height - recordWindow_record_time_dark_height)/2 * WIDTH_RATIO,
                                                                                           recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                         recordWindow_record_time_dark_height * WIDTH_RATIO);
                [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.frame = CGRectMake(0,
                                                                                                       0,
                                                                                                       recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                                       recordWindow_record_time_dark_height * WIDTH_RATIO);
                [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 0;
                
                [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateRecordTimeDark;
                
                [UIView animateWithDuration:0.24 animations:^{
                    
                    [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(0,
                                                                                             [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                             recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                             recordWindow_record_time_dark_height * WIDTH_RATIO);
                } completion:^(BOOL finished) {
                    completion();
                }];
            }];
        }];
    }else {
        [UIView animateWithDuration:0.04 animations:^{
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.alpha = 0.6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                         [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_record_time_width * WIDTH_RATIO,
                                                                                         recordWindow_record_time_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.alpha = 1;
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                         [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y + (recordWindow_record_time_height - recordWindow_record_time_dark_height)/2 * WIDTH_RATIO,
                                                                                           recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                         recordWindow_record_time_dark_height * WIDTH_RATIO);
                [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.frame = CGRectMake(0,
                                                                                                       0,
                                                                                                       recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                                       recordWindow_record_time_dark_height * WIDTH_RATIO);
                [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 0;
                
                [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateRecordTimeDark;
                
                [UIView animateWithDuration:0.24 animations:^{
                    
                    [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH - recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                             [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                             recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                             recordWindow_record_time_dark_height * WIDTH_RATIO);
                } completion:^(BOOL finished) {
                    completion();
                }];
            }];
        }];
    }
}

/**
 状态：RecordWindowStateRecordTime -> RecordWindowStateStartRecord
 动作：录制中 -> 开始录制
 */
+ (void)recordWindowRecordTimeToStartRecordAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
        [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.alpha = 0;
        [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.beginRecordView];
        //添加蒙层
        __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(recordWindow_record_time_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
        [[GTRecordWindowManager shareInstance].recordWinWindow addSubview:shadowImg];
        
        [UIView animateWithDuration:0.24 animations:^{
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x,
                                                                                     [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_begin_width * WIDTH_RATIO,
                                                                                     recordWindow_begin_width * WIDTH_RATIO);
            
            shadowImg.frame = CGRectMake(recordWindow_begin_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
            
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.alpha = 0;
        } completion:^(BOOL finished) {
            [shadowImg removeFromSuperview];
            shadowImg = nil;
            
            [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView removeFromSuperview];
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView = nil;
            
            completion();
        }];
        
        [UIView animateWithDuration:0.08 delay:0.16 options:UIViewAnimationOptionCurveLinear animations:^{
            [GTRecordWindowManager shareInstance].recordWindowVC.beginRecordView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else {
        [GTRecordWindowManager shareInstance].recordWindowVC.beginRecordView.alpha = 0;
        [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.beginRecordView];
        //添加蒙层
        __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_right_img"];
        [[GTRecordWindowManager shareInstance].recordWinWindow addSubview:shadowImg];
        
        [UIView animateWithDuration:0.24 animations:^{
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x + recordWindow_record_time_width * WIDTH_RATIO - recordWindow_begin_width * WIDTH_RATIO,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_begin_width * WIDTH_RATIO,
                                                                                     recordWindow_begin_width * WIDTH_RATIO);
            
            shadowImg.frame = CGRectMake(0,
                                         0,
                                         clickerWindow_animation_mask_width * WIDTH_RATIO,
                                         clickerWindow_animation_mask_height * WIDTH_RATIO);
            
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.alpha = 0;
        } completion:^(BOOL finished) {
            [shadowImg removeFromSuperview];
            shadowImg = nil;
            
            [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView removeFromSuperview];
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.alpha = 1;
            
            completion();
        }];
        
        [UIView animateWithDuration:0.08 delay:0.16 options:UIViewAnimationOptionCurveLinear animations:^{
            [GTRecordWindowManager shareInstance].recordWindowVC.beginRecordView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 状态：RecordWindowStateRecordTime -> RecordWindowStateNowInfinite
 动作：录制中 -> 立即回放无限循环
 */
+ (void)recordWindowRecordTimeToNowInfiniteAnimationWithCompletion:(void (^ __nullable)(void))completion {
    [GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.alpha = 0;
    [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView updateData:[GTRecordWindowManager shareInstance].schemeModel];
    [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView];
    
    //添加蒙层
    __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(recordWindow_record_time_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
    shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
    [[GTRecordWindowManager shareInstance].recordWinWindow addSubview:shadowImg];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x,
                                                                                   [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                 recordWindow_infinite_width * WIDTH_RATIO,
                                                                                 recordWindow_infinite_height * WIDTH_RATIO);

        shadowImg.frame = CGRectMake(recordWindow_infinite_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        
    } completion:^(BOOL finished) {
        [shadowImg removeFromSuperview];
        shadowImg = nil;
        
        [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView removeFromSuperview];
        [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.alpha = 1;
        
        completion();
    }];
    
    [UIView animateWithDuration:0.12 delay:0.08 options:UIViewAnimationOptionCurveLinear animations:^{
        [GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - RecordWindowStateRecordTimeDark

/**
 状态：RecordWindowStateRecordTimeDark -> RecordWindowStateRecordTime
 动作：录制中熄灭 -> 录制中
 */

+ (void)recordWindowRecordTimeDarkToRecordTimeAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
        [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x,
                                                                                   [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                   recordWindow_record_time_width * WIDTH_RATIO,
                                                                                 recordWindow_record_time_height * WIDTH_RATIO);
        [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.frame = CGRectMake(0,
                                                                                                  0,
                                                                                               recordWindow_record_time_width * WIDTH_RATIO,
                                                                                               recordWindow_record_time_height * WIDTH_RATIO);
        [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
        
        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateRecordTime;
    }else {
        [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH - recordWindow_record_time_width * WIDTH_RATIO,
                                                                                   [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                   recordWindow_record_time_width * WIDTH_RATIO,
                                                                                 recordWindow_record_time_height * WIDTH_RATIO);
        [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView.frame = CGRectMake(0,
                                                                                                  0,
                                                                                               recordWindow_record_time_width * WIDTH_RATIO,
                                                                                               recordWindow_record_time_height * WIDTH_RATIO);
        [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
        
        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateRecordTime;
    }
}

/**
 状态：RecordWindowStateRecordTimeDark -> RecordWindowStateStartRecord
 动作：录制中熄灭 -> 开始录制
 */

+ (void)recordWindowRecordTimeDarkToStartRecordAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
        [UIView animateWithDuration:0.24 animations:^{
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                     recordWindow_record_time_dark_height * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView removeFromSuperview];
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView = nil;

            [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.beginRecordView];
            
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_begin_width * WIDTH_RATIO,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y - (recordWindow_begin_width * WIDTH_RATIO - recordWindow_record_time_dark_height * WIDTH_RATIO)/2,
                                                                                     recordWindow_begin_width * WIDTH_RATIO,
                                                                                     recordWindow_begin_width * WIDTH_RATIO);
            [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateStartRecord;
            
            [UIView animateWithDuration:0.24 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(0 * WIDTH_RATIO,
                                                                                           [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_begin_width * WIDTH_RATIO,
                                                                                         recordWindow_begin_width * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }else {
        [UIView animateWithDuration:0.24 animations:^{
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                     recordWindow_record_time_dark_height * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView removeFromSuperview];
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView = nil;

            [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.beginRecordView];
            
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y - (recordWindow_begin_width * WIDTH_RATIO - recordWindow_record_time_dark_height * WIDTH_RATIO)/2,
                                                                                     recordWindow_begin_width * WIDTH_RATIO,
                                                                                     recordWindow_begin_width * WIDTH_RATIO);
            [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateStartRecord;
            
            [UIView animateWithDuration:0.24 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH - recordWindow_begin_width * WIDTH_RATIO,
                                                                                           [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_begin_width * WIDTH_RATIO,
                                                                                         recordWindow_begin_width * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }
}

/**
 状态：RecordWindowStateRecordTimeDark ->
 动作：录制中熄灭 -> 立即回放无限循环
 */

+ (void)recordWindowRecordTimeDarkToNowInfiniteAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
        [UIView animateWithDuration:0.24 animations:^{
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                     recordWindow_record_time_dark_height * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView removeFromSuperview];
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView = nil;
            
            [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView updateData:[GTRecordWindowManager shareInstance].schemeModel];
            [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView];
            
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_infinite_width * WIDTH_RATIO,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y - (recordWindow_infinite_height * WIDTH_RATIO - recordWindow_record_time_dark_height * WIDTH_RATIO)/2,
                                                                                     recordWindow_infinite_width * WIDTH_RATIO,
                                                                                     recordWindow_infinite_height * WIDTH_RATIO);
            [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateNowInfinite;
            
            [UIView animateWithDuration:0.24 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(0 * WIDTH_RATIO,
                                                                                           [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_infinite_width * WIDTH_RATIO,
                                                                                         recordWindow_infinite_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }else {
        [UIView animateWithDuration:0.24 animations:^{
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                     recordWindow_record_time_dark_height * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView removeFromSuperview];
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView = nil;
            
            [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView updateData:[GTRecordWindowManager shareInstance].schemeModel];
            [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView];
            
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y - (recordWindow_infinite_height * WIDTH_RATIO - recordWindow_record_time_dark_height * WIDTH_RATIO)/2,
                                                                                     recordWindow_infinite_width * WIDTH_RATIO,
                                                                                     recordWindow_infinite_height * WIDTH_RATIO);
            [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateNowInfinite;
            
            [UIView animateWithDuration:0.24 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH - recordWindow_infinite_width * WIDTH_RATIO,
                                                                                           [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_infinite_width * WIDTH_RATIO,
                                                                                         recordWindow_infinite_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }
}

#pragma mark - RecordWindowStateFutureFinite

/**
 状态：RecordWindowStateFutureFinite -> RecordWindowStateFutureCountdown
 动作：预约回放有限循环 -> 预约回放倒计时
 */

+ (void)recordWindowFutureFiniteToFutureCountdownAnimationWithCompletion:(void (^ __nullable)(void))completion {
    [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.alpha = 0;
    [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView];
    
    //添加蒙层
    __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(recordWindow_finite_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
    shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
    [[GTRecordWindowManager shareInstance].recordWinWindow addSubview:shadowImg];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x,
                                                                                   [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                 recordWindow_record_time_width * WIDTH_RATIO,
                                                                                 recordWindow_record_time_height * WIDTH_RATIO);
        
        shadowImg.frame = CGRectMake(recordWindow_record_time_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        
        [GTRecordWindowManager shareInstance].recordWindowVC.finiteView.alpha = 0;
    } completion:^(BOOL finished) {
        [shadowImg removeFromSuperview];
        shadowImg = nil;
        
        [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView removeFromSuperview];
        [GTRecordWindowManager shareInstance].recordWindowVC.finiteView = nil;
        
        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureCountdown;
        
        completion();
    }];
    
    [UIView animateWithDuration:0.12 delay:0.08 options:UIViewAnimationOptionCurveLinear animations:^{
        [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.alpha = 1;
    } completion:nil];
}

#pragma mark - RecordWindowStateFutureInfinite

/**
 状态：RecordWindowStateFutureInfinite -> RecordWindowStateFutureCountdown
 动作：预约回放无限循环 -> 预约回放倒计时
 */

+ (void)recordWindowFutureInfiniteToFutureCountdownAnimationWithCompletion:(void (^ __nullable)(void))completion {
    [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.alpha = 0;
    [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView];
    
    //添加蒙层
    __block UIImageView *shadowImg = [[UIImageView alloc] initWithFrame:CGRectMake(recordWindow_infinite_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO)];
    shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
    [[GTRecordWindowManager shareInstance].recordWinWindow addSubview:shadowImg];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x,
                                                                                   [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                 recordWindow_record_time_width * WIDTH_RATIO,
                                                                                 recordWindow_record_time_height * WIDTH_RATIO);
        
        shadowImg.frame = CGRectMake(recordWindow_record_time_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        
        [GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.alpha = 0;
    } completion:^(BOOL finished) {
        [shadowImg removeFromSuperview];
        shadowImg = nil;
        
        [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView removeFromSuperview];
        [GTRecordWindowManager shareInstance].recordWindowVC.infiniteView = nil;
        
        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureCountdown;
        
        completion();
    }];
    
    [UIView animateWithDuration:0.12 delay:0.08 options:UIViewAnimationOptionCurveLinear animations:^{
        [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.alpha = 1;
    } completion:nil];
}

#pragma mark - RecordWindowStateFutureCountdown

/**
 状态：RecordWindowStateFutureCountdown -> RecordWindowStateFutureFinite
 动作：预约回放倒计时 -> 预约回放有限循环
 */

+ (void)recordWindowFutureCountdownToFutureFiniteAnimationWithCompletion:(void (^ __nullable)(void))completion {
    [GTRecordWindowManager shareInstance].recordWindowVC.finiteView.alpha = 0;
    [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.finiteView];
    
    //添加蒙层
    __block UIImageView *shadowImg = [[UIImageView alloc] init];
    
    if (([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x + recordWindow_finite_width * WIDTH_RATIO) > SCREEN_WIDTH) {  //超出边界
        shadowImg.frame = CGRectMake(0, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_right_img"];
    }else {
        shadowImg.frame = CGRectMake(recordWindow_record_time_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
    }
    
    
    [[GTRecordWindowManager shareInstance].recordWinWindow addSubview:shadowImg];
    
    [UIView animateWithDuration:0.2 animations:^{
        
//        [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x,
//                                                                                   [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
//                                                                                 recordWindow_finite_width * WIDTH_RATIO,
//                                                                                 recordWindow_finite_height * WIDTH_RATIO);
//
//        shadowImg.frame = CGRectMake(recordWindow_finite_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        
        
        if (([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x + recordWindow_finite_width * WIDTH_RATIO) > SCREEN_WIDTH) {  //超出边界
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(
                                                                                     [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x-(recordWindow_finite_width * WIDTH_RATIO-recordWindow_record_time_width * WIDTH_RATIO),
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_finite_width * WIDTH_RATIO,
                                                                                     recordWindow_finite_height * WIDTH_RATIO);

            shadowImg.frame = CGRectMake(0, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
            
        }else { //没超出边界
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_finite_width * WIDTH_RATIO,
                                                                                     recordWindow_finite_height * WIDTH_RATIO);

            shadowImg.frame = CGRectMake(recordWindow_finite_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        }
        
    } completion:^(BOOL finished) {
        [shadowImg removeFromSuperview];
        shadowImg = nil;
        
        [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView removeFromSuperview];
        [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView = nil;
        
        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureFinite;
        
        completion();
    }];
    
    [UIView animateWithDuration:0.12 delay:0.08 options:UIViewAnimationOptionCurveLinear animations:^{
        [GTRecordWindowManager shareInstance].recordWindowVC.finiteView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 状态：RecordWindowStateFutureCountdown -> RecordWindowStateFutureInfinite
 动作：预约回放倒计时 -> 预约回放无限循环
 */

+ (void)recordWindowFutureCountdownToFutureInfiniteAnimationWithCompletion:(void (^ __nullable)(void))completion {
    [GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.alpha = 0;
    [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView];
    
    //添加蒙层
    __block UIImageView *shadowImg = [[UIImageView alloc] init];
    
    if (([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x + recordWindow_infinite_width * WIDTH_RATIO) > SCREEN_WIDTH) {  //超出边界
        shadowImg.frame = CGRectMake(0, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_right_img"];
    }else {
        shadowImg.frame = CGRectMake(recordWindow_record_time_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);shadowImg.image = [[GTThemeManager share] imageWithName:@"clicker_mask_left_img"];
    }
    
    [[GTRecordWindowManager shareInstance].recordWinWindow addSubview:shadowImg];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x + recordWindow_infinite_width * WIDTH_RATIO) > SCREEN_WIDTH) {  //超出边界
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(
                                                                                     [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x-(recordWindow_infinite_width * WIDTH_RATIO-recordWindow_record_time_width * WIDTH_RATIO),
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_infinite_width * WIDTH_RATIO,
                                                                                     recordWindow_infinite_height * WIDTH_RATIO);

            shadowImg.frame = CGRectMake(0, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
            
        }else { //没超出边界
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_infinite_width * WIDTH_RATIO,
                                                                                     recordWindow_infinite_height * WIDTH_RATIO);

            shadowImg.frame = CGRectMake(recordWindow_infinite_width * WIDTH_RATIO - clickerWindow_animation_mask_width * WIDTH_RATIO, 0, clickerWindow_animation_mask_width * WIDTH_RATIO, clickerWindow_animation_mask_height * WIDTH_RATIO);
        }
        
        
        
    } completion:^(BOOL finished) {
        [shadowImg removeFromSuperview];
        shadowImg = nil;
        
        [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView removeFromSuperview];
        [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView = nil;
        
        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureInfinite;
        
        completion();
    }];
    
    [UIView animateWithDuration:0.12 delay:0.08 options:UIViewAnimationOptionCurveLinear animations:^{
        [GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 状态：RecordWindowStateFutureCountdown -> RecordWindowStateFutureCountdownDark
 动作：预约回放倒计时 -> 预约回放倒计时熄灭状态
 */

+ (void)recordWindowFutureCountdownToFutureCountdownDarkAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
        [UIView animateWithDuration:0.04 animations:^{
            [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.alpha = 0.6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_record_time_width *
                                                                                         WIDTH_RATIO,
                                                                                         [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_record_time_width * WIDTH_RATIO,
                                                                                         recordWindow_record_time_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.alpha = 1;
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                         [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y + (recordWindow_record_time_height - recordWindow_record_time_dark_height)/2 * WIDTH_RATIO,
                                                                                           recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                           recordWindow_record_time_dark_height * WIDTH_RATIO);
                [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.frame = CGRectMake(0,
                                                                                                       0,
                                                                                                       recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                                       recordWindow_record_time_dark_height * WIDTH_RATIO);
                [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 0;
                
                [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureCountdownDark;
                
                [UIView animateWithDuration:0.24 animations:^{
                    [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(0,
                                                                                             [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                             recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                             recordWindow_record_time_dark_height * WIDTH_RATIO);
                }];
            }];
        }];
    }else {
        [UIView animateWithDuration:0.04 animations:^{
            [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.alpha = 0.6;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                         [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_record_time_width * WIDTH_RATIO,
                                                                                         recordWindow_record_time_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.alpha = 1;
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                         [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y + (recordWindow_record_time_height - recordWindow_record_time_dark_height)/2 * WIDTH_RATIO,
                                                                                           recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                           recordWindow_record_time_dark_height * WIDTH_RATIO);
                [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.frame = CGRectMake(0,
                                                                                                       0,
                                                                                                       recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                                       recordWindow_record_time_dark_height * WIDTH_RATIO);
                [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 0;
                
                [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureCountdownDark;
                
                [UIView animateWithDuration:0.24 animations:^{
                    [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH - recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                             [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                             recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                             recordWindow_record_time_dark_height * WIDTH_RATIO);
                }];
            }];
        }];
    }
}

#pragma mark - RecordWindowStateFutureCountdownDark

/**
 状态：RecordWindowStateFutureCountdownDark -> RecordWindowStateFutureCountdown
 动作：预约回放倒计时熄灭状态 -> 预约回放倒计时
 */

+ (void)recordWindowFutureCountdownDarkToFutureCountdownAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
        [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake([GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.x,
                                                                                   [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                   recordWindow_record_time_width * WIDTH_RATIO,
                                                                                 recordWindow_record_time_height * WIDTH_RATIO);
        [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.frame = CGRectMake(0,
                                                                                               0,
                                                                                               recordWindow_record_time_width * WIDTH_RATIO,
                                                                                               recordWindow_record_time_height * WIDTH_RATIO);
        [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
        
        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureCountdown;
    }else {
        [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH - recordWindow_record_time_width * WIDTH_RATIO,
                                                                                   [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                   recordWindow_record_time_width * WIDTH_RATIO,
                                                                                 recordWindow_record_time_height * WIDTH_RATIO);
        [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.frame = CGRectMake(0,
                                                                                               0,
                                                                                               recordWindow_record_time_width * WIDTH_RATIO,
                                                                                               recordWindow_record_time_height * WIDTH_RATIO);
        [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
        
        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureCountdown;
    }
}

/**
 状态：RecordWindowStateFutureCountdownDark -> RecordWindowStateFutureFinite
 动作：预约回放倒计时熄灭状态 -> 预约回放有限循环
 */

+ (void)recordWindowFutureCountdownDarkToFutureFiniteAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
        [UIView animateWithDuration:0.24 animations:^{
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                     recordWindow_record_time_dark_height * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView removeFromSuperview];
            [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView = nil;
            
            [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.finiteView];
            
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_finite_width * WIDTH_RATIO,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y - (recordWindow_finite_height * WIDTH_RATIO - recordWindow_record_time_dark_height * WIDTH_RATIO)/2,
                                                                                     recordWindow_finite_width * WIDTH_RATIO,
                                                                                     recordWindow_finite_height * WIDTH_RATIO);
            [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureFinite;
            
            [UIView animateWithDuration:0.24 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(0 * WIDTH_RATIO,
                                                                                           [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_finite_width * WIDTH_RATIO,
                                                                                         recordWindow_finite_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }else {
        [UIView animateWithDuration:0.24 animations:^{
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                     recordWindow_record_time_dark_height * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView removeFromSuperview];
            [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView = nil;
            
            [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.finiteView];
            
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y - (recordWindow_finite_height * WIDTH_RATIO - recordWindow_record_time_dark_height * WIDTH_RATIO)/2,
                                                                                     recordWindow_finite_width * WIDTH_RATIO,
                                                                                     recordWindow_finite_height * WIDTH_RATIO);
            [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureFinite;
            
            [UIView animateWithDuration:0.24 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH - recordWindow_finite_width * WIDTH_RATIO,
                                                                                           [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_finite_width * WIDTH_RATIO,
                                                                                         recordWindow_finite_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }
}

/**
 状态：RecordWindowStateFutureCountdownDark -> RecordWindowStateFutureInfinite
 动作：预约回放倒计时熄灭状态 -> 预约回放无限循环
 */

+ (void)recordWindowFutureCountdownDarkToFutureInfiniteAnimationWithCompletion:(void (^ __nullable)(void))completion {
    if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
        [UIView animateWithDuration:0.24 animations:^{
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                     recordWindow_record_time_dark_height * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView removeFromSuperview];
            [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView = nil;
            
            [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView];
            
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(- recordWindow_infinite_width * WIDTH_RATIO,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y - (recordWindow_infinite_height * WIDTH_RATIO - recordWindow_record_time_dark_height * WIDTH_RATIO)/2,
                                                                                     recordWindow_infinite_width * WIDTH_RATIO,
                                                                                     recordWindow_infinite_height * WIDTH_RATIO);
            [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureInfinite;
            
            [UIView animateWithDuration:0.24 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(0 * WIDTH_RATIO,
                                                                                           [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_infinite_width * WIDTH_RATIO,
                                                                                         recordWindow_infinite_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }else {
        [UIView animateWithDuration:0.24 animations:^{
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                     recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                                                     recordWindow_record_time_dark_height * WIDTH_RATIO);
        } completion:^(BOOL finished) {
            [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView removeFromSuperview];
            [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView = nil;
            
            [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView];
            
            [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH,
                                                                                       [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y - (recordWindow_infinite_height * WIDTH_RATIO - recordWindow_record_time_dark_height * WIDTH_RATIO)/2,
                                                                                     recordWindow_infinite_width * WIDTH_RATIO,
                                                                                     recordWindow_infinite_height * WIDTH_RATIO);
            [GTRecordWindowManager shareInstance].recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
            
            [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureInfinite;
            
            [UIView animateWithDuration:0.24 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.frame = CGRectMake(SCREEN_WIDTH - recordWindow_infinite_width * WIDTH_RATIO,
                                                                                           [GTRecordWindowManager shareInstance].recordWinWindow.frame.origin.y,
                                                                                         recordWindow_infinite_width * WIDTH_RATIO,
                                                                                         recordWindow_infinite_height * WIDTH_RATIO);
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    }
}

@end
