//
//  GTRecordWindowCountdownView.m
//  GTSDK
//
//  Created by shangmi on 2023/10/26.
//

#import "GTRecordWindowCountdownView.h"
#import "GTRecordWindowManager.h"
#import "GTRecordWindowAnimatiion.h"
#import "GTRecordManager.h"
#import "NSString+Custom.h"
#import "UIButton+Extent.h"

@interface GTRecordWindowCountdownView ()

@property (nonatomic, strong) UIButton *finishButton;
//@property (nonatomic, strong) UILabel *finishLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) int countdownTime;

@property (nonatomic, strong) UIButton *darkFinishButton;

//熄灭计时器
@property (nonatomic, strong) NSTimer *darkTimer;

@end

@implementation GTRecordWindowCountdownView

- (void)changeTheme:(NSNotification *)noti {
//    [super changeTheme:noti];
    
    if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdown) {
        self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    }else {
        self.backgroundColor = [UIColor clearColor];
    }
    
    self.lineView.backgroundColor = [GTThemeManager share].colorModel.clicker_future_start_view_line_color;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdown) {
        self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    }else {
        self.backgroundColor = [UIColor clearColor];
    }
    
    [self addSubview:self.finishButton];
//    [self addSubview:self.finishLabel];
    
    [self addSubview:self.lineView];
    
    [self addSubview:self.timeLabel];
    
    [self addSubview:self.darkFinishButton];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(6 * WIDTH_RATIO);
        make.left.equalTo(self.mas_left).offset(6 * WIDTH_RATIO);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
//    [self.finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.finishButton.mas_bottom).offset(1 * WIDTH_RATIO);
//        make.centerX.equalTo(self.finishButton.mas_centerX);
//        make.height.mas_equalTo(11 * WIDTH_RATIO);
//    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.finishButton.mas_right).offset(3 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(1 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(9 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(24 * WIDTH_RATIO);
    }];
    
    [self.darkFinishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(30 * WIDTH_RATIO);
        make.height.mas_equalTo(30 * WIDTH_RATIO);
    }];
    
    [self.finishButton layoutButtonWithImageTitleSpace:2];
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown:) userInfo:@(self.countdownTime) repeats:YES];
    [self startDark];
    
    [[GTRecordWindowManager shareInstance] addObserver:self forKeyPath:@"recordWindowState" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutSubviews {
    if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.darkFinishButton.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(15 * WIDTH_RATIO, 15 * WIDTH_RATIO)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = self.darkFinishButton.bounds;
        maskLayer.path = maskPath.CGPath;
        self.darkFinishButton.layer.mask = maskLayer;
    }else {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.darkFinishButton.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15 * WIDTH_RATIO, 15 * WIDTH_RATIO)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = self.darkFinishButton.bounds;
        maskLayer.path = maskPath.CGPath;
        self.darkFinishButton.layer.mask = maskLayer;
    }
}

