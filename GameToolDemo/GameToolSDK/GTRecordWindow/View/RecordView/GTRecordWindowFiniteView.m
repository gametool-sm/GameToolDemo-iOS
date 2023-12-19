//
//  GTRecordWindowFiniteView.m
//  GTSDK
//
//  Created by shangmi on 2023/10/23.
//

#import "GTRecordWindowFiniteView.h"
#import "GTClickerWindowManager.h"
#import "GTFloatingWindowManager.h"
#import "GTFloatingBallManager.h"
#import "GTRecordManager.h"
#import "GTRecordWindowAnimatiion.h"
#import "NSString+Custom.h"
#import "GTSDKConfig.h"
#import "UIButton+Extent.h"

@interface GTRecordWindowFiniteView ()

@property (nonatomic, strong) UIButton *setButton;
@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) UILabel *loopLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *waitTimeLabel;
@property (nonatomic, strong) UILabel *durationDetailLabel;

@property (nonatomic, strong) GTClickerSchemeModel *schemeModel;

//计时计时器
@property (nonatomic, strong, nullable) NSTimer *timer;
//方案耗时
@property (nonatomic, assign) int schemeTime;

@end

@implementation GTRecordWindowFiniteView

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    
    self.loopNum = 1;
    
    [self addSubview:self.setButton];
    [self addSubview:self.startButton];
    [self addSubview:self.loopDetailLabel];
    [self addSubview:self.loopLabel];
    [self addSubview:self.durationLabel];
    [self addSubview:self.waitTimeLabel];
    [self addSubview:self.durationDetailLabel];
    [self addSubview:self.waitTimeDetailLabel];
    
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(6 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.setButton.mas_right).offset(2 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
    [self.loopDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startButton.mas_right).offset(2 * WIDTH_RATIO);
        make.top.equalTo(self.mas_top).offset(8 * WIDTH_RATIO);
        make.width.mas_equalTo(38 * WIDTH_RATIO);
        make.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    
    [self.loopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startButton.mas_right).offset(2 * WIDTH_RATIO);
        make.top.equalTo(self.loopDetailLabel.mas_bottom).offset(3 * WIDTH_RATIO);
        make.width.mas_equalTo(38 * WIDTH_RATIO);
        make.height.mas_equalTo(15 * WIDTH_RATIO);
    }];                               
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loopDetailLabel.mas_right).offset(8 * WIDTH_RATIO);
        make.top.equalTo(self.mas_top).offset(8 * WIDTH_RATIO);
        make.width.mas_equalTo(25 * WIDTH_RATIO);
        make.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    
    [self.waitTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loopLabel.mas_right).offset(8 * WIDTH_RATIO);
        make.top.equalTo(self.durationLabel.mas_bottom).offset(3 * WIDTH_RATIO);
        make.width.mas_equalTo(25 * WIDTH_RATIO);
        make.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    
    [self.durationDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.durationLabel.mas_right).offset(3 * WIDTH_RATIO);
        make.centerY.equalTo(self.durationLabel.mas_centerY);
        make.height.mas_equalTo(14 * WIDTH_RATIO);
    }];
    
    [self.waitTimeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waitTimeLabel.mas_right).offset(3 * WIDTH_RATIO);
        make.centerY.equalTo(self.waitTimeLabel.mas_centerY);
        make.height.mas_equalTo(14 * WIDTH_RATIO);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(abnormalExit:)
                                                 name:GTSDKAbnormalExitNotification
                                               object:nil];
}

- (void)abnormalExit: (NSNotification *)noti {
    if ([GTRecordManager shareInstance].isPlayback) {
        int planID = [[GTRecordWindowManager shareInstance].schemeJsonString isEqualToString:@""]?0:-3;
        
        NSDictionary *parDict = @{@"plan_id" : [NSNumber numberWithInt:planID],
                                  @"circle_way" : [NSNumber numberWithInt:1],
                                  @"set_circle_times" : [NSNumber numberWithInt:self.schemeModel.cycleIndex],
                                  @"real_circle_times" :  [NSNumber numberWithInt:self.loopNum]};
        [[NSUserDefaults standardUserDefaults] setObject:parDict forKey:GTSensorEventAutoClickerRunTimes];
    }
}

