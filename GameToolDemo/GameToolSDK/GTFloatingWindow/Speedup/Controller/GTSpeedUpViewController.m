//
//  GTSpeedUpViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/6/25.
//

#import "GTSpeedUpViewController.h"
#import "GTSpeedUpSetViewController.h"
#import "GTSpeedUpSliderView.h"
#import "GTSpeedUpManager.h"
#import "GTMotionManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GTUnauthorizedCoverView.h"

#import "GTDialogView.h"

@interface GTSpeedUpViewController ()

@property (nonatomic, strong) GTMultiplyingModel *speedModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *speedModeImg;
@property (nonatomic, strong) UIImageView *speedSymbolImg;
@property (nonatomic, strong) UILabel *speedNumLabel;

@property (nonatomic, strong) GTSpeedUpSliderView *sliderView;

@property (nonatomic, strong) UIView *speedModeBgView;
@property (nonatomic, strong) UIView *speedModeButtonView;
@property (nonatomic, strong) UIButton *speedModeUpButton;
@property (nonatomic, strong) UIButton *speedModeDownButton;

@property (nonatomic, strong) UIButton *controlButton;

@end

@implementation GTSpeedUpViewController

#pragma mark - override

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
        
    self.titleLabel.textColor = [GTThemeManager share].colorModel.textColor;
    
    self.bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_box_bg_color;
    self.bottomView.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_box_bottom_bg_color;
    
    if ([GTThemeManager share].theme == GTSDKThemeTypeLight) {
        self.bgView.layer.shadowColor = [UIColor hexColor:@"#000000" withAlpha:0.07].CGColor;
        self.bgView.layer.shadowOpacity = 0.07f;
        self.bgView.layer.shadowOffset = CGSizeMake(0,0);
        self.bgView.layer.shadowOpacity = 1;
        self.bgView.layer.shadowRadius = 15;
    }else {
        self.bgView.layer.shadowColor = [UIColor clearColor].CGColor;
        self.bgView.layer.shadowOpacity = 0;
        self.bgView.layer.shadowOffset = CGSizeMake(0,0);
        self.bgView.layer.shadowOpacity = 0;
        self.bgView.layer.shadowRadius = 0;
    }
    
    if ([GTThemeManager share].theme == GTSDKThemeTypeLight) {
        self.bottomView.layer.borderWidth = 1.33f;
        self.bottomView.layer.borderColor = [UIColor hexColor:@"#FFFFFF"].CGColor;
    }else {
        self.bottomView.layer.borderWidth = 0;
        self.bottomView.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    self.speedModeBgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_mode_bg_color;
    self.speedModeButtonView.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_mode_btn_color;
    self.controlButton.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_control_color;
    
    [self.rightButton setImage:[[GTThemeManager share] imageWithName:@"window_set_btn"]   forState:UIControlStateNormal];
    
    if (self.speedModel.isUp) {
        [self.speedModeUpButton setImage:[[GTThemeManager share] imageWithName:@"speed_up_btn"] forState:UIControlStateNormal];
        [self.speedModeDownButton setImage:[[GTThemeManager share] imageWithName:@"speed_down_unselected"] forState:UIControlStateNormal];
    }else {
        [self.speedModeUpButton setImage:[[GTThemeManager share] imageWithName:@"speed_up_unselected"] forState:UIControlStateNormal];
        [self.speedModeDownButton setImage:[[GTThemeManager share] imageWithName:@"speed_down_btn"] forState:UIControlStateNormal];
    }

    if (![GTSpeedUpManager shareInstance].isStart) {
        [_controlButton setImage:[[GTThemeManager share] imageWithName:@"speed_start_btn"] forState:UIControlStateNormal];
    }else {
        [_controlButton setImage:[[GTThemeManager share] imageWithName:@"speed_pause_btn"] forState:UIControlStateNormal];
    }
}

