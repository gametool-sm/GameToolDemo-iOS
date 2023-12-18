//
//  GTClickerWindowViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTClickerWindowViewController.h"
#import "GTClickerWindowManager.h"
#import "GTClickerWindowAnimation.h"

@interface GTClickerWindowViewController ()

@end

@implementation GTClickerWindowViewController

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
}

- (void)changeTheme:(NSNotification *)noti {
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark - setter & getter - clicker

- (GTClickerWindowNowReadyView *)nowReadyView {
    if (!_nowReadyView) {
        _nowReadyView = [[GTClickerWindowNowReadyView alloc] initWithFrame:CGRectMake(0, 0, clickerWindow_ready_width * WIDTH_RATIO, clickerWindow_ready_height * WIDTH_RATIO)];
    }
    return _nowReadyView;
}

- (GTClickerWindowFutureReadyView *)futureReadyView {
    if (!_futureReadyView) {
        _futureReadyView = [[GTClickerWindowFutureReadyView alloc] initWithFrame:CGRectMake(0, 0, clickerWindow_ready_width * WIDTH_RATIO, clickerWindow_ready_height * WIDTH_RATIO)];
        //开启
        _futureReadyView.startBlock = ^{
            
        };
    }
    return _futureReadyView;
}

- (GTClickerWindowNowStartView *)nowStartView {
    if (!_nowStartView) {
        _nowStartView = [[GTClickerWindowNowStartView alloc] initWithFrame:CGRectMake(0, 0, clickerWindow_now_start_width * WIDTH_RATIO, clickerWindow_now_start_height * WIDTH_RATIO)];
    }
    return _nowStartView;
}

- (GTClickerWindowFutureStartView *)futureStartView {
    if (!_futureStartView) {
        _futureStartView = [[GTClickerWindowFutureStartView alloc] initWithFrame:CGRectMake(0, 0, clickerWindow_future_start_width * WIDTH_RATIO, clickerWindow_future_start_height * WIDTH_RATIO)];
        [_futureStartView updateData:[GTClickerWindowManager shareInstance].schemeModel];
    }
    return _futureStartView;
}

@end
