//
//  GTBaseViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/7/31.
//

#import "GTBaseViewController.h"
#import "GTThemeManager.h"

@interface GTBaseViewController ()

@end

@implementation GTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:GTSDKChangeTheme object:nil];
}

- (void)changeTheme:(NSNotification *)noti {
    self.view.backgroundColor = [GTThemeManager share].colorModel.bgColor;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {        
        UIUserInterfaceStyle currentStyle = previousTraitCollection.userInterfaceStyle;
        GTSDKThemeType themeStyle = [GTSDKUtils getSDKThemeType];
        if (themeStyle == GTSDKThemeTypeFollowSystem) {
            switch (currentStyle) {
                case UIUserInterfaceStyleLight:
                    [GTThemeManager share].theme = GTSDKThemeTypeLight;
                    break;
                case UIUserInterfaceStyleDark:
                    [GTThemeManager share].theme = GTSDKThemeTypeDark;
                    break;
                default:
                    break;
            }
            
        }
    }
}

@end
