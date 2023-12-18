//
//  GTFloatingBallManager.m
//  GTSDK
//
//  Created by shangmi on 2023/7/13.
//

#import "GTFloatingBallManager.h"
#import "GTFloatingBallDefaultView.h"
#import "GTFloatingWindowManager.h"

@implementation GTFloatingBallManager

+ (GTFloatingBallManager *)shareInstance {
   static GTFloatingBallManager *manager = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       manager = [[GTFloatingBallManager alloc]init];
   });
   return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化
        [self setUp];
    }
    return self;
}

/**
 ● 非极简模式下，gametool悬浮球默认会自动贴边，唤起时默认就是贴边熄灭状态。
 ● 极简模式状态下
   ○ 开启了自动贴边，唤起时默认就是贴边熄灭状态
   ○ 未开启自动贴边，唤起时默认就是靠边常驻点亮状态，靠左/右根据隐藏前的位置做对应判断
 */
- (void)setUp {
    //判断所有状态
    if ([GTSDKUtils getExtremelyAustereIsOn]) {//极简
        if ([GTSDKUtils getAutoHideIsOn]) {//自动贴边
            if ([GTSDKUtils getMultiplyingIsOn]) {
                self.floatingBallStyle = FloatingBallStyleControl;
            }else {
                self.floatingBallStyle = FloatingBallStyleSimpleControl;
            }
            self.floatingBallState = FloatingBallStateHideHalf;
            self.floatingBallLuminance = FloatingBallLuminanceDark;
        }else {
            if ([GTSDKUtils getMultiplyingIsOn]) {
                self.floatingBallStyle = FloatingBallStyleControl;
            }else {
                self.floatingBallStyle = FloatingBallStyleSimpleControl;
            }
            self.floatingBallState = FloatingBallStateWelt;
            self.floatingBallLuminance = FloatingBallLuminanceLight;
        }
    }else {//非极简
        self.floatingBallStyle = FloatingBallStyleDefault;
        self.floatingBallState = FloatingBallStateHideHalf;
        self.floatingBallLuminance = FloatingBallLuminanceDark;
    }
    
    self.floatingBall_control_width = floatingBall_width;
    NSArray *array = [GTSDKUtils getCurrentMultiplying];
    self.floatingBall_control_height = 47 + array.count * 26 + 7;
}

