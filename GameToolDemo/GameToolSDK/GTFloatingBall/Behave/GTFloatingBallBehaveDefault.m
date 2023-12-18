//
//  GTFloatingBallBehaveDefault.m
//  GTSDK
//
//  Created by shangmi on 2023/9/14.
//

#import "GTFloatingBallBehaveDefault.h"

@implementation GTFloatingBallBehaveDefault

/// 判断悬浮球能否移动到此处,返回纠正后坐标
/// - Parameter centerPoint: 悬浮球中心坐标
- (CGPoint)floatingBallMoveArea:(CGPoint)movePoint {
    if ([GTSDKUtils isPortrait]) { //设置为竖屏
        CGFloat top;
        CGFloat bottom;
        
        top = SAFE_AREA_TOP + floatingBall_height/2;
        bottom = SCREEN_HEIGHT - SAFE_AREA_BOTTOM - floatingBall_height/2;
        
        CGFloat newY = MAX(top, MIN(bottom, movePoint.y));
        
        return CGPointMake(movePoint.x, newY);
    }else { //设置为横屏
        UIInterfaceOrientation interfaceOritation = [[UIApplication sharedApplication] statusBarOrientation];
        //判断是横屏是left还是right
        switch (interfaceOritation) {
            case UIInterfaceOrientationLandscapeLeft: { //左横屏（home键在左边）
                CGFloat top;
                CGFloat right;
                CGFloat bottom;
                
                top = SAFE_AREA_RIGHT + floatingBall_height/2;
                
                if (movePoint.y+floatingBall_height/2  > (SCREEN_HEIGHT-safe_area_width)/2 && movePoint.y-floatingBall_height/2 < (SCREEN_HEIGHT+safe_area_width)/2 ) {
                    right = SCREEN_WIDTH - SAFE_AREA_RIGHT - floatingBall_width/2;
                }else {
                    right = SCREEN_WIDTH - floatingBall_width/2;
                }
                bottom = SCREEN_HEIGHT - SAFE_AREA_BOTTOM - floatingBall_height/2;
                
                CGFloat newX = MIN(right, movePoint.x);
                CGFloat newY = MAX(top, MIN(bottom, movePoint.y));
                
                return CGPointMake(newX, newY);
            }
                break;
            case UIInterfaceOrientationLandscapeRight: { //右横屏（home键在右边）
                CGFloat top;
                CGFloat left;
                CGFloat bottom;
                
                top = SAFE_AREA_LEFT + floatingBall_height/2;
                
                if (movePoint.y+floatingBall_height/2  > (SCREEN_HEIGHT-safe_area_width)/2 && movePoint.y-floatingBall_height/2 < (SCREEN_HEIGHT+safe_area_width)/2 ) {
                    left = SAFE_AREA_LEFT + floatingBall_width/2;
                }else {
                    left = floatingBall_width/2;
                }
                
                bottom = SCREEN_HEIGHT - SAFE_AREA_BOTTOM - floatingBall_height/2;
                
                CGFloat newX = MAX(left, movePoint.x);
                CGFloat newY = MAX(top, MIN(bottom, movePoint.y));
                
                return CGPointMake(newX, newY);
            }
                break;
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
            default:
                return movePoint;
                break;
        }
    }
}

