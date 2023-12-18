//
//  GTClickerWindowWindow.m
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTClickerWindowWindow.h"
#import "GTClickerWindowBehave.h"
#import "GTClickerWindowManager.h"
#import "GTClickerWindowAnimation.h"
#import "GTBottomHotSpotView.h"
#import "GTFloatingBallConfig.h"
#import "GTClickerManager.h"
#import "GTDialogView.h"
#import "GTFloatingBallManager.h"
#import "GTDialogWindowManager.h"

@interface GTClickerWindowWindow ()

@property (nonatomic, strong) GTBottomHotSpotView *bottomHotSpotView;
@property (nonatomic, assign) CGPoint startPoint;   //移动前的初始坐标

@end

@implementation GTClickerWindowWindow

- (void)changeTheme :(NSNotification *)noti{
    if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureDark) {
        self.backgroundColor = [UIColor clearColor];
    }else {
        self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureDark) {
            self.backgroundColor = [UIColor clearColor];
        }else {
            self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        }
        
        self.layer.cornerRadius = 14 * WIDTH_RATIO;
        self.layer.masksToBounds = YES;
        
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [[GTSDKUtils getTopWindow].view addSubview:self.bottomHotSpotView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:GTSDKChangeTheme object:nil];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
    [self addGestureRecognizer:panGesture];
}

