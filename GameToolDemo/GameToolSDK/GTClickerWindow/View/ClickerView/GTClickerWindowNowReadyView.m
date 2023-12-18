//
//  GTClickerWindowNowReadyView.m
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTClickerWindowNowReadyView.h"
#import "UIButton+Extent.h"
#import "GTClickerWindowManager.h"
#import "GTClickerWindowAnimation.h"
#import "GTClickerWindowManager.h"
#import "GTFloatingWindowManager.h"
#import "GTClickerManager.h"
#import "GTDialogWindowManager.h"
#import "GTFloatingBallManager.h"
#import "SMEventSensor.h"
#import "UIButton+Extent.h"

@interface GTClickerWindowNowReadyView ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *setButton;

//@property (nonatomic, strong) UILabel *startLabel;
//@property (nonatomic, strong) UILabel *addLabel;
//@property (nonatomic, strong) UILabel *setLabel;

@end

@implementation GTClickerWindowNowReadyView

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
    
    [self addSubview:self.shadowImg];
    
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
/**
 开始连点器功能
 */
- (void)startClick {
    //第一次移除蒙层
    [[GTDialogWindowManager shareInstance] dialogWindowHide];
    
    [GTClickerWindowManager shareInstance].clickerWindowState = ClickerWindowStateNowStart;
    [GTClickerWindowAnimation clickerWindowNowReadyToNowStartAnimationWithCompletion:nil];
    //记录当前按下立即启动按钮时的方案
    //与下次按时进行对比，如果一样，则判断是否完成过上一个方案，如果已完成，则为重新开始，否则是继续。
    //如果不一样，则重新开始
    //1.8版本更改需求：连点器的暂停改为结束，至于是否支持暂停待后面补充
    /**
    if ([[[GTClickerWindowManager shareInstance].schemeModel modelToJSONString] isEqualToString:[GTClickerWindowManager shareInstance].lastClickJsonString]) {
        if ([GTClickerManager shareInstance].isComplete) {
            //开始连点器
            [[GTClickerManager shareInstance] startScheme:[[GTClickerWindowManager shareInstance].schemeModel modelToJSONString]];
        }else {
            //继续连点器
            [[GTClickerManager shareInstance] continueScheme];
        }
    }else {
        //开始连点器
        [[GTClickerManager shareInstance] startScheme:[[GTClickerWindowManager shareInstance].schemeModel modelToJSONString]];
    }
     */
    
    //开始连点器
    [[GTClickerManager shareInstance] startScheme:[[GTClickerWindowManager shareInstance].schemeModel modelToJSONString]];
    
    //保存点击时的方案json字符串
    [GTClickerWindowManager shareInstance].lastClickJsonString = [[GTClickerWindowManager shareInstance].schemeModel modelToJSONString];
    
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
    int plan_id = [[GTClickerManager shareInstance] getPlanId];
    //AutoClickerRunDurationEvent 连点器使用时长 CP&Sensor 立即执行
    [SMEventSensor startReport:ToolTypeClicker event:AutoClickerRunDurationEvent params:@{@"plan_id":@(plan_id),@"countdown_time":@(0.0)}];
}

- (void)addClick {
    //第一次移除蒙层
    [[GTDialogWindowManager shareInstance] dialogWindowHide];
    
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
    //第一次移除蒙层
    [[GTDialogWindowManager shareInstance] dialogWindowHide];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKClickerWindowTapSetNotification object:self userInfo:nil];
    
    [[GTFloatingBallManager shareInstance] floatingBallHide];
    [[GTClickerWindowManager shareInstance] clickerWindowHide];
    [[GTFloatingWindowManager shareInstance] floatingWindowShow];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - setter & getter

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.adjustsImageWhenHighlighted = NO;
        [_startButton setImage:[[GTThemeManager share] imageWithName:@"clicker_window_start_btn"] forState:UIControlStateNormal];
        [_startButton setTitle:localString(@"执行") forState:UIControlStateNormal];
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
//        _startLabel.text = localString(@"执行");
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
        [_addButton setTitle:localString(@"执行") forState:UIControlStateNormal];
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

//蒙层
- (UIImageView *)shadowImg {
    if (!_shadowImg) {
        _shadowImg = [UIImageView new];
        _shadowImg.image = [[GTThemeManager share] imageWithName:@""];
        _shadowImg.hidden = YES;
    }
    return _shadowImg;
}

@end
