//
//  GTFloatingBallConfig.m
//  GTSDK
//
//  Created by shangmi on 2023/6/16.
//

#import "GTFloatingBallConfig.h"
#import <UIKit/UIKit.h>
#import "GTDialogWindowManager.h"
#import "GTHideFloatBallGuideDialog.h"
#import "GTHideSimpleFloatBallGuideDialog.h"
#import "GTCloseSimpleModeGuideDialog.h"
#import "GTOpenSimpleStyleGuideDialog.h"
#import "GTFloatingBallBaseView.h"
#import "GTFloatingBallManager.h"
#import "GTMotionManager.h"
#import "GTFloatingWindowManager.h"

CGFloat const floatingBall_width = 46;      //悬浮球宽度
CGFloat const floatingBall_height = 46;     //悬浮球高度
CGFloat const floatingBall_distance = 10;   //悬浮球距离边框的距离

CGFloat const hideHotView_width = 160;  //隐藏热区宽度
CGFloat const hideHotView_height = 160; //隐藏热区高度

CGFloat const safe_area_width = 100;    //定义有刘海屏的手机，刘海屏的宽度，或者灵动岛的宽度

@interface GTFloatingBallConfig ()

@property (nonatomic, assign) BOOL isLeft;

@end

@implementation GTFloatingBallConfig

#pragma mark - GTFloatingBallBehaveDefaultProtocol

