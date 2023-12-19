//
//  GTSpeedUpSetViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/6/26.
//

#import "GTSpeedUpSetViewController.h"
#import "GTSwitch.h"
#import "GTIntroduceView.h"
#import "GTSetWhenSelectedView.h"
#import "GTTipView.h"
#import "GTSpeedUpMultiplyingSetViewController.h"
#import "GTAnimationDialogView.h"
#import "GTFloatingBallManager.h"
#import "GTFloatingWindowManager.h"
#import "GTDialogWindowManager.h"
#import "GTClickerWindowManager.h"
#import "GTRecordWindowManager.h"
#import "GTRecordManager.h"

#import "GTDialogView.h"

@interface GTSpeedUpSetViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UILabel *simpleTitleLabel;
@property (nonatomic, strong) GTSwitch *switchButton;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) GTIntroduceView *introduceView;
@property (nonatomic, strong) GTSetWhenSelectedView *setWhenSelectedView;

@end

@implementation GTSpeedUpSetViewController

#pragma mark - override

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    
    self.titleLabel.textColor = [GTThemeManager share].colorModel.titleColor;
    
    [self.leftButton setImage:[[GTThemeManager share] imageWithName:@"window_back_btn"] forState:UIControlStateNormal];
    self.simpleTitleLabel.textColor = [GTThemeManager share].colorModel.textColor;
    self.bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_set_box_bg_color;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setUp];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.setWhenSelectedView removeFromSuperview];
    self.setWhenSelectedView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUp {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFloatingBallStyle) name:GTSDKChangeFloatingBallStateNotification object:nil];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.leftButton];
    
    [self.view addSubview:self.simpleTitleLabel];
    [self.view addSubview:self.switchButton];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.introduceView];
    [self.bgView addSubview:self.setWhenSelectedView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.simpleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(56 * WIDTH_RATIO);
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.height.mas_equalTo(21 * WIDTH_RATIO);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.simpleTitleLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20 * WIDTH_RATIO);
        make.width.mas_equalTo(42 * WIDTH_RATIO);
        make.height.mas_equalTo(23 * WIDTH_RATIO);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.simpleTitleLabel.mas_bottom).offset(15 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270 * WIDTH_RATIO);
        if ([GTSDKUtils getExtremelyAustereIsOn]) {
            if ([GTSDKUtils getMultiplyingIsOn]) { //倍率快捷切换是否打开
                make.height.mas_equalTo(162 * WIDTH_RATIO);
            }else {
                make.height.mas_equalTo(94 * WIDTH_RATIO);
            }
        }else {
            make.height.mas_equalTo(176 * WIDTH_RATIO);
        }
    }];
    
    [self.introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(10 * WIDTH_RATIO);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-10 * WIDTH_RATIO);
        make.width.mas_equalTo(246 * WIDTH_RATIO);
        make.centerX.equalTo(self.bgView.mas_centerX);
    }];
    
    [self.setWhenSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(3 * WIDTH_RATIO);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-3 * WIDTH_RATIO);
        make.left.equalTo(self.bgView.mas_left).offset(15 * WIDTH_RATIO);
        make.right.equalTo(self.bgView.mas_right).offset(-15 * WIDTH_RATIO);
    }];
    
    if ([GTSDKUtils getExtremelyAustereIsOn]) {
        self.introduceView.hidden = YES;
        self.setWhenSelectedView.hidden = NO;
    }else {
        self.introduceView.hidden = NO;
        self.setWhenSelectedView.hidden = YES;
    }
    
    @WeakObj(self);
    //点击提示
    self.setWhenSelectedView.clickTipBlock = ^(NSString * _Nonnull str) {
        if ([str isEqualToString:@"10001"]) { //自动贴边提示
            GTTipView *tipView = [[GTTipView alloc]initWithDescText:@"自动贴边" BundleName:[[GTThemeManager share] jsonWithName:@"auto_hide"]];
            [[GTSDKUtils getTopWindow].view addSubview:tipView];
            
        }else if ([str isEqualToString:@"10002"]) { //倍率切换提示
            GTTipView *tipView = [[GTTipView alloc]initWithDescText:@"倍率快捷切换" BundleName:[[GTThemeManager share] jsonWithName:@"multiplying"]];
            [[UIApplication sharedApplication].keyWindow addSubview:tipView];
        }
    };
    //点击当前配置
    self.setWhenSelectedView.clickCurrentConfigBlock = ^(NSArray * _Nonnull dataArray) {
        GTSpeedUpMultiplyingSetViewController *vc = [GTSpeedUpMultiplyingSetViewController new];
        vc.dataArray = [NSMutableArray arrayWithArray:dataArray];
        [selfWeak.navigationController pushViewController:vc animated:NO];
    };
    
    self.setWhenSelectedView.clickAutoHideSwitchBlock = ^(BOOL isOn) {
        if ([GTSDKUtils isfirstOpenAutoHide] && isOn) {
            [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateHideHalf;
            [GTFloatingBallManager shareInstance].floatingBallLuminance = FloatingBallLuminanceDark;
            [GTSDKUtils savefirstOpenAutoHide];
            GTTipView *tipView = [[GTTipView alloc]initWithDescText:@"自动贴边" BundleName:[[GTThemeManager share] jsonWithName:@"auto_hide"]];
            [[GTSDKUtils getTopWindow].view addSubview:tipView];
        }else {
            if (isOn) {
                [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateHideHalf;
                [GTFloatingBallManager shareInstance].floatingBallLuminance = FloatingBallLuminanceDark;
            }else {
                [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateWelt;
                [GTFloatingBallManager shareInstance].floatingBallLuminance = FloatingBallLuminanceLight;
            }
        }
    };
    
    self.setWhenSelectedView.clickMultiplyingSwitchBlock = ^(BOOL isOn) {
        
//注释        [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKChangeFloatingBallStateNotification object:selfWeak];
        //改变状态
        [GTFloatingBallManager shareInstance].floatingBallStyle = FloatingBallStyleControl;
        
        if ([GTSDKUtils isfirstOpenMultiplying] && isOn) {
            [GTSDKUtils savefirstOpenMultiplying];
            GTTipView *tipView = [[GTTipView alloc]initWithDescText:@"倍率快捷切换" BundleName:[[GTThemeManager share] jsonWithName:@"multiplying"]];
            [[GTSDKUtils getTopWindow].view addSubview:tipView];
        }
        
        if (isOn) { //倍率快捷切换打开
            //改变状态
            [GTFloatingBallManager shareInstance].floatingBallStyle = FloatingBallStyleControl;
            
            [selfWeak.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(162 * WIDTH_RATIO);
                make.top.equalTo(selfWeak.simpleTitleLabel.mas_bottom).offset(15 * WIDTH_RATIO);
                make.centerX.equalTo(selfWeak.view.mas_centerX);
                make.width.mas_equalTo(270 * WIDTH_RATIO);
            }];
            [UIView animateWithDuration:0.2 animations:^{
                [selfWeak.view layoutIfNeeded];
            }];
        }else {
            //改变状态
            [GTFloatingBallManager shareInstance].floatingBallStyle = FloatingBallStyleSimpleControl;
            
            [selfWeak.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(94 * WIDTH_RATIO);
                make.top.equalTo(selfWeak.simpleTitleLabel.mas_bottom).offset(15 * WIDTH_RATIO);
                make.centerX.equalTo(selfWeak.view.mas_centerX);
                make.width.mas_equalTo(270 * WIDTH_RATIO);
            }];
            [UIView animateWithDuration:0.2 animations:^{
                [selfWeak.view layoutIfNeeded];
            }];
        }
    };
}

