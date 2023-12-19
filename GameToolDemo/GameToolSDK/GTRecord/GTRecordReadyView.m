//
//  GTRecordReadyView.m
//  GTSDK
//
//  Created by smwl on 2023/10/26.
//

#import "GTRecordReadyView.h"
#import <math.h>
#import "GTDialogWindowManager.h"
#import "UIFont+Custom.h"

@interface GTRecordReadyView()<CAAnimationDelegate>

@property(strong,nonatomic)UIButton *cancelButton;

@property(strong,nonatomic)UIButton *jumpButton;

@property(strong,nonatomic)UILabel *progressLabel;

@property(strong,nonatomic)CAShapeLayer *backGroundLayer;

@property(strong,nonatomic)CAShapeLayer *progressLayer;

@property(assign,nonatomic)NSInteger downCount;

@property(strong,nonatomic)NSTimer *timer;

@property(strong,nonatomic)UIBezierPath *circlePath;

@property(copy,nonatomic)ReadyFinishCallBack finishCallBack;

@end

static NSString *strokeEndAnimationKey = @"strokeEndAnimationKey";

@implementation GTRecordReadyView

+(instancetype)showReadyView:(ReadyFinishCallBack)finishCallBack{
    GTRecordReadyView *readyView = [GTRecordReadyView new];
    readyView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:readyView];
    [readyView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);

    }];
    readyView.finishCallBack = finishCallBack;
    [UIView animateWithDuration:0.2 animations:^{
        readyView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    } completion:^(BOOL finished) {
        [readyView countDown];
        [readyView countDownAnimate];
    }];
    return readyView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self.downCount = 3;
        [self setUI];
//        [self countDown];
//        [self countDownAnimate];
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self configCirclePath];
    
}
-(void)countDown{
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
        if(weakSelf.downCount>1){
            weakSelf.downCount--;
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"%ld",(long)weakSelf.downCount];
//            weakSelf.progressLayer.strokeEnd = weakSelf.downCount*1.0/3.0;
        }else{
//            [weakSelf jumpCountDown:nil];

        }
    } repeats:YES];

}
-(void)countDownAnimate{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 3.0;
    animation.fromValue = @(1.0);
    animation.toValue = @(0);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [self.progressLayer addAnimation:animation forKey:strokeEndAnimationKey];
    

}
-(void)setUI{
    [self addSubview:self.cancelButton];
    [self addSubview:self.jumpButton];
    [self addSubview:self.progressLabel];
    CGFloat buttonWidth = 142.0 * WIDTH_RATIO;
    CGFloat buttonHeight = 48.0 * WIDTH_RATIO;
    CGFloat bottomOffset = [GTSDKUtils isPortrait]?-40.0:-30.0;
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(bottomOffset);
        make.height.mas_equalTo(buttonHeight);
        make.width.mas_equalTo(buttonWidth);
//        make.left.mas_equalTo(self.mas_left).mas_offset(margin);
        make.centerX.mas_equalTo(self.centerX).mas_offset(-(buttonWidth/2+9* WIDTH_RATIO));
    }];
    [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(bottomOffset);
        make.height.mas_equalTo(buttonHeight);
        make.width.mas_equalTo(buttonWidth);
//        make.right.mas_equalTo(self.mas_right).mas_offset(-margin);
        make.centerX.mas_equalTo(self.centerX).mas_offset((buttonWidth/2+9 * WIDTH_RATIO));
    }];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
}
-(void)configCirclePath{
    
    self.backGroundLayer.path = self.circlePath.CGPath;
    self.progressLayer.path = self.circlePath.CGPath;
}
-(UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action{
    UIButton *button = [UIButton new];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 24;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.clipsToBounds = YES;
//    [button setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
    [button setBackgroundImage:[[GTThemeManager share] imageWithName:@"record_ready_bottom_button"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    return button;
}
#pragma mark -- CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
//    NSLog(@"animationDidStart anim=>%@",anim);
}

// 'flag' is true if the animation reached the end of its active duration without being removed
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"animationDidStop anim=>%@ flag=>%d",anim,flag);
    if(flag){
        [self jumpCountDown:nil];
    }
    
}
#pragma mark -- cancel/jump
-(void)finishRecordGuide:(BOOL)isCanceled{
    [self.timer invalidate];
    self.timer = nil;
    //移除动画
    [self.progressLayer removeAnimationForKey:strokeEndAnimationKey];
//    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//        [[GTDialogWindowManager  shareInstance] dialogWindowHide];
        if(self.finishCallBack){
            self.finishCallBack(isCanceled);
        }
    }];

}
/// 取消录制
/// - Parameter button: <#button description#>
-(void)cancelRecord:(UIButton *)button{
    
    [self finishRecordGuide:YES];
}

/// 调过倒计时
/// - Parameter button: <#button description#>
-(void)jumpCountDown:(UIButton *)button{
    [self finishRecordGuide:NO];
    
}

#pragma mark -- getter/setter
-(UIButton *)cancelButton{
    if(!_cancelButton){
        _cancelButton = [self buttonWithTitle:@"取消" action:@selector(cancelRecord:)];
    }
    return _cancelButton;
}
-(UIButton *)jumpButton{
    if(!_jumpButton){
        _jumpButton = [self buttonWithTitle:@"跳过倒计时" action:@selector(jumpCountDown:)];
    }
    return _jumpButton;
}
-(UILabel *)progressLabel{
    if(!_progressLabel){
        _progressLabel = [UILabel new];
        [_progressLabel setFont:[UIFont boldFontOfSize:80.0]];
        
        [_progressLabel setTextColor:[UIColor whiteColor]];
        _progressLabel.text = [NSString stringWithFormat:@"%ld",self.downCount];
    }
    return _progressLabel;
}
-(CAShapeLayer *)getShapeLayerWithStrokeColor:(UIColor *)strokeColor{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeEnd = 1;
    shapeLayer.lineWidth = 12.0;
    shapeLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:shapeLayer];
    return shapeLayer;
}
-(CAShapeLayer *)backGroundLayer{
    if(!_backGroundLayer){
        _backGroundLayer =[self getShapeLayerWithStrokeColor:[UIColor colorWithWhite:1.0 alpha:0.36]];
    }
    return _backGroundLayer;
}
-(CAShapeLayer *)progressLayer{
    if(!_progressLayer){
        _progressLayer = [self getShapeLayerWithStrokeColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    }
    return _progressLayer;
}
-(UIBezierPath *)circlePath{
    if(!_circlePath){
        _circlePath = [UIBezierPath bezierPathWithArcCenter:self.progressLabel.center radius:70.0 startAngle:M_PI_4*6 endAngle:-M_PI_4*2 clockwise:NO];
        
    }
    return _circlePath;
}
-(void)dealloc{
    NSLog(@"GTRecordReadyView dealloc");
}
@end