#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSpeedInfo) name:GTSDKChangeSpeedInfo object:nil];
    
    [self setUp];
    
    [self.view addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.bgView addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"backgroundColor"]) {
        if (object == self.view && ![[change[@"new"] hexString] isEqualToString:[[GTThemeManager share].colorModel.bgColor hexString]]) {
            self.view.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        }
        if (object == self.bgView && ![[change[@"new"] hexString] isEqualToString:[[GTThemeManager share].colorModel.bgColor hexString]]) {
            self.bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_box_bg_color;
        }
    }
}

- (void)setUp {
    self.speedModel = [[GTSDKUtils getLastSpeedUpOfSpeed] firstObject];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.rightButton];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.bottomView];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.bottomView];
    [self.bgView addSubview:self.speedModeImg];
    [self.bgView addSubview:self.speedSymbolImg];
    [self.bgView addSubview:self.speedNumLabel];
    
    [self.bottomView addSubview:self.sliderView];
    
    [self.view addSubview:self.speedModeBgView];
    [self.speedModeBgView addSubview:self.speedModeButtonView];
    [self.speedModeBgView addSubview:self.speedModeUpButton];
    [self.speedModeBgView addSubview:self.speedModeDownButton];
    
    [self.view addSubview:self.controlButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20 * WIDTH_RATIO);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(54 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270 * WIDTH_RATIO);
        make.height.mas_equalTo(177 * WIDTH_RATIO);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.width.mas_equalTo(270 * WIDTH_RATIO);
        make.height.mas_equalTo(50 * WIDTH_RATIO);
    }];
    
    [self.speedModeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.speedModel.isUp) {
            make.top.equalTo(self.bgView.mas_top).offset(45 * WIDTH_RATIO);
            make.left.equalTo(self.bgView.mas_left).offset(83 * WIDTH_RATIO);
        }else {
            make.top.equalTo(self.bgView.mas_top).offset(43 * WIDTH_RATIO);
            make.left.equalTo(self.bgView.mas_left).offset(78 * WIDTH_RATIO);
        }
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
    [self.speedSymbolImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speedModeImg.mas_right).offset(2 * WIDTH_RATIO);
        make.bottom.equalTo(self.speedModeImg.mas_bottom).offset(-2 * WIDTH_RATIO);
        make.width.mas_equalTo(24 * WIDTH_RATIO);
        make.height.mas_equalTo(24 * WIDTH_RATIO);
    }];
    
    [self.speedNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speedSymbolImg.mas_right);
        make.bottom.equalTo(self.speedModeImg.mas_bottom);
        make.height.mas_equalTo(34 * WIDTH_RATIO);
    }];
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.left.equalTo(self.bottomView.mas_left).offset(14 * WIDTH_RATIO);
        make.right.equalTo(self.bottomView.mas_right).offset(-14 * WIDTH_RATIO);
    }];
    
    [self.speedModeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.bottom.equalTo(self.view.mas_bottom).offset(-24 * WIDTH_RATIO);
        make.width.mas_equalTo(72 * WIDTH_RATIO);
        make.height.mas_equalTo(33 * WIDTH_RATIO);
    }];
    [self.speedModeButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.speedModel.isUp) {
            make.left.equalTo(self.speedModeBgView.mas_left).offset(5 * WIDTH_RATIO);
        }else {
            make.right.equalTo(self.speedModeBgView.mas_right).offset(-5 * WIDTH_RATIO);
        }
        make.centerY.equalTo(self.speedModeBgView.mas_centerY);
        make.width.mas_equalTo(30 * WIDTH_RATIO);
        make.height.mas_equalTo(25 * WIDTH_RATIO);
    }];
    [self.speedModeUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speedModeBgView.mas_left).offset(5 * WIDTH_RATIO);
        make.centerY.equalTo(self.speedModeBgView.mas_centerY);
        make.width.mas_equalTo(30 * WIDTH_RATIO);
        make.height.mas_equalTo(25 * WIDTH_RATIO);
    }];
    [self.speedModeDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.speedModeBgView.mas_right).offset(-5 * WIDTH_RATIO);
        make.centerY.equalTo(self.speedModeBgView.mas_centerY);
        make.width.mas_equalTo(30 * WIDTH_RATIO);
        make.height.mas_equalTo(25 * WIDTH_RATIO);
    }];
    
    [self.controlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20 * WIDTH_RATIO);
        make.bottom.equalTo(self.view.mas_bottom).offset(-24 * WIDTH_RATIO);
        make.width.mas_equalTo(33 * WIDTH_RATIO);
        make.height.mas_equalTo(33 * WIDTH_RATIO);
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(12 * WIDTH_RATIO, 12 * WIDTH_RATIO)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = _bottomView.bounds;
    maskLayer.path = maskPath.CGPath;
    _bottomView.layer.mask = maskLayer;
    
    if (![GTSDKConfig getIsSpeedUpFeature]) {
        GTUnauthorizedCoverView *coverView = [GTUnauthorizedCoverView new];
        [self.view addSubview:coverView];
        [self.view bringSubviewToFront:coverView];
        
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.view);
        }];
    }

}

