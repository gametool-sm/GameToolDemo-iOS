//
//  GTClickerSetViewController.m
//  GTSDK
//
//  Created by shangminet on 2023/8/15.
//

#import "GTClickerSetViewController.h"
#import "GTSwitch.h"
#import "UIButton+Extent.h"
#import "GTClickerWindowManager.h"
#import "GTClickerWindowStartView.h"
#import "GTRecordManager.h"
#import "GTRecordWindowManager.h"

@interface GTClickerSetViewController ()

@property (nonatomic, strong) UILabel *setLabel;
@property (nonatomic, strong) UIButton *returnButton;

//触点显示

@property (nonatomic, strong) UIView *revealView;
@property (nonatomic, strong) UILabel *revealLabel;
@property (nonatomic, strong) GTSwitch *revealSwitchButton;
@property (nonatomic, strong) UIButton *allPointButton;
@property (nonatomic, strong) UILabel *allPointLabel;
@property (nonatomic, strong) UIButton *actionPointButton;
@property (nonatomic, strong) UILabel *actionPointLabel;

//触点大小
@property (nonatomic, strong) UIView *sizeView;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *sizetipLabel;
@property (nonatomic, strong) UIButton *sizeHintButton;

//触点大小的单项按钮
@property (nonatomic, strong) UILabel *smallPointLabel;
@property (nonatomic, strong) UILabel *middlePointLabel;
@property (nonatomic, strong) UILabel *bigPointLabel;
@property (nonatomic, strong) UIButton *smallPointButton;
@property (nonatomic, strong) UIButton *middlePointButton;
@property (nonatomic, strong) UIButton *bigPointButton;

//脚本检测
@property (nonatomic, strong) UIView *detectionView;
@property (nonatomic, strong) UILabel *detectionLabel;
@property (nonatomic, strong) UILabel *detectiontipLabel;
@property (nonatomic, strong) UIButton *detectionHintButton;
@property (nonatomic, strong) GTSwitch *detectionSwitchButton;

@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UIView *detectTipView;
@property (nonatomic, strong) UILabel *detectTipLabel;
@property (nonatomic, strong) UIImageView *detectTipImageView;


@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) GTClickerWindowStartView *clickerWindowStartView; //方案正在运行页

@end

@implementation GTClickerSetViewController


- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    
    self.setLabel.textColor = [GTThemeManager share].colorModel.titleColor;
    [self.returnButton setImage:[[GTThemeManager share] imageWithName:@"window_back_btn"] forState:UIControlStateNormal];
    self.revealView.backgroundColor = [GTThemeManager share].colorModel.clicker_SetView_color;
    self.sizeView.backgroundColor = [GTThemeManager share].colorModel.clicker_SetView_color;
    self.detectionView.backgroundColor = [GTThemeManager share].colorModel.clicker_SetView_color;
    
    self.revealLabel.textColor = [GTThemeManager share].colorModel.clicker_cell_text_color;
    self.actionPointLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.allPointLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.sizeLabel.textColor = [GTThemeManager share].colorModel.clicker_cell_text_color;
    self.smallPointLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.middlePointLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.bigPointLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.detectionLabel.textColor = [GTThemeManager share].colorModel.clicker_cell_text_color;
    
    
    [self.sizeHintButton setImage:[[GTThemeManager share] imageWithName:@"clicker_prompt_icon"] forState:UIControlStateNormal];
    [self.detectionHintButton setImage:[[GTThemeManager share] imageWithName:@"clicker_prompt_icon"] forState:UIControlStateNormal];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int pointOpera = (int)[defaults integerForKey:@"pointOpera"];
    if(pointOpera == 0){
        [self.actionPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
        self.actionPointButton.selected = YES;
    }else{
        [self.actionPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
        self.actionPointButton.selected = NO;
    }
    if(pointOpera == 1){
        [self.allPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
        self.allPointButton.selected = YES;
    }else{
        [self.allPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
        self.allPointButton.selected = NO;
    }

    int pointSize = (int)[defaults integerForKey:@"pointSize"];
    if(pointSize==1){
        [_smallPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
        _smallPointButton.selected = YES;
    }else{
        [_smallPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
        _smallPointButton.selected = NO;
    }
    if(pointSize == 0){
        [_middlePointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
        _middlePointButton.selected = YES;
    }else{
        [_middlePointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
        _middlePointButton.selected = NO;
    }
    if(pointSize == 2){
        [_bigPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
        self.bigPointButton.selected = YES;
    }else{
        [_bigPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
        self.bigPointButton.selected = NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self setReveal];
    [self setSize];
    [self setDetection];
    
    [self.view addSubview:self.clickerWindowStartView];
    [self.clickerWindowStartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @WeakObj(self);
    self.clickerWindowStartView.startViewPauseClickBlock = ^{
        [selfWeak.clickerWindowStartView setHidden:YES];
    };
    
    if([GTRecordManager shareInstance].isRecord)  {
        if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTime ||
            [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTimeDark) {
            [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecording];
        }else if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateStartRecord){
            [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecord];
        }
        self.clickerWindowStartView.hidden = NO;
    }else if ([GTRecordManager shareInstance].isPlayback) {
        [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecordPlaying];
        self.clickerWindowStartView.hidden = NO;
    }else {
        self.clickerWindowStartView.hidden = YES;
    }
    
//    [[GTRecordManager shareInstance] addObserver:self forKeyPath:@"isRecord" options:NSKeyValueObservingOptionNew context:nil];
//    [[GTRecordManager shareInstance] addObserver:self forKeyPath:@"isPlayback" options:NSKeyValueObservingOptionNew context:nil];
//    //监听悬浮窗视图样式
//    [[GTRecordWindowManager shareInstance] addObserver:self forKeyPath:@"recordWindowState" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)setUp{
    [self.view addSubview:self.returnButton];
    [self.view addSubview:self.setLabel];
    [self.setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
}

//触点显示视图设置
-(void)setReveal{
    [self.view addSubview:self.revealView];
    [self.revealView addSubview:self.revealLabel];
    [self.revealView addSubview:self.revealSwitchButton];
    
    //按钮是否是开启状态，
    if(self.revealSwitchButton.on){
        [self.revealView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.setLabel.mas_bottom).offset(8 * WIDTH_RATIO);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(270 * WIDTH_RATIO);
            make.height.mas_equalTo(70 * WIDTH_RATIO);
        }];
        [self.revealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.setLabel.mas_bottom).offset(20 * WIDTH_RATIO);
            make.left.equalTo(self.revealView.mas_left).offset(12 * WIDTH_RATIO);
            make.width.mas_equalTo(170 * WIDTH_RATIO);
            make.height.mas_equalTo(20 * WIDTH_RATIO);
            
        }];
        [self.revealSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.revealLabel.mas_centerY);
            make.right.equalTo(self.revealView.mas_right).offset(-12 * WIDTH_RATIO);
            make.width.mas_equalTo(42 * WIDTH_RATIO);
            make.height.mas_equalTo(23 * WIDTH_RATIO);
        }];

        [self singleAndLabelReveal];
    }else{ //未开启
        [self.revealView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.setLabel.mas_bottom).offset(8 * WIDTH_RATIO);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(270 * WIDTH_RATIO);
            make.height.mas_equalTo(45 * WIDTH_RATIO);
        }];
        [self.revealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.setLabel.mas_bottom).offset(20 * WIDTH_RATIO);
            make.left.equalTo(self.revealView.mas_left).offset(12 * WIDTH_RATIO);
            make.width.mas_equalTo(170 * WIDTH_RATIO);
            make.height.mas_equalTo(20 * WIDTH_RATIO);
            
        }];
        [self.revealSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.revealLabel.mas_centerY);
            make.right.equalTo(self.revealView.mas_right).offset(-12 * WIDTH_RATIO);
            make.width.mas_equalTo(42 * WIDTH_RATIO);
            make.height.mas_equalTo(23 * WIDTH_RATIO);
        }];
    }
}


