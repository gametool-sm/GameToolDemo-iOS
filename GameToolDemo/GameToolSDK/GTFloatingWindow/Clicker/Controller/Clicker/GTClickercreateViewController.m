//
//  GTClickercreateViewController.m
//  GTSDK
//
//  Created by shangminet on 2023/8/15.
//
#import "GTClikerCreateView.h"
#import "GTClickercreateViewController.h"
#import "GTFloatingWindowViewController.h"

#import "GTClickerGuide.h"

#import "GTClickerPointSetViewController.h"
#import "GTFloatingWindowManager.h"
#import "GTClickerWindowManager.h"
#import "GTClickerActionModel.h"
#import "GTDialogWindowManager.h"
#import "GTClickerWindowAnimation.h"
#import "GTFloatingBallManager.h"
#import "UIButton+Extent.h"
#import "GTRecordSetViewController.h"
#import "GTRecordGuideView.h"
#import "GTRecordWindowManager.h"
#import "GTRecordSchemeSetController.h"

#import "GTRecordManager.h"
#import "SMEventSensor.h"

@interface GTClickercreateViewController ()

//mp4占位符
@property (nonatomic, strong) UIImageView *createView;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *connectpointButton;
@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UILabel *selectTypeLabel;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIView *tipNewPointLocationView;
@property (nonatomic, strong) UILabel *tipNewPointLocationLabel;
@property (nonatomic, strong) UIImageView *tipLocationImage;

@end

@implementation GTClickercreateViewController

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    self.view.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.selectTypeLabel.textColor = [GTThemeManager share].colorModel.titleColor;
    [self.recordButton setTitleColor:[GTThemeManager share].colorModel.clicker_createbutton_color forState:UIControlStateNormal];
    [self.recordButton setBackgroundColor:[GTThemeManager share].colorModel.clicker_create_button_color];
    [self.recordButton setImage:[[GTThemeManager share] imageWithName:@"clicker_create_video"] forState:UIControlStateNormal];
    [self.connectpointButton setTitleColor:[GTThemeManager share].colorModel.clicker_createbutton_color forState:UIControlStateNormal];
    [self.connectpointButton setBackgroundColor:[GTThemeManager share].colorModel.clicker_create_button_color];
    [self.connectpointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_create_click"] forState:UIControlStateNormal];
    [self.returnButton setImage:[[GTThemeManager share] imageWithName:@"window_back_btn"] forState:UIControlStateNormal];
//    self.createView.backgroundColor = [GTThemeManager share].colorModel.clicker_create_createView_color;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.selectTypeLabel];
    [self.view addSubview:self.recordButton];
    [self.view addSubview:self.connectpointButton];
    [self.view addSubview:self.returnButton];
    [self.view addSubview:self.createView];
    
    [self.selectTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.left.equalTo(self.view.mas_left).offset(16 * WIDTH_RATIO);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.connectpointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20 * WIDTH_RATIO);
        make.left.equalTo(self.view.mas_centerX).mas_offset(5* WIDTH_RATIO);
        make.right.equalTo(self.view.mas_right).offset(-20 * WIDTH_RATIO);
        make.height.mas_equalTo(42 * WIDTH_RATIO);
    }];
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20 * WIDTH_RATIO);
        make.right.equalTo(self.view.mas_centerX).mas_offset(-5* WIDTH_RATIO);
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.height.mas_equalTo(42 * WIDTH_RATIO);
    }];
    [self.createView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectTypeLabel.mas_bottom).offset(16 * WIDTH_RATIO);
        make.bottom.equalTo(self.recordButton.mas_top).offset(-18 * WIDTH_RATIO);
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.right.equalTo(self.view.mas_right).offset(-20 * WIDTH_RATIO);
    }];

}


#pragma mark - response

//返回
- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