- (void)dealloc {
    [self removeTimer];
    [[GTRecordWindowManager shareInstance] removeObserver:self forKeyPath:@"recordWindowState"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"recordWindowState"]) {
        if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdownDark) {
            [GTRecordWindowManager shareInstance].recordWinWindow.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor clearColor];
            self.finishButton.hidden = YES;
            self.darkFinishButton.hidden = NO;
            self.lineView.hidden = YES;
            
            
            self.timeLabel.textColor = [UIColor hexColor:@"#FFFFFF"];
            self.timeLabel.font = [UIFont mediumFontOfSize:14 * WIDTH_RATIO];
            self.timeLabel.layer.shadowOffset = CGSizeMake(0, 0);
            self.timeLabel.layer.shadowRadius = 1 * WIDTH_RATIO;
            self.timeLabel.layer.shadowOpacity = 1;
            self.timeLabel.layer.shadowColor = [UIColor hexColor:@"#000000"].CGColor;
            
            if ([GTRecordWindowManager shareInstance].recordWinWindow.center.x < SCREEN_WIDTH/2) {
                [self.darkFinishButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.mas_left);
                    make.top.equalTo(self.mas_top);
                    make.width.mas_equalTo(30 * WIDTH_RATIO);
                    make.height.mas_equalTo(30 * WIDTH_RATIO);
                }];
                
                [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.darkFinishButton.mas_right).offset(4 * WIDTH_RATIO);
                    make.right.equalTo(self.mas_right);
                    make.centerY.equalTo(self.mas_centerY);
                    make.height.mas_equalTo(30 * WIDTH_RATIO);
                }];
            }else {
                [self.darkFinishButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.mas_right);
                    make.top.equalTo(self.mas_top);
                    make.width.mas_equalTo(30 * WIDTH_RATIO);
                    make.height.mas_equalTo(30 * WIDTH_RATIO);
                }];
                
                [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.darkFinishButton.mas_left).offset(-4 * WIDTH_RATIO);
                    make.left.equalTo(self.mas_left);
                    make.centerY.equalTo(self.mas_centerY);
                    make.height.mas_equalTo(30 * WIDTH_RATIO);
                }];
            }
            
            [self layoutIfNeeded];
        }else if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdown) {
            [GTRecordWindowManager shareInstance].recordWinWindow.backgroundColor = [GTThemeManager share].colorModel.bgColor;
            self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
            self.finishButton.hidden = NO;
            self.darkFinishButton.hidden = YES;
            self.lineView.hidden = NO;
            
            
            self.timeLabel.textColor = [UIColor themeColorWithAlpha:0.8];
            self.timeLabel.font = [UIFont mediumFontOfSize:16 * WIDTH_RATIO];
            self.timeLabel.layer.shadowOffset = CGSizeMake(0, 0);
            self.timeLabel.layer.shadowRadius = 0;
            self.timeLabel.layer.shadowOpacity = 0;
            self.timeLabel.layer.shadowColor = [UIColor hexColor:@"#000000"].CGColor;
            
            [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lineView.mas_right).offset(9 * WIDTH_RATIO);
                make.centerY.equalTo(self.mas_centerY);
                make.height.mas_equalTo(24 * WIDTH_RATIO);
            }];
            
            [self layoutIfNeeded];
        }
    }
}

- (void)updateData:(GTClickerSchemeModel *)model {

    if (model.startMethod == ClickerWindowStartMethodCountdown) {
        //倒计时
        self.countdownTime = [NSDate countDownConvertToSeconds:model.startTime];
    }else {
        //预约时间
        self.countdownTime = [NSDate appointmentTimeConvertToSeconds:model.startTime];
    }
    
    // 格式化时间为00:00:00格式
    NSString *formattedTime = [NSString secondsConversionTime:self.countdownTime];
    
    self.timeLabel.text = formattedTime;
}

- (void)removeTimer {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
}

// 更新倒计时的方法
- (void)updateCountdown:(NSTimer *)timer {
    // 更新倒计时的剩余时间
    self.countdownTime--;
    
    if (self.countdownTime <= 1) {
        [self removeDark]; // 停止定时器
    }
    
    // 判断倒计时是否已结束
    if (self.countdownTime <= 0) {
        [timer invalidate]; // 停止定时器
        //开始录制回放功能
        [self startRecord];
        return;
    }

    // 格式化时间为00:00:00格式
    NSString *formattedTime = [NSString secondsConversionTime:self.countdownTime];

    // 输出倒计时时间
    NSLog(@"%@", formattedTime);
    self.timeLabel.text = formattedTime;
}

#pragma mark - 熄灭定时器

//开始熄灭倒计时（只有启动方式为倒计时和立即的才有熄灭状态）
- (void)startDark {
    // 每次启动计时器前先停止之前的计时器
    [self.darkTimer invalidate];

    // 创建一个1秒钟的计时器
    self.darkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerExpired) userInfo:nil repeats:NO];
}

//移除会变成熄灭状态的计时器
- (void)removeDark {
    [self.darkTimer invalidate];
    self.darkTimer = nil;
}

- (void)timerExpired {
    //定时启动转换为熄灭状态
    [GTRecordWindowAnimatiion recordWindowFutureCountdownToFutureCountdownDarkAnimationWithCompletion:^{
        
    }];
}

#pragma mark - response

