//
//  GTToolSetHomeViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/7/18.
//

#import "GTToolSetHomeViewController.h"
#import "GTDialogViewWithInput.h"
#import <YYKit.h>
#import "GTToolSetDebugViewController.h"
#import "GTThemeManager.h"

@interface GTToolSetHomeViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *tapView;

@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UIView *themeBgView;
@property (nonatomic, strong) UIButton *lightButton;
@property (nonatomic, strong) UIButton *darkButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UILabel *lightLabel;
@property (nonatomic, strong) UILabel *darkLabel;
@property (nonatomic, strong) UILabel *followLabel;

@property (nonatomic, strong) UIImageView *checkImg;
@property (nonatomic, strong) UIView *selectedView;

@end

@implementation GTToolSetHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        appearance.backgroundColor = UIColor.whiteColor;
        appearance.shadowColor = UIColor.whiteColor;
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = self.navigationController.navigationBar.standardAppearance;
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    } else {
        self.navigationController.navigationBar.shadowImage = [UIImage new];
    }

    [self setUp];
}

- (void)setUp {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tapView];
    
    [self.view addSubview:self.themeLabel];
    [self.view addSubview:self.themeBgView];
    [self.themeBgView addSubview:self.lightButton];
    [self.themeBgView addSubview:self.darkButton];
    [self.themeBgView addSubview:self.followButton];
    [self.themeBgView addSubview:self.lightLabel];
    [self.themeBgView addSubview:self.darkLabel];
    [self.themeBgView addSubview:self.followLabel];
    [self.themeBgView addSubview:self.checkImg];
    [self.themeBgView addSubview:self.selectedView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right);
        make.width.mas_equalTo(150 * WIDTH_RATIO);
        make.height.mas_equalTo(50 * WIDTH_RATIO);
    }];
    
    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20 * WIDTH_RATIO);
//        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.width.mas_equalTo(270 * WIDTH_RATIO);
        make.height.mas_equalTo(21 * WIDTH_RATIO);
    }];
    
    [self.themeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeLabel.mas_bottom).offset(10 * WIDTH_RATIO);
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.width.mas_equalTo(270 * WIDTH_RATIO);
        make.height.mas_equalTo(105 * WIDTH_RATIO);
    }];
    
    [self.lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeBgView.mas_top).offset(12 * WIDTH_RATIO);
        make.left.equalTo(self.themeBgView.mas_left).offset(12 * WIDTH_RATIO);
        make.width.mas_equalTo(74 * WIDTH_RATIO);
        make.height.mas_equalTo(58 * WIDTH_RATIO);
    }];
    
    [self.darkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeBgView.mas_top).offset(12 * WIDTH_RATIO);
        make.left.equalTo(self.lightButton.mas_right).offset(10 * WIDTH_RATIO);
        make.width.mas_equalTo(74 * WIDTH_RATIO);
        make.height.mas_equalTo(58 * WIDTH_RATIO);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.themeBgView.mas_top).offset(12 * WIDTH_RATIO);
        make.right.equalTo(self.themeBgView.mas_right).offset(-12 * WIDTH_RATIO);
        make.width.mas_equalTo(74 * WIDTH_RATIO);
        make.height.mas_equalTo(58 * WIDTH_RATIO);
    }];
    
    [self.lightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lightButton.mas_bottom).offset(8 * WIDTH_RATIO);
        make.left.equalTo(self.lightButton.mas_left);
        make.width.mas_equalTo(74 * WIDTH_RATIO);
        make.height.mas_equalTo(17 * WIDTH_RATIO);
    }];
    
    [self.darkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.darkButton.mas_bottom).offset(8 * WIDTH_RATIO);
        make.left.equalTo(self.darkButton.mas_left);
        make.width.mas_equalTo(74 * WIDTH_RATIO);
        make.height.mas_equalTo(17 * WIDTH_RATIO);
    }];
    
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.followButton.mas_bottom).offset(8 * WIDTH_RATIO);
        make.left.equalTo(self.followButton.mas_left);
        make.width.mas_equalTo(74 * WIDTH_RATIO);
        make.height.mas_equalTo(17 * WIDTH_RATIO);
    }];
    
    GTSDKThemeType themeStyle = [GTSDKUtils getSDKThemeType];
    switch (themeStyle) {
        case GTSDKThemeTypeLight: {
            [self.checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.lightButton.mas_bottom).offset(-5 * WIDTH_RATIO);
                make.right.equalTo(self.lightButton.mas_right).offset(-5 * WIDTH_RATIO);
                make.width.mas_equalTo(14 * WIDTH_RATIO);
                make.height.mas_equalTo(14 * WIDTH_RATIO);
            }];
            
            [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.lightButton.mas_centerX).offset(0);
                make.centerY.equalTo(self.lightButton.mas_centerY);
                make.width.mas_equalTo(78 * WIDTH_RATIO);
                make.height.mas_equalTo(62 * WIDTH_RATIO);
            }];
        }
            break;
        case GTSDKThemeTypeDark: {
            [self.checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.darkButton.mas_bottom).offset(-5 * WIDTH_RATIO);
                make.right.equalTo(self.darkButton.mas_right).offset(-5 * WIDTH_RATIO);
                make.width.mas_equalTo(14 * WIDTH_RATIO);
                make.height.mas_equalTo(14 * WIDTH_RATIO);
            }];
            
            [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.darkButton.mas_centerX).offset(0);
                make.centerY.equalTo(self.darkButton.mas_centerY);
                make.width.mas_equalTo(78 * WIDTH_RATIO);
                make.height.mas_equalTo(62 * WIDTH_RATIO);
            }];
        }
            break;
        case GTSDKThemeTypeFollowSystem: {
            [self.checkImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.followButton.mas_bottom).offset(-5 * WIDTH_RATIO);
                make.right.equalTo(self.followButton.mas_right).offset(-5 * WIDTH_RATIO);
                make.width.mas_equalTo(14 * WIDTH_RATIO);
                make.height.mas_equalTo(14 * WIDTH_RATIO);
            }];
            
            [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.followButton.mas_centerX).offset(0);
                make.centerY.equalTo(self.followButton.mas_centerY);
                make.width.mas_equalTo(78 * WIDTH_RATIO);
                make.height.mas_equalTo(62 * WIDTH_RATIO);
            }];
        }
            break;
        default:
            break;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 10;
    [self.tapView addGestureRecognizer:tap];
    