//触点大小视图设置
-(void)setSize{
    [self.view addSubview:self.sizeView];
    [self.sizeView addSubview:self.sizeLabel];
    [self.sizeView addSubview:self.sizeHintButton];
    [self.sizeView addSubview:self.smallPointButton];
    [self.sizeView addSubview:self.smallPointLabel];
    [self.sizeView addSubview:self.middlePointButton];
    [self.sizeView addSubview:self.middlePointLabel];
    [self.sizeView addSubview:self.bigPointButton];
    [self.sizeView addSubview:self.bigPointLabel];

    [self.sizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.revealView.mas_bottom).offset(6 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270 * WIDTH_RATIO);
        make.height.mas_equalTo(75 * WIDTH_RATIO);
    }];
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sizeView.mas_top).offset(12 * WIDTH_RATIO);
        make.bottom.equalTo(self.sizeView.mas_bottom).offset(-40 * WIDTH_RATIO);
        make.left.equalTo(self.sizeView.mas_left).offset(12 * WIDTH_RATIO);
        make.right.equalTo(self.sizeView.mas_right).offset(-185 * WIDTH_RATIO);
    }];
    
    [self.sizeHintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sizeLabel.mas_centerY);
        make.left.equalTo(self.sizeLabel.mas_left).offset(62* WIDTH_RATIO);
        make.width.mas_equalTo(15 * WIDTH_RATIO);
        make.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    
    [self.smallPointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sizeLabel.mas_bottom).offset(12* WIDTH_RATIO);
        make.left.equalTo(self.sizeView.mas_left).offset(12* WIDTH_RATIO);
        make.width.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    [self.smallPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.smallPointButton.mas_centerY);
        make.left.equalTo(self.smallPointButton.mas_right).offset(3* WIDTH_RATIO);
        make.height.equalTo(@(20* WIDTH_RATIO));
        make.width.equalTo(@(55* WIDTH_RATIO));
    }];
    [self.middlePointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sizeLabel.mas_bottom).offset(12* WIDTH_RATIO);
        make.left.equalTo(self.smallPointButton.mas_right).offset(72* WIDTH_RATIO);
        make.width.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    [self.middlePointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middlePointButton.mas_centerY);
        make.left.equalTo(self.middlePointButton.mas_right).offset(3* WIDTH_RATIO);
        make.height.equalTo(@(20* WIDTH_RATIO));
        make.width.equalTo(@(55* WIDTH_RATIO));
    }];
    [self.bigPointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sizeLabel.mas_bottom).offset(12* WIDTH_RATIO);
        make.left.equalTo(self.middlePointButton.mas_right).offset(72* WIDTH_RATIO);
        make.width.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    [self.bigPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bigPointButton.mas_centerY);
        make.left.equalTo(self.bigPointButton.mas_right).offset(3* WIDTH_RATIO);
        make.height.equalTo(@(20* WIDTH_RATIO));
        make.width.equalTo(@(55* WIDTH_RATIO));
    }];
}

//脚本检测视图设置
-(void)setDetection{
    [self.view addSubview:self.detectionView];
    [self.detectionView addSubview:self.detectionLabel];
    [self.detectionView addSubview:self.detectionSwitchButton];
    [self.detectionView addSubview:self.detectionHintButton];
    
    [self.detectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sizeView.mas_bottom).offset(6 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270 * WIDTH_RATIO);
        make.height.mas_equalTo(45 * WIDTH_RATIO);
    }];
    [self.detectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detectionView.mas_top).offset(12 * WIDTH_RATIO);
        make.bottom.equalTo(self.detectionView.mas_bottom).offset(-12 * WIDTH_RATIO);
        make.left.equalTo(self.detectionView.mas_left).offset(12 * WIDTH_RATIO);
        make.right.equalTo(self.detectionView.mas_right).offset(-88 * WIDTH_RATIO);
    }];
    [self.detectionHintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detectionLabel.mas_centerY);
        make.left.equalTo(self.sizeLabel.mas_left).offset(77 * WIDTH_RATIO);
        make.width.mas_equalTo(15 * WIDTH_RATIO);
        make.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    [self.detectionSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detectionView.mas_centerY);
        make.right.equalTo(self.detectionView.mas_right).offset(-12 * WIDTH_RATIO);
        make.width.mas_equalTo(42 * WIDTH_RATIO);
        make.height.mas_equalTo(23 * WIDTH_RATIO);
    }];
}

//单项按钮
- (void)singleAndLabelReveal {
    [self.revealView addSubview:self.allPointButton];
    [self.revealView addSubview:self.actionPointButton];
    [self.revealView addSubview:self.actionPointLabel];
    [self.revealView addSubview:self.allPointLabel];
    
    [self.actionPointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.revealLabel.mas_bottom).offset(12 * WIDTH_RATIO);
        make.left.equalTo(self.revealView.mas_left).offset(12 * WIDTH_RATIO);
        make.height.width.equalTo(@(15* WIDTH_RATIO));
    }];
    [self.allPointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.actionPointButton.mas_centerY);
        make.height.width.equalTo(@(15* WIDTH_RATIO));
    }];
    [self.actionPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.actionPointButton.mas_centerY);
        make.left.equalTo(self.actionPointButton.mas_right).offset(3* WIDTH_RATIO);
        make.height.equalTo(@(20* WIDTH_RATIO));
        make.width.equalTo(@(70* WIDTH_RATIO));
    }];
    [self.allPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.allPointButton.mas_centerY);
        make.left.equalTo(self.allPointButton.mas_right).offset(3* WIDTH_RATIO);
        make.height.equalTo(@(20* WIDTH_RATIO));
        make.width.equalTo(@(70* WIDTH_RATIO));
    }];
}

