//
//  GTRecordWindowViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import "GTRecordWindowViewController.h"
#import "GTRecordWindowManager.h"
#import "GTRecordWindowAnimatiion.h"

@interface GTRecordWindowViewController ()

@end

@implementation GTRecordWindowViewController

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

- (void)changeTheme:(NSNotification *)noti {
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark - setter & getter - record

- (GTRecordWindowBeginRecordView *)beginRecordView {
    if (!_beginRecordView) {
        _beginRecordView = [[GTRecordWindowBeginRecordView alloc] initWithFrame:CGRectMake(0, 0, recordWindow_begin_width * WIDTH_RATIO, recordWindow_begin_width * WIDTH_RATIO)];
    }
    return _beginRecordView;
}

- (GTRecordWindowRecordTimeView *)recordTimeView {
    if (!_recordTimeView) {
        _recordTimeView = [[GTRecordWindowRecordTimeView alloc] initWithFrame:CGRectMake(0, 0, recordWindow_record_time_width * WIDTH_RATIO, recordWindow_record_time_height * WIDTH_RATIO)];
    }
    return _recordTimeView;
}

- (GTRecordWindowInfiniteView *)infiniteView {
    if (!_infiniteView) {
        _infiniteView = [[GTRecordWindowInfiniteView alloc] initWithFrame:CGRectMake(0, 0, recordWindow_infinite_width * WIDTH_RATIO, recordWindow_infinite_height * WIDTH_RATIO)];
        [_infiniteView updateData:[GTRecordWindowManager shareInstance].schemeModel];
    }
    return _infiniteView;
}

- (GTRecordWindowFiniteView *)finiteView {
    if (!_finiteView) {
        _finiteView = [[GTRecordWindowFiniteView alloc] initWithFrame:CGRectMake(0, 0, recordWindow_finite_width * WIDTH_RATIO, recordWindow_finite_height * WIDTH_RATIO)];
        [_finiteView updateData:[GTRecordWindowManager shareInstance].schemeModel];
    }
    return _finiteView;
}

- (GTRecordWindowCountdownView *)counntdownView {
    if (!_counntdownView) {
        _counntdownView = [[GTRecordWindowCountdownView alloc] initWithFrame:CGRectMake(0, 0, recordWindow_record_time_width * WIDTH_RATIO, recordWindow_record_time_height * WIDTH_RATIO)];
        [_counntdownView updateData:[GTRecordWindowManager shareInstance].schemeModel];
    }
    return _counntdownView;
}

@end
