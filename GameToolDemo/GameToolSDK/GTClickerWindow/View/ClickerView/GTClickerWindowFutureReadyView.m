//
//
//
//
//
//
//  GTClickerWindowFutureReadyView.m
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTClickerWindowFutureReadyView.h"
#import "UIButton+Extent.h"
#import "GTClickerWindowManager.h"
#import "GTClickerWindowAnimation.h"
#import "GTFloatingWindowManager.h"
#import "GTClickerMainViewController.h"
#import "GTClickerWindowBehave.h"
#import "GTFloatingBallManager.h"
#import "GTClickerManager.h"
#import "SMEventSensor.h"
#import "UIButton+Extent.h"

//启动
typedef void(^StartBlock)(void);
//增加
typedef void(^addBlock)(void);
//设置
typedef void(^SetBlock)(void);
@interface GTClickerWindowFutureReadyView ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *setButton;


//@property (nonatomic, strong) UILabel *startLabel;
//@property (nonatomic, strong) UILabel *addLabel;
//@property (nonatomic, strong) UILabel *setLabel;

@end

@implementation GTClickerWindowFutureReadyView

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
//    [self addSubview:self.startLabel];
    
    [self addSubview:self.addButton];
//    [self addSubview:self.addLabel];
    
    [self addSubview:self.setButton];
//    [self addSubview:self.setLabel];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(6 * WIDTH_RATIO);
        make.left.equalTo(self.mas_left).offset(6 * WIDTH_RATIO);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
//    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.startButton.mas_bottom).offset(1 * WIDTH_RATIO);
//        make.centerX.equalTo(self.startButton.mas_centerX);
//        make.height.mas_equalTo(11 * WIDTH_RATIO);
//    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(6 * WIDTH_RATIO);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
//    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.addButton.mas_bottom).offset(1 * WIDTH_RATIO);
//        make.centerX.equalTo(self.addButton.mas_centerX);
//        make.height.mas_equalTo(11 * WIDTH_RATIO);
//    }];
    
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(6 * WIDTH_RATIO);
        make.right.equalTo(self.mas_right).offset(-6 * WIDTH_RATIO);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
//    [self.setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.setButton.mas_bottom).offset(1 * WIDTH_RATIO);
//        make.centerX.equalTo(self.setButton.mas_centerX);
//        make.height.mas_equalTo(11 * WIDTH_RATIO);
//    }];
    
    [self.startButton layoutButtonWithImageTitleSpace:2];
    
    [self.addButton layoutButtonWithImageTitleSpace:2];
    
    [self.setButton layoutButtonWithImageTitleSpace:2];
}

#pragma mark - response

- (void)startClick {
    [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateFutureStart;
    
    [GTClickerWindowAnimation clickerWindowFutureReadyToFutureStartAnimationWithCompletion:^{
        [[GTClickerWindowManager shareInstance].clickerWindowVC.futureStartView clickerWindowStartDark];
    }];
    
    if ([[GTClickerWindowManager shareInstance].schemeJsonString isEqualToString:@""]) {
        //工具箱元素点击埋点
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:0],  @"toolbox_click_type" : [NSNumber numberWithInt:6]} shouldFlush:YES];
    }else {
        //工具箱元素点击埋点
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:-2],  @"toolbox_click_type" : [NSNumber numberWithInt:6]} shouldFlush:YES];
    }
    
    if (self.startBlock) {
        self.startBlock();
    }
    GTClickerSchemeModel *schemeModel = [GTClickerWindowManager shareInstance].schemeModel;
    int plan_id = [[GTClickerManager shareInstance] getPlanId];;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"plan_id":@(plan_id)}];
    if(schemeModel.startMethod==ClickerWindowStartMethodCountdown){
        int countdown_time = [NSDate countDownConvertToSeconds:schemeModel.startTime];
        [params addEntriesFromDictionary:@{@"countdown_time":@(countdown_time)}];
    }
    if (schemeModel.startMethod ==  ClickerWindowStartMethodPreset) {
        int countdown_time = [NSDate appointmentTimeConvertToSeconds:schemeModel.startTime];
        [params addEntriesFromDictionary:@{@"countdown_time":@(countdown_time)}];
    }
    //AutoClickerRunDurationEvent 连点器使用时长 CP&Sensor 倒计时和定时
    [SMEventSensor startReport:ToolTypeClicker event:AutoClickerRunDurationEvent params:params];
    
}