- (void)viewDidLayoutSubviews {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(12.0 * WIDTH_RATIO, 12.0 * WIDTH_RATIO)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bottomView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bottomView.layer.mask = maskLayer;
}

- (void)changeSpeedInfo {
    [GTSpeedUpManager shareInstance].isStart = [GTSDKUtils getSpeedUpControl];
    if (![GTSpeedUpManager shareInstance].isStart) {
        [self.controlButton setImage:[[GTThemeManager share] imageWithName:@"speed_start_btn"] forState:UIControlStateNormal];
    }else {
        [self.controlButton setImage:[[GTThemeManager share] imageWithName:@"speed_pause_btn"] forState:UIControlStateNormal];
    }
}

#pragma mark - response

- (void)setClick {
    GTSpeedUpSetViewController *setVC = [GTSpeedUpSetViewController new];
    [self.navigationController pushViewController:setVC animated:NO];
}

- (void)upClick {
    [self.speedModeButtonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speedModeBgView.mas_left).offset(5 * WIDTH_RATIO);
        make.centerY.equalTo(self.speedModeBgView.mas_centerY);
        make.width.mas_equalTo(30 * WIDTH_RATIO);
        make.height.mas_equalTo(25 * WIDTH_RATIO);
    }];
    [UIView animateWithDuration:0.28 animations:^{
        [self.view layoutIfNeeded];
        self.speedModeUpButton.alpha = 1;
        self.speedModeDownButton.alpha = 0.8;
    }];
    self.sliderView.isUp = YES;
    self.speedModeImg.image = [[GTThemeManager share] imageWithName:@"speed_up_img"];
    
    [self.speedModeUpButton setImage:[[GTThemeManager share] imageWithName:@"speed_up_btn"] forState:UIControlStateNormal];
    [self.speedModeDownButton setImage:[[GTThemeManager share] imageWithName:@"speed_down_unselected"] forState:UIControlStateNormal];
    
    CGFloat upSpeed = [GTSDKUtils getSpeedUpOfUp];
    CGFloat downSpeed = [GTSDKUtils getSpeedUpOfDown];
    int time = (int)fabs((1 - downSpeed) * 10 - (upSpeed - 1));
    
    //得到队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //建立一个定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(0.18* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(timer, start, interval, 0);
    __block NSInteger count = 0;
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
       
