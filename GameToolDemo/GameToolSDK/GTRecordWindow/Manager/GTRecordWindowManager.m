//
//  GTRecordWindowManager.m
//  GTSDK
//
//  Created by shangmi on 2023/10/27.
//

#import "GTRecordWindowManager.h"
#import "GTRecordManager.h"
#import "GTFloatingWindowManager.h"

@implementation GTRecordWindowManager

+ (GTRecordWindowManager *)shareInstance {
   static GTRecordWindowManager *manager = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       manager = [[GTRecordWindowManager alloc]init];
   });
   return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)getRecordState {
    if (!self.schemeModel) {
        return;
    }
    
    if (self.recordWindowState == RecordWindowStateRecordTime ||
        self.recordWindowState == RecordWindowStateRecordTimeDark ||
        self.recordWindowState == RecordWindowStateFutureCountdown ||
        self.recordWindowState == RecordWindowStateFutureCountdownDark ||
        self.recordWindowState == RecordWindowStateStartRecord) {
        return;
    }
    
    switch (self.schemeModel.startMethod) {
        case ClickerWindowStartMethodNow: {
            if (self.schemeModel.cycleIndex == 0) {
                self.recordWindowState = RecordWindowStateNowInfinite;
            }else {
                self.recordWindowState = RecordWindowStateNowFinite;
            }
        }
            break;
        case ClickerWindowStartMethodPreset:
        case ClickerWindowStartMethodCountdown: {
            if (self.schemeModel.cycleIndex == 0) {
                self.recordWindowState = RecordWindowStateFutureInfinite;
            }else {
                self.recordWindowState = RecordWindowStateFutureFinite;
            }
        }
            break;
        default:
            break;
    }

}

- (void)updateClickerView {
    [self getRecordState];
    
//    CGPoint point = [GTSDKUtils getRecordWindowLastPosition];
    CGPoint point = CGPointMake(self.recordWinWindow.origin.x, self.recordWinWindow.origin.y);
    self.recordWinWindow.layer.cornerRadius = 15 * WIDTH_RATIO;
    if (self.recordWindowVC.view.subviews.count == 0) {
        switch (self.recordWindowState) {
            case RecordWindowStateStartRecord: {
                self.recordWinWindow.frame = CGRectMake(point.x,
                                                        point.y,
                                                        recordWindow_begin_width * WIDTH_RATIO,
                                                        recordWindow_begin_width * WIDTH_RATIO);
                [self.recordWindowVC.view addSubview:self.recordWindowVC.beginRecordView];
            }
                break;
            case RecordWindowStateRecordTime: {
                self.recordWinWindow.frame = CGRectMake(point.x,
                                                        point.y,
                                                        recordWindow_record_time_width * WIDTH_RATIO,
                                                        recordWindow_record_time_height * WIDTH_RATIO);
                [self.recordWindowVC.view addSubview:self.recordWindowVC.recordTimeView];
            }
                break;
            case RecordWindowStateRecordTimeDark:{
                self.recordWinWindow.frame = CGRectMake(point.x,
                                                        point.y,
                                                        recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                        recordWindow_record_time_dark_height * WIDTH_RATIO);
                [self.recordWindowVC.view addSubview:self.recordWindowVC.recordTimeView];
                self.recordWinWindow.layer.cornerRadius = 0 * WIDTH_RATIO;
            }
                break;
            case RecordWindowStateFutureCountdown: {
                self.recordWinWindow.frame = CGRectMake(point.x,
                                                        point.y,
                                                        recordWindow_record_time_width * WIDTH_RATIO,
                                                        recordWindow_record_time_height * WIDTH_RATIO);
                [self.recordWindowVC.view addSubview:self.recordWindowVC.counntdownView];
            }
                break;
            case RecordWindowStateFutureCountdownDark:{
                self.recordWinWindow.frame = CGRectMake(point.x,
                                                        point.y,
                                                        recordWindow_record_time_dark_width * WIDTH_RATIO,
                                                        recordWindow_record_time_dark_height * WIDTH_RATIO);
                [self.recordWindowVC.view addSubview:self.recordWindowVC.counntdownView];
                self.recordWinWindow.layer.cornerRadius = 0 * WIDTH_RATIO;
            }
                break;
            case RecordWindowStateNowFinite:
            case RecordWindowStateFutureFinite: {
                self.recordWinWindow.frame = CGRectMake(point.x,
                                                        point.y,
                                                        recordWindow_finite_width * WIDTH_RATIO,
                                                        recordWindow_finite_height * WIDTH_RATIO);
                [self.recordWindowVC.view addSubview:self.recordWindowVC.finiteView];
                [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView updateData:self.schemeModel];
            }
                break;
            case RecordWindowStateNowInfinite:
            case RecordWindowStateFutureInfinite: {
                self.recordWinWindow.frame = CGRectMake(point.x,
                                                        point.y,
                                                        recordWindow_infinite_width * WIDTH_RATIO,
                                                        recordWindow_infinite_height * WIDTH_RATIO);
                [self.recordWindowVC.view addSubview:self.recordWindowVC.infiniteView];

                [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView updateData:self.schemeModel];
            }
                break;
            default:
                break;
        }
        
        if ((self.recordWinWindow.frame.origin.x + self.recordWinWindow.frame.size.width) > SCREEN_WIDTH) {
            self.recordWinWindow.frame = CGRectMake(SCREEN_WIDTH - self.recordWinWindow.frame.size.width, self.recordWinWindow.frame.origin.y, self.recordWinWindow.frame.size.width, self.recordWinWindow.frame.size.height);
        }
    }
}