//自动靠边
- (void)floatingBallWeltWithSpeed:(double)speed completion:(void (^ __nullable)(void))completion{
    CGPoint newPoint = [GTFloatingBallManager shareInstance].ballWindow.center;

    if ([GTSDKUtils isPortrait]) {
        //竖屏
        if (newPoint.x < SCREEN_WIDTH/2) {
            newPoint.x = floatingBall_width/2 + 10; //距边10px
        }else {
            newPoint.x = SCREEN_WIDTH - floatingBall_width/2 - 10;

        }
    }else {        //横屏
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (orientation) {
            case UIInterfaceOrientationLandscapeLeft: {
                if (newPoint.x < (SCREEN_WIDTH - SAFE_AREA_RIGHT)/2) {
                    newPoint.x = floatingBall_width/2 + 10; //距边10px
                }else {
                    if (newPoint.y+floatingBall_height/2  > (SCREEN_HEIGHT-safe_area_width)/2 && newPoint.y-floatingBall_height/2 < (SCREEN_HEIGHT+safe_area_width)/2 ) {
                        newPoint.x = SCREEN_WIDTH - SAFE_AREA_RIGHT - floatingBall_width/2 - floatingBall_distance;
                    }else {
                        newPoint.x = SCREEN_WIDTH - floatingBall_width/2 - floatingBall_distance; //距边10px
                    }
                }
            }
                break;
            case UIInterfaceOrientationLandscapeRight: {
                if (newPoint.x < SAFE_AREA_LEFT + (SCREEN_WIDTH - SAFE_AREA_LEFT)/2) {
                    if (newPoint.y+floatingBall_height/2  > (SCREEN_HEIGHT-safe_area_width)/2 && newPoint.y-floatingBall_height/2 < (SCREEN_HEIGHT+safe_area_width)/2 ) {
                        newPoint.x = SAFE_AREA_LEFT + floatingBall_width/2 + floatingBall_distance; //距边10px
                    }else {
                        newPoint.x = floatingBall_width/2 + floatingBall_distance; //距边10px
                    }
                }else {
                    newPoint.x = SCREEN_WIDTH - floatingBall_width/2 - floatingBall_distance;
                }
            }
                break;

            default:
                break;
        }
    }

    double duration = [GTFloatingBallConfig floatingBallWithView:[GTFloatingBallManager shareInstance].ballWindow spendTimeAsSpeed:speed];
    //侧边吸附动画
    [UIView animateWithDuration:duration animations:^{
        [GTFloatingBallManager shareInstance].ballWindow.center = newPoint;
    } completion:^(BOOL finished) {
        completion();
    }];
}

//贴边隐藏一半
- (void)floatingBallHideHalfWithCompletion:(void (^)(void))completion {
    CGPoint centerPoint = [GTFloatingBallManager shareInstance].ballWindow.center;
    
    if ([GTSDKUtils isPortrait]) {  //竖屏
        if (centerPoint.x < SCREEN_WIDTH/2) {
            centerPoint = CGPointMake(0, centerPoint.y);
        } else {
            centerPoint = CGPointMake(SCREEN_WIDTH, centerPoint.y);
        }
    } else{
        UIInterfaceOrientation interfaceOritation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOritation) {
            case UIInterfaceOrientationLandscapeLeft: {
                if (centerPoint.x < (SCREEN_WIDTH-SAFE_AREA_RIGHT)/2) {
                    centerPoint = CGPointMake(0, centerPoint.y);
                } else {
                    //存在刘海，需要判断位置
                    if (centerPoint.y+floatingBall_height/2  > (SCREEN_HEIGHT-safe_area_width)/2 && centerPoint.y-floatingBall_height/2 < (SCREEN_HEIGHT+safe_area_width)/2 ) {
                        centerPoint = CGPointMake(SCREEN_WIDTH-SAFE_AREA_RIGHT, centerPoint.y);
                    }else {
                        centerPoint = CGPointMake(SCREEN_WIDTH, centerPoint.y);
                    }
                }
            }
                break;
            case UIInterfaceOrientationLandscapeRight: {
                if (centerPoint.x < (SCREEN_WIDTH-SAFE_AREA_LEFT)/2+SAFE_AREA_LEFT) {
                    //存在刘海，需要判断位置
                    if (centerPoint.y+floatingBall_height/2  > (SCREEN_HEIGHT-safe_area_width)/2 && centerPoint.y-floatingBall_height/2 < (SCREEN_HEIGHT+safe_area_width)/2 ) {
                        centerPoint = CGPointMake(SAFE_AREA_LEFT, centerPoint.y);
                    }else {
                        centerPoint = CGPointMake(0, centerPoint.y);
                    }
                } else {
                    centerPoint = CGPointMake(SCREEN_WIDTH, centerPoint.y);
                }
            }
                break;
            default:
                centerPoint = CGPointMake(0, centerPoint.y);
                break;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            [GTFloatingBallManager shareInstance].ballWindow.center = centerPoint;
        }completion:^(BOOL finished) {
            completion();
        }];
    });
}

//弹出
- (void)floatinngBallPopUpWithCompletion:(void (^)(void))completion {
    [self floatingBallLightWithCompletion:completion];
}

//熄灭
- (void)floatingBallDarkWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.2 animations:^{
        [GTFloatingBallManager shareInstance].ballVC.floatingBallView.shadowView.hidden = NO;
        [GTFloatingBallManager shareInstance].ballVC.floatingBallView.shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        completion();
    }];
}

//点亮
- (void)floatingBallLightWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.3 animations:^{
        [GTFloatingBallManager shareInstance].ballVC.floatingBallView.shadowView.alpha = 0;
        [GTFloatingBallManager shareInstance].ballVC.floatingBallView.shadowView.hidden = YES;
    } completion:^(BOOL finished) {
        completion();
    }];
}

@end
