//
//  GTRecordWindowBeginRecordView.m
//  GTSDK
//
//  Created by shangmi on 2023/10/17.
//

#import "GTRecordWindowBeginRecordView.h"
#import "GTRecordView+GTRecord.h"
#import "GTRecordView+PlayBack.h"
#import "GTRecordReadyView.h"
#import "GTRecordWindowManager.h"
#import "GTRecordGuideView.h"
#import "UIButton+Extent.h"

@interface GTRecordWindowBeginRecordView ()

@property (nonatomic, strong) UIButton *startButton;

@end

@implementation GTRecordWindowBeginRecordView

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
    
    [self addSubview:self.startButton];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
    [self.startButton layoutButtonWithImageTitleSpace:2];
}

- (void)startClick {
    //移除录制第一次蒙层
    [GTRecordGuideView closeGuideNow];
    
    //开始录制
    //该悬浮窗在180ms内渐隐
    [UIView animateWithDuration:0.18 animations:^{
        [GTRecordWindowManager shareInstance].recordWinWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [[GTRecordWindowManager shareInstance] recordWindowHide];
        __block GTRecordView *recordView=nil;
        [GTRecordReadyView showReadyView:^(BOOL isCanceled) {
            if(!isCanceled){
                [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateRecordTime;
                recordView = [GTRecordView recordView];
                [recordView beginRecord];
                recordView.alpha = 0.0;
            }else {
                [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateStartRecord;
            }
            [GTRecordWindowManager shareInstance].recordWindowVC.recordTimeView = nil;
            [[GTRecordWindowManager shareInstance] recordWindowShow];
            [UIView animateWithDuration:0.18 animations:^{
                [GTRecordWindowManager shareInstance].recordWinWindow.alpha = 1;
                recordView.alpha = 1.0;
            }];
 
        }];
    }];

 

}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.adjustsImageWhenHighlighted = NO;
        [_startButton setImage:[[GTThemeManager share] imageWithName:@"record_window_begin_btn"] forState:UIControlStateNormal];
        [_startButton setTitle:localString(@"开始录制") forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor themeColorWithAlpha:0.8] forState:UIControlStateNormal];
        _startButton.titleLabel.font = [UIFont systemFontOfSize:8 *  WIDTH_RATIO];
        _startButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_startButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

@end