//添加方案正在运行的提示图
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"isRecord"] || [keyPath isEqual:@"isPlayback"] || [keyPath isEqual:@"recordWindowState"]) {
        if([GTRecordManager shareInstance].isRecord)  {
            if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTime ||
                [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTimeDark) {
                [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecording];
            }else if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateStartRecord){
                [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecord];
            }
            self.clickerWindowStartView.hidden = NO;
        }else if ([GTRecordManager shareInstance].isPlayback) {
            [self.clickerWindowStartView updateDataWithType:SchemeActionPageTypeRecordPlaying];
            self.clickerWindowStartView.hidden = NO;
        }else {
            self.clickerWindowStartView.hidden = YES;
        }
    }
}

#pragma mark - response
- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)revealClick:(GTSwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.revealSwitchButton.on forKey:@"revealSwitchState"];
    [defaults setBool:YES forKey:@"reveal"];
    [defaults synchronize];
    
    if (!self.revealSwitchButton.on) {
        
        [GTClickerWindowManager shareInstance].pointSetModel.pointShowType = ClickerWindowPointShowNo;
        [UIView animateWithDuration:0.12 animations:^{
            [self.actionPointLabel removeFromSuperview];
            [self.allPointLabel removeFromSuperview];
            [self.actionPointButton removeFromSuperview];
            [self.allPointButton removeFromSuperview];
            [self.revealView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(45 * WIDTH_RATIO);
            }];
            [self.sizeView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.revealView.mas_bottom).offset(6 * WIDTH_RATIO);
            }];
            [self.detectionView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.sizeView.mas_bottom).offset(6 * WIDTH_RATIO);
            }];
            [self.view layoutIfNeeded];
        }];
    } else {
        int pointOpera = (int)[defaults integerForKey:@"pointOpera"];
        if (pointOpera == 0) {
            //显示运行按钮的功能
            [GTClickerWindowManager shareInstance].pointSetModel.pointShowType = ClickerWindowPointShowExecute;
        }else {
            //显示运行按钮的功能
            [GTClickerWindowManager shareInstance].pointSetModel.pointShowType = ClickerWindowPointShowAll;
        }
        [UIView animateWithDuration:0.12 animations:^{
            [self.revealView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(70 * WIDTH_RATIO);
            }];
            [self.sizeView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.revealView.mas_bottom).offset(6 * WIDTH_RATIO);
            }];
            [self.detectionView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.sizeView.mas_bottom).offset(6 * WIDTH_RATIO);
            }];
            [self.view layoutIfNeeded];
            //添加触点显示的单项按钮🔘与label
            [self singleAndLabelReveal];
        }];
    }
}