//        AudioServicesPlaySystemSound(1519);
        count++;
        if(count == time){
            
            dispatch_cancel(timer);
            
        }
    });
    //因为定时器默认是暂停的因此咱们启动一下
    //启动定时器
    dispatch_resume(timer);
    
    
    
    [UIView animateWithDuration:time * 0.18 animations:^{
        self.sliderView.progress = ([GTSDKUtils getSpeedUpOfUp] - 1) * 0.11;
    }];
    
    self.speedModel.number = [GTSDKUtils getSpeedUpOfUp];
    self.speedModel.isUp = YES;
    
    self.speedModeImg.alpha = 0;
    self.speedNumLabel.alpha = 0;
    self.speedSymbolImg.alpha = 0;
    self.speedModeImg.transform = CGAffineTransformMakeTranslation(0, 21);
    self.speedNumLabel.transform = CGAffineTransformMakeTranslation(0, 21);
    self.speedSymbolImg.transform = CGAffineTransformMakeTranslation(0, 21);
    self.speedNumLabel.text = [NSString getSpeedText:self.speedModel];
    
    [UIView animateWithDuration:0.48 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.speedModeImg.alpha = 1;
        self.speedNumLabel.alpha = 1;
        self.speedSymbolImg.alpha = 1;
        self.speedModeImg.transform = CGAffineTransformMakeTranslation(0, 0);
        self.speedNumLabel.transform = CGAffineTransformMakeTranslation(0, 0);
        self.speedSymbolImg.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
    
    [GTSDKUtils saveSpeedUpOfSpeed:@[self.speedModel]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[GTSDKUtils getCurrentMultiplying]];
    [arr replaceObjectAtIndex:0 withObject:self.speedModel];
    [GTSDKUtils saveCurrentMultiplying:[arr copy]];
}

- (void)downClick {
    [self.speedModeButtonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.speedModeBgView.mas_right).offset(-5 * WIDTH_RATIO);
        make.centerY.equalTo(self.speedModeBgView.mas_centerY);
        make.width.mas_equalTo(30 * WIDTH_RATIO);
        make.height.mas_equalTo(25 * WIDTH_RATIO);
    }];
    [UIView animateWithDuration:0.28 animations:^{
        [self.view layoutIfNeeded];
        self.speedModeUpButton.alpha = 0.8;
        self.speedModeDownButton.alpha = 1;
    }];
    
    self.sliderView.isUp = NO;
    self.speedModeImg.image = [[GTThemeManager share] imageWithName:@"speed_down_img"];
    
    [self.speedModeUpButton setImage:[[GTThemeManager share] imageWithName:@"speed_up_unselected"] forState:UIControlStateNormal];
    [self.speedModeDownButton setImage:[[GTThemeManager share] imageWithName:@"speed_down_btn"] forState:UIControlStateNormal];
    
    CGFloat upSpeed = [GTSDKUtils getSpeedUpOfUp];
    CGFloat downSpeed = [GTSDKUtils getSpeedUpOfDown];
    int time = (int)fabs((1 - downSpeed) * 10 - (upSpeed - 1));
    
    [UIView animateWithDuration:time * 0.18 animations:^{
        self.sliderView.progress = (1 - [GTSDKUtils getSpeedUpOfDown]) * 0.11* 10;
    }];
    
    self.speedModel.number = [GTSDKUtils getSpeedUpOfDown];
    self.speedModel.isUp = NO;
    
    self.speedModeImg.alpha = 0;
    self.speedNumLabel.alpha = 0;
    self.speedSymbolImg.alpha = 0;
    self.speedModeImg.transform = CGAffineTransformMakeTranslation(0, 21);
    self.speedNumLabel.transform = CGAffineTransformMakeTranslation(0, 21);
    self.speedSymbolImg.transform = CGAffineTransformMakeTranslation(0, 21);
    
    self.speedNumLabel.text = [NSString getSpeedText:self.speedModel];
    
    [UIView animateWithDuration:0.48 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.speedModeImg.alpha = 1;
        self.speedNumLabel.alpha = 1;
        self.speedSymbolImg.alpha = 1;
        self.speedModeImg.transform = CGAffineTransformMakeTranslation(0, 0);
        self.speedNumLabel.transform = CGAffineTransformMakeTranslation(0, 0);
        self.speedSymbolImg.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
    
    [GTSDKUtils saveSpeedUpOfSpeed:@[self.speedModel]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[GTSDKUtils getCurrentMultiplying]];
    [arr replaceObjectAtIndex:0 withObject:self.speedModel];
    [GTSDKUtils saveCurrentMultiplying:[arr copy]];
}
    