/// 悬浮球自动贴边
/// - Parameters:
///   - view: 悬浮球所在view
///   - speed: 速度
///   - completion: completion
+ (void)floatingBallWeltWithView:(UIView *)view speed:(double)speed completion:(void(^)(void))completion {
    CGPoint newPoint = view.center;
    
    if ([GTSDKUtils isPortrait]) {
        //竖屏
        if (newPoint.x < SCREEN_WIDTH/2) {
            newPoint.x = floatingBall_width/2 + 10; //距边10px
        }else {
            newPoint.x = SCREEN_WIDTH - floatingBall_width/2 - 10;
        }
    }else {
        //横屏
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
    

    double duration = [GTFloatingBallConfig floatingBallWithView:view spendTimeAsSpeed:speed];
    //侧边吸附动画
    [UIView animateWithDuration:duration animations:^{
        view.center = newPoint;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

//悬浮球贴边隐藏一半悬浮球
+ (void)floatingBallDefaultModeHideHalfWithView:(UIView *)view {
    CGPoint centerPoint = view.center;
    
    if ([GTSDKUtils isPortrait]) {
        if (centerPoint.x < SCREEN_WIDTH/2) {
            centerPoint = CGPointMake(0, centerPoint.y);
        } else {
            centerPoint = CGPointMake(SCREEN_WIDTH, centerPoint.y);
        }
    } else{
        UIInterfaceOrientation interfaceOritation = [[UIApplication sharedApplication] statusBarOrientation];
        if (interfaceOritation == UIInterfaceOrientationLandscapeRight) {
            if (centerPoint.x < (SCREEN_WIDTH-SAFE_AREA_LEFT)/2+SAFE_AREA_LEFT) {
                
                if (centerPoint.y+floatingBall_height/2  > (SCREEN_HEIGHT-safe_area_width)/2 && centerPoint.y-floatingBall_height/2 < (SCREEN_HEIGHT+safe_area_width)/2 ) {
                    centerPoint = CGPointMake(SAFE_AREA_LEFT, centerPoint.y);
                }else {
                    centerPoint = CGPointMake(0, centerPoint.y);
                }
                
            } else {
                centerPoint = CGPointMake(SCREEN_WIDTH, centerPoint.y);
            }
        } else if (interfaceOritation == UIInterfaceOrientationLandscapeLeft) {
            if (centerPoint.x < (SCREEN_WIDTH-SAFE_AREA_RIGHT)/2) {
                centerPoint = CGPointMake(0, centerPoint.y);
            } else {
                
                if (centerPoint.y+floatingBall_height/2  > (SCREEN_HEIGHT-safe_area_width)/2 && centerPoint.y-floatingBall_height/2 < (SCREEN_HEIGHT+safe_area_width)/2 ) {
                    centerPoint = CGPointMake(SCREEN_WIDTH-SAFE_AREA_RIGHT, centerPoint.y);
                }else {
                    centerPoint = CGPointMake(SCREEN_WIDTH, centerPoint.y);
                }
                
            }
        }else {
            centerPoint = CGPointMake(0, centerPoint.y);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            view.center = centerPoint;
        }completion:^(BOOL finished) {
            
        }];
    });
}

//悬浮球熄灭
+ (void)floatingBallDefaultModeExtinguishWithView:(UIView *)view completion:(void (^ _Nullable)(void))completion {
    view.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        view.hidden = NO;
        view.alpha = 0.4;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

//悬浮球点亮
+ (void)floatingBallDefaultModeLightedWithView:(UIView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        view.maskView.alpha = 0;
        view.maskView.hidden = YES;
    }];
//    self.floatingBallState = FloatingBallStateResponse;
}

#pragma mark - GTFloatingBallBehaveControlProtocol

+ (void)floatingBallControlModeClingWithView:(UIView *)view {
    UIInterfaceOrientation interfaceOritation = [UIApplication sharedApplication].statusBarOrientation;
    
    CGPoint centerPoint = view.window.center;
    CGFloat width = view.window.frame.size.width * 0.84;
    if ([GTSDKUtils isPortrait]) {
        if (centerPoint.x < SCREEN_WIDTH/2) {
            centerPoint = CGPointMake(width/2 , centerPoint.y);
        } else {
            centerPoint = CGPointMake(SCREEN_WIDTH-width/2, centerPoint.y);
        }
    } else{
        if (interfaceOritation == UIInterfaceOrientationLandscapeRight) {
            if (centerPoint.x < SCREEN_WIDTH/2) {
                
                if (centerPoint.y+floatingBall_height/2  > (SCREEN_HEIGHT-safe_area_width)/2 && centerPoint.y-floatingBall_height/2 < (SCREEN_HEIGHT+safe_area_width)/2 ) {
                    centerPoint = CGPointMake(SAFE_AREA_LEFT + width/2, centerPoint.y);
                }else {
                    centerPoint = CGPointMake(width/2, centerPoint.y);
                }
                
            } else {
                centerPoint = CGPointMake(SCREEN_WIDTH - width/2, centerPoint.y);
            }
        } else if (interfaceOritation == UIInterfaceOrientationLandscapeLeft) {
            if (centerPoint.x < SCREEN_WIDTH/2) {
                centerPoint = CGPointMake(width/2, centerPoint.y);
            } else {
                
                if (centerPoint.y+floatingBall_height/2  > (SCREEN_HEIGHT-safe_area_width)/2 && centerPoint.y-floatingBall_height/2 < (SCREEN_HEIGHT+safe_area_width)/2 ) {
                    centerPoint = CGPointMake(SCREEN_WIDTH-SAFE_AREA_RIGHT-width/2, centerPoint.y);
                }else {
                    centerPoint = CGPointMake(SCREEN_WIDTH-width/2, centerPoint.y);
                }
                
            }
        }else {
            centerPoint = CGPointMake(width/2, centerPoint.y);
        }
    }
    
    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.32 animations:^{
            GTFloatingBallBaseView *baseView = (GTFloatingBallBaseView *)view;
//注释            baseView.floatingBallBtn.backgroundColor = [UIColor clearColor];
            view.transform = CGAffineTransformMakeScale(0.84, 0.84);
            
            view.window.center = centerPoint;
            
//            if (view.window.frame.origin.x < SCREEN_WIDTH/2) {
//                view.window.transform = CGAffineTransformMakeTranslation(-16, 0);
//            }else {
//                view.window.transform = CGAffineTransformMakeTranslation(16, 0);
//            }
            
            
            
            
            
      
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            if (view.window.frame.origin.x < SCREEN_WIDTH/2) {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
                maskLayer.frame = view.bounds;
                maskLayer.path = maskPath.CGPath;
                view.layer.mask = maskLayer;
            }else {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
                maskLayer.frame = view.bounds;
                maskLayer.path = maskPath.CGPath;
                view.layer.mask = maskLayer;
            }
            
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateHideHalf;
        }];
    });
}

