//
//  GTClickerWindowStartView.m
//  GTSDK
//
//  Created by shangminet on 2023/9/23.
//

#import "GTClickerWindowStartView.h"
#import "GTClickerWindowManager.h"
#import "GTFloatingWindowManager.h"
#import "GTClickerManager.h"
#import "GTClickerWindowAnimation.h"
#import "GTRecordManager.h"
#import "GTRecordWindowManager.h"

@implementation GTClickerWindowStartView

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.tipLabel.textColor = [GTThemeManager share].colorModel.clicker_pausetext_color;
    [self.pauseSchemeButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_zanting"] forState:UIControlStateNormal];
    self.pauseView.image =[[GTThemeManager share] imageWithName:@"clicker_window_start"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 20 * WIDTH_RATIO;
        self.layer.masksToBounds = YES;
        [self setUp];
    }
    return self;
}

- (void)updateDataWithType:(SchemeActionPageType)type {
    self.schemeActionPageType  = type;
    switch (type) {
        case SchemeActionPageTypeRecord: {
            self.pauseView.image =[[GTThemeManager share] imageWithName:@"record_window_record"];
            self.tipLabel.text = localString(@"录制功能已开启，请点击录制悬浮窗开始录制");
            [self.pauseSchemeButton setTitle:localString(@"退出录制") forState:UIControlStateNormal];
            [self.pauseSchemeButton setImage:[[GTThemeManager share] imageWithName:@"record_window_quit"] forState:UIControlStateNormal];
        }
            break;
        case SchemeActionPageTypeRecording: {
            self.pauseView.image =[[GTThemeManager share] imageWithName:@"clicker_window_start"];
            self.tipLabel.text = localString(@"方案正在录制中，请结束录制后再操作");
            [self.pauseSchemeButton setTitle:localString(@"结束录制") forState:UIControlStateNormal];
            [self.pauseSchemeButton setImage:[[GTThemeManager share] imageWithName:@"record_window_finish"] forState:UIControlStateNormal];
        }
            break;
        case SchemeActionPageTypeClickerPlaying: {
            self.pauseView.image =[[GTThemeManager share] imageWithName:@"clicker_window_start"];
            self.tipLabel.text = localString(@"方案正在运行，请暂停后再设置");
            [self.pauseSchemeButton setTitle:localString(@"暂停方案") forState:UIControlStateNormal];
            [self.pauseSchemeButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_zanting"] forState:UIControlStateNormal];
        }
        case SchemeActionPageTypeRecordPlaying: {
            self.pauseView.image =[[GTThemeManager share] imageWithName:@"clicker_window_start"];
            self.tipLabel.text = localString(@"方案正在运行，请结束运行后再设置");
            [self.pauseSchemeButton setTitle:localString(@"结束运行") forState:UIControlStateNormal];
            [self.pauseSchemeButton setImage:[[GTThemeManager share] imageWithName:@"record_window_finish"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}


- (void)setUp {
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    [self addSubview:self.pauseSchemeButton];
    [self addSubview:self.pauseView];
    [self addSubview:self.tipLabel];

    [self.pauseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120 * WIDTH_RATIO);
        make.height.mas_equalTo(86 * WIDTH_RATIO);
        make.left.mas_equalTo(95 * WIDTH_RATIO);
        make.top.equalTo(self.mas_top).offset(63 * WIDTH_RATIO);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pauseView.mas_centerX);
        make.top.equalTo(self.pauseView.mas_bottom).offset(20 * WIDTH_RATIO);
    }];
    [self.pauseSchemeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(248 * WIDTH_RATIO);
        make.centerX.equalTo(self.pauseView.mas_centerX);
        make.width.mas_equalTo(200 * WIDTH_RATIO);
        make.height.mas_equalTo(42 * WIDTH_RATIO);
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pauseSchemeClick{
    switch (self.schemeActionPageType) {
        case SchemeActionPageTypeRecord: {  //退出录制
            [GTRecordManager shareInstance].isRecord = NO;
            //发送通知给悬浮弹窗，从方案设置页返回到方案列表页
            [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKRecordWindowQuitSchemeNotification object:nil];
            
            if (self.startViewPauseClickBlock) {
                self.startViewPauseClickBlock();
            }
        }
            break;
        case SchemeActionPageTypeRecording: {   //结束录制
            [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView removeTimer];
            [[GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView removeDark];
            
            [GTRecordWindowManager shareInstance].schemeModel = [[GTRecordView recordView] finishRecord];
//            [GTRecordWindowManager shareInstance].schemeJsonString = [[[GTRecordView recordView] finishRecord] modelToJSONString];
            
            
            if ([GTRecordWindowManager shareInstance].schemeModel) {
                [GTRecordManager shareInstance].isRecord = NO;
                [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateNowInfinite;
                
                if (self.startViewPauseClickBlock) {
                    self.startViewPauseClickBlock();
                }
            }else {
                [GTRecordManager shareInstance].isRecord = YES;
                [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateStartRecord;
                //移除绘制view
                [[GTRecordView recordView] remove];
            }
            //发送通知给悬浮弹窗，从方案设置页返回到方案列表页
            [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKRecordFinishRecordNotification object:nil];
            
        }
            break;
        case SchemeActionPageTypeClickerPlaying: {//连点结束运行
            if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateNowStart) {
                if ([GTClickerWindowManager shareInstance].schemeModel.startMethod == ClickerWindowStartMethodNow) {
                    [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateNowReady;
                    [GTClickerWindowAnimation clickerWindowNowStartToNowReadyAnimationWithCompletion:nil];
                }else {
                    [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureReady;
                    [GTClickerWindowAnimation clickerWindowNowStartToFutureReadyAnimationWithCompletion:nil];
                }
            }else if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart) {
                
                [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureReady;
                [GTClickerWindowAnimation clickerWindowFutureStartToFutureReadyAnimationWithCompletion:nil];
            }else if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureDark) {
                
                [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureReady;
                [GTClickerWindowAnimation clickerWindowFutureDarkToFutureReadyAnimationWithCompletion:nil];
            }
            
            //暂停连点器
            [[GTClickerManager shareInstance] pauseScheme];
            
            [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView removeTimer];
            [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView clickerWindowRemoveDark];
            
            if (self.startViewPauseClickBlock) {
                self.startViewPauseClickBlock();
            }
        }
        case SchemeActionPageTypeRecordPlaying: {//录制结束运行
            [GTRecordManager shareInstance].isPlayback = NO;
            
            //连点器运行次数埋点
            if ([[GTRecordWindowManager shareInstance].schemeJsonString isEqualToString:@""]) {
                if ([GTRecordWindowManager shareInstance].schemeModel.cycleIndex) { //未保存有限循环
                    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventAutoClickerRunTimes andProperties:@{
                        @"plan_id" : [NSNumber numberWithInt:0],
                        @"circle_way" : [NSNumber numberWithInt:1],
                        @"set_circle_times" : [NSNumber numberWithInt:[GTRecordWindowManager shareInstance].schemeModel.cycleIndex],
                        @"real_circle_times" :  [NSNumber numberWithInt:[GTRecordWindowManager shareInstance].recordWindowVC.finiteView.loopNum]
                    } shouldFlush:YES];
                }else { //未保存无限循环
                    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventAutoClickerRunTimes andProperties:@{
                        @"plan_id" : [NSNumber numberWithInt:0],
                        @"circle_way" : [NSNumber numberWithInt:2],
                        @"set_circle_times" : [NSNumber numberWithInt:0],
                        @"real_circle_times" :  [NSNumber numberWithInt:[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.loopNum]
                    } shouldFlush:YES];
                }
            }else {
                if ([GTRecordWindowManager shareInstance].schemeModel.cycleIndex) { //已保存有限循环
                    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventAutoClickerRunTimes andProperties:@{
                        @"plan_id" : [NSNumber numberWithInt:-3],
                        @"circle_way" : [NSNumber numberWithInt:1],
                        @"set_circle_times" : [NSNumber numberWithInt:[GTRecordWindowManager shareInstance].schemeModel.cycleIndex],
                        @"real_circle_times" :  [NSNumber numberWithInt:[GTRecordWindowManager shareInstance].recordWindowVC.finiteView.loopNum]
                    } shouldFlush:YES];
                }else { //已保存无限循环
                    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventAutoClickerRunTimes andProperties:@{
                        @"plan_id" : [NSNumber numberWithInt:-3],
                        @"circle_way" : [NSNumber numberWithInt:2],
                        @"set_circle_times" : [NSNumber numberWithInt:0],
                        @"real_circle_times" :  [NSNumber numberWithInt:[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView.loopNum]
                    } shouldFlush:YES];
                }
            }
            
            //连点器使用时长埋点（结束计时）
            //神策结束计时
            [[GTDataTimeCounter sharedInstance] end:GTSensorEventAutoClickerRunDurationID];
            //cp结束计时
            [SMDurationEventReport finishReport:GTSensorEventAutoClickerRunDuration];
            
            //移除计时
            if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdown ||
                [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdownDark) {
                [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView removeTimer];
                [[GTRecordWindowManager shareInstance].recordWindowVC.counntdownView removeDark];
                
                [GTRecordWindowManager shareInstance].recordWindowVC.counntdownView  = nil;
            }
            
            switch ([GTRecordWindowManager shareInstance].schemeModel.startMethod) {
                case ClickerWindowStartMethodNow: {
                    if ([GTRecordWindowManager shareInstance].schemeModel.cycleIndex == 0) {
                        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateNowInfinite;
                        [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView finishScheme];
                    }else {
                        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateNowFinite;
                        [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView finishScheme];
                    }
                }
                    break;
                case ClickerWindowStartMethodPreset:
                case ClickerWindowStartMethodCountdown: {
                    if ([GTRecordWindowManager shareInstance].schemeModel.cycleIndex == 0) {
                        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureInfinite;
                        [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView finishScheme];
                    }else {
                        [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureFinite;
                        [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView finishScheme];
                    }
                }
                    break;
                default:
                    break;
            }
            
            if (self.startViewPauseClickBlock) {
                self.startViewPauseClickBlock();
            }
        }
            break;
        default:
            break;
    }
}

- (UIButton *)pauseSchemeButton {
    if (!_pauseSchemeButton) {
        _pauseSchemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pauseSchemeButton.layer.cornerRadius = 12*WIDTH_RATIO;
        _pauseSchemeButton.layer.masksToBounds = YES;
        [_pauseSchemeButton setBackgroundColor:[UIColor themeColor]];
        
        [_pauseSchemeButton setTitle:localString(@"暂停方案") forState:UIControlStateNormal];
        _pauseSchemeButton.titleLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
        
        [_pauseSchemeButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_zanting"] forState:UIControlStateNormal];
        
        CGFloat spacing = 2.0;
        _pauseSchemeButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        _pauseSchemeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        _pauseSchemeButton.adjustsImageWhenHighlighted = false;
        [_pauseSchemeButton addTarget:self action:@selector(pauseSchemeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseSchemeButton;
}

-(UIImageView *)pauseView{
    if(!_pauseView){
        _pauseView = [UIImageView new];
        _pauseView.backgroundColor = [UIColor clearColor];
        _pauseView.image =[[GTThemeManager share] imageWithName:@"clicker_window_start"];
    }
    return _pauseView;
}
-(UILabel *)tipLabel{
    if(!_tipLabel){
        _tipLabel = [UILabel new];
        _tipLabel.textColor = [GTThemeManager share].colorModel.clicker_pausetext_color;
        _tipLabel.text = localString(@"方案正在运行，请暂停后再设置");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
        
    }
    return _tipLabel;
}
@end


