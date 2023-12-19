//
//  GTSetWhenSelectedView.m
//  GTSDK
//
//  Created by shangmi on 2023/6/29.
//

#import "GTSetWhenSelectedView.h"
#import "UIButton+Extent.h"

@interface GTSetWhenSelectedView ()

//自动贴边
@property (nonatomic, strong) UILabel *autoHideLabel;
@property (nonatomic, strong) UIButton *autoHideTipButton;

//倍率快捷切换
@property (nonatomic, strong) UILabel *multiplyingLabel;
@property (nonatomic, strong) UIButton *multiplyingTipButton;
@property (nonatomic, strong) GTSwitch *multiplyingSwitch;
//当前配置
@property (nonatomic, strong) UILabel *currentConfigLabel;
@property (nonatomic, strong) UIImageView *currentConfigArrowImg;
@property (nonatomic, strong) UIButton *currentConfigButton;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation GTSetWhenSelectedView

#pragma mark - override

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    
    self.backgroundColor = [GTThemeManager share].colorModel.speed_up_set_box_bg_color;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        [view removeFromSuperview];
        view = nil;
    }
    
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.autoHideLabel];
    [self addSubview:self.autoHideTipButton];
    [self addSubview:self.autoHideSwitch];
    
    [self addSubview:self.multiplyingLabel];
    [self addSubview:self.multiplyingTipButton];
    [self addSubview:self.multiplyingSwitch];
    
    [self addSubview:self.currentConfigLabel];
    [self addSubview:self.currentConfigArrowImg];
    [self addSubview:self.currentConfigButton];
    
    [self.autoHideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(43 * WIDTH_RATIO);
    }];
    
    [self.autoHideTipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.autoHideLabel.mas_right).offset(2 * WIDTH_RATIO);
        make.centerY.equalTo(self.autoHideLabel.mas_centerY);
        make.width.mas_equalTo(15 * WIDTH_RATIO);
        make.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    
    [self.autoHideSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.autoHideLabel.mas_centerY);
        make.width.mas_equalTo(42 * WIDTH_RATIO);
        make.height.mas_equalTo(23 * WIDTH_RATIO);
    }];
    
    [self.multiplyingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.autoHideLabel.mas_bottom);
        make.height.mas_equalTo(43 * WIDTH_RATIO);
    }];
    
    [self.multiplyingTipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.multiplyingLabel.mas_right).offset(2 * WIDTH_RATIO);
        make.centerY.equalTo(self.multiplyingLabel.mas_centerY);
        make.width.mas_equalTo(15 * WIDTH_RATIO);
        make.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    
    [self.multiplyingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.multiplyingLabel.mas_centerY);
        make.width.mas_equalTo(42 * WIDTH_RATIO);
        make.height.mas_equalTo(23 * WIDTH_RATIO);
    }];
    
    [self.currentConfigLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.multiplyingLabel.mas_bottom).offset(12 * WIDTH_RATIO);
        make.height.mas_equalTo(18 * WIDTH_RATIO);
    }];
    
    [self.currentConfigArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.multiplyingLabel.mas_bottom).offset(29 * WIDTH_RATIO);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(10 * WIDTH_RATIO);
        make.height.mas_equalTo(10 * WIDTH_RATIO);
    }];
    
    [self.currentConfigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.multiplyingLabel.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self initLabel];
}

- (void)initLabel {
    UIView * __block lastView = [UIView new];
    @WeakObj(self);
    self.dataArray = [GTSDKUtils getCurrentMultiplying];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GTMultiplyingModel *model = (GTMultiplyingModel *)self.dataArray[idx];
        
        UIView *view = [UIView new];
        view.layer.cornerRadius = 6 * WIDTH_RATIO;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [GTThemeManager share].colorModel.speed_up_set_mul_bg_color;
        [selfWeak addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (idx == 0) {
                make.left.equalTo(selfWeak.currentConfigLabel.mas_left);
            }else {
                make.left.equalTo(lastView.mas_right).offset(3 * WIDTH_RATIO);
            }
            make.top.equalTo(selfWeak.currentConfigLabel.mas_bottom).offset(5 * WIDTH_RATIO);
            make.height.mas_equalTo(20 * WIDTH_RATIO);
        }];
        
        lastView = view;
        
        UIImageView *img = [UIImageView new];
        img.image = [[GTThemeManager share] imageWithName:@"small_mul_img"];
        [selfWeak addSubview:img];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(5 * WIDTH_RATIO);
            make.centerY.equalTo(view.mas_centerY);
            make.width.mas_equalTo(6 * WIDTH_RATIO);
            make.height.mas_equalTo(14 * WIDTH_RATIO);
        }];
        
        UILabel *label = [UILabel new];
        label.text =  [NSString getSpeedText:model];
        label.textColor = [GTThemeManager share].colorModel.textColor;
        label.font = [UIFont systemFontOfSize:12 * WIDTH_RATIO];
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(img.mas_right).offset(1 * WIDTH_RATIO);
            make.right.equalTo(view.mas_right).offset(-5 * WIDTH_RATIO);
        }];
    }];
}

