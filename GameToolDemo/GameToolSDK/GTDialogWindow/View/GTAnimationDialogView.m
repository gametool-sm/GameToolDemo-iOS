//
//  GTAnimationDialogView.m
//  GTSDK
//
//  Created by shangmi on 2023/7/3.
//

//与悬浮球和悬浮弹窗同一层级
#import "GTAnimationDialogView.h"
#import "GTFloatingBallManager.h"
#import <YYImage.h>
#import "GTFirstOpenMinimalistMask.h"
#import "GTDialogWindowManager.h"
#import "GTClickerWindowManager.h"

@interface GTAnimationDialogView ()

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy)NSString *bundleName;

@property (nonatomic, copy) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *contentImg;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation GTAnimationDialogView

#pragma mark - override

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    
    self.titleLabel.textColor = [GTThemeManager share].colorModel.titleColor;
    self.tipLabel.textColor = [GTThemeManager share].colorModel.textColor;
}

- (instancetype)initWithTitle:(NSString *)title BundleName:(nonnull NSString *)bundleName confirm:(nullable ConfirmButtonBlock)confirmButtonBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.confirmButtonBlock = confirmButtonBlock;
        self.titleText = [title copy];
        self.bundleName = [bundleName copy];
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.bgView];
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.contentImg];
    [self.bgView addSubview:self.checkButton];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.confirmButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(310 * WIDTH_RATIO);
        make.height.mas_equalTo(298 * WIDTH_RATIO);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset( 20 * WIDTH_RATIO);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.height.mas_equalTo(21 * WIDTH_RATIO);
    }];
    
    [self.contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(19 * WIDTH_RATIO);
        make.width.mas_equalTo(262 * WIDTH_RATIO);
        make.height.mas_equalTo(127 * WIDTH_RATIO);
    }];
    
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(110 * WIDTH_RATIO);
        make.top.equalTo(self.contentImg.mas_bottom).offset(15 * WIDTH_RATIO);
        make.width.mas_equalTo(14 * WIDTH_RATIO);
        make.height.mas_equalTo(14 * WIDTH_RATIO);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkButton.mas_right).offset(4 * WIDTH_RATIO);
        make.centerY.equalTo(self.checkButton.mas_centerY);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20 * WIDTH_RATIO);
        make.width.mas_equalTo(200 * WIDTH_RATIO);
        make.height.mas_equalTo(42 * WIDTH_RATIO);
    }];
}

- (void)checkClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

- (void)confirmClick:(UIButton *)sender {
    if (self.checkButton.isSelected) { //如果勾选了下次不再弹出，则直接记作三次
        [GTSDKUtils saveExtremelyAustereTipShowTimes:3];
    }else {
        int num = [GTSDKUtils getExtremelyAustereTipShowTimes];
        [GTSDKUtils saveExtremelyAustereTipShowTimes:num+1];
    }
    
    [[GTDialogWindowManager shareInstance] dialogWindowHide];
    
    if(![GTSDKUtils isShowMinimalistGuideMask] && [GTSDKUtils getExtremelyAustereIsOn]) {
        //第一次打开极简模式，点击确认后添加蒙层
        GTFirstOpenMinimalistMask *firstMask = [[GTFirstOpenMinimalistMask alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [[GTSDKUtils getTopWindow].view addSubview:firstMask];
        
        //引导蒙层上的悬浮球给定状态
        [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateWelt;
        [GTFloatingBallManager shareInstance].floatingBallLuminance = FloatingBallLuminanceLight;
    }
    
    //展示加速器悬浮球
    [[GTFloatingBallManager shareInstance] floatingBallShow];
    //展示连点器悬浮窗
    if ([GTClickerWindowManager shareInstance].schemeModel != nil) {
        [[GTClickerWindowManager shareInstance] clickerWindowShow];
    }
    [GTFloatingBallManager shareInstance].ballWindow.alpha = 1;
    
    [self removeFromSuperview];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        _bgView.layer.cornerRadius = 20 * WIDTH_RATIO;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = self.titleText;
        _titleLabel.textColor = [GTThemeManager share].colorModel.titleColor;
        _titleLabel.font = [UIFont systemFontOfSize:15 * WIDTH_RATIO];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)contentImg {
    if (!_contentImg) {
//        _contentImg = [LOTAnimationView autoDirectoryAnimationNamed:self.bundleName inBundle:[[GTThemeManager share] getGTSDKBundle]];
//        _contentImg.loopAnimation = YES;
        _contentImg = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
        _contentImg.image = [YYImage gt_imageNamed:@"speedup_intro.gif"];
    }
    return _contentImg;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setImage:[[GTThemeManager share] imageWithName:@"window_check_btn_normal"] forState:UIControlStateNormal];
        [_checkButton setImage:[[GTThemeManager share] imageWithName:@"window_check_btn_selected"] forState:UIControlStateSelected];
        [_checkButton addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = @"下次不再弹出";
        _tipLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _tipLabel.font = [UIFont systemFontOfSize:12 * WIDTH_RATIO];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = [UIColor themeColor];
        [_confirmButton setTitle:@"我知道了" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        [_confirmButton setTitleColor:[UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

@end
