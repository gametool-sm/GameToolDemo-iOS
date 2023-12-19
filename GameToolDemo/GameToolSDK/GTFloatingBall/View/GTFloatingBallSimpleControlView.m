//
//  GTFloatingBallSimpleControlView.m
//  GTSDK
//
//  Created by shangmi on 2023/7/3.
//

#import "GTFloatingBallSimpleControlView.h"
#import "GTSpeedUpManager.h"
#import "GTFirstOpenMinimalistMask.h"

@interface GTFloatingBallSimpleControlView ()

@end

@implementation GTFloatingBallSimpleControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GTThemeManager share].colorModel.bgColor;

        [self setUp];
    }
    return self;
}

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.floatingBallBtn.backgroundColor = [GTThemeManager share].colorModel.floating_ball_btn_bg;
}

- (void)setUp {
    [super setUp];
    
    [self addSubview:self.floatingBallBtn];
    self.floatingBallBtn.backgroundColor = [GTThemeManager share].colorModel.floating_ball_btn_bg;
    
    [self.floatingBallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(35 * WIDTH_RATIO);
        make.height.mas_equalTo(35 * WIDTH_RATIO);
    }];
}

- (void)clickShadowView:(CGPoint)point {    
    if (CGRectContainsPoint(self.floatingBallBtn.frame, point)) {
        [self controlClick];
    }
}

- (void)controlClick {
    [GTSpeedUpManager shareInstance].isStart = ![GTSpeedUpManager shareInstance].isStart;
    if ([GTSpeedUpManager shareInstance].isStart) {
        [self.floatingBallBtn setImage:[[GTThemeManager share] imageWithName:@"floating_ball_pause_btn"] forState:UIControlStateNormal];
    }else {
        [self.floatingBallBtn setImage:[[GTThemeManager share] imageWithName:@"floating_ball_start_btn"] forState:UIControlStateNormal];
    }
    
    [GTSDKUtils saveSpeedUpControl:[GTSpeedUpManager shareInstance].isStart];
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKChangeSpeedInfo object:self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.floatingBallBtn.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.floatingBallBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    });
    
    //如果极简模式的蒙版存在，则移除
    for (UIView *view in [GTSDKUtils getTopWindow].view.subviews) {
        if ([view isKindOfClass:[GTFirstOpenMinimalistMask class]]) {
            [view removeFromSuperview];
            [GTSDKUtils saveShowMinimalistGuideMask];
        }
    }
    
    if ([GTSDKUtils getAutoHideIsOn]) { //判断极简模式下贴边功能是否打开
        dispatch_async(dispatch_get_main_queue(), ^{
//注释            [GTFloatingBallConfig floatingBallControlModeClingWithView:self];
        });
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 添加蒙层
//注释        [GTFloatingBallConfig floatingBallControlModeExtinguishWithView:self completion:nil];
    });
}

- (UIButton *)floatingBallBtn {
    if (!_floatingBallBtn) {
        _floatingBallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _floatingBallBtn.adjustsImageWhenHighlighted = NO;
        _floatingBallBtn.backgroundColor = [GTThemeManager share].colorModel.floating_ball_btn_bg;
        if ([GTSpeedUpManager shareInstance].isStart) {
            [_floatingBallBtn setImage:[[GTThemeManager share] imageWithName:@"floating_ball_pause_btn"] forState:UIControlStateNormal];
        }else {
            [_floatingBallBtn setImage:[[GTThemeManager share] imageWithName:@"floating_ball_start_btn"] forState:UIControlStateNormal];
        }
        [_floatingBallBtn addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
        _floatingBallBtn.layer.cornerRadius = 17.5 * WIDTH_RATIO;
        _floatingBallBtn.layer.masksToBounds = YES;
    }
    return _floatingBallBtn;
}

@end
