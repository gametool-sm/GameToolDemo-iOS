//
//  GTClickerWindowNowStartView.m
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTClickerWindowNowStartView.h"
#import "UIButton+Extent.h"
#import "GTClickerWindowManager.h"
#import "GTClickerWindowAnimation.h"
#import "GTClickerManager.h"
#import "UIButton+Extent.h"

@interface GTClickerWindowNowStartView ()

@property (nonatomic, strong) UIButton *pauseButton;

//@property (nonatomic, strong) UILabel *pauseLabel;

@end

@implementation GTClickerWindowNowStartView

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
    
    [self addSubview:self.pauseButton];
//    [self addSubview:self.pauseLabel];
    
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(6 * WIDTH_RATIO);
        make.left.equalTo(self.mas_left).offset(6 * WIDTH_RATIO);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
//    [self.pauseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.pauseButton.mas_bottom).offset(1 * WIDTH_RATIO);
//        make.centerX.equalTo(self.pauseButton.mas_centerX);
//        make.height.mas_equalTo(11 * WIDTH_RATIO);
//    }];
    
    [self.pauseButton layoutButtonWithImageTitleSpace:2];
}

#pragma mark - response

- (void)pauseClick {
    if ([GTClickerWindowManager shareInstance].schemeModel.startMethod == ClickerWindowStartMethodNow) {
        [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateNowReady;
        [GTClickerWindowAnimation clickerWindowNowStartToNowReadyAnimationWithCompletion:nil];
    }else {
        [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureReady;
        [GTClickerWindowAnimation clickerWindowNowStartToFutureReadyAnimationWithCompletion:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowPauseNotification object:self userInfo:nil];
    
    //暂停连点器
    [[GTClickerManager shareInstance] pauseScheme];
    

}

#pragma mark - setter & getter

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pauseButton.adjustsImageWhenHighlighted = NO;
        [_pauseButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_pause_btn"] forState:UIControlStateNormal];
        [_pauseButton setTitle:localString(@"暂停") forState:UIControlStateNormal];
        [_pauseButton setTitleColor:[UIColor themeColorWithAlpha:0.8] forState:UIControlStateNormal];
        _pauseButton.titleLabel.font = [UIFont systemFontOfSize:8 *  WIDTH_RATIO];
        _pauseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_pauseButton addTarget:self action:@selector(pauseClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}

//- (UILabel *)pauseLabel {
//    if (!_pauseLabel) {
//        _pauseLabel = [UILabel new];
//        _pauseLabel.text = localString(@"暂停");
//        _pauseLabel.textColor = [UIColor themeColorWithAlpha:0.8];
//        _pauseLabel.font = [UIFont systemFontOfSize:9 * WIDTH_RATIO];
//        _pauseLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _pauseLabel;
//}



@end
