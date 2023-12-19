//
//  GTRecordWindowWindow.m
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import "GTRecordWindowWindow.h"
#import "GTRecordWindowManager.h"
#import "GTBottomHotSpotView.h"
#import "GTDialogWindowManager.h"
#import "GTRecordWindowBehave.h"
#import "GTFloatingBallConfig.h"
#import "GTRecordWindowAnimatiion.h"
#import "GTRecordManager.h"
#import "GTDialogView.h"
#import "GTRecordGuideView.h"

@interface GTRecordWindowWindow ()

@property (nonatomic, strong) GTBottomHotSpotView *bottomHotSpotView;
@property (nonatomic, assign) CGPoint startPoint;   //移动前的初始坐标

@end

@implementation GTRecordWindowWindow

- (void)changeTheme :(NSNotification *)noti{
    if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTimeDark  ||
        [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdownDark) {
        self.backgroundColor = [UIColor clearColor];
    }else {
        self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTimeDark  || [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdownDark) {
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
            
            if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTime) {
                //移除熄灭倒计时
                [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView removeDark];
            }
            if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdown) {
                //移除熄灭倒计时
                [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView removeDark];
            }
            
            if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTimeDark) {
                //点亮
                [GTRecordWindowAnimatiion recordWindowRecordTimeDarkToRecordTimeAnimationWithCompletion:^{
                    
                }];
            }
            if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdownDark) {
                //点亮
                [GTRecordWindowAnimatiion recordWindowFutureCountdownDarkToFutureCountdownAnimationWithCompletion:^{
                    
                }];
            }
            //移除录制第一次蒙层
            [GTRecordGuideView closeGuide];
            
            self.startPoint = CGPointMake(CENTERX(self), CENTERY(self));
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [gesture translationInView:self];
            //中心将要移动的点 （进行判断移动范围）
            CGPoint movePoint = CGPointMake(point.x + CENTERX(self),
                                            point.y + CENTERY(self));
            self.center = [GTRecordWindowBehave RecordWindowMoveArea:movePoint];
            
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
            [GTSDKUtils saveRecordWindowPosition:CGPointMake(self.origin.x, self.origin.y)];
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
            if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTime) {
                //熄灭
                [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView startDark];
            }
            if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdown) {
                //熄灭
                [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView startDark];
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
            if (([GTRecordManager shareInstance].isRu || [GTRecordManager shareInstance].isPlayback) && [GTRecordWindowManager shareInstance].recordWindowState != RecordWindowStateFutureCountdown) {    //正在运行中
                [[GTDialogWindowManager shareInstance] dialogWindowShow];
                [[GTDialogWindowManager shareInstance].dialogWindow makeToast:localString(@"方案运行中，请暂停后再关闭") duration:0.5 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
                    [[GTDialogWindowManager shareInstance] dialogWindowHide];
                }];
                [selfWeak.bottomHotSpotView hide];
            }else { //退出方案
                switch ([GTRecordWindowManager shareInstance].recordWindowState) {
                    case RecordWindowStateStartRecord: {    //还没开始录制，直接退出
                        [GTRecordManager shareInstance].isRecord = NO;
                        //发送通知给悬浮弹窗，从方案设置页返回到方案列表页
                        [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKRecordWindowQuitSchemeNotification object:nil];
                        
                        [[GTRecordWindowManager shareInstance] recordWindowHide];
                        [GTRecordWindowManager shareInstance].schemeModel = nil;
                        [selfWeak.bottomHotSpotView hide];
                    }
                        break;
                    case RecordWindowStateRecordTime: {    //录制中
                        [[GTDialogWindowManager shareInstance] dialogWindowShow];
                        [[GTDialogWindowManager shareInstance].dialogWindow makeToast:localString(@"方案录制中，请结束后再关闭") duration:0.5 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
                            [[GTDialogWindowManager shareInstance] dialogWindowHide];
                        }];
                        [selfWeak.bottomHotSpotView hide];
                        //熄灭
                        [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView startDark];
                    }
                        break;
                    case RecordWindowStateNowFinite:
                    case RecordWindowStateFutureFinite:
                    case RecordWindowStateNowInfinite:
                    case RecordWindowStateFutureInfinite: { //判断是否保存，已保存则直接隐藏(修改为弹出toast)，未保存则弹出退出方案弹窗
                        if ([[[GTRecordWindowManager shareInstance].schemeModel modelToJSONString] isEqualToString:[GTRecordWindowManager shareInstance].schemeJsonString]) {//方案不需要保存
                            //发送通知给悬浮弹窗，从方案设置页返回到方案列表页
                            [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKRecordWindowQuitSchemeNotification object:nil];
                            //移除绘制view
                            [[GTRecordView recordView] remove];
                            
                            [[GTRecordWindowManager shareInstance] recordWindowHide];
                            [GTRecordWindowManager shareInstance].schemeModel = nil;
//                            [GTRecordWindowManager shareInstance].isAllPointShow = NO;
//                            [GTRecordWindowManager shareInstance].lastClickJsonString = @"";
                            //弹出toast
                            [[GTSDKUtils getTopWindow].view makeToast:localString(@"在工具箱中可以重新唤起连点器") duration:0.5 position:CSToastPositionCenter];
                            [selfWeak.bottomHotSpotView hide];
                            
                            //连点器启动时长埋点（结束计时）
                            //神策开始计时
                            [[GTDataTimeCounter sharedInstance] end:GTSensorEventAutoClickerStartDurationID];
                            //cp开始计时
//                            [SMDurationEventReport finishReport:GTSensorEventAutoClickerStartDuration];
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
                                [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKRecordWindowQuitSchemeNotification object:nil];
                                //移除绘制view
                                [[GTRecordView recordView] remove];
                                
                                [[GTRecordWindowManager shareInstance] recordWindowHide];
                                [GTRecordWindowManager shareInstance].schemeModel = nil;
//                                [GTRecordWindowManager shareInstance].isAllPointShow = NO;
//                                [GTRecordWindowManager shareInstance].lastClickJsonString = @"";
                                [selfWeak.bottomHotSpotView hide];
                                [[GTDialogWindowManager shareInstance] dialogWindowHide];
                            }];
                            [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
                            [[GTDialogWindowManager shareInstance] dialogWindowShow];
                            
                            //连点器启动时长埋点（结束计时）
                            //神策开始计时
                            [[GTDataTimeCounter sharedInstance] end:GTSensorEventAutoClickerStartDuration];
                            //cp开始计时
//                            [SMDurationEventReport finishReport:GTSensorEventAutoClickerStartDuration];
                        }
                    }
                        break;
                    case RecordWindowStateFutureCountdown: {   //暂停倒计时，退出方案弹窗
                        selfWeak.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - hideHotView_height / 2 -  SAFE_AREA_BOTTOM);
                        [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.countdownTimer.fireDate = [NSDate distantFuture];
                        //判断是否修改方案
                        if ([[[GTRecordWindowManager shareInstance].schemeModel modelToJSONString] isEqualToString:[GTRecordWindowManager shareInstance].schemeJsonString]) {
                            [selfWeak.bottomHotSpotView hide];
                            //发送通知给悬浮弹窗，从方案设置页返回到方案列表页
                            [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKRecordWindowQuitSchemeNotification object:nil];
                            //移除绘制view
                            [[GTRecordView recordView] remove];
                            
                            [[GTRecordWindowManager shareInstance] recordWindowHide];
                            [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView = nil;
                            
                            [GTRecordWindowManager shareInstance].schemeModel = nil;
//                            [GTRecordWindowManager shareInstance].isAllPointShow = NO;
//                            [GTRecordWindowManager shareInstance].lastClickJsonString = @"";
                            [GTRecordManager shareInstance].isPlayback = NO;
                            //弹出toast
                            [[GTSDKUtils getTopWindow].view makeToast:localString(@"在工具箱中可以重新唤起连点器") duration:0.5 position:CSToastPositionCenter];
                            
                            //连点器启动时长埋点（结束计时）
                            //神策开始计时
                            [[GTDataTimeCounter sharedInstance] end:GTSensorEventAutoClickerStartDuration];
                            //cp开始计时
//                            [SMDurationEventReport finishReport:GTSensorEventAutoClickerStartDuration];
                        }else {
                            GTDialogView *dialogView = [[GTDialogView alloc] initWithStyle:DialogViewStyleDefault
                                                                                     title:localString(@"温馨提示")
                                                                                   content:localString(@"当前方案未保存，是否确认退出")
                                                                           leftButtonTitle:@"取消"
                                                                          rightButtonTitle:@"退出"
                                                                           leftButtonBlock:^{
                                [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView.countdownTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
                                //熄灭
                                [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView startDark];
                                [selfWeak.bottomHotSpotView hide];
                                [[GTDialogWindowManager shareInstance] dialogWindowHide];
                            }
                                                                          rightButtonBlock:^{
                                //发送通知给悬浮弹窗，从方案设置页返回到方案列表页
                                [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKRecordWindowQuitSchemeNotification object:nil];
                                //移除绘制view
                                [[GTRecordView recordView] remove];
                                
                                [[GTRecordWindowManager shareInstance] recordWindowHide];
                                [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView = nil;
                                
                                [GTRecordWindowManager shareInstance].schemeModel = nil;
//                                [GTRecordWindowManager shareInstance].isAllPointShow = NO;
//                                [GTRecordWindowManager shareInstance].lastClickJsonString = @"";
                                [GTRecordManager shareInstance].isPlayback = NO;
                                [selfWeak.bottomHotSpotView hide];
                                [[GTDialogWindowManager shareInstance] dialogWindowHide];
                                
                                //连点器启动时长埋点（结束计时）
                                //神策开始计时
                                [[GTDataTimeCounter sharedInstance] end:GTSensorEventAutoClickerStartDuration];
                                //cp开始计时
//                                [SMDurationEventReport finishReport:GTSensorEventAutoClickerStartDuration];
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
