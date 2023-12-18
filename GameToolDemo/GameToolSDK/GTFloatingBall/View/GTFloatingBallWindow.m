//
//  GTFloatingBallWindow.m
//  GTSDK
//
//  Created by shangmi on 2023/6/25.
//

#import "GTFloatingBallWindow.h"
#import "GTFloatingBallManager.h"
#import "GTFirstOpenMinimalistMask.h"
#import "GTFloatingWindowManager.h"
#import "GTFloatingBallAnimation.h"
#import "GTDialogWindowManager.h"
#import "GTBottomHotSpotView.h"
#import "GTDialogView.h"
#import "GTFloatingBallDefaultView.h"
#import "GTFloatingBallSimpleControlView.h"
#import "GTFloatingBallControlView.h"

@interface GTFloatingBallWindow ()

@property (nonatomic, assign) CGPoint startPoint;   //移动前的初始坐标
@property (nonatomic, strong) GTBottomHotSpotView *bottomHotSpotView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation GTFloatingBallWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    [[GTSDKUtils getTopWindow].view addSubview:self.bottomHotSpotView];
    
    //添加手势
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    self.longPressGesture.allowableMovement = 5.0;
    [self addGestureRecognizer:self.tapGesture];
    [self addGestureRecognizer:self.panGesture];
    [self addGestureRecognizer:self.longPressGesture];
}

