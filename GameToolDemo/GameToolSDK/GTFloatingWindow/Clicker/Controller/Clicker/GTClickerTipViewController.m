//
//  GTClickerTipViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/8/11.
//

#import "GTClickerTipViewController.h"
#import "GTClickerMainViewController.h"
#import "GTIntroduceView.h"
#import "GTUnauthorizedCoverView.h"

@interface GTClickerTipViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) GTIntroduceView *introduceView;

@property (nonatomic, strong) UIButton *startButton;

@end

@implementation GTClickerTipViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.introduceView];
    [self.view addSubview:self.startButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];

    [self.introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(54 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270 * WIDTH_RATIO);
        make.height.mas_equalTo(184 * WIDTH_RATIO);
    }];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(248 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(200 * WIDTH_RATIO);
        make.height.mas_equalTo(42 * WIDTH_RATIO);
    }];
    
    if (![GTSDKConfig getIsSpeedUpFeature]) {
        GTUnauthorizedCoverView *coverView = [GTUnauthorizedCoverView new];
        [self.view addSubview:coverView];
        [self.view bringSubviewToFront:coverView];
        
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.view);
        }];
    }
}

#pragma mark - response

- (void)startClick {
    //记录已看过tip页面
    [GTSDKUtils saveReadClickTutorials];
    
    //工具箱元素点击埋点
    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:-1],  @"toolbox_click_type" : [NSNumber numberWithInt:1]} shouldFlush:YES];
    
    if (self.startExploringBlock) {
        self.startExploringBlock();
    }
}

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    
    self.titleLabel.textColor = [GTThemeManager share].colorModel.textColor;
}

#pragma mark - setter & getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = localString(@"连点器");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15*WIDTH_RATIO];
    }
    return _titleLabel;
}

- (GTIntroduceView *)introduceView {
    if (!_introduceView) {
        _introduceView = [[GTIntroduceView alloc] initWithDescText:@"连点器是一款模拟手动操作的辅助工具可用于执行一些重复度高的操作行为。"  bundleName:@"accelerator_specification"];
    }
    return _introduceView;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.layer.cornerRadius = 12*WIDTH_RATIO;
        _startButton.layer.masksToBounds = YES;
        [_startButton setBackgroundColor:[UIColor themeColor]];
        [_startButton setTitle:localString(@"开始探索") forState:UIControlStateNormal];
        _startButton.titleLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
        [_startButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

@end