//极简模式悬浮球弹出
+ (void)floatingBallControlModePopUpWithView:(UIView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        GTFloatingBallBaseView *baseView = (GTFloatingBallBaseView *)view;
//        baseView.floatingBallBtn.backgroundColor = [UIColor hexColor:@"#EAF4FF"];
        
        view.transform = CGAffineTransformMakeScale(1, 1);
        view.window.transform = CGAffineTransformMakeTranslation(0, 0);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(23, 23)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        
        [view layoutIfNeeded];
    }];
}

//极简模式悬浮球熄灭
+ (void)floatingBallControlModeExtinguishWithView:(UIView *)view completion:(void(^ __nullable)(void))completion {
    view.maskView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        view.maskView.hidden = NO;
        view.maskView.alpha = 0.4;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

//极简模式悬浮球点亮
+ (void)floatingBallControlModeLightedWithView:(UIView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        view.maskView.alpha = 0;
        view.maskView.hidden = YES;
    }];
}

#pragma mark - 根据贴边速度,计算贴边时间

+ (double)floatingBallWithView:(UIView *)view spendTimeAsSpeed:(double)speed {
//    return 0.22;
    double time;
    if ([GTSDKUtils isPortrait]) {
        //竖屏
        CGFloat distance = MIN(view.centerX, SCREEN_WIDTH - view.centerX);
        time = distance/speed;
    }else {
        //横屏
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (orientation) {
            case UIInterfaceOrientationLandscapeLeft: {
                CGFloat distance = MIN(view.centerX, SCREEN_WIDTH - SAFE_AREA_RIGHT - view.centerX);
                time = distance/speed;
            }
                break;
            case UIInterfaceOrientationLandscapeRight: {
                CGFloat distance = MIN(view.centerX, SCREEN_WIDTH - SAFE_AREA_LEFT - view.centerX);
                time = distance/speed;
            }
                break;
                
            default: time = 0.5;
                break;
        }
    }
    return time/1000;
}

