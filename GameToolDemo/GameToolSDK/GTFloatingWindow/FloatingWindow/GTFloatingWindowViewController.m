//
//  GTFloatingWindowViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/6/25.
//

#import "GTFloatingWindowViewController.h"
#import "GTSDKConfig.h"
#import "GTFloatingWindowConfig.h"
#import "GTSpeedUpViewController.h"
#import "GTSpeedUpTipViewController.h"
#import "GTClickerMainViewController.h"
#import "GTClickerTipViewController.h"
#import "GTToolSetHomeViewController.h"
#import "GTFloatingBallManager.h"
#import "GTFloatingWindowManager.h"
#import "GTClickerWindowManager.h"
#import "GTDialogWindowManager.h"
#import "GTRecordManager.h"
#import "GTRecordWindowManager.h"

@interface GTFloatingWindowViewController () <ToolBarClickDelegate>

//加速器
@property (nonatomic, strong) GTSpeedUpViewController *speedUpVC;
@property (nonatomic, strong) GTSpeedUpTipViewController *speedUpTipVC;
@property (nonatomic, strong) UINavigationController *speedUpNav;
@property (nonatomic, strong) UINavigationController *speedUpTipNav;
//连点器
@property (nonatomic, strong) GTClickerMainViewController *clickerMainVC;
@property (nonatomic, strong) GTClickerTipViewController *clickerTipVC;
@property (nonatomic, strong) UINavigationController *clickerMainNav;
@property (nonatomic, strong) UINavigationController *clickerTipNav;
//设置页面
@property (nonatomic, strong) GTToolSetHomeViewController *toolSetVC;
@property (nonatomic, strong) UINavigationController *toolSetNav;
//记录当前页面
@property (nonatomic, strong) UINavigationController *currentNav;

@end

@implementation GTFloatingWindowViewController

- (BOOL)shouldAutorotate{
    if ([GTSDKUtils isPortrait]) {
        return NO;
    }else {
        return YES;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([GTSDKUtils isPortrait]) {
        return UIInterfaceOrientationMaskPortrait;
    }else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if ([GTSDKUtils isPortrait]) {
        return UIInterfaceOrientationPortrait;
    }else {
        return UIInterfaceOrientationLandscapeRight;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.mainView];
    
    if ([GTSDKUtils isPortrait]) {
        [self layOutBasePortrait];
    }else {
        [self layOutBaseHorizontal];
    }
    
    if ([GTSDKUtils isReadSpeedUpTutorials]) {
        [self addChildViewController:self.speedUpNav];
        [self.mainView addSubview:self.speedUpNav.view];
        self.currentNav = self.speedUpNav;
        
//        [self.speedUpNav.view mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.left.top.equalTo(self.mainView);
////            make.width.mas_equalTo(floatingWindow_width * WIDTH_RATIO);
////            make.height.mas_equalTo(floatingWindow_height * WIDTH_RATIO);
//            make.left.right.top.bottom.equalTo(self.mainView);
//        }];
    }else {
        [self addChildViewController:self.speedUpTipNav];
        [self.mainView addSubview:self.speedUpTipNav.view];
        self.currentNav = self.speedUpTipNav;

//        [self.speedUpTipNav.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.bottom.equalTo(self.mainView);
//        }];
    }
    
    @WeakObj(self);
    //加速器点击【开始探索】
    self.speedUpTipVC.startExploringBlock = ^{
        [selfWeak.speedUpTipNav willMoveToParentViewController:nil];
        [selfWeak.speedUpTipNav.view removeFromSuperview];
        [selfWeak.speedUpTipNav removeFromParentViewController];
        selfWeak.currentNav = selfWeak.speedUpNav;
        [selfWeak addChildViewController:selfWeak.speedUpNav];
        [selfWeak.mainView addSubview:selfWeak.speedUpNav.view];
        

//        [selfWeak.speedUpNav.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.bottom.equalTo(selfWeak.mainView);
//        }];
    };
}

-(void)layOutBasePortrait {
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-(SCREEN_HEIGHT - floatingWindowAndChange_height * WIDTH_RATIO)/3);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(floatingWindow_width * WIDTH_RATIO);
        make.height.mas_equalTo(floatingWindow_height * WIDTH_RATIO);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.mas_left);
        make.bottom.equalTo(self.mainView.mas_top).offset(-10 * WIDTH_RATIO);
        make.width.mas_equalTo(toolbar_width * WIDTH_RATIO);
        make.height.mas_equalTo(toolbar_height * WIDTH_RATIO);
    }];
}

-(void)layOutBaseHorizontal {
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SAFE_AREA_LEFT + 25 * WIDTH_RATIO);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(floatingWindow_width * WIDTH_RATIO);
        make.height.mas_equalTo(floatingWindow_height * WIDTH_RATIO);
    }];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.mas_right).offset(10 * WIDTH_RATIO);
        make.top.equalTo(self.mainView.mas_top);
        make.width.mas_equalTo(toolbar_height * WIDTH_RATIO);
        make.height.mas_equalTo(toolbar_width * WIDTH_RATIO);
    }];
}


#pragma mark - ToolBarClickDelegate

- (void)toolBar:(GTToolBarView *)toolBar backClick:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.32 animations:^{
            [[GTFloatingWindowManager shareInstance] floatingWindowHide];
        } completion:^(BOOL finished) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKChangeFloatingBallStateNotification object:self];
            
            if ([GTOperationControl shareInstance].gtSDKStyle == GTSDKStyleCustomFloatingBall && ![GTSDKUtils getExtremelyAustereIsOn]) {
                
            }else {
                [GTFloatingBallManager shareInstance].ballWindow.alpha = 0;
                [[GTFloatingBallManager shareInstance] floatingBallShow];
                [UIView animateWithDuration:0.2 animations:^{
                    [GTFloatingBallManager shareInstance].ballWindow.alpha = 1;
//                    [GTFloatingBallManager shareInstance].ballWindow.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
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
                }];
            }
        }];
    });

}