#pragma mark - response

- (void)backClick {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)switchClick:(GTSwitch *)sender {
    [GTSDKUtils saveExtremelyAustereIsOn:sender.isOn];
    
    if ([GTSDKUtils isfirstOpenExtremely]) {
        [GTSDKUtils savefirstOpenExtremely];
        
        self.setWhenSelectedView.autoHideSwitch.on = YES;
    }
    
    //工具箱开关切换埋点
    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxOpenCloseSwitch andProperties:@{
        @"tool_name" : @"加速器",
        @"is_open" : [NSNumber numberWithBool:sender.isOn],
        @"toolbox_openclose_type" : [NSNumber numberWithInt:2]
    } shouldFlush:YES];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKChangeFloatingBallStateNotification object:self];
    
    if (sender.isOn) {
        //改变状态,判断有没有开倍率
        if ([GTSDKUtils getMultiplyingIsOn]) {
            [GTFloatingBallManager shareInstance].floatingBallStyle = FloatingBallStyleControl;
        }else {
            [GTFloatingBallManager shareInstance].floatingBallStyle = FloatingBallStyleSimpleControl;
        }
        //判断有没有开自动贴边
        if ([GTSDKUtils getAutoHideIsOn]) {
            [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateHideHalf;
        }else {
            [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateWelt;
        }

        if ([GTSDKUtils getExtremelyAustereTipShowTimes] < 3) {
            GTAnimationDialogView *dialogView = [[GTAnimationDialogView alloc] initWithTitle:@"长按快速打开加速器" BundleName:[[GTThemeManager share] jsonWithName:@"minimalist_pop_up"] confirm:nil];
            dialogView.alpha = 0;
            dialogView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
            [[GTDialogWindowManager  shareInstance] dialogWindowShow];
            
            //动画
            [UIView animateWithDuration:0.24 animations:^{
                [GTFloatingWindowManager shareInstance].windowWindow.alpha = 0;
            } completion:^(BOOL finished) {
                //隐藏悬浮弹窗
                [[GTFloatingWindowManager shareInstance] floatingWindowHide];
                
                //判断是否显示连点器悬浮窗，如果有方案正在启用中，则显示。否则不显示
                if ([GTClickerWindowManager shareInstance].schemeModel != nil) {
                    [[GTClickerWindowManager shareInstance] clickerWindowShow];
                }else {
                    [[GTClickerWindowManager shareInstance] clickerWindowHide];
                }
                //判断是否显示录制悬浮窗，如果有方案正在启用中，则显示。否则不显示
                if ([GTRecordWindowManager shareInstance].schemeModel != nil) {
                    [[GTRecordWindowManager shareInstance] recordWindowShow];
                }else {
                    if ([GTRecordManager shareInstance].isRecord) {
                        [[GTRecordWindowManager shareInstance] recordWindowShow];
                    }else {
                        [[GTRecordWindowManager shareInstance] recordWindowHide];
                    }
                }
                
                [GTFloatingWindowManager shareInstance].windowWindow.alpha = 1;
            }];
            
            [UIView animateWithDuration:0.12 delay:0.12 options:UIViewAnimationOptionCurveLinear animations:^{
                dialogView.alpha = 1;
                dialogView.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                //隐藏加速悬浮球
                [[GTFloatingBallManager shareInstance] floatingBallHide];
                //隐藏连点器悬浮窗
                [[GTClickerWindowManager shareInstance] clickerWindowHide];
            }];
        }
        
        self.introduceView.hidden = YES;
        self.setWhenSelectedView.hidden = NO;
        [self.bgView bringSubviewToFront:self.setWhenSelectedView];
        
        if ([GTSDKUtils getMultiplyingIsOn]) { //倍率快捷切换是否打开
            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(162 * WIDTH_RATIO);
                make.top.equalTo(self.simpleTitleLabel.mas_bottom).offset(15 * WIDTH_RATIO);
                make.centerX.equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(270 * WIDTH_RATIO);
            }];
        }else {
            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(94 * WIDTH_RATIO);
                make.top.equalTo(self.simpleTitleLabel.mas_bottom).offset(15 * WIDTH_RATIO);
                make.centerX.equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(270 * WIDTH_RATIO);
            }];
        }
    }else {
        [GTFloatingBallManager shareInstance].floatingBallStyle = FloatingBallStyleDefault;
        [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateHideHalf;
        
        self.introduceView.hidden = NO;
        self.setWhenSelectedView.hidden = YES;
        [self.bgView bringSubviewToFront:self.introduceView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(176 * WIDTH_RATIO);
                make.top.equalTo(self.simpleTitleLabel.mas_bottom).offset(15 * WIDTH_RATIO);
                make.centerX.equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(270 * WIDTH_RATIO);
            }];
            [self.view layoutIfNeeded];
        });
    }
    [self.view layoutIfNeeded];
}