- (void)controlClick {
    [GTSpeedUpManager shareInstance].isStart = ![GTSpeedUpManager shareInstance].isStart;
    if (![GTSpeedUpManager shareInstance].isStart) {
        //点击后暂停
        [_controlButton setImage:[[GTThemeManager share] imageWithName:@"speed_start_btn"] forState:UIControlStateNormal];
        [GTSpeedUpManager changeSpeed:1];
        
        //工具箱元素点击埋点
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"加速器", @"plan_id" : [NSNumber numberWithInt:-1],  @"toolbox_click_type" : [NSNumber numberWithInt:3]} shouldFlush:YES];
        
        //加速器使用时长埋点（结束计时）
        //神策开始计时
        [[GTDataTimeCounter sharedInstance] end:GTSensorEventGameSpeedUseDurationID];
        //cp开始计时
        [SMDurationEventReport finishReport:GTSensorEventAutoClickerStartDuration];
    }else {
        //点击后开始
        [_controlButton setImage:[[GTThemeManager share] imageWithName:@"speed_pause_btn"] forState:UIControlStateNormal];
        [GTSpeedUpManager changeSpeed:self.speedModel.number];
        
        //工具箱元素点击埋点
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"加速器", @"plan_id" : [NSNumber numberWithInt:-1],  @"toolbox_click_type" : [NSNumber numberWithInt:2]} shouldFlush:YES];
        
        if (self.speedModel.number != 1.0) {
            //加速器使用时长埋点（开始计时）
            //神策开始计时
            GTSensorEventGameSpeedUseDurationID = [[GTDataTimeCounter sharedInstance] start:GTSensorEventGameSpeedUseDuration];
            //cp开始计时
            [SMDurationEventReport startReport:ToolTypeClicker eventName:GTSensorEventAutoClickerStartDuration params:@{}];
        }
    }
    
    [GTSDKUtils saveSpeedUpControl:[GTSpeedUpManager shareInstance].isStart];
}
#pragma mark - setter & getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"加速器";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _titleLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
    }
    return _titleLabel;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[[GTThemeManager share] imageWithName:@"window_set_btn"]   forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_box_bg_color;
        _bgView.layer.cornerRadius = 12 * WIDTH_RATIO;
        _bgView.layer.masksToBounds = NO;
        
        if ([GTThemeManager share].theme == GTSDKThemeTypeLight) {
            _bgView.layer.shadowColor = [UIColor hexColor:@"#000000" withAlpha:0.07].CGColor;
            _bgView.layer.shadowOpacity = 0.07f;
            _bgView.layer.shadowOffset = CGSizeMake(0,0);
            _bgView.layer.shadowOpacity = 1;
            _bgView.layer.shadowRadius = 15;
        }
    }
    return _bgView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_box_bottom_bg_color;
        
        if ([GTThemeManager share].theme == GTSDKThemeTypeLight) {
            _bottomView.layer.borderWidth = 1.33f;
            _bottomView.layer.borderColor = [UIColor hexColor:@"#FFFFFF"].CGColor;
        }
    }
    return _bottomView;
}

- (UIImageView *)speedModeImg {
    if (!_speedModeImg) {
        _speedModeImg = [UIImageView new];
        if (self.speedModel.isUp) {
            _speedModeImg.image = [[GTThemeManager share] imageWithName:@"speed_up_img"];
        }else {
            _speedModeImg.image = [[GTThemeManager share] imageWithName:@"speed_down_img"];
        }
    }
    return _speedModeImg;
}