+ (void)defaultFloatingBallHideWithFloatBallImg:(nonnull UIView *)floatBallImg andHideFloatBallView:(nonnull GTBottomHotSpotView *)hideFloatBallView cancelHide:(nonnull void (^)(void))cancelHide confirm:(nonnull void (^)(void))confirm{
    @WeakObj(self);
    if ([GTSDKUtils getFloatBallHideWindowShowTimes] == 3) {
        if (!hideFloatBallView.isHidden) {
            [hideFloatBallView hide];
        }
        [UIView animateWithDuration:0.32 animations:^{
            floatBallImg.alpha = 0.1;
            floatBallImg.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            [[GTFloatingBallManager shareInstance] floatingBallHide];
            floatBallImg.transform = CGAffineTransformMakeScale(1, 1);
            floatBallImg.alpha = 1;
            if (confirm) {
                confirm();
            }
            [selfWeak confirmHideFloatBall];
            
            //将悬浮球滑动到下方关闭上报
            [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventFloatBallHide andProperties:@{@"floatball_hide_way" : [NSNumber numberWithInt:1]} shouldFlush:YES];
        }];
        return;
    }
    
    GTHideFloatBallGuideDialog *dialogView = [[GTHideFloatBallGuideDialog alloc] initWithDescText:localString(@"翻转手机可唤出或隐藏悬浮球") confirm:^{
        if (!hideFloatBallView.isHidden) {
            [hideFloatBallView hide];
        }
        [UIView animateWithDuration:0.32 animations:^{
            floatBallImg.alpha = 0.1;
            floatBallImg.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            floatBallImg.transform = CGAffineTransformMakeScale(1, 1);
            [[GTFloatingBallManager shareInstance] floatingBallHide];
            floatBallImg.alpha = 1;
            if (confirm) {
                confirm();
            }
            [selfWeak confirmHideFloatBall];
            
            //将悬浮球滑动到下方关闭上报
            [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventFloatBallHide andProperties:@{@"floatball_hide_way" : [NSNumber numberWithInt:1]} shouldFlush:YES];
        }];
    } cancel:^{
        if (!hideFloatBallView.isHidden) {
            [hideFloatBallView hide];        }
        if (cancelHide) {
            cancelHide();
        }
    }];
    
    [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
    [[GTDialogWindowManager shareInstance] dialogWindowShow];
}
+ (void)simpleFloatingBallHideWithFloatBallImg:(UIView *)floatBallImg andHideFloatBallView:(GTBottomHotSpotView *)hideFloatBallView cancelHide:(void (^)(void))cancelHide hideFloatBall:(void (^)(void))hideFloatBall closeSimpleStyle:(void (^)(void))closeSimpleStyle {
    switch ([[GTSDKUtils getGTSDKStyle] intValue]) {
        case 0: {
            GTHideSimpleFloatBallGuideDialog * dialogView = [[GTHideSimpleFloatBallGuideDialog alloc] initWithTitleText:localString(@"选择操作") closeSimpleStype:^{
                if (closeSimpleStyle) {
                    closeSimpleStyle();
                }
            } hideFloatBall:^{
                if (hideFloatBall) {
                    hideFloatBall();
                }
                if ([GTSDKUtils getCloseSimpleStyleWindowShowTimes] == 3) {
                    [self confirmHideFloatBall];
                }
            } cancelBtnBlock:^{
                if (!hideFloatBallView.isHidden) {
                    [hideFloatBallView hide];
                }
                if (cancelHide) {
                    cancelHide();
                }
            }];
            [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
            [[GTDialogWindowManager shareInstance] dialogWindowShow];
        }
            break;
        case 1: {
            GTCloseSimpleModeGuideDialog * dialogView = [[GTCloseSimpleModeGuideDialog alloc] initWithTitleText:localString(@"选择操作") closeSimpleStype:^{
                if (closeSimpleStyle) {
                    closeSimpleStyle();
                }
            } cancelBtnBlock:^{
                if (!hideFloatBallView.isHidden) {
                    [hideFloatBallView hide];
                }
                if (cancelHide) {
                    cancelHide();
                }
            }];
            [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
            [[GTDialogWindowManager shareInstance] dialogWindowShow];
        }
            break;;
        default:
            break;
    }
}
+ (void)reopenSimpleStyleDialogWithFloatBallImg:(UIView *)floatBallImg andHideFloatBallView:(GTBottomHotSpotView *)hideFloatBallView cancelClose:(void (^)(void))cancelClose confirmClose:(void (^)(void))confirmClose {
    GTOpenSimpleStyleGuideDialog * dialogView = [[GTOpenSimpleStyleGuideDialog alloc] initWithTitleText:localString(@"温馨提示") DescText:localString(@"在【加速器】中可以重新开启极简模式") confirm:^{
        if (!hideFloatBallView.isHidden) {
            [hideFloatBallView hide];
        }
        if (confirmClose) {
            confirmClose();
        }
        
    } cancel:^{
        if (!hideFloatBallView.isHidden) {
            [hideFloatBallView hide];
        }
        if (cancelClose) {
            cancelClose();
        }
    }];
    [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
    [[GTDialogWindowManager shareInstance] dialogWindowShow];
}
#pragma mark - 确认隐藏悬浮球
+(void)confirmHideFloatBall {
    [GTFloatingBallManager shareInstance].floatBallStatusCanChange = YES;
    [GTOperationControl shareInstance].AlreadyHideFloatBall = YES;
    [[GTMotionManager shareManager] startMonitorMotionWithCompletion:^{
        if ([GTFloatingBallManager shareInstance].floatBallStatusCanChange) {
            if (![GTFloatingBallManager shareInstance].ballWindow.isHidden) {
                [[GTFloatingBallManager shareInstance] floatingBallHide];
                
                if (![GTSDKUtils getExtremelyAustereIsOn]) {    //小兔子状态
                    //通过翻转手机隐藏悬浮球上报
                    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventFloatBallHide andProperties:@{@"floatball_hide_way" : [NSNumber numberWithInt:2]} shouldFlush:YES];
                }
            } else {
                [[GTFloatingBallManager shareInstance] floatingBallShow];
            }
            [GTFloatingBallManager shareInstance].floatBallStatusCanChange = NO;
            DELAYED(1.5, ^{
                [GTFloatingBallManager shareInstance].floatBallStatusCanChange = YES;
            });
        }
    }];
}
+ (void)closeSimpleStyle {
    [GTSDKUtils saveExtremelyAustereIsOn:NO];
    [GTFloatingBallManager shareInstance].floatingBallStyle = FloatingBallStyleDefault;
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKChangeFloatingBallStateNotification object:nil];
    [[GTFloatingBallManager shareInstance] floatingBallHide];
    [[GTFloatingBallManager shareInstance] floatingBallShow];
}
@end