#pragma mark - Notification

- (void)updateFloatingBallStyle {
    self.switchButton.on = [GTSDKUtils getExtremelyAustereIsOn];
    
    [GTSDKUtils saveExtremelyAustereIsOn:self.switchButton.isOn];
    
    if ([GTSDKUtils isfirstOpenExtremely]) {
        [GTSDKUtils savefirstOpenExtremely];
        
        self.setWhenSelectedView.autoHideSwitch.on = YES;
    }
        
    if (self.switchButton.isOn) {
        self.introduceView.hidden = YES;
        self.setWhenSelectedView.hidden = NO;
        [self.bgView bringSubviewToFront:self.setWhenSelectedView];
        
        if ([GTSDKUtils getMultiplyingIsOn]) { //倍率快捷切换是否打开
            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(162 * WIDTH_RATIO);
                make.top.equalTo(self.simpleTitleLabel.mas_bottom).offset(15 * WIDTH_RATIO);
                make.centerX.equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(270 * WIDTH_RATIO);
            }];
        }else {
            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(94 * WIDTH_RATIO);
                make.top.equalTo(self.simpleTitleLabel.mas_bottom).offset(15 * WIDTH_RATIO);
                make.centerX.equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(270 * WIDTH_RATIO);
            }];
        }
    }else {
        self.introduceView.hidden = NO;
        self.setWhenSelectedView.hidden = YES;
        [self.bgView bringSubviewToFront:self.introduceView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(176 * WIDTH_RATIO);
                make.top.equalTo(self.simpleTitleLabel.mas_bottom).offset(15 * WIDTH_RATIO);
                make.centerX.equalTo(self.view.mas_centerX);
                make.width.mas_equalTo(270 * WIDTH_RATIO);
            }];
            [self.view layoutIfNeeded];
        });
    }
    [self.view layoutIfNeeded];
}