- (void)finishClick {
    if ([GTRecordWindowManager shareInstance].recordWindowState != RecordWindowStateFutureCountdown) {
        return;
    }
    
    [self removeTimer];
    [self removeDark];
//    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowPauseNotification object:self userInfo:nil];
    
    [GTRecordManager shareInstance].isPlayback = NO;
    if ([GTRecordWindowManager shareInstance].schemeModel.cycleIndex == 0) {
        [GTRecordWindowAnimatiion recordWindowFutureCountdownToFutureInfiniteAnimationWithCompletion:^{
            
        }];
    }else {
        [GTRecordWindowAnimatiion recordWindowFutureCountdownToFutureFiniteAnimationWithCompletion:^{
            
        }];
    }
    
    //连点器使用时长埋点（结束计时）
    //神策结束计时
    [[GTDataTimeCounter sharedInstance] end:GTSensorEventAutoClickerRunDurationID];
    //cp结束计时
    [SMDurationEventReport finishReport:GTSensorEventAutoClickerRunDuration];
}

- (void)darkFinishClick {
    [self removeTimer];
    [self removeDark];
//    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowPauseNotification object:self userInfo:nil];
    
    [GTRecordManager shareInstance].isPlayback = NO;
    if ([GTRecordWindowManager shareInstance].schemeModel.cycleIndex == 0) {
        [GTRecordWindowAnimatiion recordWindowFutureCountdownDarkToFutureInfiniteAnimationWithCompletion:^{
            
        }];
    }else {
        [GTRecordWindowAnimatiion recordWindowFutureCountdownDarkToFutureFiniteAnimationWithCompletion:^{
            
        }];
    }
    
    //连点器使用时长埋点（结束计时）
    //神策结束计时
    [[GTDataTimeCounter sharedInstance] end:GTSensorEventAutoClickerRunDurationID];
    //cp结束计时
    [SMDurationEventReport finishReport:GTSensorEventAutoClickerRunDuration];
}

/**
 开始录制回放功能
 */
- (void)startRecord {
    [self removeDark];
    
    if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdown) {
        if ([GTRecordWindowManager shareInstance].schemeModel.cycleIndex == 0) {
            [GTRecordWindowAnimatiion recordWindowFutureCountdownToFutureInfiniteAnimationWithCompletion:^{
                [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView startScheme];
                [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView updateSize];
            }];
        }else {
            [GTRecordWindowAnimatiion recordWindowFutureCountdownToFutureFiniteAnimationWithCompletion:^{
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView startScheme];
                [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView updateSize];
            }];
        }
    }else {
        if ([GTRecordWindowManager shareInstance].schemeModel.cycleIndex == 0) {
            [GTRecordWindowAnimatiion recordWindowFutureCountdownDarkToFutureInfiniteAnimationWithCompletion:^{
                [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView startScheme];
                [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView updateSize];
            }];
        }else {
            [GTRecordWindowAnimatiion recordWindowFutureCountdownDarkToFutureFiniteAnimationWithCompletion:^{
                [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView startScheme];
                [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView updateSize];
            }];
        }
    }
    
    
}

#pragma mark - setter & getter

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishButton.adjustsImageWhenHighlighted = NO;
        [_finishButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_finish_btn"] forState:UIControlStateNormal];
        [_finishButton setTitle:localString(@"结束") forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor themeColorWithAlpha:0.8] forState:UIControlStateNormal];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:8 *  WIDTH_RATIO];
        _finishButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_finishButton addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

//- (UILabel *)finishLabel {
//    if (!_finishLabel) {
//        _finishLabel = [UILabel new];
//        _finishLabel.text = localString(@"结束");
//        _finishLabel.textColor = [UIColor themeColorWithAlpha:0.8];
//        _finishLabel.font = [UIFont systemFontOfSize:9 * WIDTH_RATIO];
//        _finishLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _finishLabel;
//}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [GTThemeManager share].colorModel.clicker_future_start_view_line_color;
    }
    return _lineView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor themeColorWithAlpha:0.8];
        _timeLabel.font = [UIFont mediumFontOfSize:16 * WIDTH_RATIO];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UIButton *)darkFinishButton {
    if (!_darkFinishButton) {
        _darkFinishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _darkFinishButton.adjustsImageWhenHighlighted = NO;
        _darkFinishButton.alpha = 0.6;
        _darkFinishButton.hidden = YES;
        _darkFinishButton.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:1];
        [_darkFinishButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_finish_dark_btn"] forState:UIControlStateNormal];
        [_darkFinishButton addTarget:self action:@selector(darkFinishClick) forControlEvents:UIControlEventTouchUpInside];
//        [_darkFinishButton setEnlargeEdgeWithTop:6 right:6 bottom:6 left:6];
    }
    return _darkFinishButton;
}

@end

