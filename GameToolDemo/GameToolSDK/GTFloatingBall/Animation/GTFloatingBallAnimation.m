//
//  GTFloatingBallAnimation.m
//  GTSDK
//
//  Created by shangmi on 2023/9/14.
//

#import "GTFloatingBallAnimation.h"
#import "GTFloatingBallManager.h"
#import "GTFloatingWindowManager.h"

@implementation GTFloatingBallAnimation

/// 长按悬浮球动画
+ (void)longPressFloatingBallAnimation {
    [UIView animateWithDuration:0.24 animations:^{
        [GTFloatingBallManager shareInstance].ballWindow.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [GTFloatingBallManager shareInstance].ballVC.floatingBallView.shadowView.alpha = 0.6;
    } completion:^(BOOL finished) {
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [UIView animateWithDuration:0.16 animations:^{
            [GTFloatingBallManager shareInstance].ballWindow.transform = CGAffineTransformMakeScale(1.1, 1.1);
            [GTFloatingBallManager shareInstance].ballVC.floatingBallView.shadowView.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                [GTFloatingBallManager shareInstance].ballWindow.transform = CGAffineTransformMakeScale(0.9, 0.9);
                [GTFloatingBallManager shareInstance].ballWindow.alpha = 0;
            } completion:^(BOOL finished) {
                //因为是长按，所以state是极简，所以复原成0.73（待定）
                [GTFloatingBallManager shareInstance].ballWindow.transform = CGAffineTransformMakeScale(0.73, 0.73);
                [[GTFloatingBallManager shareInstance] floatingBallHide];
                [GTFloatingBallManager shareInstance].ballWindow.alpha = 1;
                [[GTFloatingWindowManager shareInstance] floatingWindowShow];
                [GTFloatingWindowManager shareInstance].windowWindow.alpha = 0;
                [GTFloatingWindowManager shareInstance].windowWindow.transform = CGAffineTransformMakeTranslation(0, 15);
                [UIView animateWithDuration:0.32 animations:^{
                    [GTFloatingWindowManager shareInstance].windowWindow.alpha = 1;
                    [GTFloatingWindowManager shareInstance].windowWindow.transform = CGAffineTransformMakeTranslation(0, 0);
                }];
                
            }];
        }];
    }];
}

@end