#pragma mark - setter & getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"设置";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [GTThemeManager share].colorModel.titleColor;
        _titleLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
    }
    return _titleLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[[GTThemeManager share] imageWithName:@"window_back_btn"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UILabel *)simpleTitleLabel {
    if (!_simpleTitleLabel) {
        _simpleTitleLabel = [UILabel new];
        _simpleTitleLabel.text = @"极简模式";
        _simpleTitleLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _simpleTitleLabel.font = [UIFont boldFontOfSize:15 * WIDTH_RATIO];
    }
    return _simpleTitleLabel;
}

- (GTSwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [GTSwitch new];
        _switchButton.on = [GTSDKUtils getExtremelyAustereIsOn];
        [_switchButton addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchButton;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_set_box_bg_color;
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (GTIntroduceView *)introduceView {
    if (!_introduceView) {
        _introduceView = [[GTIntroduceView alloc] initWithDescText:@"加速器是一款合规的软件变速工具，在不影响软件性能的前提下可加快软件运行速度节约操作时间。" bundleName:@"minimalist_mode_Introduction"];;
    }
    return _introduceView;
}

- (GTSetWhenSelectedView *)setWhenSelectedView {
    if (!_setWhenSelectedView) {
        _setWhenSelectedView = [GTSetWhenSelectedView new];
    }
    return _setWhenSelectedView;
}


@end