//录制
- (void)recordClick{
    [[GTFloatingWindowManager shareInstance] floatingWindowHide];
    if([GTOperationControl shareInstance].gtSDKStyle ==  GTSDKStyleDefault) {
        [[GTFloatingBallManager shareInstance] floatingBallShow];
    }
    
    //因为录制只有有轨迹的情况下才算是有方案，所以这里不构造手持方案
    //在点击结束录制，并判断有轨迹时，才给手持方案赋值
//    GTRecordSetViewController *recordSetViewController = [GTRecordSetViewController new];
    GTRecordSchemeSetController *recordSetViewController = [GTRecordSchemeSetController new];
    recordSetViewController.DataArray = self.DataArray;
    recordSetViewController.row = self.DataArray.count;
    [self.navigationController pushViewController:recordSetViewController animated:NO];
    
    [GTRecordManager shareInstance].isRecord = YES;
    [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateStartRecord;
    [[GTRecordWindowManager shareInstance] recordWindowShow];
    
    //移除GTClickercreateViewController页面
    NSMutableArray *updatedViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
       if([vc isKindOfClass:[GTClickercreateViewController class]]){
           [updatedViewControllers removeObject:vc];
       }
    }
    self.navigationController.viewControllers = updatedViewControllers;
        [GTRecordGuideView showGuideViewWithCloseCallBack:^{
    }];
    
    //工具箱元素点击埋点
    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:-1],  @"toolbox_click_type" : [NSNumber numberWithInt:5]} shouldFlush:YES];
    
    //连点器启动时长埋点（开始计时）
    //神策开始计时    
    GTSensorEventAutoClickerStartDurationID = [[GTDataTimeCounter sharedInstance] start:GTSensorEventAutoClickerStartDuration externParam:@{@"kEventName" : @"AutoClickerStartDuration", @"kProperties" : @{@"plan_id" : [NSNumber numberWithInt:0]}}];
    //cp开始计时
//    [SMDurationEventReport startReport:ToolTypeClicker eventName:GTSensorEventAutoClickerStartDuration params:@{}];
}

