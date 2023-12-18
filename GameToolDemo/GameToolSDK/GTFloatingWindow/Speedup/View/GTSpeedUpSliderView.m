//
//  GTSpeedUpSliderView.m
//  GTSDK
//
//  Created by shangmi on 2023/7/3.
//

#import "GTSpeedUpSliderView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface GTSpeedUpSliderView ()

@property (nonatomic, strong) UIView *untrackView;
@property (nonatomic, strong) UIView *trackView;
@property (nonatomic, strong) UIImageView *thumbImg;

@property (nonatomic, assign) CGRect valveRect;
@property (nonatomic, copy) void(^changeEvent)(CGFloat value);
@property (nonatomic, copy) void(^endValueEvent)(CGFloat value);
@property(nonatomic,assign) BOOL hasDialog;

//记录上一个value
@property(nonatomic,assign) CGFloat lastValue;

@end

@implementation GTSpeedUpSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
    
    [self addSubview:self.untrackView];
    [self addSubview:self.trackView];
    [self addSubview:self.thumbImg];
    
    [self.untrackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(242 * WIDTH_RATIO);
        make.height.mas_equalTo(5 * WIDTH_RATIO);
    }];
    [self.trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.untrackView);
        make.width.mas_equalTo(242 * WIDTH_RATIO * self.progress);
    }];
    [self.thumbImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.trackView.mas_right);
        make.centerY.equalTo(self.trackView.mas_centerY);
        make.width.mas_equalTo(21 * WIDTH_RATIO);
        make.height.mas_equalTo(21 * WIDTH_RATIO);
    }];

    [self.thumbImg addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGPoint centerPoint = [[object valueForKeyPath:keyPath] CGPointValue];
    CGFloat value = [[self bestProgressWithOldProgress:centerPoint.x/self.width][@"value"] floatValue];
    if (value != self.lastValue) {
        AudioServicesPlaySystemSound(1519);
    }
    self.lastValue = value;
}

- (void)dealloc {
    [self.thumbImg removeObserver:self forKeyPath:@"center"];
}

#pragma mark - response

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    CGPoint translation = [gesture locationInView:self];

    CGFloat newX = translation.x;
    CGFloat newY = self.thumbImg.center.y;
    
    self.thumbImg.center = CGPointMake(newX, newY);
    [self updateData:newX];
    
    if (self.endValueEvent) {
        CGFloat progress = newX / self.width;
        _progress = [[self bestProgressWithOldProgress:progress][@"progress"] floatValue];
        self.thumbImg.center = CGPointMake(_progress * self.width, newY);
        self.endValueEvent([[self bestProgressWithOldProgress:progress][@"value"] floatValue]);
    }
}

- (void)dragAction:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    
    UIGestureRecognizerState moveState = gesture.state;
    switch (moveState) {
        case UIGestureRecognizerStateBegan: {
            
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat newX = self.thumbImg.center.x + translation.x;
            CGFloat newY = self.thumbImg.center.y;
            
            // 限制移动范围
            newX = MAX(self.thumbImg.frame.size.width / 2, MIN(self.untrackView.frame.size.width - self.thumbImg.frame.size.width / 2, newX));
            
            self.thumbImg.center = CGPointMake(newX, newY);
            [self updateData:newX];
            
            
        }
            break;
        case UIGestureRecognizerStateEnded: {
            if (self.endValueEvent) {
                CGFloat progress = CENTERX(self.thumbImg)/ self.width;
                _progress = [[self bestProgressWithOldProgress:progress][@"progress"] floatValue];
                self.thumbImg.centerX = self.width * _progress;
                
                [self.trackView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(self.width * _progress);
                }];
                
                self.endValueEvent([[self bestProgressWithOldProgress:progress][@"value"] floatValue]);
            }
        }
            break;
        default:
            break;
    }
    [gesture setTranslation:CGPointZero inView:self];
}

- (void)changeValue:(void(^_Nullable)(CGFloat value))changeEvent endValue:(void(^_Nullable)(CGFloat value))endValue
{
    self.changeEvent = changeEvent;
    self.endValueEvent = endValue;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect frame = CGRectInset(self.thumbImg.frame, -20, -20);

    return CGRectContainsPoint(frame, point) ? self.thumbImg : [super hitTest:point withEvent:event];
}

#pragma mark - private method

