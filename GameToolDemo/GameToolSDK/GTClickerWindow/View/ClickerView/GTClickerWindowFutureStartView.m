//
//  GTClickerWindowFutureStartView.m
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTClickerWindowFutureStartView.h"
#import "UIButton+Extent.h"
#import "GTClickerWindowManager.h"
#import "GTClickerSchemeModel.h"
#import "GTClickerWindowAnimation.h"
#import "GTClickerWindowAnimation.h"
#import "GTClickerManager.h"
#import "GTClickerWindowBehave.h"
#import "SMEventSensor.h"
#import "UIButton+Extent.h"

@interface GTClickerWindowFutureStartView ()

@property (nonatomic, strong) UIButton *finishButton;
//@property (nonatomic, strong) UILabel *finishLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) int countdownTime;

@property (nonatomic, strong) UIButton *darkFinishButton;

//熄灭计时器
@property (nonatomic, strong) NSTimer *darkTimer;

@end

@implementation GTClickerWindowFutureStartView

- (void)changeTheme:(NSNotification *)noti {
//    [super changeTheme:noti];
    
    if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart) {
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
    if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart) {
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
//        make.right.equalTo(self.mas_right).offset(-5 * WIDTH_RATIO);
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
        
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown:) userInfo:@(self.countdownTime) repeats:YES];
    
    [[GTClickerWindowManager shareInstance] addObserver:self forKeyPath:@"clickerWindowState" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutSubviews {
    if ([GTClickerWindowManager shareInstance].clickerWinWindow.center.x < SCREEN_WIDTH/2) {
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
    [[GTClickerWindowManager shareInstance] removeObserver:self forKeyPath:@"clickerWindowState"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"clickerWindowState"]) {
        if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureDark) {
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
            
            if ([GTClickerWindowManager shareInstance].clickerWinWindow.center.x < SCREEN_WIDTH/2) {
                self.timeLabel.textAlignment = NSTextAlignmentLeft;
                
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
                self.timeLabel.textAlignment = NSTextAlignmentRight;
                
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
        }else if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart) {
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
//                make.right.equalTo(self.mas_right).offset(-5 * WIDTH_RATIO);
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
    
    int hours = self.countdownTime / 3600;
    int minutes = (self.countdownTime % 3600) / 60;
    int seconds = self.countdownTime % 60;
    // 格式化时间为00:00:00格式
    NSString *formattedTime = [NSString stringWithFormat:@"%02d : %02d : %02d", hours, minutes, seconds];
    
    self.timeLabel.text = formattedTime;
}

- (void)removeTimer {
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
}

// 更新倒计时的方法
- (void)updateCountdown:(NSTimer *)timer {
    // 判断倒计时是否已结束
    if (self.countdownTime <= 0) {
        [timer invalidate]; // 停止定时器
        //开始连点器功能
        [self startClicker];
        return;
    }

    // 计算小时、分钟和秒数
    int hours = self.countdownTime / 3600;
    int minutes = (self.countdownTime % 3600) / 60;
    int seconds = self.countdownTime % 60;

    // 格式化时间为00:00:00格式
    NSString *formattedTime = [NSString stringWithFormat:@"%02d : %02d : %02d", hours, minutes, seconds];

    // 输出倒计时时间
    NSLog(@"%@", formattedTime);
    self.timeLabel.text = formattedTime;

    // 更新倒计时的剩余时间
    self.countdownTime--;
}

#pragma mark - 熄灭定时器

//开始熄灭倒计时（只有启动方式为倒计时和立即的才有熄灭状态）
- (void)clickerWindowStartDark {
    // 每次启动计时器前先停止之前的计时器
    [self.darkTimer invalidate];

    // 创建一个1秒钟的计时器
    self.darkTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerExpired) userInfo:nil repeats:NO];
}

//移除会变成熄灭状态的计时器
- (void)clickerWindowRemoveDark {
    [self.darkTimer invalidate];
    self.darkTimer = nil;
}

- (void)timerExpired {
    //定时启动转换为熄灭状态
    [GTClickerWindowAnimation clickerWindowFutureStartToFutureDarkAnimationWithCompletion:^{
    }];
}

#pragma mark - response

- (void)finishClick {
    [self removeTimer];
    [self clickerWindowRemoveDark];
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowPauseNotification object:self userInfo:nil];

    [GTClickerWindowAnimation clickerWindowFutureStartToFutureReadyAnimationWithCompletion:^{
        [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureReady;
    }];
}

- (void)darkFinishClick {
    [self removeTimer];
    [self clickerWindowRemoveDark];
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowPauseNotification object:self userInfo:nil];

    [GTClickerWindowAnimation clickerWindowFutureDarkToFutureReadyAnimationWithCompletion:^{
        [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureReady;
    }];

}

/**
 开始连点器功能
 */
- (void)startClicker {
    if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureStart) {
        [GTClickerWindowAnimation clickerWindowFutureStartToNowStartAnimationWithCompletion:nil];
    }else if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureDark) {
        [GTClickerWindowAnimation clickerWindowFutureDarkToNowStartAnimationWithCompletion:nil];
    }
    
    [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateNowStart;
    
    //开始连点器
    [[GTClickerManager shareInstance] startScheme:[[GTClickerWindowManager shareInstance].schemeModel modelToJSONString]];
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
    }
    return _darkFinishButton;
}

@end