- (void)addClick {
    GTClickerActionModel *actionModel = [GTClickerActionModel new];
    actionModel.tapCount = 1;
    actionModel.pressDuration = 80;
    actionModel.clickInterval = 1000;
    actionModel.centerX = SCREEN_WIDTH/2;
    actionModel.centerY = [GTSDKUtils isPortrait]?160 * WIDTH_RATIO : 80 * WIDTH_RATIO;
    [[GTClickerWindowManager shareInstance].schemeModel.actionArray addObject:actionModel];
    [[GTClickerWindowManager shareInstance].compareArray addObject:actionModel];
    GTClickerPointWindow *pointWindow = [[GTClickerPointWindow alloc] initWithFrame:CGRectZero withIndex:(int)([GTClickerWindowManager shareInstance].pointWindowArray.count+1) actionModel:actionModel];
    pointWindow.windowLevel = 26000 + 10 * (int)[GTClickerWindowManager shareInstance].pointWindowArray.count;
    [[GTClickerWindowManager shareInstance].pointWindowArray addObject:pointWindow];
    
    pointWindow.transform = CGAffineTransformMakeScale(0, 0);
    [pointWindow makeKeyAndVisible];
    
    [GTClickerWindowAnimation clickerNormalAddPointWindow:pointWindow animationWithCompletion:^{
        
    }];
    [GTClickerWindowManager shareInstance].isAllPointShow = YES;
}

- (void)setClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowTapSetNotification object:self userInfo:nil];

    [[GTFloatingBallManager shareInstance] floatingBallHide];
    [[GTClickerWindowManager shareInstance] clickerWindowHide];
    [[GTFloatingWindowManager shareInstance] floatingWindowShow];
}

#pragma mark - setter & getter

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.adjustsImageWhenHighlighted = NO;
        [_startButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_start_btn"] forState:UIControlStateNormal];
        [_startButton setTitle:localString(@"定时执行") forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor themeColorWithAlpha:0.8] forState:UIControlStateNormal];
        _startButton.titleLabel.font = [UIFont systemFontOfSize:8 *  WIDTH_RATIO];
        _startButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_startButton addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

//- (UILabel *)startLabel {
//    if (!_startLabel) {
//        _startLabel = [UILabel new];
//        _startLabel.text = localString(@"定时执行");
//        _startLabel.textColor = [UIColor themeColorWithAlpha:0.8];
//        _startLabel.font = [UIFont systemFontOfSize:9 * WIDTH_RATIO];
//        _startLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _startLabel;
//}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.adjustsImageWhenHighlighted = NO;
        [_addButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_add_btn"] forState:UIControlStateNormal];
        [_addButton setTitle:localString(@"增加") forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor themeColorWithAlpha:0.8] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:8 *  WIDTH_RATIO];
        _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

//- (UILabel *)addLabel {
//    if (!_addLabel) {
//        _addLabel = [UILabel new];
//        _addLabel.text = localString(@"增加");
//        _addLabel.textColor = [UIColor themeColorWithAlpha:0.8];
//        _addLabel.font = [UIFont systemFontOfSize:9 * WIDTH_RATIO];
//        _addLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _addLabel;
//}

- (UIButton *)setButton {
    if (!_setButton) {
        _setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _setButton.adjustsImageWhenHighlighted = NO;
        [_setButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_set_btn"] forState:UIControlStateNormal];
        [_setButton setTitle:localString(@"设置") forState:UIControlStateNormal];
        [_setButton setTitleColor:[UIColor themeColorWithAlpha:0.8] forState:UIControlStateNormal];
        _setButton.titleLabel.font = [UIFont systemFontOfSize:8 *  WIDTH_RATIO];
        _setButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_setButton addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setButton;
}

//- (UILabel *)setLabel {
//    if (!_setLabel) {
//        _setLabel = [UILabel new];
//        _setLabel.text = localString(@"设置");
//        _setLabel.textColor = [UIColor themeColorWithAlpha:0.8];
//        _setLabel.font = [UIFont systemFontOfSize:9 * WIDTH_RATIO];
//        _setLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _setLabel;
//}

@end