- (void)updateData:(CGFloat)newx {
    if (newx < 0) {
        newx = 0;
    } else if (newx > self.width) {
        newx = self.width;
    }
    
    [self.trackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(newx);
    }];
    
    CGFloat progress = self.thumbImg.centerX / self.width;
        
    if (self.changeEvent) {
        self.changeEvent([[self bestProgressWithOldProgress:progress][@"value"] floatValue]);
    }
    
}

//最佳档位的吸附效果
-(NSDictionary *)bestProgressWithOldProgress:(CGFloat)oldProgress{
    int P = oldProgress*100;
    if (self.isUp) {
        int P = oldProgress*100;
        if (0 <= P && P <=5.5){
            return @{@"progress":@"0", @"value":@"1"};
        }else if (5.5 < P && P <= 16.5){
            return @{@"progress":@"0.11", @"value":@"2"};
        }else if (16.5 < P && P <= 27.5){
            return @{@"progress":@"0.22", @"value":@"3"};
        }else if (27.5 < P && P <= 38.5){
            return @{@"progress":@"0.33", @"value":@"4"};
        }else if (38.5 < P && P <= 49.5){
            return @{@"progress":@"0.44", @"value":@"5"};
        }else if (49.5 < P && P <= 60.5){
            return @{@"progress":@"0.55", @"value":@"6"};
        }else if (60.5 < P && P <= 71.5){
            return @{@"progress":@"0.66", @"value":@"7"};
        }else if (71.5 < P && P <= 82.5){
            return @{@"progress":@"0.77", @"value":@"8"};
        }else if (82.5 < P && P <= 93.5){
            return @{@"progress":@"0.88", @"value":@"9"};
        }else {
            return @{@"progress":@"1", @"value":@"10"};
        }
    }else {
        if (0 <= P && P <=5.5){
            return @{@"progress":@"0", @"value":@"1"};
        }else if (5.5 < P && P <= 16.5){
            return @{@"progress":@"0.11", @"value":@"0.9"};
        }else if (16.5 < P && P <= 27.5){
            return @{@"progress":@"0.22", @"value":@"0.8"};
        }else if (27.5 < P && P <= 38.5){
            return @{@"progress":@"0.33", @"value":@"0.7"};
        }else if (38.5 < P && P <= 49.5){
            return @{@"progress":@"0.44", @"value":@"0.6"};
        }else if (49.5 < P && P <= 60.5){
            return @{@"progress":@"0.55", @"value":@"0.5"};
        }else if (60.5 < P && P <= 71.5){
            return @{@"progress":@"0.66", @"value":@"0.4"};
        }else if (71.5 < P && P <= 82.5){
            return @{@"progress":@"0.77", @"value":@"0.3"};
        }else if (82.5 < P && P <= 93.5){
            return @{@"progress":@"0.88", @"value":@"0.2"};
        }else {
            return @{@"progress":@"1", @"value":@"0.1"};
        }
    }
}

#pragma mark - setter & getter

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.lastValue = [[self bestProgressWithOldProgress:progress][@"value"] floatValue];
    [self.trackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(242 * WIDTH_RATIO * _progress);
    }];
    [self layoutIfNeeded];
    self.thumbImg.frame = CGRectMake(self.thumbImg.origin.x, self.thumbImg.origin.y, self.thumbImg.size.width, self.thumbImg.size.height);
}

- (UIView *)untrackView {
    if (!_untrackView) {  
        _untrackView = [UIView new];
        _untrackView.backgroundColor = [UIColor hexColor:@"#7791AF" withAlpha:0.09];
        _untrackView.layer.cornerRadius = 2.5 * WIDTH_RATIO;
        _untrackView.layer.masksToBounds = YES;
    }
    return _untrackView;
}

- (UIView *)trackView {
    if (!_trackView) {
        _trackView = [UIView new];
        _trackView.backgroundColor = [UIColor themeColor];
        _trackView.layer.cornerRadius = 2.5 * WIDTH_RATIO;
        _trackView.layer.masksToBounds = YES;
    }
    return _trackView;
}

- (UIImageView *)thumbImg {
    if (!_thumbImg) {
        _thumbImg = [UIImageView new];
        _thumbImg.userInteractionEnabled = YES;
        _thumbImg.image = [[GTThemeManager share] imageWithName:@"speed_thumb_img"];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
        [_thumbImg addGestureRecognizer:panGesture];
    }
    return _thumbImg;
}

@end