//连点
- (void)connectpointClick{
    [[GTFloatingWindowManager shareInstance] floatingWindowHide];
    if([GTOperationControl shareInstance].gtSDKStyle ==  GTSDKStyleDefault) {
        [[GTFloatingBallManager shareInstance] floatingBallShow];
    }
    /*
     蒙层引导动画实现
     唤起连点器悬浮窗和引导蒙图
     设置一个是否引导过的缓存值 firstConnectPoint
     设置一个新的model
     */
    [GTClickerWindowManager shareInstance].schemeModel = nil;
    self.model = [GTClickerSchemeModel new];
    GTClickerActionModel *point = [GTClickerActionModel new];
    point.tapCount = 1;
    point.pressDuration = 80;
    point.clickInterval = 1000;
    point.centerX = SCREEN_WIDTH/2;
    point.centerY = [GTSDKUtils isPortrait]?160 * WIDTH_RATIO : 80 * WIDTH_RATIO;
    point.timestamp = 0;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:point];
    self.model.index = (int)self.DataArray.count;
    self.model.type = 1;
    self.model.cycleIndex = 0;
    self.model.startMethod = 0;
    self.model.name = [NSString stringWithFormat:@"默认连点方案%ld", self.DataArray.count + 1];
    self.model.startTime = @"00:00:00";
    self.model.actionArray = array;
    self.model.recordLines = [NSMutableArray array];
    
    GTClickerActionModel *point2 = [GTClickerActionModel new];
    point2.tapCount = 1;
    point2.pressDuration = 80;
    point2.clickInterval = 1000;
    point2.centerX = SCREEN_WIDTH/2;
    point2.centerY = [GTSDKUtils isPortrait]?160 * WIDTH_RATIO : 80 * WIDTH_RATIO;
    point2.timestamp = 0;
    NSMutableArray *array2 = [NSMutableArray array];
    [array2 addObject:point2];
    [GTClickerWindowManager shareInstance].compareArray = array2 ;
    [GTClickerWindowManager shareInstance].schemeModel = self.model;
    [GTClickerWindowManager shareInstance].schemeJsonString = @"";
    //从启用进入连点器悬浮窗，如果是不显示状态，则触点都不显示，其余状态显示.
    //新创建方案，不管pointShowType是什么状态，触点都显示
    [GTClickerWindowManager shareInstance].isAllPointShow = YES;
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.backgroundView = [[UIView alloc] initWithFrame:screenRect];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.tipView];
    [self.tipView addSubview:self.tipLocationImage];
    [self.tipView addSubview:self.tipNewPointLocationView];
    [self.tipNewPointLocationView addSubview:self.tipNewPointLocationLabel];
    
    if ([GTSDKUtils isPortrait]) {
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backgroundView.mas_centerX).offset(20 * WIDTH_RATIO);
            make.centerY.equalTo(self.backgroundView.mas_top).offset(160 * WIDTH_RATIO);
            make.width.equalTo(@(140 * WIDTH_RATIO));
            make.height.equalTo(@(35 *WIDTH_RATIO));
        }];
    }else{
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backgroundView.mas_centerX).offset(20 * WIDTH_RATIO);
            make.centerY.equalTo(self.backgroundView.mas_top).offset(80 * WIDTH_RATIO);
            make.width.equalTo(@(140 * WIDTH_RATIO));
            make.height.equalTo(@(35 *WIDTH_RATIO));
        }];
    }
    

        [self.tipLocationImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tipView.mas_centerY);
            make.left.equalTo(self.tipView.mas_left);
            make.width.equalTo(@(5*WIDTH_RATIO));
            make.height.equalTo(@(14*WIDTH_RATIO));
        }];
        [self.tipNewPointLocationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tipLocationImage.mas_centerY);
            make.left.equalTo(self.tipLocationImage.mas_right).offset(-1);
            make.width.equalTo(@(140*WIDTH_RATIO));
            make.height.equalTo(@(35*WIDTH_RATIO));
            
        }];
        
        [self.tipNewPointLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.tipNewPointLocationView.mas_centerY);
            make.centerX.equalTo(self.tipNewPointLocationView.mas_centerX);
        }];
    
    self.tipView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.tipView.layer.anchorPoint = CGPointMake(0, 0.5);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL firstConnectPoint = [defaults boolForKey:@"firstConnectPoint"];
    if(!firstConnectPoint){
        [[GTDialogWindowManager shareInstance] dialogWindowShow];
        [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:self.backgroundView];
        //更改层级显示
        [GTClickerWindowManager shareInstance].clickerWinWindow.windowLevel = 30200;
        [GTFloatingBallManager shareInstance].ballWindow.windowLevel = 30300;
        GTClickerPointWindow *pointWindow = [GTClickerWindowManager shareInstance].pointWindowArray[0];
        [GTClickerWindowAnimation clickerFirstAddPointWindow:pointWindow animationWithCompletion:^{
            [UIView animateWithDuration:0.28 animations:^{
                self.tipView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.tipView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    GTClickerGuide *guideView = [GTClickerGuide new];
                    guideView.frame = UIScreen.mainScreen.bounds;
                    [self.backgroundView addSubview:guideView];
                    [[GTFloatingWindowManager shareInstance] floatingWindowHide];
                    [[GTClickerWindowManager shareInstance] clickerWindowShow];
                    [defaults setBool:YES forKey:@"firstConnectPoint"];
                    [defaults synchronize];
                }];
            }];
            
        }];
    }else{
        [[UIApplication sharedApplication].delegate.window addSubview:self.backgroundView];
        [[GTFloatingWindowManager shareInstance] floatingWindowHide];
        [[GTClickerWindowManager shareInstance] clickerWindowShow];
        GTClickerPointWindow *pointWindow = [GTClickerWindowManager shareInstance].pointWindowArray[0];
        [GTClickerWindowAnimation clickerFirstAddPointWindow:pointWindow animationWithCompletion:^{
            [UIView animateWithDuration:0.28 animations:^{
                self.tipView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.tipView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    
                }];
            }];
            pointWindow.dragTipDisappearBlock = ^{
                [self.backgroundView removeFromSuperview];
            };
            DELAYED(3, ^{
                [self.backgroundView removeFromSuperview];
            });
        }];
    }
    GTClickerPointSetViewController *pointSetViewController = [GTClickerPointSetViewController new];
    [self.navigationController pushViewController:pointSetViewController animated:NO];
    pointSetViewController.row = self.DataArray.count;
    pointSetViewController.DataArray = self.DataArray;
    
    //移除GTClickercreateViewController页面
    NSMutableArray *updatedViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
       if([vc isKindOfClass:[GTClickercreateViewController class]]){
           [updatedViewControllers removeObject:vc];
       }
    }
    self.navigationController.viewControllers = updatedViewControllers;
    
    //工具箱元素点击埋点
    [[GTDataConfig sharedInstance] uploadSensorDataWithEvent:GTSensorEventToolBoxElementClick andProperties:@{@"tool_name" : @"连点器", @"plan_id" : [NSNumber numberWithInt:-1],  @"toolbox_click_type" : [NSNumber numberWithInt:4]} shouldFlush:YES];
    int plan_id = [[GTClickerManager shareInstance] getPlanId];
    //AutoClickerStartDurationEvent 连点器启用方案 Sensor Only
    [SMEventSensor startReport:ToolTypeClicker event:AutoClickerStartDurationEvent params:@{
        @"plan_id":@(plan_id)
    }];
}


