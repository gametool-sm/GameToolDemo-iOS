//
//  GTFloatingBallControlView.m
//  GTSDK
//
//  Created by shangmi on 2023/7/3.
//

#import "GTFloatingBallControlView.h"
#import "GTSpeedUpManager.h"
#import "GTSDKConfig.h"
#import "GTFloatingBallConfig.h"
#import "GTFirstOpenMinimalistMask.h"
#import "GTFloatingBallManager.h"

@interface GTFloatingBallControlView ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) GTMultiplyingModel *selectedModel;

@end

@implementation GTFloatingBallControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        [self setUp];
    }
    return self;
}

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        [view removeFromSuperview];
        view = nil;
    }
    
    [self setUp];
}

- (void)setUp {
    [super setUp];
    
    [self addSubview:self.floatingBallBtn];
    
    [self.floatingBallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(6 * WIDTH_RATIO);
        make.width.mas_equalTo(35 * WIDTH_RATIO);
        make.height.mas_equalTo(35 * WIDTH_RATIO);
    }];
    
    self.buttonArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray arrayWithArray:[GTSDKUtils getCurrentMultiplying]];
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        [button setTitle:[NSString stringWithFormat:@"x%@", [NSString getSpeedText:self.dataArray[idx]]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        GTMultiplyingModel *model = (GTMultiplyingModel *)self.dataArray[idx];
        if (model.isSelected) {
            self.selectedModel = model;
            [button setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        }else {
            [button setTitleColor:[GTThemeManager share].colorModel.textColor forState:UIControlStateNormal];
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.floatingBallBtn.mas_bottom).offset(6 * WIDTH_RATIO + 27 * WIDTH_RATIO * idx);
            make.centerX.equalTo(self.mas_centerX);
            make.width.mas_equalTo(46 * WIDTH_RATIO);
            make.height.mas_equalTo(27 * WIDTH_RATIO);
        }];
        
        [self.buttonArray addObject:button];
    }];
}

- (void)buttonClick:(UIButton *)sender {
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GTMultiplyingModel *model = self.dataArray[idx];
        
        if (sender == (UIButton *)obj) {
            model.isSelected = YES;
            [obj setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
            
            //加速器倍率调整埋点
            [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventGameSpeedRateAdjust andProperties:@{
                @"rate_adjust_source" : [NSNumber numberWithInt:2],
                @"speed_rate" : [NSNumber numberWithFloat:[[NSString getSpeedText:self.dataArray[idx]] floatValue]]
            } shouldFlush:YES];
        }else {
            model.isSelected = NO;
            [obj setTitleColor:[GTThemeManager share].colorModel.floating_ball_control_mode_btn_title_color forState:UIControlStateNormal];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 添加蒙层
//注释            [GTFloatingBallConfig floatingBallControlModeExtinguishWithView:self completion:nil];
        });
        
        [GTSDKUtils saveCurrentMultiplying:self.dataArray];
        //改变加速
    }];
}

- (void)clickShadowView:(CGPoint)point {
    if (CGRectContainsPoint(self.floatingBallBtn.frame, point)) {
        [self controlClick];
    }else {
        [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = (UIButton *)obj;
            if (CGRectContainsPoint(button.frame, point)) {
                [self buttonClick:button];
            }
        }];
    }
}

- (void)controlClick {
    [GTSpeedUpManager shareInstance].isStart = ![GTSpeedUpManager shareInstance].isStart;
    if ([GTSpeedUpManager shareInstance].isStart) { //开始
        //工具箱元素点击埋点
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"加速器", @"plan_id" : [NSNumber numberWithInt:-1],  @"toolbox_click_type" : [NSNumber numberWithInt:11]} shouldFlush:YES];
        
        [self.floatingBallBtn setImage:[[GTThemeManager share] imageWithName:@"floating_ball_pause_btn"] forState:UIControlStateNormal];
        
        if (self.selectedModel.number != 1.0) {
            //加速器使用时长埋点（开始计时）
            //神策开始计时
            GTSensorEventGameSpeedUseDurationID = [[GTDataTimeCounter sharedInstance] start:GTSensorEventGameSpeedUseDuration];
            //cp开始计时
            [SMDurationEventReport startReport:ToolTypeClicker eventName:GTSensorEventAutoClickerStartDuration params:@{}];
        }
    }else {
        //工具箱元素点击埋点
        [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"加速器", @"plan_id" : [NSNumber numberWithInt:-1],  @"toolbox_click_type" : [NSNumber numberWithInt:12]} shouldFlush:YES];
        
        [self.floatingBallBtn setImage:[[GTThemeManager share] imageWithName:@"floating_ball_start_btn"] forState:UIControlStateNormal];
        
        //加速器使用时长埋点（结束计时）
        //神策开始计时
        [[GTDataTimeCounter sharedInstance] end:GTSensorEventGameSpeedUseDurationID];
        //cp开始计时
        [SMDurationEventReport finishReport:GTSensorEventAutoClickerStartDuration];
    }
    
    [GTSDKUtils saveSpeedUpControl:[GTSpeedUpManager shareInstance].isStart];
    [[NSNotificationCenter defaultCenter] postNotificationName:GTSDKChangeSpeedInfo object:self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.floatingBallBtn.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.floatingBallBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    });
    
    //如果极简模式的蒙版存在，则移除
    for (UIView *view in [GTSDKUtils getTopWindow].view.subviews) {
        if ([view isKindOfClass:[GTFirstOpenMinimalistMask class]]) {
            [view removeFromSuperview];
            [GTSDKUtils saveShowMinimalistGuideMask];
        }
    }
    
    if ([GTSDKUtils getAutoHideIsOn]) { //判断极简模式下贴边功能是否打开
        dispatch_async(dispatch_get_main_queue(), ^{
//注释            [GTFloatingBallConfig floatingBallControlModeClingWithView:self];
        });
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 添加蒙层
//注释        [GTFloatingBallConfig floatingBallControlModeExtinguishWithView:self completion:nil];
    });
}

- (UIButton *)floatingBallBtn {
    if (!_floatingBallBtn) {
        _floatingBallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _floatingBallBtn.adjustsImageWhenHighlighted = NO;
        _floatingBallBtn.backgroundColor = [GTThemeManager share].colorModel.floating_ball_btn_bg;
        if ([GTSpeedUpManager shareInstance].isStart) {
            [_floatingBallBtn setImage:[[GTThemeManager share] imageWithName:@"floating_ball_pause_btn"] forState:UIControlStateNormal];
        }else {
            [_floatingBallBtn setImage:[[GTThemeManager share] imageWithName:@"floating_ball_start_btn"] forState:UIControlStateNormal];
        }
        [_floatingBallBtn addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
        _floatingBallBtn.layer.cornerRadius = 17.5 * WIDTH_RATIO;
        _floatingBallBtn.layer.masksToBounds = YES;
    }
    return _floatingBallBtn;
}


@end