- (void)toolBar:(GTToolBarView *)toolBar didSelected:(UIButton *)sender{
    if (sender == toolBar.speedUpButton) {
        toolBar.speedUpButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_selected_btn_color;
        toolBar.clickerButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        toolBar.setButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        
        toolBar.speedUpButton.selected = YES;
        toolBar.clickerButton.selected = NO;
        toolBar.setButton.selected = NO;
        
        if ([GTSDKUtils isReadSpeedUpTutorials]) {
            [self replaceController:self.currentNav newController:self.speedUpNav];
        }else {
            [self replaceController:self.currentNav newController:self.speedUpTipNav];
        }
    }else if (sender == toolBar.clickerButton) {
        toolBar.speedUpButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        toolBar.clickerButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_selected_btn_color;
        toolBar.setButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        
        toolBar.speedUpButton.selected = NO;
        toolBar.clickerButton.selected = YES;
        toolBar.setButton.selected = NO;
        
        if ([GTSDKUtils isReadClickerTutorials]) {
            [self replaceController:self.currentNav newController:self.clickerMainNav];
        }else {
            [self replaceController:self.currentNav newController:self.clickerTipNav];
        }
        
        @WeakObj(self);
        //连点器点击【开始探索】
        self.clickerTipVC.startExploringBlock = ^{
            [selfWeak.clickerTipNav willMoveToParentViewController:nil];
            [selfWeak.clickerTipNav.view removeFromSuperview];
            [selfWeak.clickerTipNav removeFromParentViewController];
            selfWeak.currentNav = selfWeak.clickerMainNav;
            [selfWeak addChildViewController:selfWeak.clickerMainNav];
            [selfWeak.mainView addSubview:selfWeak.clickerMainNav.view];
            

//            [selfWeak.clickerMainNav.view mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.top.bottom.equalTo(selfWeak.mainView);
//            }];
        };
    }else if (sender == toolBar.setButton) {
        toolBar.speedUpButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        toolBar.clickerButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        toolBar.setButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_selected_btn_color;
        
        toolBar.speedUpButton.selected = NO;
        toolBar.clickerButton.selected = NO;
        toolBar.setButton.selected = YES;
        
        [self replaceController:self.currentNav newController:self.toolSetNav];
    }
}

#pragma mark - private method
//  页面切换
- (void)replaceController:(UINavigationController *)oldController newController:(UINavigationController *)newController {
    if (self.currentNav == newController) {
        return;
    }
    [self addChildViewController:newController];
    newController.view.frame = self.mainView.bounds;
    [newController.view layoutIfNeeded];
    [self transitionFromViewController:oldController toViewController:newController duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {

//            [newController.view mas_makeConstraints:^(MASConstraintMaker *make) {
////                make.left.top.equalTo(self.mainView);
////                make.width.mas_equalTo(floatingWindow_width * WIDTH_RATIO);
////                make.height.mas_equalTo(floatingWindow_width * WIDTH_RATIO);
//
//                make.left.right.top.bottom.equalTo(self.mainView);
//            }];
            
            [newController didMoveToParentViewController:oldController];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            
            self.currentNav = newController;
            
        }else{
            self.currentNav = oldController;
        }
    }];
}


#pragma mark - setter & getter

- (GTToolBarView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[GTToolBarView alloc] init];
        _toolBar.toolBarClickDelegate = self;
    }
    return _toolBar;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor hexColor:@"#FFFFFF"];
        _mainView.layer.cornerRadius = 20 * WIDTH_RATIO;
        _mainView.layer.masksToBounds = YES;
    }
    return _mainView;
}

- (UINavigationController *)speedUpNav {
    if (!_speedUpNav) {
        _speedUpVC = [GTSpeedUpViewController new];
        _speedUpNav = [[UINavigationController alloc]initWithRootViewController:_speedUpVC];
        _speedUpNav.view.frame = self.mainView.bounds;
    }
    return _speedUpNav;
}

- (UINavigationController *)speedUpTipNav {
    if (!_speedUpTipNav) {
        _speedUpTipVC = [GTSpeedUpTipViewController new];
        _speedUpTipNav = [[UINavigationController alloc]initWithRootViewController:_speedUpTipVC];
        _speedUpTipNav.view.frame = self.mainView.bounds;
    }
    return _speedUpTipNav;
}

- (UINavigationController *)clickerMainNav {
    if (!_clickerMainNav) {
        _clickerMainVC = [GTClickerMainViewController new];
        _clickerMainNav = [[UINavigationController alloc]initWithRootViewController:_clickerMainVC];
        _clickerMainNav.view.frame = self.mainView.bounds;
    }
    return _clickerMainNav;
}

- (UINavigationController *)clickerTipNav {
    if (!_clickerTipNav) {
        _clickerTipVC = [GTClickerTipViewController new];
        _clickerTipNav = [[UINavigationController alloc]initWithRootViewController:_clickerTipVC];
        _clickerTipNav.view.frame = self.mainView.bounds;
    }
    return _clickerTipNav;
}

- (UINavigationController *)toolSetNav {
    if (!_toolSetNav) {
        _toolSetVC = [GTToolSetHomeViewController new];
        _toolSetNav = [[UINavigationController alloc]initWithRootViewController:_toolSetVC];
        _toolSetNav.view.frame = self.mainView.bounds;
    }
    return _toolSetNav;
}

@end