#pragma mark - setter & getter
- (UILabel *)selectTypeLabel {
    if (!_selectTypeLabel) {
        _selectTypeLabel = [UILabel new];
        _selectTypeLabel.text = localString(@"选择方案类型");
        _selectTypeLabel.textAlignment = NSTextAlignmentCenter;
        _selectTypeLabel.textColor = [GTThemeManager share].colorModel.titleColor;
        _selectTypeLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
    }
    return _selectTypeLabel;
}

- (UILabel *)tipNewPointLocationLabel {
    if (!_tipNewPointLocationLabel) {
        _tipNewPointLocationLabel = [UILabel new];
        _tipNewPointLocationLabel.text = localString(@"新触点默认在这生成～");
        _tipNewPointLocationLabel.textAlignment = NSTextAlignmentCenter;
        _tipNewPointLocationLabel.textColor = [UIColor hexColor:@"#FFFFFF" withAlpha:0.9];
        _tipNewPointLocationLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    }
    return _tipNewPointLocationLabel;
}

- (UIButton *)returnButton {
    if (!_returnButton) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnButton setImage:[[GTThemeManager share] imageWithName:@"window_back_btn"] forState:UIControlStateNormal];
        [_recordButton setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
        [_returnButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnButton;
}

-(UIImageView *)createView{
    if (!_createView) {
        _createView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
//        _createView.backgroundColor = [GTThemeManager share].colorModel.clicker_create_createView_color;
        _createView.layer.cornerRadius = 8*WIDTH_RATIO;
        _createView.layer.masksToBounds = YES;
        _createView.image = [YYImage gt_imageNamed:@"create_clicker.gif"];
    }
    return _createView;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordButton.layer.cornerRadius = 12*WIDTH_RATIO;
        _recordButton.layer.masksToBounds = YES;
        [_recordButton setBackgroundColor:[GTThemeManager share].colorModel.clicker_create_button_color];
        _recordButton.adjustsImageWhenHighlighted = false;
        [_recordButton setTitle:localString(@"录制") forState:UIControlStateNormal];
        [_recordButton setTitleColor:[GTThemeManager share].colorModel.clicker_createbutton_color forState:UIControlStateNormal];
        _recordButton.titleLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
        
        [ _recordButton setImage:[[GTThemeManager share] imageWithName:@"clicker_create_video"] forState:UIControlStateNormal];
        
        CGFloat spacing = 2.0;
        _recordButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        _recordButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordButton;
}

- (UIButton *)connectpointButton {
    if (!_connectpointButton) {
        _connectpointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _connectpointButton.layer.cornerRadius = 12*WIDTH_RATIO;
        _connectpointButton.layer.masksToBounds = YES;
        [_connectpointButton setBackgroundColor:[GTThemeManager share].colorModel.clicker_create_button_color];
        _connectpointButton.adjustsImageWhenHighlighted = false;
        [_connectpointButton setTitle:localString(@"连点") forState:UIControlStateNormal];
        [_connectpointButton setTitleColor:[GTThemeManager share].colorModel.clicker_createbutton_color forState:UIControlStateNormal];
        _connectpointButton.titleLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
        
        [_connectpointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_create_click"] forState:UIControlStateNormal];
        
        CGFloat spacing = 2.0;
        _connectpointButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        _connectpointButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        
        [_connectpointButton addTarget:self action:@selector(connectpointClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectpointButton;
}

-(UIView *)tipNewPointLocationView{
    if(!_tipNewPointLocationView){
        _tipNewPointLocationView = [UIView new];
        _tipNewPointLocationView.backgroundColor = [UIColor hexColor:@"#1C2531"];
        _tipNewPointLocationView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _tipNewPointLocationView.layer.masksToBounds = YES;
    }
    return _tipNewPointLocationView;
}

-(UIView *)tipView{
    if(!_tipView){
        _tipView = [UIView new];
        _tipView.backgroundColor = [UIColor clearColor];
    }
    return _tipView;
}
-(UIImageView *)tipLocationImage{
    if(!_tipLocationImage){
        _tipLocationImage = [UIImageView new];
        _tipLocationImage.backgroundColor = [UIColor clearColor];
        _tipLocationImage.image =[[GTThemeManager share] imageWithName:@"Dark/mask_tip_point"];
    }
    return _tipLocationImage;
}


@end