- (void)updateFloatingBallWindow {
    self.ballWindow.behaveFactory = [GTFloatingBallBehaveFactory new];
    //计算极简倍率悬浮球高度
    NSArray *array = [GTSDKUtils getCurrentMultiplying];
    self.floatingBall_control_height = 47 + array.count * 26 + 7;
    
    CGPoint centerPoint = [GTSDKUtils getFloatingBallLastPosition];
    _ballWindow.transform = CGAffineTransformMakeScale(1, 1);
    switch (self.floatingBallStyle) {
        case FloatingBallStyleDefault:
            _ballWindow.frame = CGRectMake(centerPoint.x - floatingBall_width/2, centerPoint.y - floatingBall_height/2, floatingBall_width, floatingBall_height);
            break;
        case FloatingBallStyleSimpleControl: {
            _ballWindow.frame = CGRectMake(floatingBall_distance, centerPoint.y - floatingBall_height/2, floatingBall_width, floatingBall_height);
        }
            break;
        case FloatingBallStyleControl: {
            _ballWindow.frame = CGRectMake(centerPoint.x - floatingBall_width/2, centerPoint.y - self.floatingBall_control_height/2, floatingBall_width, self.floatingBall_control_height);
        }
            break;
        default:
            break;
    }

    [self.ballVC.view addSubview:self.ballVC.floatingBallView];
    
    UIBezierPath *maskPath;
    
    switch (self.floatingBallState) {
        case FloatingBallStateWelt: {//贴边
            _ballWindow.transform = CGAffineTransformMakeScale(1, 1);
            _ballWindow.center = CGPointMake(floatingBall_distance + floatingBall_width/2 + SAFE_AREA_LEFT, centerPoint.y);
            maskPath = [UIBezierPath bezierPathWithRoundedRect:_ballWindow.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(floatingBall_width / 2, floatingBall_width / 2)];
        }
            break;
        case FloatingBallStateHideHalf: {//隐藏一半
            switch (self.floatingBallStyle) {
                case FloatingBallStyleDefault: {
                    _ballWindow.transform = CGAffineTransformMakeScale(1, 1);
                    maskPath = [UIBezierPath bezierPathWithRoundedRect:_ballWindow.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(floatingBall_width / 2, floatingBall_width / 2)];
                    
                    if ([GTSDKUtils isPortrait]) {
                        if (centerPoint.x < SCREEN_WIDTH/2) {
                            _ballWindow.center = CGPointMake(0, centerPoint.y);
                        }else {
                            _ballWindow.center = CGPointMake(SCREEN_WIDTH, centerPoint.y);
                        }
                    }else {
                        switch ([[UIApplication sharedApplication] statusBarOrientation]) {
                            case UIInterfaceOrientationLandscapeLeft: {
                                if (centerPoint.x < SCREEN_WIDTH/2) {
                                    _ballWindow.center = CGPointMake(0, centerPoint.y);
                                }else {
                                    _ballWindow.center = CGPointMake(SCREEN_WIDTH - SAFE_AREA_RIGHT, centerPoint.y);
                                }
                            }
                                break;
                            case UIInterfaceOrientationLandscapeRight: {
                                if (centerPoint.x < SCREEN_WIDTH/2) {
                                    _ballWindow.center = CGPointMake(SAFE_AREA_LEFT, centerPoint.y);
                                }else {
                                    _ballWindow.center = CGPointMake(SCREEN_WIDTH, centerPoint.y);
                                }
                            }
                                break;
                            default:
                                break;
                        }
                    }
                    
                }
                    break;
                case FloatingBallStyleSimpleControl:
                case FloatingBallStyleControl: {
                    if (centerPoint.x < SCREEN_WIDTH/2) {
                        maskPath = [UIBezierPath bezierPathWithRoundedRect:_ballWindow.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(floatingBall_width * 0.73 /2 + SAFE_AREA_LEFT, floatingBall_width * 0.73 /2)];
                        _ballWindow.center = CGPointMake(floatingBall_width /2 * 0.73 + SAFE_AREA_LEFT, centerPoint.y);
                    }else {
                        maskPath = [UIBezierPath bezierPathWithRoundedRect:_ballWindow.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(floatingBall_width * 0.73 /2, floatingBall_width * 0.73 /2)];
                        _ballWindow.center = CGPointMake(SCREEN_WIDTH - SAFE_AREA_RIGHT - floatingBall_width /2 * 0.73, centerPoint.y);
                    }
                    _ballWindow.transform = CGAffineTransformMakeScale(0.73, 0.73);
                }
                default:
                    break;
            }
        }
            break;
        case FloatingBallStateHide: {//隐藏
            
        }
            break;
        default:
            break;
    }
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = _ballWindow.bounds;
    maskLayer.path = maskPath.CGPath;
    _ballWindow.layer.mask = maskLayer;
    NSLog(@"%f, %f=======",self.ballWindow.frame.size.height, self.ballVC.floatingBallView.frame.size.height);
}

#pragma mark - GTFloatingBallOperationProtocol

/**
 *  悬浮球显示
 */
- (void)floatingBallShow {
    if (!self.ballVC.view.subviews.count) {
        //每次出现重新布局
        [self updateFloatingBallWindow];
    }
    [self.ballWindow setHidden:NO];
    self.ballWindow.backgroundColor = [UIColor redColor];
    
}

/**
 *  悬浮球隐藏
 */
- (void)floatingBallHide {
    [self.ballVC.view removeAllSubviews];
    self.ballVC.floatingBallView = nil;
    
    [self.ballWindow.behaveFactory removeFloatingBallHideHalfTimer];
    [self.ballWindow.behaveFactory removeFloatingBallDarkTimer];
    self.ballWindow.behaveFactory = nil;
    [self.ballWindow setHidden:YES];
}

#pragma mark - setter & getter