//    if (@available(iOS 13.0, *)) {
//        switch ([GTThemeManager share].theme) {
//            case GTSDKThemeTypeLight:
//                self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
//                break;
//            case GTSDKThemeTypeDark:
//                self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
//                break;
//            default:
//                break;
//        }
//    }
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateEnded:{
            GTDialogViewWithInput *dialogView = [[GTDialogViewWithInput alloc] initWithTitle:@"密码验证" content:@"" confirm:^(NSString * _Nonnull str) {
                //密码对比
                NSString *pwString = [GTSDKConfig getDevVerify];
                if ([[[[str sha1String] md5String] sha1String] isEqualToString:pwString]) {
                    //进入后门
                    GTToolSetDebugViewController *debugVC = [GTToolSetDebugViewController new];
                    [self.navigationController pushViewController:debugVC animated:NO];
                }
                
            } cancel:^{
                
            }];
            [[GTSDKUtils getTopWindow].view addSubview:dialogView];
        }
            break;
            
        default:
            break;
    }
}

- (void)chooseTheme:(UIButton *)sender {
    //埋点上报参数
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    
    if (@available(iOS 13.0, *)) {
        if (sender == self.lightButton) {
            //浅色模式
            [GTThemeManager share].theme = GTSDKThemeTypeLight;
            
            [messageDict setObject:@"浅色模式" forKey:@"dark_mode_type"];
        }else if (sender == self.darkButton) {
            //深色模式
            [GTThemeManager share].theme = GTSDKThemeTypeDark;
            
            [messageDict setObject:@"深色模式" forKey:@"dark_mode_type"];
        }else if (sender == self.followButton) {
            //跟随系统
            [GTThemeManager share].theme = GTSDKThemeTypeFollowSystem;
            
            [messageDict setObject:@"跟随系统" forKey:@"dark_mode_type"];
        }
        [GTSDKUtils saveSDKThemeType:(int)[GTThemeManager share].theme];
        
        UIUserInterfaceStyle style = self.traitCollection.userInterfaceStyle;
        //内存中主题只有两种，跟随系统存起来是为了第一次进来可以判断主题
        if ([GTThemeManager share].theme == GTSDKThemeTypeFollowSystem) {
            if (style == UIUserInterfaceStyleLight) {
                [GTThemeManager share].theme = GTSDKThemeTypeLight;
            }else {
                [GTThemeManager share].theme = GTSDKThemeTypeDark;
            }
        }
    }else {
        if (sender == self.lightButton) {
            //浅色模式
            [GTThemeManager share].theme = GTSDKThemeTypeLight;
            
            [messageDict setObject:@"浅色模式" forKey:@"dark_mode_type"];
        }else if (sender == self.darkButton) {
            //深色模式
            [GTThemeManager share].theme = GTSDKThemeTypeDark;
            
            [messageDict setObject:@"深色模式" forKey:@"dark_mode_type"];
        }else if (sender == self.followButton) {
            //跟随系统
            [GTThemeManager share].theme = GTSDKThemeTypeLight;
            
            [messageDict setObject:@"跟随系统" forKey:@"dark_mode_type"];
        }
        [GTSDKUtils saveSDKThemeType:(int)[GTThemeManager share].theme];
    }
    
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle style = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        if (style == UIUserInterfaceStyleLight) {
            [messageDict setObject:[NSNumber numberWithInt:1] forKey:@"phone_system_dark_mode_type"];
        }else {
            [messageDict setObject:[NSNumber numberWithInt:2] forKey:@"phone_system_dark_mode_type"];
        }
    } else {
        [messageDict setObject:[NSNumber numberWithInt:1] forKey:@"phone_system_dark_mode_type"];
    }
    
    //工具箱深色模式切换埋点
    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxDarkModeSwitch andProperties:messageDict shouldFlush:YES];
    
    [self.checkImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sender.mas_bottom).offset(-5 * WIDTH_RATIO);
        make.right.equalTo(sender.mas_right).offset(-5 * WIDTH_RATIO);
        make.width.mas_equalTo(14 * WIDTH_RATIO);
        make.height.mas_equalTo(14 * WIDTH_RATIO);
    }];
    
    [self.selectedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sender.mas_centerX).offset(0);
        make.centerY.equalTo(sender.mas_centerY);
        make.width.mas_equalTo(78 * WIDTH_RATIO);
        make.height.mas_equalTo(62 * WIDTH_RATIO);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKChangeTheme object:self];
}