- (void)PointOperaClick:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int pointOpera = (int)[defaults integerForKey:@"pointOpera"];
    
    if (sender.tag == pointOpera) {
        return;
    }
    switch (sender.tag) {
        case 0:{
            self.actionPointButton.selected = YES;
            [self.actionPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
            
            self.allPointButton.selected = NO;
            [self.allPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            pointOpera = 0;
            [defaults setInteger:pointOpera forKey:@"pointOpera"];
            [defaults synchronize];

            //显示运行按钮的功能
            [GTClickerWindowManager shareInstance].pointSetModel.pointShowType = ClickerWindowPointShowExecute;
            
            
            break;
            
        }
        case 1:{
            self.allPointButton.selected = YES;
            [self.allPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
            
            self.actionPointButton.selected = NO;
            [self.actionPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            
            pointOpera = 1;
            [defaults setInteger:pointOpera forKey:@"pointOpera"];
            [defaults synchronize];

            //显示所有按钮的功能
            [GTClickerWindowManager shareInstance].pointSetModel.pointShowType = ClickerWindowPointShowAll;
            
            break;
            
        }
        default:
            break;
    }
}



- (void)PointClick:(UIButton *)button{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int pointSize = (int)[defaults integerForKey:@"pointSize"];
    self.selectedButtonIndex = pointSize;
    int buttonIndex = (int)button.tag; // 按钮的tag分别为0、1、2 中小大
    if (buttonIndex == self.selectedButtonIndex) {
        return;
    }
    self.selectedButtonIndex = buttonIndex;
    switch (self.selectedButtonIndex) {
        case 0:{
            self.middlePointButton.selected = YES;
            [self.middlePointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
            
            self.smallPointButton.selected = NO;
            [self.smallPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            
            self.bigPointButton.selected = NO;
            [self.bigPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:self.selectedButtonIndex forKey:@"pointSize"];
            [defaults synchronize];

            //将触点图片设置为标准
            [GTClickerWindowManager shareInstance].pointSetModel.pointSize = ClickerWindowPointSizeOfMedium;
        }
            break;
        case 1:{
            self.smallPointButton.selected = YES;
            [self.smallPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
            
            self.middlePointButton.selected = NO;
            [self.middlePointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            
            self.bigPointButton.selected = NO;
            [self.bigPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:self.selectedButtonIndex forKey:@"pointSize"];
            [defaults synchronize];

            //将触点图片设置为小的
            [[GTClickerWindowManager shareInstance].pointSetModel setPointSize:ClickerWindowPointSizeOfSmall];
        }
            break;
        case 2:{
            self.bigPointButton.selected = YES;
            [self.bigPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
            
            self.middlePointButton.selected = NO;
            [self.middlePointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            
            self.smallPointButton.selected = NO;
            [self.smallPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:self.selectedButtonIndex forKey:@"pointSize"];
            [defaults synchronize];
            
            [GTClickerWindowManager shareInstance].pointSetModel.pointSize = ClickerWindowPointSizeOfLarge;
        }
            break;
        default:
            break;
    }

}

- (void)detectionClick:(GTSwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.detectionSwitchButton.on forKey:@"detectionSwitchState"];
    [defaults synchronize];
    
    //工具箱开关切换埋点
    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxOpenCloseSwitch andProperties:@{
        @"tool_name" : @"连点器",
        @"is_open" : [NSNumber numberWithBool:self.detectionSwitchButton.on],
        @"toolbox_openclose_type" : [NSNumber numberWithInt:1]
    } shouldFlush:YES];
    
    //检测脚本功能
    
    
    
}

//触点大小的提示弹窗
- (void)sizeHintClick:(UIButton *)sender {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.backgroundView = [[UIView alloc] initWithFrame:screenRect];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapBackgroundGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCustomView)];
    [self.backgroundView addGestureRecognizer:tapBackgroundGesture];
   
    [[GTSDKUtils getTopWindow].view addSubview:self.backgroundView];
    
    //提示语
    self.tipView = [UIView new];
    self.tipView.layer.cornerRadius = 10*WIDTH_RATIO;
    self.tipView.backgroundColor = [GTThemeManager share].colorModel.clicker_settipView_color;
    self.tipView.layer.borderColor = [GTThemeManager share].colorModel.clicker_tipborder_gray_color.CGColor;
    self.tipView.layer.borderWidth = 0.5*WIDTH_RATIO;
    self.tipView.layer.shadowColor = [GTThemeManager share].colorModel.clicker_tipshadow_color.CGColor;
    self.tipView.layer.shadowOffset = CGSizeMake(0,0);
    self.tipView.layer.shadowOpacity = 1*WIDTH_RATIO;
    self.tipView.layer.shadowRadius = 14*WIDTH_RATIO;
    
    [self.backgroundView addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sizeHintButton.mas_top).offset(-8*WIDTH_RATIO);
        make.centerX.equalTo(self.sizeHintButton.mas_centerX);
        make.height.equalTo(@(35*WIDTH_RATIO));
        make.width.equalTo(@(125*WIDTH_RATIO));
    }];
    
    self.tipLabel = [UILabel new];
    self.tipLabel.text = localString(@"仅生效于连点功能");
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    self.tipLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    
    [self.tipView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tipView.mas_bottom).offset(-9*WIDTH_RATIO);
        make.top.equalTo(self.tipView.mas_top).offset(9*WIDTH_RATIO);
        make.left.equalTo(self.tipView.mas_left).offset(10*WIDTH_RATIO);
        make.right.equalTo(self.tipView.mas_right).offset(-10*WIDTH_RATIO);
    }];
    
   
    self.tipImageView = [UIImageView new];
    self.tipImageView.image = [[GTThemeManager share] imageWithName:@"gt_triangle_icon"];

    [self.backgroundView addSubview:self.tipImageView];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sizeHintButton.mas_top).offset(-4*WIDTH_RATIO);
        make.centerX.equalTo(self.sizeHintButton.mas_centerX);
        make.width.equalTo(@(14*WIDTH_RATIO));
        make.height.equalTo(@(5*WIDTH_RATIO));
    }];
}


