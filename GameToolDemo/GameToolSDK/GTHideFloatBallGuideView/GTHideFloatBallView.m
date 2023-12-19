//
//  GTHideFloatBallView.m
//  GTSDK
//
//  Created by smwl_dxl on 2023/7/3.
//

#import "GTHideFloatBallView.h"
#import "GTOperationControl.h"

@interface GTHideFloatBallView ()
/*
 底部的半圆背景
 */
@property (nonatomic, strong) UIView * semiCircleView;

/*
 关闭按钮
 */
@property (nonatomic, strong) UIImageView * closeImg;
/*
 隐藏提示文本
 */
@property (nonatomic, strong) UILabel * hideTipsLb;
/*
 悬浮球进入热区时循环缩放的view
 */
@property (nonatomic, strong) UIView * scaleView;
/*
 缩放动画的中心点
 */
@property (nonatomic, assign) CGPoint animationPoint;
@end

@implementation GTHideFloatBallView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if ([GTSDKUtils isPortrait]) {
            self.frame = CGRectMake(0, SCREEN_HEIGHT - 160 - SAFE_AREA_BOTTOM, SCREEN_WIDTH, 160 + SAFE_AREA_BOTTOM);
        } else {
            self.frame = CGRectMake(0, SCREEN_HEIGHT - 160 - SAFE_AREA_BOTTOM, 458 * WIDTH_RATIO, 160 + SAFE_AREA_BOTTOM);
            DELAYED(0.5, ^{
                [self mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                    make.width.mas_offset(458 * WIDTH_RATIO);
                    make.height.mas_offset(160 + SAFE_AREA_BOTTOM);
                    make.top.mas_equalTo(SCREEN_HEIGHT - 160 - SAFE_AREA_BOTTOM);
                }];
                [self layoutIfNeeded];
            });
            
        }
        
        [self setUI];
        [self setLayout];
    }
    return self;
}
-(void)setUI {
    [self addSubview:self.semiCircleView];
    [self.semiCircleView addSubview:self.hideHotView];
    [self.hideHotView addSubview:self.scaleView];
    [self.hideHotView addSubview:self.closeImg];
    [self.hideHotView addSubview:self.hideTipsLb];
    [self.hideHotView addSubview:self.hideTipsLb];
    
}
- (void)setLayout {
    if ([GTSDKUtils isPortrait]) {
        self.semiCircleView.frame = CGRectMake(0, self.frame.size.height,  389*2 * WIDTH_RATIO, 389*2 * WIDTH_RATIO);
    } else {
        self.semiCircleView.frame = CGRectMake(0, self.frame.size.height, 230*2 * WIDTH_RATIO, 230*2 * WIDTH_RATIO);
    }
    CGPoint semiCircleViewCenter = self.semiCircleView.center;
    semiCircleViewCenter.x = self.center.x;
    self.semiCircleView.center = semiCircleViewCenter;
    
    
    [self.hideHotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.height.mas_offset(160 * WIDTH_RATIO);
        make.centerX.mas_equalTo(0);
    }];
    [self.hideHotView layoutIfNeeded];
    self.animationPoint = self.hideHotView.center;
    
    [self.scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.height.mas_offset(130);
    }];
    
    [self.closeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_offset(50 * WIDTH_RATIO);
        make.top.mas_equalTo(55);
    }];
    
    [self.hideTipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.closeImg.mas_bottom).mas_offset(12 * WIDTH_RATIO);
        make.height.mas_offset(15 * WIDTH_RATIO);
        make.left.right.mas_equalTo(0);
    }];
    
}
- (UIView *)semiCircleView {
    if (!_semiCircleView) {
        _semiCircleView = [UIView new];
        _semiCircleView.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.3];
        if ([GTSDKUtils isPortrait]) {
            _semiCircleView.layer.cornerRadius = 389*2 * WIDTH_RATIO / 2;
        } else {
            _semiCircleView.layer.cornerRadius = 230*2 * WIDTH_RATIO / 2;
        }
        _semiCircleView.layer.masksToBounds = YES;
    }
    return _semiCircleView;
}
- (UIView *)hideHotView {
    if (!_hideHotView) {
        _hideHotView = [UIView new];
//        _hideHotView.backgroundColor = [UIColor yellowColor];
    }
    return _hideHotView;
}
- (UIImageView *)closeImg {
    if (!_closeImg) {
        _closeImg = [UIImageView new];
        _closeImg.image = [[GTThemeManager share] imageWithName:@"icon_close"];
        _closeImg.alpha = 0;
    }
    return _closeImg;
}
- (UILabel *)hideTipsLb {
    if (!_hideTipsLb) {
        _hideTipsLb = [UILabel new];
        _hideTipsLb.text = localString(@"拖拽至此可关闭");
        _hideTipsLb.textColor = [UIColor hexColor:@"#ffffff" withAlpha:0.9];
        _hideTipsLb.alpha = 0;
        _hideTipsLb.textAlignment = NSTextAlignmentCenter;
        _hideTipsLb.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
    }
    return _hideTipsLb;
}
- (UIView *)scaleView {
    if (!_scaleView) {
        _scaleView = [UIView new];
        _scaleView.layer.cornerRadius = 130 / 2;
        _scaleView.layer.masksToBounds = YES;
        _scaleView.alpha = 0;
        _scaleView.backgroundColor = [UIColor hexColor:@"#ffffff"];
    }
    return _scaleView;
}
- (void)show {
    @WeakObj(self);
    [UIView animateWithDuration:0.32 animations:^{
        selfWeak.semiCircleView.frame = CGRectMake(selfWeak.semiCircleView.frame.origin.x, 0, selfWeak.semiCircleView.frame.size.width, selfWeak.semiCircleView.frame.size.height);
    }];
    
    DELAYED(0.12, ^{
        [UIView animateWithDuration:0.2 animations:^{
            selfWeak.hideTipsLb.alpha = 0.9;
            selfWeak.closeImg.alpha = 0.7;
        }];
    });
}
#pragma mark - 隐藏整个隐藏区域的view
- (void)hide {
    
    @WeakObj(self);
    [UIView animateWithDuration:0.32 animations:^{
        if ([GTSDKUtils isPortrait]) {
            selfWeak.semiCircleView.frame = CGRectMake(selfWeak.semiCircleView.frame.origin.x, selfWeak.frame.size.height,  389*2 * WIDTH_RATIO, 389*2 * WIDTH_RATIO);
        } else {
            selfWeak.semiCircleView.frame = CGRectMake(selfWeak.semiCircleView.frame.origin.x, selfWeak.frame.size.height, 230*2 * WIDTH_RATIO, 230*2 * WIDTH_RATIO);
        }
    } completion:^(BOOL finished) {
        [selfWeak setHidden:YES];
    }];
    
    [UIView animateWithDuration:0.08 animations:^{
        selfWeak.hideTipsLb.alpha = 0;
        selfWeak.closeImg.alpha = 0;
    }];
    [self.scaleView.layer removeAllAnimations];
}
-(void)willHide {
    if (self.floatBallIsInHotView) {
        if (self.hideFloatBall) {
            self.hideFloatBall();
        }
    }
}
#pragma mark - 放大动画
- (void)amplifyAnimation {
    if (self.floatBallIsInHotView) {
        @WeakObj(self);
        [UIView animateWithDuration:0.6 animations:^{
            selfWeak.scaleView.alpha = 0.1;
            selfWeak.scaleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            selfWeak.scaleView.layer.cornerRadius = 130 / 2;
            selfWeak.scaleView.layer.masksToBounds = YES;
        } completion:^(BOOL finished) {
            [selfWeak reduceAnimation];
        }];
    }
}
#pragma mark - 缩小动画
-(void)reduceAnimation {
    if (self.floatBallIsInHotView) {
        @WeakObj(self);
        [UIView animateWithDuration:0.6 animations:^{
            selfWeak.scaleView.transform = CGAffineTransformMakeScale(0.87, 0.87);
            selfWeak.scaleView.layer.masksToBounds = YES;
            selfWeak.scaleView.layer.cornerRadius = 60;
            selfWeak.scaleView.alpha = 0;
        } completion:^(BOOL finished) {
            [selfWeak amplifyAnimation];
        }];
    }
}
#pragma mark - 悬浮球进入热区
-(void)enterHideHotView {
    if (!self.floatBallIsInHotView) {
        self.closeImg.alpha = 0.8;
        self.scaleView.alpha = 0;
        self.floatBallIsInHotView = YES;
        [UIView animateWithDuration:0.6 animations:^{
            self.scaleView.alpha = 0.1;
        }];
        [self reduceAnimation];
    }
}
#pragma mark - 悬浮球移出热区
-(void)exitOutHideHotView {
    if (self.floatBallIsInHotView) {
        self.closeImg.alpha = 0.7;
        self.scaleView.alpha = 0;
        self.scaleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
    self.floatBallIsInHotView = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