//拖动悬浮球手势动作
- (void)dragAction:(UIPanGestureRecognizer *)gesture {
    UIGestureRecognizerState moveState = gesture.state;
    switch (moveState) {
        case UIGestureRecognizerStateBegan: {
            if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart) {
                //移除熄灭倒计时
                [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView clickerWindowRemoveDark];
            }
            
            if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureDark) {
                //点亮
                [GTClickerWindowAnimation clickerWindowFutureDarkToFutureStartAnimationWithCompletion:^{
                    
                }];
            }
            //移除连点器第一次蒙层
            [[GTDialogWindowManager shareInstance] dialogWindowHide];
            
            self.startPoint = CGPointMake(CENTERX(self), CENTERY(self));
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart) {
                //移除熄灭倒计时
                [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView clickerWindowRemoveDark];
            }
            CGPoint point = [gesture translationInView:self];
            //中心将要移动的点 （进行判断移动范围）
            CGPoint movePoint = CGPointMake(point.x + CENTERX(self),
                                            point.y + CENTERY(self));
            self.center = [GTClickerWindowBehave clickerWindowMoveArea:movePoint];
            
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
           
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [GTSDKUtils saveClickerWindowPosition:CGPointMake(self.origin.x, self.origin.y)];
            /**
             停在了热区内
             */
            if (self.bottomHotSpotView.isInHotView) {
                if (!self.bottomHotSpotView.isHidden) {
                    [self.bottomHotSpotView willHide];
                }
                break;
            }
            if (!self.bottomHotSpotView.isHidden) {
                [self.bottomHotSpotView hide];
            }
            /**
             倒计时开始状态1s后熄灭
             */
            if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart) {
                //熄灭
                [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView clickerWindowStartDark];
            }
        }
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
            if ([GTClickerManager shareInstance].isRun) {    //正在运行中
                [[GTDialogWindowManager shareInstance] dialogWindowShow];
                [[GTDialogWindowManager shareInstance].dialogWindow makeToast:localString(@"方案运行中，请暂停后再关闭") duration:0.5 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
                    [[GTDialogWindowManager shareInstance] dialogWindowHide];
                }];
                [selfWeak.bottomHotSpotView hide];
            }else { //退出方案
                switch ([GTClickerWindowManager shareInstance].clickerWindowState) {
                    case ClickerWindowStateNowReady:
                    case ClickerWindowStateFutureReady: { //判断是否保存，已保存则直接隐藏(修改为弹出toast)，未保存则弹出退出方案弹窗
                        if ([[[GTClickerWindowManager shareInstance].schemeModel modelToJSONString] isEqualToString:[GTClickerWindowManager shareInstance].schemeJsonString]) {
                            //发送通知给悬浮弹窗，从方案设置页返回到方案列表页
                            [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowQuitSchemeNotification object:nil];
                            [[GTClickerWindowManager shareInstance] clickerWindowHide];
                            [GTClickerWindowManager shareInstance].schemeModel = nil;
                            [GTClickerWindowManager shareInstance].isAllPointShow = NO;
                            [GTClickerWindowManager shareInstance].lastClickJsonString = @"";
                            //弹出toast
                            [[GTSDKUtils getTopWindow].view makeToast:localString(@"在工具箱中可以重新唤起连点器") duration:0.5 position:CSToastPositionCenter];
                            [selfWeak.bottomHotSpotView hide];
                        }else {
                            selfWeak.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - hideHotView_height / 2 -  SAFE_AREA_BOTTOM);
                            GTDialogView *dialogView = [[GTDialogView alloc] initWithStyle:DialogViewStyleDefault
                                                                                     title:localString(@"温馨提示")
                                                                                   content:localString(@"当前方案未保存，是否确认退出")
                                                                           leftButtonTitle:@"取消"
                                                                          rightButtonTitle:@"退出"
                                                                           leftButtonBlock:^{
                                [selfWeak.bottomHotSpotView hide];
                                [[GTDialogWindowManager shareInstance] dialogWindowHide];
                            }
                                                                          rightButtonBlock:^{
                                //发送通知给悬浮弹窗，从方案设置页返回到方案列表页
                                [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowQuitSchemeNotification object:nil];
                                [[GTClickerWindowManager shareInstance] clickerWindowHide];
                                [GTClickerWindowManager shareInstance].schemeModel = nil;
                                [GTClickerWindowManager shareInstance].isAllPointShow = NO;
                                [GTClickerWindowManager shareInstance].lastClickJsonString = @"";
                                [selfWeak.bottomHotSpotView hide];
                                [[GTDialogWindowManager shareInstance] dialogWindowHide];
                            }];
                            [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
                            [[GTDialogWindowManager shareInstance] dialogWindowShow];
                        }
                    }
                        break;
                    case ClickerWindowStateFutureStart: {   //暂停倒计时，退出方案弹窗
                        selfWeak.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - hideHotView_height / 2 -  SAFE_AREA_BOTTOM);
                        [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.countDownTimer.fireDate = [NSDate distantFuture];
                        //判断是否修改方案
                        if ([[[GTClickerWindowManager shareInstance].schemeModel modelToJSONString] isEqualToString:[GTClickerWindowManager shareInstance].schemeJsonString]) {
                            [selfWeak.bottomHotSpotView hide];
                            //发送通知给悬浮弹窗，从方案设置页返回到方案列表页
                            [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowQuitSchemeNotification object:nil];
                            [[GTClickerWindowManager shareInstance] clickerWindowHide];
                            [GTClickerWindowManager shareInstance].schemeModel = nil;
                            [GTClickerWindowManager shareInstance].isAllPointShow = NO;
                            [GTClickerWindowManager shareInstance].lastClickJsonString = @"";
                            //弹出toast
                            [[GTSDKUtils getTopWindow].view makeToast:localString(@"在工具箱中可以重新唤起连点器") duration:0.5 position:CSToastPositionCenter];
                        }else {
                            GTDialogView *dialogView = [[GTDialogView alloc] initWithStyle:DialogViewStyleDefault
                                                                                     title:localString(@"温馨提示")
                                                                                   content:localString(@"当前方案未保存，是否确认退出")
                                                                           leftButtonTitle:@"取消"
                                                                          rightButtonTitle:@"退出"
                                                                           leftButtonBlock:^{
                                [GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView.countDownTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
                                //熄灭
                                [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView clickerWindowStartDark];
                                [selfWeak.bottomHotSpotView hide];
                                [[GTDialogWindowManager shareInstance] dialogWindowHide];
                            }
                                                                          rightButtonBlock:^{
                                //发送通知给悬浮弹窗，从方案设置页返回到方案列表页
                                [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowQuitSchemeNotification object:nil];
                                [[GTClickerWindowManager shareInstance] clickerWindowHide];
                                [GTClickerWindowManager shareInstance].schemeModel = nil;
                                [GTClickerWindowManager shareInstance].isAllPointShow = NO;
                                [GTClickerWindowManager shareInstance].lastClickJsonString = @"";
                                [selfWeak.bottomHotSpotView hide];
                                [[GTDialogWindowManager shareInstance] dialogWindowHide];
                            }];
                            [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
                            [[GTDialogWindowManager shareInstance] dialogWindowShow];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
        };
    }
    return _bottomHotSpotView;
}

@end
