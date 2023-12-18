//
//  GTBaseView.m
//  GTSDK
//
//  Created by shangmi on 2023/8/5.
//

#import "GTBaseView.h"

@implementation GTBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

@end