//脚本检测的提示弹窗
-(void)detectionHintClick:(UIButton *)sender{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.backgroundView = [[UIView alloc] initWithFrame:screenRect];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapBackgroundGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCustomView)];
    [self.backgroundView addGestureRecognizer:tapBackgroundGesture];
    [[GTSDKUtils getTopWindow].view addSubview:self.backgroundView];
    
    self.detectTipView = [UIView new];
    self.detectTipView.layer.cornerRadius = 10*WIDTH_RATIO;
    self.detectTipView.backgroundColor = [GTThemeManager share].colorModel.clicker_settipView_color;
    self.detectTipView.layer.borderColor = [GTThemeManager share].colorModel.clicker_tipborder_gray_color.CGColor;
    self.detectTipView.layer.borderWidth = 0.5*WIDTH_RATIO ;
    self.detectTipView.layer.shadowColor = [GTThemeManager share].colorModel.clicker_tipshadow_color.CGColor;
    self.detectTipView.layer.shadowOffset = CGSizeMake(0,0);
    self.detectTipView.layer.shadowOpacity = 1*WIDTH_RATIO;
    self.detectTipView.layer.shadowRadius = 14*WIDTH_RATIO;
    
    [self.backgroundView addSubview: self.detectTipView];
    [ self.detectTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.detectionHintButton.mas_top).offset(-8);
        make.left.equalTo(self.view.mas_left).offset(10*WIDTH_RATIO);
        make.right.equalTo(self.view.mas_right).offset(-10*WIDTH_RATIO);
        make.height.equalTo(@(51*WIDTH_RATIO));
    }];
    
    self.detectTipLabel = [UILabel new];
    self.detectTipLabel.text = localString(@"开启后触点的点击位置和间隔将加入一个随机值保证每次点击不一致，但是不影响实际的点击效果");
    self.detectTipLabel.textAlignment = NSTextAlignmentLeft;
    self.detectTipLabel.numberOfLines = 2;
    self.detectTipLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    self.detectTipLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    [self.backgroundView addSubview:self.detectTipLabel];
    
    [self.detectTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.detectTipView.mas_bottom).offset(-9*WIDTH_RATIO);
        make.top.equalTo(self.detectTipView.mas_top).offset(9*WIDTH_RATIO);
        make.left.equalTo(self.detectTipView.mas_left).offset(10*WIDTH_RATIO);
        make.right.equalTo(self.detectTipView.mas_right).offset(-10*WIDTH_RATIO);
    }];
    
  
    self.detectTipImageView = [UIImageView new];
    self.detectTipImageView.image = [[GTThemeManager share] imageWithName:@"gt_triangle_icon"];

    [self.backgroundView addSubview:self.detectTipImageView];
    [self.detectTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.detectionHintButton.mas_top).offset(-4);
        make.centerX.equalTo(self.detectionHintButton.mas_centerX);
        make.width.equalTo(@(14));
        make.height.equalTo(@(5));
    }];
}

//两个提示框用的一个backgroundView,调用同一个函数可以清除
-(void)hideCustomView {
    [self.backgroundView removeFromSuperview];
}