#pragma mark - response
//点击悬浮球手势，展示悬浮弹窗
- (void)tapAction:(UITapGestureRecognizer *)gesture {
    //像连点器设置页发通知，重新请求获取当前手持方案
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowTapSetNotification object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKRecordWindowTapSetNotification object:self userInfo:nil];
    //第一次移除蒙层
    [[GTDialogWindowManager shareInstance] dialogWindowHide];

    switch ([GTFloatingBallManager shareInstance].floatingBallStyle) {
        case FloatingBallStyleDefault: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    self.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    self.alpha = 0;
                    self.maskView.alpha = 0;
                } completion:^(BOOL finished) {
                    [[GTFloatingBallManager shareInstance] floatingBallHide];
                   
                    self.alpha = 1;
                    self.transform = CGAffineTransformMakeScale(1, 1);
                    [[GTFloatingWindowManager shareInstance] floatingWindowShow];
                    [GTFloatingWindowManager shareInstance].windowWindow.alpha = 0;
                    [GTFloatingWindowManager shareInstance].windowWindow.transform = CGAffineTransformMakeTranslation(0, 15);
                    [UIView animateWithDuration:0.32 animations:^{
                        [GTFloatingWindowManager shareInstance].windowWindow.alpha = 1;
                        [GTFloatingWindowManager shareInstance].windowWindow.transform = CGAffineTransformMakeTranslation(0, 0);
                    }];
                }];
            });
        }
            break;
        case FloatingBallStyleSimpleControl: {
            CGPoint location = [gesture locationInView:[GTFloatingBallManager shareInstance].ballVC.view];
            
            if (CGRectContainsPoint([GTFloatingBallManager shareInstance].ballVC.view.frame, location)) {
                //透过蒙层点到按钮
                [(GTFloatingBallSimpleControlView *)[GTFloatingBallManager shareInstance].ballVC.floatingBallView clickShadowView:location];
            }
        }
            break;
        case FloatingBallStyleControl: {
            
            CGPoint location = [gesture locationInView:[GTFloatingBallManager shareInstance].ballVC.view];
            
            if (CGRectContainsPoint([GTFloatingBallManager shareInstance].ballVC.view.frame, location)) {
                //透过蒙层点到按钮
                [(GTFloatingBallControlView *)[GTFloatingBallManager shareInstance].ballVC.floatingBallView clickShadowView:location];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    //如果极简模式的蒙版存在，则移除
    for (UIView *view in [GTSDKUtils getTopWindow].view.subviews) {
        if ([view isKindOfClass:[GTFirstOpenMinimalistMask class]]) {
            [view removeFromSuperview];
            [GTSDKUtils saveShowMinimalistGuideMask];
        }
    }
}

//长按悬浮球手势
- (void)longPressAction:(UITapGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            if ([GTFloatingBallManager shareInstance].floatingBallStyle == FloatingBallStyleSimpleControl || [GTFloatingBallManager shareInstance].floatingBallStyle == FloatingBallStyleControl) {
                //移除隐藏和熄灭
                [self.behaveFactory removeFloatingBallHideHalfTimer];
                [self.behaveFactory removeFloatingBallDarkTimer];
                
                //长按悬浮球动画
                [GTFloatingBallAnimation longPressFloatingBallAnimation];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            switch ([GTFloatingBallManager shareInstance].floatingBallStyle) {
                case FloatingBallStyleDefault: {    //小白兔
                    //开始倒计时隐藏一半
//                    [self.behaveFactory startFloatingBallHideHalfTimer];
                }
                    break;
                case FloatingBallStyleSimpleControl:
                case FloatingBallStyleControl: {
                    if ([GTSDKUtils getAutoHideIsOn]) { //判断极简模式下隐藏一半功能是否打开
                        //开始倒计时隐藏一半
//                        [self.behaveFactory startFloatingBallHideHalfTimer];
                    }
                }
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    //如果极简模式的蒙版存在，则移除
    for (UIView *view in [GTSDKUtils getTopWindow].view.subviews) {
        if ([view isKindOfClass:[GTFirstOpenMinimalistMask class]]) {
            [view removeFromSuperview];
            [GTSDKUtils saveShowMinimalistGuideMask];
        }
    }
}

//拖动悬浮球手势动作
- (void)dragAction:(UIPanGestureRecognizer *)gesture {
    UIGestureRecognizerState moveState = gesture.state;
    
    switch (moveState) {
        case UIGestureRecognizerStateBegan: {
            //移除隐藏和熄灭
            [self.behaveFactory removeFloatingBallHideHalfTimer];
            [self.behaveFactory removeFloatingBallDarkTimer];
            //只要移动就点亮
            [self.behaveFactory floatingBallLightWithCompletion:^{
            }];
            //移动就弹出         
            [self.behaveFactory floatinngBallPopUpWithCompletion:^{
                [GTFloatingBallManager shareInstance].floatingBallLuminance = FloatingBallLuminanceLight;
                [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateWelt;
            }];
            
            CGPoint point = [gesture translationInView:self];
            //中心将要移动的点 （进行判断移动范围）
            self.startPoint = CGPointMake(point.x + CENTERX(self),
                                              point.y + CENTERY(self));
            
            //如果极简模式的蒙版存在，则移除
            for (UIView *view in [GTSDKUtils getTopWindow].view.subviews) {
                if ([view isKindOfClass:[GTFirstOpenMinimalistMask class]]) {
                    [view removeFromSuperview];
                    [GTSDKUtils saveShowMinimalistGuideMask];
                }
            }
            
            //移除连点器第一次蒙层
            [[GTDialogWindowManager shareInstance] dialogWindowHide];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [gesture translationInView:self];
            //中心将要移动的点 （进行判断移动范围）
            CGPoint newPoinnt = CGPointMake(point.x + CENTERX(self),
                                            point.y + CENTERY(self));
            
            CGPoint targetPoint = [self.behaveFactory floatingBallMoveArea:newPoinnt];
            self.center = targetPoint;
            /**
             根据位置来判断小兔子朝向
             */
            if ([GTFloatingBallManager shareInstance].floatingBallStyle == FloatingBallStyleDefault) {
                GTFloatingBallDefaultView *defaultView = (GTFloatingBallDefaultView *)[GTFloatingBallManager shareInstance].ballVC.floatingBallView;
                if (self.center.x < SCREEN_WIDTH/2) { //屏幕左侧
                    [defaultView.floatingBallImg setImage:[[GTThemeManager share] imageWithName:@"floating_ball_right_icon"]];
                }else { //屏幕右侧
                    [defaultView.floatingBallImg setImage:[[GTThemeManager share] imageWithName:@"floating_ball_left_icon"]];
                }
            }
            /**
             根据位移来判断下部分退出方案的阴影区域展示
             */
            if (self.bottomHotSpotView.isHidden && (fabs(CENTERX(self)-self.startPoint.x) >= 10 || fabs(CENTERY(self)-self.startPoint.y) >= 10)) {
                [self.bottomHotSpotView setHidden:NO];
                [self.bottomHotSpotView show];
            }
            /**
             计算悬浮窗center是否进入热区，如果进了，则开始动画
             */
            if (!self.bottomHotSpotView.isHidden) {
                CGRect hotRect = CGRectMake((SCREEN_WIDTH - hideHotView_width) / 2, SCREEN_HEIGHT - hideHotView_height -  SAFE_AREA_BOTTOM, hideHotView_height, hideHotView_height);
                BOOL isInPoint = CGRectContainsPoint(hotRect, self.center);
                if (isInPoint) {
                    [self.bottomHotSpotView enterHideHotView];
                } else {
                    [self.bottomHotSpotView exitOutHideHotView];
                }
            }
            
            @WeakObj(self);
            self.bottomHotSpotView.hideFloatBall = ^{
                selfWeak.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - (160 * WIDTH_RATIO + SAFE_AREA_BOTTOM) / 2);
                //记录悬浮球位置
                [GTSDKUtils saveFloatingBallPosition:selfWeak.center];
                if (![GTSDKUtils getExtremelyAustereIsOn]) {
                    [GTFloatingBallConfig defaultFloatingBallHideWithFloatBallImg:selfWeak andHideFloatBallView:selfWeak.bottomHotSpotView cancelHide:^{
                        [[GTDialogWindowManager shareInstance] dialogWindowHide];
                        [selfWeak.behaveFactory floatingBallWeltWithSpeed:0.375 completion:^{
                            
                            [selfWeak.behaveFactory startFloatingBallHideHalfTimer];
                        }];
                    } confirm:^{
                        [selfWeak.behaveFactory floatingBallWeltWithSpeed:0.375 completion:^{
                        }];
                    }];
                } else {
                    [GTFloatingBallConfig simpleFloatingBallHideWithFloatBallImg:selfWeak andHideFloatBallView:selfWeak.bottomHotSpotView cancelHide:^{
                        [selfWeak.behaveFactory floatingBallWeltWithSpeed:0.375 completion:^{
                            [selfWeak.behaveFactory startFloatingBallHideHalfTimer];
                        }];
                    } hideFloatBall:^{
                        [GTFloatingBallConfig defaultFloatingBallHideWithFloatBallImg:selfWeak andHideFloatBallView:selfWeak.bottomHotSpotView cancelHide:^{
                            [selfWeak.behaveFactory floatingBallWeltWithSpeed:0.375 completion:^{
                                [selfWeak.behaveFactory startFloatingBallHideHalfTimer];
                            }];
                        } confirm:^{
                            [selfWeak.behaveFactory floatingBallWeltWithSpeed:0.375 completion:^{
                            }];
                        }];
                    } closeSimpleStyle:^{
                        if ([GTSDKUtils getCloseSimpleStyleWindowShowTimes] != 3) {
                            [GTFloatingBallConfig reopenSimpleStyleDialogWithFloatBallImg:selfWeak andHideFloatBallView:selfWeak.bottomHotSpotView cancelClose:^{
                                [selfWeak.behaveFactory floatingBallWeltWithSpeed:0.375 completion:^{
                                    [selfWeak.behaveFactory startFloatingBallHideHalfTimer];
                                }];
                            } confirmClose:^{
                                [selfWeak.behaveFactory floatingBallWeltWithSpeed:0.375 completion:^{
                                    [GTSDKUtils saveFloatingBallPosition:selfWeak.center];
                                    [GTFloatingBallConfig closeSimpleStyle];
                                    [selfWeak.behaveFactory startFloatingBallHideHalfTimer];
                                }];
                            }];
                        } else {
                            if (!selfWeak.bottomHotSpotView.isHidden) {
                                [selfWeak.bottomHotSpotView hide];
                            }
                            [selfWeak.behaveFactory floatingBallWeltWithSpeed:0.375 completion:^{
                                [GTSDKUtils saveFloatingBallPosition:selfWeak.center];
                                [GTFloatingBallConfig closeSimpleStyle];
                                [selfWeak.behaveFactory startFloatingBallHideHalfTimer];
                            }];
                            
                        }
                    }];
                }
            };
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [GTSDKUtils saveFloatingBallPosition:self.center];
            
            //悬浮球移动埋点
            NSDictionary *dict = @{@"initial_horizontal_pixel" : [NSNumber numberWithInt:self.startPoint.x], @"initial_vertical_pixel" : [NSNumber numberWithInt:self.startPoint.y],  @"end_horizontal_pixel" : [NSNumber numberWithInt:(int)CENTERX(self)], @"end_vertical_pixel" : [NSNumber numberWithInt:(int)CENTERY(self)]};
            [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventFloatBallMove andProperties:dict shouldFlush:YES];
            
            /**
             停在了热区内
             */
            if (self.bottomHotSpotView.isInHotView) {
                if (!self.bottomHotSpotView.isHidden) {
                    [self.bottomHotSpotView willHide];
                    break;
                }
                
            }
            if (!self.bottomHotSpotView.isHidden) {
                [self.bottomHotSpotView hide];
            }
            
            
            //贴边
            [self.behaveFactory floatingBallWeltWithSpeed:0.375 completion:^{
                //记录悬浮球位置
                [GTSDKUtils saveFloatingBallPosition:self.center];
            }];
            
            switch ([GTFloatingBallManager shareInstance].floatingBallStyle) {
                case FloatingBallStyleDefault: {    //小白兔
                    //开始倒计时隐藏一半
                    [self.behaveFactory startFloatingBallHideHalfTimer];
                }
                    break;
                case FloatingBallStyleSimpleControl:
                case FloatingBallStyleControl: {
                    if ([GTSDKUtils getAutoHideIsOn]) { //判断极简模式下隐藏一半功能是否打开
                        //开始倒计时隐藏一半
                        [self.behaveFactory startFloatingBallHideHalfTimer];
                    }
                }
                default:
                    break;
            }
            
            
            
            
            
            
            
            
            
            
            
            
        }
            break;
        default:
            break;
        }
    [gesture setTranslation:CGPointZero inView:self];
}

- (GTBottomHotSpotView *)bottomHotSpotView {
    if (!_bottomHotSpotView) {
        _bottomHotSpotView = [GTBottomHotSpotView new];
        [_bottomHotSpotView setHidden:YES];
        
        @WeakObj(self);
        _bottomHotSpotView.hideFloatBall = ^{
            
        };
    }
    return _bottomHotSpotView;
}

- (GTFloatingBallBehaveFactory *)behaveFactory {
    if (!_behaveFactory) {
        _behaveFactory = [GTFloatingBallBehaveFactory new];
    }
    return _behaveFactory;
}


@end
