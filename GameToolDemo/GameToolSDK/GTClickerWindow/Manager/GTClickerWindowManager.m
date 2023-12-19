//
//  GTClickerWindowManager.m
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTClickerWindowManager.h"
#import "GTFloatingWindowManager.h"

@interface GTClickerWindowManager ()

@end

@implementation GTClickerWindowManager

+ (GTClickerWindowManager *)shareInstance {
   static GTClickerWindowManager *manager = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       manager = [[GTClickerWindowManager alloc]init];
   });
   return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化
        self.pointSetModel = [GTClickerPointSetModel new];
        
        self.pointWindowArray = [NSMutableArray array];
        self.isAllPointShow = NO;
        //        self.isFromNewScheme = NO;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int pointSize = (int)[defaults integerForKey:@"pointSize"];
        switch (pointSize) {
            case 0:{
                self.pointSetModel.pointSize = ClickerWindowPointSizeOfMedium;
            }
                break;
            case 1:{
                self.pointSetModel.pointSize = ClickerWindowPointSizeOfSmall;
            }
                break;
            case 2:{
                self.pointSetModel.pointSize = ClickerWindowPointSizeOfLarge;
            }
                break;
            default:
                break;
        }
        int pointOpera = (int)[defaults integerForKey:@"pointOpera"];
        if(pointOpera == 0){
            self.pointSetModel.pointShowType = ClickerWindowPointShowExecute;
        }else if(pointOpera == 1){
            self.pointSetModel.pointShowType = ClickerWindowPointShowAll;
        }else{
            self.pointSetModel.pointShowType = ClickerWindowPointShowNo;
        }
    }
    return self;
}

- (void)setUp {     //初始化clickerWindowState
    switch (self.schemeModel.startMethod) {
        case ClickerWindowStartMethodNow:
            self.clickerWindowState = ClickerWindowStateNowReady;
            break;
        case ClickerWindowStartMethodPreset:
            self.clickerWindowState = ClickerWindowStateFutureReady;
            break;
        case ClickerWindowStartMethodCountdown:
            self.clickerWindowState = ClickerWindowStateFutureReady;
            break;
        default:
            break;
    }
    
    //更新视图
    [self updateClickerView];
    
    [[GTClickerWindowManager shareInstance].pointWindowArray removeAllObjects];
    if (self.schemeModel) {
        for (int i = 0; i < self.schemeModel.actionArray.count; i++) {
            GTClickerActionModel *actionModel = self.schemeModel.actionArray[i];
            GTClickerPointWindow *pointWindow = [[GTClickerPointWindow alloc] initWithFrame:CGRectZero withIndex:i+1 actionModel:actionModel];
            pointWindow.windowLevel = 26000 + 10 * i;
//            pointWindow.actionModel = actionModel;
            [self.pointWindowArray addObject:pointWindow];
            
            [pointWindow makeKeyAndVisible];
        }
    }
    
    //监听状态
    [self addObserver:self forKeyPath:@"clickerWindowState" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    //监听开启方式
    [self.schemeModel addObserver:self forKeyPath:@"startMethod" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew  context:nil];
    //监听悬浮弹窗是否隐藏
    [[GTFloatingWindowManager shareInstance].windowWindow addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew  context:nil];
}

- (void)dealloc {
    //监听状态
    [self removeObserver:self forKeyPath:@"clickerWindowState" context:nil];
    //监听开启方式
    [self.schemeModel removeObserver:self forKeyPath:@"startMethod" context:nil];
    //监听悬浮弹窗是否隐藏
    [[GTFloatingWindowManager shareInstance].windowWindow removeObserver:self forKeyPath:@"hidden" context:nil];
}


#pragma mark - Notification & KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"clickerWindowState"]) {
        if ([GTClickerWindowManager shareInstance].clickerWindowState == ClickerWindowStateFutureDark) {
            self.clickerWinWindow.backgroundColor = [UIColor clearColor];
        }else {
            self.clickerWinWindow.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        }
    }
    if ([keyPath isEqualToString:@"startMethod"]) {
        for (UIView *view in [GTClickerWindowManager shareInstance].clickerWindowVC.view.subviews) {
            [view removeFromSuperview];
        }
        switch (self.schemeModel.startMethod) {
            case ClickerWindowStartMethodNow:
                [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.nowReadyView];
                break;
            case ClickerWindowStartMethodPreset:
                [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView];
                break;
            case ClickerWindowStartMethodCountdown:
                [[GTClickerWindowManager shareInstance].clickerWindowVC.view addSubview:[GTClickerWindowManager shareInstance].clickerWindowVC.futureReadyView];
                break;
            default:
                break;
        }
    }
    if ([keyPath isEqualToString:@"hidden"]) {
        if ([GTClickerWindowManager shareInstance].schemeModel == nil) {
            self.clickerWinWindow.hidden = YES;
        }else {
//            self.clickerWinWindow.hidden = ![GTFloatingWindowManager shareInstance].windowWindow.isHidden;
            
            if ([GTFloatingWindowManager shareInstance].windowWindow.isHidden) {
                [self clickerWindowShow];
            }else {
                [self clickerWindowHide];
            }
        }
    }
}

