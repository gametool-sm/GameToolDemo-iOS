//
//  GTFloatingBallBaseView.m
//  GTSDK
//
//  Created by shangmi on 2023/7/13.
//

#import "GTFloatingBallBaseView.h"
#import "GTSpeedUpManager.h"
#import "GTFloatingBallConfig.h"
#import "GTFirstOpenMinimalistMask.h"

@implementation GTFloatingBallBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self setUp];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:GTSDKChangeTheme object:nil];
    }
    return self;
}

- (void)changeTheme:(NSNotification *)noti {
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GTSDKChangeTheme object:nil];
}

- (void)setUp {
    [self addSubview:self.shadowView];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.hidden = YES;
        _shadowView.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.4];
    }
    return _shadowView;
}

@end