- (void)updateData:(GTClickerSchemeModel *)model {
    self.schemeModel = model;
    
    self.schemeTime = model.recordEndTime - model.recordStartTime;
    self.durationDetailLabel.text = [NSString secondsConversionTime:self.schemeTime];
    
    self.waitTime = [[NSString stringWithFormat:@"%.3f",[[GTRecordManager shareInstance] timeIntervalBeforeFirstLineSchemeJsonStr:[[GTRecordWindowManager shareInstance].schemeModel modelToJSONString]]] floatValue];
    self.waitTimeDetailLabel.text = [NSString millisecondConversionTime:self.waitTime];
    
    if (![GTRecordManager shareInstance].isPlayback) {
        switch (model.startMethod) {
            case ClickerWindowStartMethodNow: {
                [self.startButton setTitle:localString(@"回放") forState:UIControlStateNormal];
            }
                break;
            case ClickerWindowStartMethodPreset: {
                [self.startButton setTitle:localString(@"定时回放") forState:UIControlStateNormal];
            }
                break;
            case ClickerWindowStartMethodCountdown: {
                [self.startButton setTitle:localString(@"定时回放") forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        [self.startButton setImage:[[GTThemeManager share] imageWithName:@"record_window_playback_btn"] forState:UIControlStateNormal];
        [self.setButton setImage:[[GTThemeManager share] imageWithName:@"record_window_set_btn"] forState:UIControlStateNormal];
        [self.setButton setTitle:@"设置" forState:UIControlStateNormal];
        
        self.loopNum = 1;
    }else {
        if ([GTRecordManager shareInstance].isRu) {
            [self.startButton setImage:[[GTThemeManager share] imageWithName:@"record_window_pause_btn"] forState:UIControlStateNormal];
            [self.startButton setTitle:localString(@"暂停") forState:UIControlStateNormal];
        }else {
            [self.startButton setImage:[[GTThemeManager share] imageWithName:@"record_window_start_btn"] forState:UIControlStateNormal];
            [self.startButton setTitle:localString(@"继续") forState:UIControlStateNormal];
        }
        [self.setButton setImage:[[GTThemeManager share] imageWithName:@"record_window_finish_btn"] forState:UIControlStateNormal];
        [self.setButton setTitle:@"结束" forState:UIControlStateNormal];
    }
    
    self.loopDetailLabel.text = [NSString stringWithFormat:@"%d/%d", self.loopNum, model.cycleIndex];
//    self.loopDetailLabel.text = [NSString stringWithFormat:@"999/999", self.loopNum, model.cycleIndex];
    
    [self updateSize];
}

//对齐按钮和文字
- (void)updateSize {
    [self.setButton layoutButtonWithImageTitleSpace:2];
    [self.startButton layoutButtonWithImageTitleSpace:2];
}

#pragma mark - 距离下一次动作的时间倒计时计时器

//开始距离下一次动作的时间倒计时计时器
- (void)startWaitTimer {
//    [self.waitTimer invalidate];
//    self.waitTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateWaitTime:) userInfo:@(self.waitTime) repeats:YES];
    self.waitDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWaitTime:)];
    [self.waitDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

//移除距离下一次动作的时间倒计时计时器
- (void)removeWaitTimer {
    [self.waitDisplayLink invalidate];
    self.waitDisplayLink = nil;
}

- (void)updateWaitTime:(CADisplayLink *)displayLink {
    // 更新计时时间
    self.waitTime -= displayLink.duration;
    if (self.waitTime < 0) {
        self.waitTime = 0;
        self.waitTimeDetailLabel.text = [NSString millisecondConversionTime:0];;
        
        [self removeWaitTimer];
        return;;
    }
    
    self.waitTimeDetailLabel.text = [NSString millisecondConversionTime:self.waitTime];;
}

#pragma mark - 计时计时器

- (void)startTimer {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeNumber:) userInfo:@(self.timeNumber) repeats:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

// 更新计时
- (void)updateTimeNumber:(NSTimer *)timer {
    // 更新计时时间
    self.timeNumber ++;
    
    self.durationDetailLabel.text = [NSString secondsConversionTime:self.timeNumber];
}

#pragma mark - response

- (void)setClick {
    if (![GTRecordManager shareInstance].isPlayback) {    //设置
        [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKRecordWindowTapSetNotification object:self userInfo:nil];
        
        [[GTFloatingBallManager shareInstance] floatingBallHide];
        [[GTRecordWindowManager shareInstance] recordWindowHide];
        [[GTFloatingWindowManager shareInstance] floatingWindowShow];
    }else {                 //结束
        //连点器运行次数埋点
        if ([[GTRecordWindowManager shareInstance].schemeJsonString isEqualToString:@""]) {
            [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventAutoClickerRunTimes andProperties:@{
                @"plan_id" : [NSNumber numberWithInt:0],
                @"circle_way" : [NSNumber numberWithInt:1],
                @"set_circle_times" : [NSNumber numberWithInt:self.schemeModel.cycleIndex],
                @"real_circle_times" : [NSNumber numberWithInt:self.loopNum]
            } shouldFlush:YES];
        }else {
            [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventAutoClickerRunTimes andProperties:@{
                @"plan_id" : [NSNumber numberWithInt:-3],
                @"circle_way" : [NSNumber numberWithInt:1],
                @"set_circle_times" : [NSNumber numberWithInt:self.schemeModel.cycleIndex],
                @"real_circle_times" : [NSNumber numberWithInt:self.loopNum]
            } shouldFlush:YES];
        }
        
        //连点器使用时长埋点（结束计时）
        //神策结束计时
        [[GTDataTimeCounter sharedInstance] end:GTSensorEventAutoClickerRunDurationID];
        //cp结束计时
        [SMDurationEventReport finishReport:GTSensorEventAutoClickerRunDuration];
        
        [self finishScheme];
    }
    [self updateSize];
}

- (void)startClick {
    switch (self.schemeModel.startMethod) {
        case ClickerWindowStartMethodNow: {         //立即回放
            if ([GTRecordManager shareInstance].isPlayback) { //继续或暂停
                if ([GTRecordManager shareInstance].isRu) {    //暂停
                    [self pauseScheme];
                    
                    //神策埋点暂停计时
                    [[GTDataTimeCounter sharedInstance] stop:YES type:GTSensorEventAutoClickerRunDurationID];
                    //cp埋点暂停计时
                    [SMDurationEventReport pauseReport:GTSensorEventAutoClickerRunDuration];
                }else {             //继续
                    [self continueScheme];
                    
                    //神策埋点继续计时
                    [[GTDataTimeCounter sharedInstance] stop:NO type:GTSensorEventAutoClickerRunDurationID];
                    //cp埋点继续计时
                    [SMDurationEventReport continueReport:GTSensorEventAutoClickerRunDuration];
                }
            }else {             //开始回放
                self.timeNumber = 0;
                [self startScheme];
                
                int planID = [[GTRecordWindowManager shareInstance].schemeJsonString isEqualToString:@""]?0:-3;
                //工具箱元素点击埋点
                [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:planID],  @"toolbox_click_type" : [NSNumber numberWithInt:6]} shouldFlush:YES];
                
                //连点器使用时长埋点（开始计时）
                //神策开始计时
                GTSensorEventAutoClickerRunDurationID = [[GTDataTimeCounter sharedInstance] start:GTSensorEventAutoClickerRunDuration externParam:@{@"kEventName" : @"AutoClickerRunDuration", @"kProperties" : @{@"plan_id":[NSNumber numberWithInt:planID]}, @"kPresetCountdownTime" : @0}];
                //cp开始计时
                [SMDurationEventReport startReport:ToolTypeClicker eventName:GTSensorEventAutoClickerRunDuration params:@{}];
                
            }
        }
            break;
        case ClickerWindowStartMethodPreset:
        case ClickerWindowStartMethodCountdown: {       //定时回放
            if ([GTRecordManager shareInstance].isPlayback) { //继续或暂停
                if ([GTRecordManager shareInstance].isRu) {    //暂停
                    [self pauseScheme];
                    
                    //神策埋点暂停计时
                    [[GTDataTimeCounter sharedInstance] stop:YES type:GTSensorEventAutoClickerRunDurationID];
                    //cp埋点暂停计时
                    [SMDurationEventReport pauseReport:GTSensorEventAutoClickerRunDuration];
                }else {             //继续
                    [self continueScheme];
                    
                    //神策埋点继续计时
                    [[GTDataTimeCounter sharedInstance] stop:NO type:GTSensorEventAutoClickerRunDurationID];
                    //cp埋点继续计时
                    [SMDurationEventReport continueReport:GTSensorEventAutoClickerRunDuration];
                }
            }else {             //开始回放
                self.timeNumber = 0;
                [GTRecordManager shareInstance].isPlayback = YES;
                [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureCountdown;
                [GTRecordWindowAnimatiion recordWindowFutureFiniteToFutureCountdownAnimationWithCompletion:^{
                }];
                
                int planID = [[GTRecordWindowManager shareInstance].schemeJsonString isEqualToString:@""]?0:-3;
                //倒计时总时间
                __block int countdownTime;
                if (self.schemeModel.startMethod == ClickerWindowStartMethodCountdown) {
                    //倒计时
                    countdownTime = [NSDate countDownConvertToSeconds:self.schemeModel.startTime];
                }else {
                    //预约时间
                    countdownTime = [NSDate appointmentTimeConvertToSeconds:self.schemeModel.startTime];
                }
                //工具箱元素点击埋点
                [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:planID],  @"toolbox_click_type" : [NSNumber numberWithInt:6]} shouldFlush:YES];
                
                //加速器使用时长埋点（开始计时）
                //神策开始计时
                GTSensorEventAutoClickerRunDurationID = [[GTDataTimeCounter sharedInstance] start:GTSensorEventAutoClickerRunDuration externParam:@{@"kEventName" : @"AutoClickerRunDuration", @"kProperties" : @{@"plan_id" : [NSNumber numberWithInt:planID]}, @"kPresetCountdownTime" : @(countdownTime)}];
                //cp开始计时
                [SMDurationEventReport startReport:ToolTypeClicker eventName:GTSensorEventAutoClickerRunDuration params:@{@"countdown_time" : @(countdownTime)}];
            }
        }
            break;
        default:
            break;
    }
    [self updateSize];
}