- (UIImageView *)speedSymbolImg {
    if (!_speedSymbolImg) {
        _speedSymbolImg = [UIImageView new];
        _speedSymbolImg.image = [[GTThemeManager share] imageWithName:@"speed_multiply_img"];
    }
    return _speedSymbolImg;
}

- (UILabel *)speedNumLabel {
    if (!_speedNumLabel) {
        _speedNumLabel = [UILabel new];
        _speedNumLabel.text = [NSString getSpeedText:self.speedModel];
        _speedNumLabel.textColor = [UIColor themeColor];
        _speedNumLabel.font = [UIFont boldSystemFontOfSize:34*WIDTH_RATIO];
    }
    return _speedNumLabel;
}

- (UIView *)speedModeBgView {
    if (!_speedModeBgView) {
        _speedModeBgView = [UIView new];
        _speedModeBgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_mode_bg_color;
        _speedModeBgView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _speedModeBgView.layer.masksToBounds = YES;
    }
    return _speedModeBgView;
}

- (UIView *)speedModeButtonView {
    if (!_speedModeButtonView) {
        _speedModeButtonView = [UIView new];
        _speedModeButtonView.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_mode_btn_color;
        _speedModeButtonView.layer.cornerRadius = 8 * WIDTH_RATIO;
        _speedModeButtonView.layer.masksToBounds = YES;

    }
    return _speedModeButtonView;
}

