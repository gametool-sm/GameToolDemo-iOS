//
//  GTFloatingBallViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/6/25.
//

#import "GTFloatingBallViewController.h"
#import "GTFloatingBallDefaultView.h"
#import "GTFloatingBallSimpleControlView.h"
#import "GTFloatingBallControlView.h"
#import "GTSDKUtils.h"
#import "GTFloatingBallConfig.h"
#import "GTTimerManager+FloatingBall.h"
#import "GTHideFloatBallView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GTFloatingBallManager.h"
#import "GTFirstOpenMinimalistMask.h"

@interface GTFloatingBallViewController () {
    CGPoint     _beginPoint;
    CGPoint     _beginCenter;
    NSInteger   _direction;
}



@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation GTFloatingBallViewController

- (BOOL)shouldAutorotate{
    if ([GTSDKUtils isPortrait]) {
        return NO;
    }else {
        return YES;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([GTSDKUtils isPortrait]) {
        return UIInterfaceOrientationMaskPortrait;
    }else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if ([GTSDKUtils isPortrait]) {
        return UIInterfaceOrientationPortrait;
    }else {
        return UIInterfaceOrientationLandscapeRight;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUp];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (FloatingBallStyle)getFloatingBallStyle {
    //极简模式是否打开
    BOOL extremelyAustereIsOn = [GTSDKUtils getExtremelyAustereIsOn];
    //倍率便捷切换是否打开
    BOOL multiplyingIsOn = [GTSDKUtils getMultiplyingIsOn];
    
    if (extremelyAustereIsOn) {
        if (multiplyingIsOn) {
            [GTFloatingBallManager shareInstance].floatingBallStyle = FloatingBallStyleControl;
        }else {
            [GTFloatingBallManager shareInstance].floatingBallStyle = FloatingBallStyleSimpleControl;
        }
    }else {
        [GTFloatingBallManager shareInstance].floatingBallStyle = FloatingBallStyleDefault;
    }
    return [GTFloatingBallManager shareInstance].floatingBallStyle;
}

- (void)setUp {
    [self.view addSubview:self.floatingBallView];
}

#pragma mark - NSNotification
//- (void)orientationChange:(NSNotification *)noti {
//    if (![GTSDKUtils isPortrait]) {
//        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//        //存一下位置
//        [GTSDKUtils saveFloatingBallPosition:self.floatingBallView.window.center];
//        NSLog(@"x=%f====y=%f", self.floatingBallView.window.frame.origin.x, self.floatingBallView.window.frame.origin.y);
//        switch (orientation) {
//            case UIInterfaceOrientationLandscapeLeft:
//            case UIInterfaceOrientationLandscapeRight:{
//                if (self.floatingBallStyle == FloatingBallStyleDefault) {
//                    //转换小兔子方向
//                    GTFloatingBallDefaultView *view = (GTFloatingBallDefaultView *)self.floatingBallView;
//                    if (self.view.window.frame.origin.x < SCREEN_WIDTH/2) {
//                        view.floatingBallImg.image = [GTThemeManager share] imageWithName:@"floating_ball_right_icon"];
//                    }else {
//                        view.floatingBallImg.image = [GTThemeManager share] imageWithName:@"floating_ball_left_icon"];
//                    }
//                }
//                if ((self.floatingBallStyle == FloatingBallStyleSimpleControl || self.floatingBallStyle == FloatingBallStyleControl )&& [GTSDKUtils getAutoHideIsOn]) {
//                    if (self.view.window.frame.origin.x < SCREEN_WIDTH/2) {
//                        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.floatingBallView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0, 0)];
//                        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
//                        maskLayer1.frame = self.floatingBallView.bounds;
//                        maskLayer1.path = maskPath1.CGPath;
//                        self.floatingBallView.layer.mask = maskLayer1;
//                        UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.floatingBallView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
//                        CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc]init];
//                        maskLayer2.frame = self.floatingBallView.bounds;
//                        maskLayer2.path = maskPath2.CGPath;
//                        self.floatingBallView.layer.mask = maskLayer2;
//                    }else {
//                        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.floatingBallView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0, 0)];
//                        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
//                        maskLayer1.frame = self.floatingBallView.bounds;
//                        maskLayer1.path = maskPath1.CGPath;
//                        self.floatingBallView.layer.mask = maskLayer1;
//                        UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.floatingBallView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
//                        CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc]init];
//                        maskLayer2.frame = self.floatingBallView.bounds;
//                        maskLayer2.path = maskPath2.CGPath;
//                        self.floatingBallView.layer.mask = maskLayer2;
//                    }
//                }
//            }
//                break;
//            default:
//                break;
//        }
//    }
//}

#pragma mark - 取消隐藏悬浮球
-(void)cancelHideFloatBall {
//    switch ([GTFloatingBallManager shareInstance].floatingBallStyle) {
//        case FloatingBallStyleDefault: {
//            //贴边
//            [GTFloatingBallConfig floatingBallWeltWithView:self.view.window speed:0.5 completion:^{
//                //记录位置
//                [GTSDKUtils saveFloatingBallPosition:self.view.window.center];
//                [[GTTimerManager shareManager] startFloatingBallBeginWeltWithExtinguishComplete:^{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [GTFloatingBallConfig floatingBallDefaultModeExtinguishWithView:self.floatingBallView.maskView completion:nil];
//                    });
//                } hideHalfComplete:^{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [GTFloatingBallConfig floatingBallDefaultModeHideHalfWithView:self.view.window];
//                    });
//                }];
//            }];
//        }
//            break;
//        case FloatingBallStyleSimpleControl:
//        case FloatingBallStyleControl: {
//            //贴边
//            [GTFloatingBallConfig floatingBallWeltWithView:self.view.window speed:0.5 completion:^{
//                //记录位置
//                [GTSDKUtils saveFloatingBallPosition:self.view.window.center];
//
//                [[GTTimerManager shareManager] startFloatingBallBeginWeltWithExtinguishComplete:^{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [GTFloatingBallConfig floatingBallControlModeExtinguishWithView:self.floatingBallView completion:nil];
//                    });
//                } hideHalfComplete:^{
//                    if ([GTSDKUtils getAutoHideIsOn]) { //判断极简模式下贴边功能是否打开
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [GTFloatingBallConfig floatingBallControlModeClingWithView:self.floatingBallView];
//                        });
//                    }
//
//                }];
//            }];
//        }
//            break;
//        default:
//            break;
//    }
}

#pragma mark - private method

#pragma mark - setter & getter

- (GTFloatingBallBaseView *)floatingBallView {
    if (!_floatingBallView) {
        switch ([GTFloatingBallManager shareInstance].floatingBallStyle) {
            case FloatingBallStyleDefault: {
                _floatingBallView = [GTFloatingBallDefaultView new];
                _floatingBallView.frame = CGRectMake(0, 0, floatingBall_width, floatingBall_height);
                _floatingBallView.userInteractionEnabled = YES;
            }
                break;
            case FloatingBallStyleSimpleControl: {
                _floatingBallView = [GTFloatingBallSimpleControlView new];
                _floatingBallView.frame = CGRectMake(0, 0, floatingBall_width, floatingBall_height);
                _floatingBallView.userInteractionEnabled = YES;
            }
                break;
            case FloatingBallStyleControl: {
                _floatingBallView = [GTFloatingBallControlView new];
                _floatingBallView.frame = CGRectMake(0, 0, floatingBall_width, [GTFloatingBallManager shareInstance].floatingBall_control_height);
                _floatingBallView.userInteractionEnabled = YES;
            }
                break;
            default:
                break;
        }
        
        //把蒙层放在最上面
        [_floatingBallView bringSubviewToFront:_floatingBallView.shadowView];
        
        switch ([GTFloatingBallManager shareInstance].floatingBallLuminance) {
            case FloatingBallLuminanceLight:
                _floatingBallView.shadowView.hidden = YES;
                break;
            case FloatingBallLuminanceDark:
                _floatingBallView.shadowView.hidden = NO;
                break;
            default:
                break;
        }
    }
    return _floatingBallView;
}

- (GTHideFloatBallView *)hideFloatBallView {
    if (!_hideFloatBallView) {
        _hideFloatBallView = [GTHideFloatBallView new];
        [_hideFloatBallView setHidden:YES];
    }
    return _hideFloatBallView;
}

@end