#pragma mark - Control Scheme

- (void)startScheme {
    [GTRecordManager shareInstance].isPlayback = YES;
    
    //开始计时
    [self startTimer];
//    [self startWaitTimer];
    
    [_startButton setImage:[[GTThemeManager share] imageWithName:@"record_window_pause_btn"] forState:UIControlStateNormal];
    [_startButton setTitle:@"暂停" forState:UIControlStateNormal];
    
    [_setButton setImage:[[GTThemeManager share] imageWithName:@"record_window_finish_btn"] forState:UIControlStateNormal];
    [_setButton setTitle:@"结束" forState:UIControlStateNormal];
    //开始回放功能

    [[GTRecordManager shareInstance] startScheme:[[GTClickerWindowManager shareInstance].schemeModel modelToJSONString]];
    
    [self updateSize];
}

- (void)pauseScheme {
    //移除计时
    [self removeTimer];
    [self removeWaitTimer];
    
    [_startButton setImage:[[GTThemeManager share] imageWithName:@"record_window_start_btn"] forState:UIControlStateNormal];
    [_startButton setTitle:@"继续" forState:UIControlStateNormal];
    //暂停回放功能
    [[GTRecordManager shareInstance] pauseScheme];
}

- (void)continueScheme {
    //开始计时
    [self startTimer];
//    [self startWaitTimer];
    
    [_startButton setImage:[[GTThemeManager share] imageWithName:@"record_window_pause_btn"] forState:UIControlStateNormal];
    [_startButton setTitle:@"暂停" forState:UIControlStateNormal];
    //继续回放功能
    [[GTRecordManager shareInstance] continueScheme];
}