- (void)updateClickerView {
    CGPoint point = [GTSDKUtils getClickerWindowLastPosition];
    
    if (self.clickerWindowVC.view.subviews.count == 0) {
//        self.clickerWinWindow.frame = CGRectMake(10, centerPoint.y - clickerWindow_ready_height/2 * WIDTH_RATIO, clickerWindow_ready_width * WIDTH_RATIO, clickerWindow_ready_height * WIDTH_RATIO);
//        switch (self.schemeModel.startMethod) {
//            case 0:
//                self.clickerWindowState = ClickerWindowStateNowReady;
//                [self.clickerWindowVC.view addSubview:self.clickerWindowVC.nowReadyView];
//                break;
//            case 1:
//                self.clickerWindowState = ClickerWindowStateFutureReady;
//                [self.clickerWindowVC.view addSubview:self.clickerWindowVC.futureReadyView];
//                break;
//            case 2:
//                self.clickerWindowState = ClickerWindowStateFutureReady;
//                [self.clickerWindowVC.view addSubview:self.clickerWindowVC.futureReadyView];
//                break;
//            default:
//                break;
//        }
        
        switch (self.clickerWindowState) {
            case ClickerWindowStateNowReady: {
                self.clickerWinWindow.frame = CGRectMake(point.x,
                                                         point.y,
                                                         clickerWindow_ready_width * WIDTH_RATIO,
                                                         clickerWindow_ready_height * WIDTH_RATIO);
                [self.clickerWindowVC.view addSubview:self.clickerWindowVC.nowReadyView];
            }
                break;
            case ClickerWindowStateFutureReady: {
                self.clickerWinWindow.frame = CGRectMake(point.x,
                                                         point.y,
                                                         clickerWindow_ready_width * WIDTH_RATIO,
                                                         clickerWindow_ready_height * WIDTH_RATIO);
                [self.clickerWindowVC.view addSubview:self.clickerWindowVC.futureReadyView];
            }
                break;
            case ClickerWindowStateNowStart: {
                self.clickerWinWindow.frame = CGRectMake(point.x,
                                                         point.y,
                                                         clickerWindow_now_start_width * WIDTH_RATIO,
                                                         clickerWindow_now_start_height * WIDTH_RATIO);
                [self.clickerWindowVC.view addSubview:self.clickerWindowVC.nowStartView];
            }
                break;
            case ClickerWindowStateFutureStart: {
                self.clickerWinWindow.frame = CGRectMake(point.x,
                                                         point.y,
                                                         clickerWindow_future_start_width * WIDTH_RATIO,
                                                         clickerWindow_future_start_height * WIDTH_RATIO);
                [self.clickerWindowVC.view addSubview:self.clickerWindowVC.futureStartView];
            }
                break;
            case ClickerWindowStateFutureDark: {
                self.clickerWinWindow.frame = CGRectMake(0,
                                                         point.y+(clickerWindow_future_start_height-clickerWindow_future_dark_height)/2 * WIDTH_RATIO,
                                                         clickerWindow_future_dark_width * WIDTH_RATIO,
                                                         clickerWindow_future_dark_height * WIDTH_RATIO);
                [self.clickerWindowVC.view addSubview:self.clickerWindowVC.futureStartView];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - GTClickerWindowOperationProtocol

- (void)clickerWindowShow {
    if (self.schemeModel) {
        [self updateClickerView];
    }
    [self.clickerWinWindow setHidden:NO];
}

- (void)clickerWindowHide {
    [self.clickerWindowVC.view removeAllSubviews];
    [self.clickerWinWindow setHidden:YES];
}

#pragma mark - setter & getter

- (void)setSchemeModel:(GTClickerSchemeModel *)schemeModel {
    _schemeModel = schemeModel;
    if (schemeModel) {
        [self setUp];
    }
}

- (GTClickerWindowWindow *)clickerWinWindow {
    if (!_clickerWinWindow) {
        CGPoint centerPoint = [GTSDKUtils getClickerWindowLastPosition];
        _clickerWinWindow = [GTClickerWindowWindow new];
        
        _clickerWinWindow.frame = CGRectMake(10, centerPoint.y - clickerWindow_ready_height * WIDTH_RATIO/2, clickerWindow_ready_width * WIDTH_RATIO, clickerWindow_ready_height * WIDTH_RATIO);
        
        _clickerWinWindow.windowLevel = 29000;
        _clickerWinWindow.userInteractionEnabled = YES;
        _clickerWinWindow.hidden = YES;
        _clickerWinWindow.layer.masksToBounds = YES;
        
        _clickerWindowVC = [[GTClickerWindowViewController alloc] init];
        _clickerWinWindow.rootViewController = _clickerWindowVC;
    }
    return _clickerWinWindow;
}

@end