- (UIButton *)speedModeUpButton {
    if (!_speedModeUpButton) {
        _speedModeUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _speedModeUpButton.adjustsImageWhenHighlighted = NO;
        if (self.speedModel.isUp) {
            [_speedModeUpButton setImage:[[GTThemeManager share] imageWithName:@"speed_up_btn"]  forState:UIControlStateNormal];
        }else {
            [_speedModeUpButton setImage:[[GTThemeManager share] imageWithName:@"speed_up_unselected"]  forState:UIControlStateNormal];
        }
        [_speedModeUpButton addTarget:self action:@selector(upClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedModeUpButton;
}

- (UIButton *)speedModeDownButton {
    if (!_speedModeDownButton) {
        _speedModeDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _speedModeDownButton.adjustsImageWhenHighlighted = NO;
        if (self.speedModel.isUp) {
            [_speedModeDownButton setImage:[[GTThemeManager share] imageWithName:@"speed_down_unselected"]  forState:UIControlStateNormal];
        }else {
            [_speedModeDownButton setImage:[[GTThemeManager share] imageWithName:@"speed_down_btn"]  forState:UIControlStateNormal];
        }
        [_speedModeDownButton addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedModeDownButton;
}

- (UIButton *)controlButton {
    if (!_controlButton) {
        _controlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _controlButton.adjustsImageWhenHighlighted = NO;
        _controlButton.backgroundColor = [GTThemeManager share].colorModel.speed_up_main_control_color;
        _controlButton.layer.cornerRadius = 10 * WIDTH_RATIO;
        _controlButton.layer.masksToBounds = YES;
        
        if (![GTSpeedUpManager shareInstance].isStart) {
            [_controlButton setImage:[[GTThemeManager share] imageWithName:@"speed_start_btn"] forState:UIControlStateNormal];
        }else {
            [_controlButton setImage:[[GTThemeManager share] imageWithName:@"speed_pause_btn"] forState:UIControlStateNormal];
        }
        [_controlButton addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlButton;
}

- (GTSpeedUpSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [GTSpeedUpSliderView new];
        
        if (self.speedModel.isUp) {
            _sliderView.isUp = YES;
            _sliderView.progress = (self.speedModel.number - 1) * 0.11;
        }else {
            _sliderView.isUp = NO;
            _sliderView.progress = (1- self.speedModel.number) * 0.11 * 10;
        }
        
        @WeakObj(self);
        [_sliderView changeValue:^(CGFloat value) {
            NSString *speed = @"";
            if (self->_sliderView.isUp) {
                speed = [NSString stringWithFormat:@"%.0f", value];
            }else {
                speed = [NSString stringWithFormat:@"%.1f", value];
            }
            if (![speed isEqualToString:self.speedNumLabel.text]) {
                AudioServicesPlaySystemSound(1519);
            }
            self.speedNumLabel.text = speed;
        } endValue:^(CGFloat value) {
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"GTSDKSpeedUpOfDown"] && ![[NSUserDefaults standardUserDefaults] objectForKey:@"GTSDKSpeedUpOfUp"]) {//第一次滑动
                [GTSpeedUpManager shareInstance].isStart = YES;
                [GTSDKUtils saveSpeedUpControl:YES];
                [self.controlButton setImage:[[GTThemeManager share] imageWithName:@"speed_pause_btn"] forState:UIControlStateNormal];
            }
            
            NSString *speed = @"";
            if (self->_sliderView.isUp) {
                speed = [NSString stringWithFormat:@"%.0f", value];
//                weakSelf.currentSpeed = [[detailSpeedData objectForKey:[NSString stringWithFormat:@"%.0f",[speed floatValue]]] floatValue];
                [GTSDKUtils saveSpeedUpOfUp:[speed intValue]];
            }else {
                speed = [NSString stringWithFormat:@"%.1f", value];
//                weakSelf.currentSpeed = [[detailSpeedData objectForKey:[NSString stringWithFormat:@"%.2f",[speed floatValue]]] floatValue];
                [GTSDKUtils saveSpeedUpOfDown:value];
            }
            
            if (selfWeak.speedModel.number != [speed floatValue]  && [speed floatValue] != 1) {
                //加速器使用时长埋点（结束计时）
                //神策开始计时
                [[GTDataTimeCounter sharedInstance] end:GTSensorEventGameSpeedUseDurationID];
                //cp开始计时
                [SMDurationEventReport finishReport:GTSensorEventAutoClickerStartDuration];
                
                //加速器使用时长埋点（开始计时）
                //神策开始计时
                GTSensorEventGameSpeedUseDurationID = [[GTDataTimeCounter sharedInstance] start:GTSensorEventGameSpeedUseDuration];
                //cp开始计时
                [SMDurationEventReport startReport:ToolTypeClicker eventName:GTSensorEventAutoClickerStartDuration params:@{}];
            }
            
            selfWeak.speedModel.number = [speed floatValue];
            [GTSDKUtils saveSpeedUpOfSpeed:@[selfWeak.speedModel]];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[GTSDKUtils getCurrentMultiplying]];
            [arr replaceObjectAtIndex:0 withObject:selfWeak.speedModel];
            [GTSDKUtils saveCurrentMultiplying:[arr copy]];
                
            self.speedNumLabel.text = [NSString getSpeedText:self.speedModel];
            
            //传入加速库
            [GTSpeedUpManager changeSpeed:self.speedModel.number];
            
            //加速器倍率调整埋点
            [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventGameSpeedRateAdjust andProperties:@{
                @"rate_adjust_source" : [NSNumber numberWithInt:1],
                @"speed_rate" : [NSNumber numberWithFloat:[speed floatValue]]
            } shouldFlush:YES];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [UIView animateWithDuration:0.32 animations:^{
//                    self.speedNumLabel.alpha = 0;
//                    self.speedNumLabel.transform = CGAffineTransformMakeTranslation(0, -15);
//                } completion:^(BOOL finished) {
//                    self.speedNumLabel.transform = CGAffineTransformMakeTranslation(0, 21);
//                    self.speedNumLabel.text = [NSString getSpeedText:self.speedModel];
//
//                }];
//                [UIView animateWithDuration:0.48 animations:^{
//                    self.speedNumLabel.alpha = 1;
//                    self.speedNumLabel.transform = CGAffineTransformMakeTranslation(0, 0);
//                }];
//            });
            
            
        }];
        
    }
    return _sliderView;
}

@end