- (void)setUp {
    //监听状态
    [self addObserver:self forKeyPath:@"recordWindowState" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    //监听开启方式
    [self.schemeModel addObserver:self forKeyPath:@"startMethod" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew  context:nil];
    //监听循环次数
    [self.schemeModel addObserver:self forKeyPath:@"cycleIndex" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew  context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"recordWindowState"];
    [self.schemeModel removeObserver:self forKeyPath:@"startMethod"];
    [self.schemeModel removeObserver:self forKeyPath:@"cycleIndex"];
}

#pragma mark - Notification & KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"startMethod"] || [keyPath isEqualToString:@"cycleIndex"]) {
//        for (UIView *view in [GTRecordWindowManager shareInstance].recordWindowVC.view.subviews) {
//            [view removeFromSuperview];
//        }
//
//        if (self.schemeModel.cycleIndex == 0) {
//            [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView];
//            [[GTRecordWindowManager shareInstance].recordWindowVC.infiniteView updateData:self.schemeModel];
//        }else {
//            [[GTRecordWindowManager shareInstance].recordWindowVC.view addSubview:[GTRecordWindowManager shareInstance].recordWindowVC.finiteView];
//            [[GTRecordWindowManager shareInstance].recordWindowVC.finiteView updateData:self.schemeModel];
//        }
//    }
    if ([keyPath isEqualToString:@"recordWindowState"]) {
        if ([GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateRecordTimeDark ||
            [GTRecordWindowManager shareInstance].recordWindowState == RecordWindowStateFutureCountdownDark) {
            self.recordWinWindow.backgroundColor = [UIColor clearColor];
        }else {
            self.recordWinWindow.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        }
    }
    if ([keyPath isEqualToString:@"isHidden"]) {
        if (![GTFloatingWindowManager shareInstance].windowWindow.isHidden) {
            [self recordWindowHide];
        }
    }
}

- (void)setSchemeModel:(GTClickerSchemeModel *)schemeModel {
    _schemeModel = schemeModel;
    if (schemeModel) {
        [self setUp];
    }else {
        [self.schemeModel removeObserver:self forKeyPath:@"startMethod"];
        [self.schemeModel removeObserver:self forKeyPath:@"cycleIndex"];
    }
    if(!schemeModel){
        self.schemeJsonString = @"";
    }
//    self.schemeJsonString = [schemeModel modelToJSONString];
}

#pragma mark - GTRecordWindowOperationProtocol

- (void)recordWindowShow {
    [self updateClickerView];
    [self.recordWinWindow setHidden:NO];
}

- (void)recordWindowHide {
    [self.recordWindowVC.view removeAllSubviews];
    [self.recordWinWindow setHidden:YES];
}

- (GTRecordWindowWindow *)recordWinWindow {
    if (!_recordWinWindow) {
        CGPoint centerPoint = [GTSDKUtils getRecordWindowLastPosition];
        _recordWinWindow = [GTRecordWindowWindow new];
        
        _recordWinWindow.frame = CGRectMake(10, centerPoint.y - clickerWindow_ready_height * WIDTH_RATIO/2, clickerWindow_ready_width * WIDTH_RATIO, clickerWindow_ready_height * WIDTH_RATIO);
        
        _recordWinWindow.windowLevel = 29000;
        _recordWinWindow.userInteractionEnabled = YES;
        _recordWinWindow.hidden = YES;
        _recordWinWindow.layer.masksToBounds = YES;
        
        _recordWindowVC = [[GTRecordWindowViewController alloc] init];
        _recordWinWindow.rootViewController = _recordWindowVC;
    }
    return _recordWinWindow;
}



@end
