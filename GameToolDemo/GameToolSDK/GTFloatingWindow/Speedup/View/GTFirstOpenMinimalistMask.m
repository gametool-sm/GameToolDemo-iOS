//
//  GTFirstOpenMinimalistMask.m
//  GTSDK
//
//  Created by shangmi on 2023/7/28.
//

#import "GTFirstOpenMinimalistMask.h"
#import "GTOperationControl.h"
#import "GTFloatingBallConfig.h"
#import "GTFloatingBallManager.h"

@interface GTFirstOpenMinimalistMask()

@property (nonatomic, strong) UIImageView *tipPointImg;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIImageView *bottomArrowImg;
@property (nonatomic, strong) UIImageView *bottomImg;
@property (nonatomic, strong) UIImageView *bottomCloseImg;
@property (nonatomic, strong) UILabel *bottomCloseLabel;

@end

@implementation GTFirstOpenMinimalistMask

#pragma mark - override

- (void)changeTheme:(NSNotification *)noti {
    self.tipView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.tipLabel.textColor = [GTThemeManager share].colorModel.textColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.5];
    
    [self addSubview:self.tipPointImg];
    [self addSubview:self.tipView];
    [self.tipView addSubview:self.tipLabel];
    
    [self addSubview:self.bottomArrowImg];
    [self addSubview:self.bottomImg];
    [self.bottomImg addSubview:self.bottomCloseImg];
    [self.bottomImg addSubview:self.bottomCloseLabel];
    
    CGPoint point = [GTSDKUtils getFloatingBallLastPosition];
    [self.tipPointImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo([GTOperationControl share].ballWindow.mas_centerY);
//        make.left.equalTo([GTOperationControl share].ballWindow.mas_right).offset(6 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_top).offset(point.y);
        make.left.equalTo(self.mas_left).offset(SAFE_AREA_LEFT + floatingBall_distance + floatingBall_width + 6 * WIDTH_RATIO);
        make.width.mas_equalTo(5 * WIDTH_RATIO);
        make.height.mas_equalTo(14 * WIDTH_RATIO);
    }];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tipPointImg.mas_centerY);
        make.left.equalTo(self.tipPointImg.mas_right);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipView.mas_top).offset(11 * WIDTH_RATIO);
        make.bottom.equalTo(self.tipView.mas_bottom).offset(-11 * WIDTH_RATIO);
        make.left.equalTo(self.tipView.mas_left).offset(12 * WIDTH_RATIO);
        make.right.equalTo(self.tipView.mas_right).offset(-12 * WIDTH_RATIO);
    }];
    
    [self.bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([GTSDKUtils isPortrait]) {
            make.width.mas_equalTo(375 * WIDTH_RATIO);
            make.height.mas_equalTo(160 * WIDTH_RATIO);
        }else {
            make.width.mas_equalTo(419 * WIDTH_RATIO);
            make.height.mas_equalTo(135 * WIDTH_RATIO);
        }
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.bottomCloseImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50 * WIDTH_RATIO);
        make.height.mas_equalTo(50 * WIDTH_RATIO);
        make.bottom.equalTo(self.bottomImg.mas_bottom).offset(-55 * WIDTH_RATIO);
        make.centerX.equalTo(self.bottomImg.mas_centerX);
    }];
    
    [self.bottomCloseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18 * WIDTH_RATIO);
        make.top.equalTo(self.bottomCloseImg.mas_bottom).offset(13 * WIDTH_RATIO);
        make.centerX.equalTo(self.bottomCloseImg.mas_centerX);
    }];
    
    [self.bottomArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomImg.mas_top).offset(-8 * WIDTH_RATIO);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(24 * WIDTH_RATIO);
        make.height.mas_equalTo(50 * WIDTH_RATIO);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //引导蒙层上的悬浮球给定状态
    [GTFloatingBallManager shareInstance].floatingBallState = FloatingBallStateHideHalf;
    [GTFloatingBallManager shareInstance].floatingBallLuminance = FloatingBallLuminanceDark;
    
    [self removeFromSuperview];
    [GTSDKUtils saveShowMinimalistGuideMask];
    
    [[GTFloatingBallManager shareInstance] floatingBallHide];
    [[GTFloatingBallManager shareInstance] floatingBallShow];
}

- (UIImageView *)tipPointImg {
    if (!_tipPointImg) {
        _tipPointImg = [UIImageView new];
        _tipPointImg.image = [[GTThemeManager share] imageWithName:@"mask_tip_point"];
    }
    return _tipPointImg;
}

- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [UIView new];
        _tipView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        _tipView.layer.cornerRadius = 13 * WIDTH_RATIO;
        _tipView.layer.masksToBounds = YES;
    }
    return _tipView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = localString(@"点击可快速暂停加速功能");
        _tipLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _tipLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
    }
    return _tipLabel;
}

- (UIImageView *)bottomArrowImg {
    if (!_bottomArrowImg) {
        _bottomArrowImg = [UIImageView new];
        _bottomArrowImg.image = [[GTThemeManager share] imageWithName:@"mask_bottom_arrow"];
    }
    return _bottomArrowImg;
}

- (UIImageView *)bottomImg {
    if (!_bottomImg) {
        _bottomImg = [UIImageView new];
        if ([GTSDKUtils isPortrait]) {
            _bottomImg.image = [[GTThemeManager share] imageWithName:@"mask_bottom_view_P"];
        }else {
            _bottomImg.image = [[GTThemeManager share] imageWithName:@"mask_bottom_view_H"];
        }
    }
    return _bottomImg;
}

- (UIImageView *)bottomCloseImg {
    if (!_bottomCloseImg) {
        _bottomCloseImg = [UIImageView new];
        _bottomCloseImg.image = [[GTThemeManager share] imageWithName:@"mask_bottom_sub"];
    }
    return _bottomCloseImg;
}

- (UILabel *)bottomCloseLabel {
    if (!_bottomCloseLabel) {
        _bottomCloseLabel = [UILabel new];
        _bottomCloseLabel.text = localString(@"拖拽至此可关闭");
        _bottomCloseLabel.textColor = [UIColor hexColor:@"#FFFFFF"];
        _bottomCloseLabel.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
    }
    return _bottomCloseLabel;
}

@end