- (void)changeTheme:(NSNotification *)noti {
    [UIView animateWithDuration:0.32 animations:^{
        self.view.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        self.titleLabel.textColor = [GTThemeManager share].colorModel.titleColor;
        self.themeBgView.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        self.themeLabel.textColor = [GTThemeManager share].colorModel.titleColor;
        self.lightLabel.textColor = [GTThemeManager share].colorModel.textColor;
        self.darkLabel.textColor = [GTThemeManager share].colorModel.textColor;
        self.followLabel.textColor = [GTThemeManager share].colorModel.textColor;
    }];
}

#pragma mark - setter & getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"工具设置";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [GTThemeManager share].colorModel.titleColor;
        _titleLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
    }
    return _titleLabel;
}

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [UIView new];
        _tapView.userInteractionEnabled = YES;
    }
    return _tapView;
}

- (UILabel *)themeLabel {
    if (!_themeLabel) {
        _themeLabel = [UILabel new];
        _themeLabel.text = @"主题";
        _themeLabel.textColor = [GTThemeManager share].colorModel.headingOneColor;
        _themeLabel.font = [UIFont boldSystemFontOfSize:15*WIDTH_RATIO];
    }
    return _themeLabel;
}

- (UIView *)themeBgView {
    if (!_themeBgView) {
        _themeBgView = [UIView new];
        _themeBgView.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _themeBgView.layer.cornerRadius = 10  * WIDTH_RATIO;
        _themeBgView.layer.masksToBounds = YES;
    }
    return _themeBgView;
}

- (UIButton *)lightButton {
    if (!_lightButton) {
        _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lightButton setImage:[[GTThemeManager share] imageWithName:@"set_light_btn"] forState:UIControlStateNormal];
        [_lightButton addTarget:self action:@selector(chooseTheme:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightButton;
}

- (UIButton *)darkButton {
    if (!_darkButton) {
        _darkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_darkButton setImage:[[GTThemeManager share] imageWithName:@"set_dark_btn"] forState:UIControlStateNormal];
        [_darkButton addTarget:self action:@selector(chooseTheme:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _darkButton;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followButton setImage:[[GTThemeManager share] imageWithName:@"set_system_btn"] forState:UIControlStateNormal];
        [_followButton addTarget:self action:@selector(chooseTheme:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}

- (UIImageView *)checkImg {
    if (!_checkImg) {
        _checkImg = [[UIImageView alloc] init];
        _checkImg.image = [[GTThemeManager share] imageWithName:@"set_check_btn"];
    }
    return _checkImg;
}

- (UILabel *)lightLabel {
    if (!_lightLabel) {
        _lightLabel = [UILabel new];
        _lightLabel.text = @"浅色模式";
        _lightLabel.textAlignment = NSTextAlignmentCenter;
        _lightLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _lightLabel.font = [UIFont boldSystemFontOfSize:12*WIDTH_RATIO];
    }
    return _lightLabel;
}

- (UILabel *)darkLabel {
    if (!_darkLabel) {
        _darkLabel = [UILabel new];
        _darkLabel.text = @"深色模式";
        _darkLabel.textAlignment = NSTextAlignmentCenter;
        _darkLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _darkLabel.font = [UIFont boldSystemFontOfSize:12*WIDTH_RATIO];
    }
    return _darkLabel;
}

- (UILabel *)followLabel {
    if (!_followLabel) {
        _followLabel = [UILabel new];
        _followLabel.text = @"跟随系统";
        _followLabel.textAlignment = NSTextAlignmentCenter;
        _followLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _followLabel.font = [UIFont boldSystemFontOfSize:12*WIDTH_RATIO];
    }
    return _followLabel;
}

- (UIView *)selectedView {
    if (!_selectedView) {
        _selectedView = [UIView new];
        _selectedView.backgroundColor = [UIColor clearColor];
        _selectedView.layer.cornerRadius = 11 * WIDTH_RATIO;
        _selectedView.layer.masksToBounds = YES;
        _selectedView.layer.borderColor = [UIColor themeColor].CGColor;
        _selectedView.layer.borderWidth = 2 * WIDTH_RATIO;
    }
    return _selectedView;;
}

@end