#pragma mark - response

- (void)autoHideTipClick:(UIButton *)sender {
    if (self.clickTipBlock) {
        self.clickTipBlock([NSString stringWithFormat:@"%ld", (long)sender.tag]);
    }
}

- (void)multiplyingTipClick:(UIButton *)sender {
    if (self.clickTipBlock) {
        self.clickTipBlock([NSString stringWithFormat:@"%ld", (long)sender.tag]);
    }
}

- (void)autoHideSwitchClick:(GTSwitch *)sender {
    [GTSDKUtils saveAutoHideIsOn:sender.isOn];
    
    if (self.clickAutoHideSwitchBlock) {
        self.clickAutoHideSwitchBlock(sender.isOn);
    }
}

- (void)multiplyingSwitchClick:(GTSwitch *)sender {
    [GTSDKUtils saveMultiplyingIsOn:sender.isOn];
    
    //工具箱开关切换埋点
    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxOpenCloseSwitch andProperties:@{
        @"tool_name" : @"加速器",
        @"is_open" : [NSNumber numberWithBool:sender.isOn],
        @"toolbox_openclose_type" : [NSNumber numberWithInt:3]
    } shouldFlush:YES];
    
    if (self.clickMultiplyingSwitchBlock) {
        self.clickMultiplyingSwitchBlock(sender.isOn);
    }
}

- (void)currentConfigClick:(UIButton *)sender {
    if (self.clickCurrentConfigBlock) {
        self.clickCurrentConfigBlock(self.dataArray);
    }
}

#pragma mark - setter & getter

- (UILabel *)autoHideLabel {
    if (!_autoHideLabel) {
        _autoHideLabel = [UILabel new];
        _autoHideLabel.text = @"自动贴边";
        _autoHideLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _autoHideLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
    }
    return _autoHideLabel;
}

- (UIButton *)autoHideTipButton {
    if (!_autoHideTipButton) {
        _autoHideTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _autoHideTipButton.tag = 10001;
        [_autoHideTipButton setImage:[[GTThemeManager share] imageWithName:@"window_tip_btn"] forState:UIControlStateNormal];
        [_autoHideTipButton addTarget:self action:@selector(autoHideTipClick:) forControlEvents:UIControlEventTouchUpInside];
        [_autoHideTipButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    }
    return _autoHideTipButton;
}

- (GTSwitch *)autoHideSwitch {
    if (!_autoHideSwitch) {
        _autoHideSwitch = [GTSwitch new];
        _autoHideSwitch.on = [GTSDKUtils getAutoHideIsOn];
        [_autoHideSwitch addTarget:self action:@selector(autoHideSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _autoHideSwitch;
}


- (UILabel *)multiplyingLabel {
    if (!_multiplyingLabel) {
        _multiplyingLabel = [UILabel new];
        _multiplyingLabel.text = @"倍率快捷切换";
        _multiplyingLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _multiplyingLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
    }
    return _multiplyingLabel;
}

- (UIButton *)multiplyingTipButton {
    if (!_multiplyingTipButton) {
        _multiplyingTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _multiplyingTipButton.tag = 10002;
        [_multiplyingTipButton setImage:[[GTThemeManager share] imageWithName:@"window_tip_btn"] forState:UIControlStateNormal];
        [_multiplyingTipButton addTarget:self action:@selector(multiplyingTipClick:) forControlEvents:UIControlEventTouchUpInside];
        [_multiplyingTipButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    }
    return _multiplyingTipButton;
}

- (GTSwitch *)multiplyingSwitch {
    if (!_multiplyingSwitch) {
        _multiplyingSwitch = [GTSwitch new];
        _multiplyingSwitch.on = [GTSDKUtils getMultiplyingIsOn];
        [_multiplyingSwitch addTarget:self action:@selector(multiplyingSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _multiplyingSwitch;
}

- (UILabel *)currentConfigLabel {
    if (!_currentConfigLabel) {
        _currentConfigLabel = [UILabel new];
        _currentConfigLabel.text = @"当前配置";
        _currentConfigLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _currentConfigLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
    }
    return _currentConfigLabel;
}

- (UIImageView *)currentConfigArrowImg {
    if (!_currentConfigArrowImg) {
        _currentConfigArrowImg = [UIImageView new];
        _currentConfigArrowImg.image = [[GTThemeManager share] imageWithName:@"set_next_btn"];
    }
    return _currentConfigArrowImg;
}

- (UIButton *)currentConfigButton {
    if (!_currentConfigButton) {
        _currentConfigButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_currentConfigButton addTarget:self action:@selector(currentConfigClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentConfigButton;
}

@end