- (void)finishScheme {
    [GTRecordManager shareInstance].isPlayback = NO;
    self.timeNumber = 0;

    //移除计时
    [self removeTimer];
    [self removeWaitTimer];

    [_setButton setImage:[[GTThemeManager share] imageWithName:@"record_window_set_btn"] forState:UIControlStateNormal];
    [_setButton setTitle:@"设置" forState:UIControlStateNormal];
    
    [_startButton setImage:[[GTThemeManager share] imageWithName:@"record_window_playback_btn"] forState:UIControlStateNormal];
    switch (self.schemeModel.startMethod) {
        case ClickerWindowStartMethodNow:
            [_startButton setTitle:@"回放" forState:UIControlStateNormal];
            break;
        case ClickerWindowStartMethodPreset:
            [_startButton setTitle:@"定时回放" forState:UIControlStateNormal];
            break;
        case ClickerWindowStartMethodCountdown:
            [_startButton setTitle:@"定时回放" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    self.loopNum = 1;
    self.loopDetailLabel.text = [NSString stringWithFormat:@"%d/%d", self.loopNum, self.schemeModel.cycleIndex];
    self.durationDetailLabel.text = [NSString secondsConversionTime:self.schemeTime];
    self.waitTime = [[NSString stringWithFormat:@"%.3f",[[GTRecordManager shareInstance] timeIntervalBeforeFirstLineSchemeJsonStr:[[GTRecordWindowManager shareInstance].schemeModel modelToJSONString]]] floatValue];
    self.waitTimeDetailLabel.text = [NSString millisecondConversionTime:self.waitTime];
    
    //暂停回放功能
    [[GTRecordManager shareInstance] pauseScheme];
    //移除画布
    [[GTRecordView recordView] remove];
    
    [self updateSize];
}

#pragma mark - setter & getter

- (UIButton *)setButton {
    if (!_setButton) {
        _setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _setButton.adjustsImageWhenHighlighted = NO;
        [_setButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_set_btn"] forState:UIControlStateNormal];
        [_setButton setTitle:localString(@"设置") forState:UIControlStateNormal];
        [_setButton setTitleColor:[UIColor themeColorWithAlpha:0.8] forState:UIControlStateNormal];
        _setButton.titleLabel.font = [UIFont systemFontOfSize:8 *  WIDTH_RATIO];
        _setButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_setButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setButton;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.adjustsImageWhenHighlighted = NO;
        [_startButton setImage:[[GTThemeManager share] imageWithName:@"record_window_playback_btn"] forState:UIControlStateNormal];
        [_startButton setTitle:localString(@"回放") forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor themeColorWithAlpha:0.8] forState:UIControlStateNormal];
        _startButton.titleLabel.font = [UIFont systemFontOfSize:8 *  WIDTH_RATIO];
        _startButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_startButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UILabel *)loopDetailLabel {
    if (!_loopDetailLabel) {
        _loopDetailLabel = [UILabel new];
        _loopDetailLabel.text = @"1/99";
        _loopDetailLabel.textColor = [UIColor themeColor];
        _loopDetailLabel.font = [UIFont systemFontOfSize:10 * WIDTH_RATIO];
        _loopDetailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _loopDetailLabel;
}

- (UILabel *)loopLabel {
    if (!_loopLabel) {
        _loopLabel = [UILabel new];
        _loopLabel.text = localString(@"循环");
        _loopLabel.textColor = [UIColor themeColor];
        _loopLabel.font = [UIFont systemFontOfSize:10 * WIDTH_RATIO];
        _loopLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _loopLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel new];
        _durationLabel.text = localString(@"总计");
        _durationLabel.textColor = [UIColor themeColor];
        _durationLabel.font = [UIFont systemFontOfSize:10 * WIDTH_RATIO];
        _durationLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _durationLabel;
}

- (UILabel *)waitTimeLabel {
    if (!_waitTimeLabel) {
        _waitTimeLabel = [UILabel new];
        _waitTimeLabel.text = localString(@"等待");
        _waitTimeLabel.textColor = [UIColor themeColor];
        _waitTimeLabel.font = [UIFont systemFontOfSize:10 * WIDTH_RATIO];
        _waitTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _waitTimeLabel;
}

- (UILabel *)durationDetailLabel {
    if (!_durationDetailLabel) {
        _durationDetailLabel = [UILabel new];
        _durationDetailLabel.text = @"00:00:00";
        _durationDetailLabel.textColor = [UIColor themeColor];
        _durationDetailLabel.font = [UIFont systemFontOfSize:10 * WIDTH_RATIO];
        _durationDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _durationDetailLabel;
}

- (UILabel *)waitTimeDetailLabel {
    if (!_waitTimeDetailLabel) {
        _waitTimeDetailLabel = [UILabel new];
        _waitTimeDetailLabel.text = @"00:00:00";
        _waitTimeDetailLabel.textColor = [UIColor themeColor];
        _waitTimeDetailLabel.font = [UIFont systemFontOfSize:10 * WIDTH_RATIO];
        _waitTimeDetailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _waitTimeDetailLabel;
}

@end