- (GTFloatingBallWindow *)ballWindow {
    if (!_ballWindow) {
        _ballWindow = [[GTFloatingBallWindow alloc] init];
        _ballWindow.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        CGPoint centerPoint = [GTSDKUtils getFloatingBallLastPosition];
        
        switch (self.floatingBallStyle) {
            case FloatingBallStyleDefault:
                _ballWindow.frame = CGRectMake(centerPoint.x - floatingBall_width/2, centerPoint.y - floatingBall_height/2, floatingBall_width, floatingBall_height);
                break;
            case FloatingBallStyleSimpleControl: {
                _ballWindow.frame = CGRectMake(centerPoint.x - floatingBall_width/2, centerPoint.y - floatingBall_height/2, floatingBall_width, floatingBall_height);
            }
                break;
            case FloatingBallStyleControl: {
                _ballWindow.frame = CGRectMake(centerPoint.x - floatingBall_width/2, centerPoint.y - self.floatingBall_control_height/2, floatingBall_width, self.floatingBall_control_height);
            }
                break;
            default:
                break;
        }
        
        UIBezierPath *maskPath;
        
        switch (self.floatingBallState) {
            case FloatingBallStateWelt: {//贴边
                maskPath = [UIBezierPath bezierPathWithRoundedRect:_ballWindow.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(floatingBall_width / 2, floatingBall_width / 2)];
                _ballWindow.transform = CGAffineTransformMakeScale(1, 1);
            }
                break;
            case FloatingBallStateHideHalf: {//隐藏一半
                switch (self.floatingBallStyle) {
                    case FloatingBallStyleDefault: {
                        maskPath = [UIBezierPath bezierPathWithRoundedRect:_ballWindow.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(floatingBall_width / 2, floatingBall_width / 2)];
                        _ballWindow.transform = CGAffineTransformMakeScale(1, 1);
                        
                        
                        
                        
                        if ([GTSDKUtils isPortrait]) {
                            if (centerPoint.x < SCREEN_WIDTH/2) {
                                _ballWindow.center = CGPointMake(0, centerPoint.y);
                            }else {
                                _ballWindow.center = CGPointMake(SCREEN_WIDTH, centerPoint.y);
                            }
                        }else {
                            switch ([[UIApplication sharedApplication] statusBarOrientation]) {
                                case UIInterfaceOrientationLandscapeLeft: {
                                    if (centerPoint.x < SCREEN_WIDTH/2) {
                                        _ballWindow.center = CGPointMake(0, centerPoint.y);
                                    }else {
                                        _ballWindow.center = CGPointMake(SCREEN_WIDTH - SAFE_AREA_RIGHT, centerPoint.y);
                                    }
                                }
                                    break;
                                case UIInterfaceOrientationLandscapeRight: {
                                    if (centerPoint.x < SCREEN_WIDTH/2) {
                                        _ballWindow.center = CGPointMake(SAFE_AREA_LEFT, centerPoint.y);
                                    }else {
                                        _ballWindow.center = CGPointMake(SCREEN_WIDTH, centerPoint.y);
                                    }
                                }
                                    break;
                                default:
                                    break;
                            }
                        }

                        
                        
                        
                        
                        
                    }
                        break;
                    case FloatingBallStyleSimpleControl:
                    case FloatingBallStyleControl: {
                        if (centerPoint.x < SCREEN_WIDTH/2) {
                            maskPath = [UIBezierPath bezierPathWithRoundedRect:_ballWindow.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(floatingBall_width * 0.73 /2, floatingBall_width  * 0.73 /2)];
                            _ballWindow.center = CGPointMake(floatingBall_width /2 * 0.73 + SAFE_AREA_LEFT, centerPoint.y);
                        }else {
                            maskPath = [UIBezierPath bezierPathWithRoundedRect:_ballWindow.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(floatingBall_width * 0.73 /2, floatingBall_width * 0.73 /2)];
                            _ballWindow.center = CGPointMake(SCREEN_WIDTH - SAFE_AREA_RIGHT - floatingBall_width /2 * 0.73, centerPoint.y);
                        }
                        _ballWindow.transform = CGAffineTransformMakeScale(0.73, 0.73);
                    }
                    default:
                        break;
                }
            }
                break;
            case FloatingBallStateHide: {//隐藏
                
            }
                break;
            default:
                break;
        }
        
        _ballWindow.windowLevel = 30000;
        _ballWindow.userInteractionEnabled = YES;
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _ballWindow.bounds;
        maskLayer.path = maskPath.CGPath;
        _ballWindow.layer.mask = maskLayer;
        
        _ballVC = [[GTFloatingBallViewController alloc] init];
        _ballWindow.rootViewController = _ballVC;
    }
    return _ballWindow;
}

@end