#pragma mark -setter & getter
- (UIButton *)returnButton {
    if (!_returnButton) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnButton setImage:[[GTThemeManager share] imageWithName:@"window_back_btn"] forState:UIControlStateNormal];
        [_returnButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
        [_returnButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnButton;
}

- (UILabel *)setLabel {
    if (!_setLabel) {
        _setLabel = [UILabel new];
        _setLabel.text = localString(@"设置");
        _setLabel.textAlignment = NSTextAlignmentCenter;
        _setLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _setLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
    }
    return _setLabel;
}

/*
    reveal
*/

-(UIView *)revealView{
    if(!_revealView){
        _revealView = [UIView new];
        _revealView.backgroundColor = [GTThemeManager share].colorModel.clicker_SetView_color;
        _revealView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _revealView.layer.masksToBounds = YES;
    }
    return _revealView;
}
- (UILabel *)revealLabel {
    if (!_revealLabel) {
        _revealLabel = [UILabel new];
        _revealLabel.text = localString(@"触点显示");
        _revealLabel.textAlignment = NSTextAlignmentLeft;
        _revealLabel.textColor = [GTThemeManager share].colorModel.clicker_cell_text_color;
        _revealLabel.font = [UIFont systemFontOfSize:14*WIDTH_RATIO];
    }
    return _revealLabel;
}
- (GTSwitch *)revealSwitchButton {
    if (!_revealSwitchButton) {
        _revealSwitchButton = [GTSwitch new];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL switchState = [defaults boolForKey:@"revealSwitchState"];
        BOOL reveal = [defaults boolForKey:@"reveal"];
        
        if(reveal){
            _revealSwitchButton.on = switchState;
        }else{
            _revealSwitchButton.on = YES;
        }
        
        [_revealSwitchButton addTarget:self action:@selector(revealClick:) forControlEvents:UIControlEventValueChanged];
       
    }
    return _revealSwitchButton;
}

- (UIButton *)actionPointButton {
    if (!_actionPointButton) {
        _actionPointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionPointButton.layer.cornerRadius = 7.5;
        _actionPointButton.layer.masksToBounds = YES;
        _actionPointButton.tag = 0;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int pointOpera = (int)[defaults integerForKey:@"pointOpera"];

        if(pointOpera == 0){
            [_actionPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
        }else{
            [_actionPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
        }
        [_actionPointButton addTarget:self action:@selector(PointOperaClick:) forControlEvents:UIControlEventTouchUpInside];
        [_actionPointButton setEnlargeEdgeWithTop:5 right:70 bottom:5 left:5];
    }
    return _actionPointButton;
}
- (UILabel *)actionPointLabel {
    if (!_actionPointLabel) {
        _actionPointLabel = [UILabel new];
        _actionPointLabel.text = localString(@"运行触点");
        _actionPointLabel.textAlignment = NSTextAlignmentLeft;
        _actionPointLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _actionPointLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
    }
    return _actionPointLabel;
}
- (UIButton *)allPointButton {
    if (!_allPointButton) {
        _allPointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allPointButton.layer.cornerRadius = 7.5;
        _allPointButton.layer.masksToBounds = YES;
        _allPointButton.tag = 1;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int pointOpera = (int)[defaults integerForKey:@"pointOpera"];

        if(pointOpera == 1){
            [_allPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
        }else{
            [_allPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
        }
        [_allPointButton addTarget:self action:@selector(PointOperaClick:) forControlEvents:UIControlEventTouchUpInside];
        [_allPointButton setEnlargeEdgeWithTop:5 right:70 bottom:5 left:5];
    }
    return _allPointButton;
}
- (UILabel *)allPointLabel {
    if (!_allPointLabel) {
        _allPointLabel = [UILabel new];
        _allPointLabel.text = localString(@"所有触点");
        _allPointLabel.textAlignment = NSTextAlignmentLeft;
        _allPointLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _allPointLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
    }
    return _allPointLabel;
}

/*
    size
*/

-(UIView *)sizeView{
    if(!_sizeView){
        _sizeView = [UIView new];
        _sizeView.backgroundColor = [GTThemeManager share].colorModel.clicker_SetView_color;
        _sizeView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _sizeView.layer.masksToBounds = YES;
    }
    return _sizeView;
}
- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [UILabel new];
        _sizeLabel.text = localString(@"触点大小");
        _sizeLabel.textAlignment = NSTextAlignmentLeft;
        _sizeLabel.textColor = [GTThemeManager share].colorModel.clicker_cell_text_color;
        _sizeLabel.font = [UIFont systemFontOfSize:14*WIDTH_RATIO];
    }
    return _sizeLabel;
}
- (UIButton *)sizeHintButton {
    if (!_sizeHintButton) {
        _sizeHintButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sizeHintButton.layer.cornerRadius = 7.5;
        _sizeHintButton.layer.masksToBounds = YES;
        [_sizeHintButton setImage:[[GTThemeManager share] imageWithName:@"clicker_prompt_icon"] forState:UIControlStateNormal];
        [_sizeHintButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
        [_sizeHintButton addTarget:self action:@selector(sizeHintClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sizeHintButton;
}
- (UILabel *)smallPointLabel {
    if (!_smallPointLabel) {
        _smallPointLabel = [UILabel new];
        _smallPointLabel.text = localString(@"小");
        _smallPointLabel.textAlignment = NSTextAlignmentLeft;
        _smallPointLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _smallPointLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
    }
    return _smallPointLabel;
}
- (UILabel *)middlePointLabel {
    if (!_middlePointLabel) {
        _middlePointLabel = [UILabel new];
        _middlePointLabel.text = localString(@"标准");
        _middlePointLabel.textAlignment = NSTextAlignmentLeft;
        _middlePointLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _middlePointLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
    }
    return _middlePointLabel;
}
- (UILabel *)bigPointLabel {
    if (!_bigPointLabel) {
        _bigPointLabel = [UILabel new];
        _bigPointLabel.text = localString(@"大");
        _bigPointLabel.textAlignment = NSTextAlignmentLeft;
        _bigPointLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _bigPointLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
    }
    return _bigPointLabel;
}
- (UIButton *)smallPointButton {
    if (!_smallPointButton) {
        _smallPointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _smallPointButton.layer.cornerRadius = 7.5;
        _smallPointButton.layer.masksToBounds = YES;
        _smallPointButton.tag = 1;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int pointSize = (int)[defaults integerForKey:@"pointSize"];
        
        if(pointSize==1){
            [_smallPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
            _smallPointButton.selected = YES;
        }else{
            [_smallPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            _smallPointButton.selected = NO;
        }
        [_smallPointButton addTarget:self action:@selector(PointClick:) forControlEvents:UIControlEventTouchUpInside];
        [_smallPointButton setEnlargeEdgeWithTop:8 right:55 bottom:8 left:8];
    }
    return _smallPointButton;
}
- (UIButton *)middlePointButton {
    if (!_middlePointButton) {
        _middlePointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _middlePointButton.layer.cornerRadius = 7.5;
        _middlePointButton.layer.masksToBounds = YES;
        _middlePointButton.tag = 0;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int pointSize = (int)[defaults integerForKey:@"pointSize"];
        if(pointSize == 0){
            [_middlePointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
            _middlePointButton.selected = YES;
        }else{
            [_middlePointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            _middlePointButton.selected = NO;
        }
        [_middlePointButton addTarget:self action:@selector(PointClick:) forControlEvents:UIControlEventTouchUpInside];
        [_middlePointButton setEnlargeEdgeWithTop:8 right:55 bottom:8 left:8];
    }
    return _middlePointButton;
}
- (UIButton *)bigPointButton {
    if (!_bigPointButton) {
        _bigPointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bigPointButton.layer.cornerRadius = 7.5;
        _bigPointButton.layer.masksToBounds = YES;
        _bigPointButton.tag = 2;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int pointSize = (int)[defaults integerForKey:@"pointSize"];
      
        if(pointSize == 2){
            [_bigPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_choose_icon"] forState:UIControlStateNormal];
            self.bigPointButton.selected = YES;
        }else{
            [_bigPointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_radio_unchoose_icon"] forState:UIControlStateNormal];
            self.bigPointButton.selected = NO;
        }
        [_bigPointButton addTarget:self action:@selector(PointClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bigPointButton setEnlargeEdgeWithTop:8 right:55 bottom:8 left:8];
    }
    return _bigPointButton;
}

/*
    detection
*/

-(UIView *)detectionView{
    if(!_detectionView){
        _detectionView = [UIView new];
        _detectionView.backgroundColor = [GTThemeManager share].colorModel.clicker_SetView_color;
        _detectionView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _detectionView.layer.masksToBounds = YES;
    }
    return _detectionView;
}
- (UILabel *)detectionLabel {
    if (!_detectionLabel) {
        _detectionLabel = [UILabel new];
        _detectionLabel.text = localString(@"防脚本检测");
        _detectionLabel.textAlignment = NSTextAlignmentLeft;
        _detectionLabel.textColor = [GTThemeManager share].colorModel.clicker_cell_text_color;
        _detectionLabel.font = [UIFont systemFontOfSize:14*WIDTH_RATIO];
    }
    return _detectionLabel;
}
- (UIButton *)detectionHintButton {
    if (!_detectionHintButton) {
        _detectionHintButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detectionHintButton.layer.cornerRadius = 7.5;
        _detectionHintButton.layer.masksToBounds = YES;
        [_detectionHintButton setImage:[[GTThemeManager share] imageWithName:@"clicker_prompt_icon"] forState:UIControlStateNormal];
        [_detectionHintButton addTarget:self action:@selector(detectionHintClick:) forControlEvents:UIControlEventTouchUpInside];
        [_detectionHintButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:8];
    }
    return _detectionHintButton;
}
- (GTSwitch *)detectionSwitchButton {
    if (!_detectionSwitchButton) {
        _detectionSwitchButton = [GTSwitch new];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL switchState = [defaults boolForKey:@"detectionSwitchState"];
        _detectionSwitchButton.on = switchState;
        [_detectionSwitchButton addTarget:self action:@selector(detectionClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _detectionSwitchButton;
}



@end
