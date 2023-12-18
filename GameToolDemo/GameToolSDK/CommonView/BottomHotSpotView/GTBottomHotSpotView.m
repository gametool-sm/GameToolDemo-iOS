//
//  GTBottomHotSpotView.m
//  GTSDK
//
//  Created by shangmi on 2023/8/30.
//

#import "GTBottomHotSpotView.h"
#import "GTFloatingBallConfig.h"

@interface GTBottomHotSpotView ()
/**
 底部的半圆背景
 */
@property (nonatomic, strong) UIImageView * bgImg;
/*
 关闭按钮
 */
@property (nonatomic, strong) UIImageView * closeImg;
/*
 隐藏提示文本
 */
@property (nonatomic, strong) UILabel * tipsLabel;
/*
 悬浮球进入热区时循环缩放的view
 */
@property (nonatomic, strong) UIView * scaleView;
/*
 缩放动画的中心点
 */
@property (nonatomic, assign) CGPoint animationPoint;

@end

@implementation GTBottomHotSpotView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if ([GTSDKUtils isPortrait]) {
            self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 160 * WIDTH_RATIO + SAFE_AREA_BOTTOM);
        } else {
            self.frame = CGRectMake((SCREEN_WIDTH-458 * WIDTH_RATIO)/2, SCREEN_HEIGHT, 458 * WIDTH_RATIO, 160 * WIDTH_RATIO + SAFE_AREA_BOTTOM);
        }
        
        [self setUp];
    }
    return self;
}
-(void)setUp {
    [self addSubview:self.bgImg];
    [self.bgImg addSubview:self.hideHotView];
    [self.bgImg addSubview:self.scaleView];
    [self.bgImg addSubview:self.closeImg];
    [self.bgImg addSubview:self.tipsLabel];
    
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.frame.size.width);
        make.height.mas_offset(self.frame.size.height);
    }];
    
    [self.hideHotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImg.mas_centerX);
        make.centerY.equalTo(self.bgImg.mas_centerY);
        make.width.height.mas_equalTo(hideHotView_width * WIDTH_RATIO);
    }];
    self.animationPoint = self.hideHotView.center;
    
    [self.scaleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImg.mas_centerX);
        make.centerY.equalTo(self.bgImg.mas_centerY);
        make.width.height.mas_equalTo(130 * WIDTH_RATIO);
    }];
    
    [self.closeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImg.mas_centerX);
        make.centerY.equalTo(self.bgImg.mas_centerY);
        make.width.height.mas_equalTo(50 * WIDTH_RATIO);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.closeImg.mas_bottom).mas_offset(12 * WIDTH_RATIO);
        make.height.mas_offset(15 * WIDTH_RATIO);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)show {
    @WeakObj(self);
    [UIView animateWithDuration:0.32 animations:^{
        selfWeak.bgImg.transform = CGAffineTransformMakeTranslation(0, -selfWeak.height);
    }];
    
    DELAYED(0.12, ^{
        [UIView animateWithDuration:0.2 animations:^{
            selfWeak.tipsLabel.alpha = 0.9;
            selfWeak.closeImg.alpha = 0.7;
        }];
    });
}
#pragma mark - 隐藏整个隐藏区域的view

- (void)hide {
    @WeakObj(self);
    [UIView animateWithDuration:0.32 animations:^{
        selfWeak.bgImg.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [selfWeak setHidden:YES];
    }];
    
    [UIView animateWithDuration:0.08 animations:^{
        selfWeak.tipsLabel.alpha = 0;
        selfWeak.closeImg.alpha = 0;
    }];
    [self.scaleView.layer removeAllAnimations];
}

/**
 松手后未停留在热区，bottomView隐藏
 */
-(void)willHide {
    if (self.isInHotView) {
        if (self.hideFloatBall) {
            self.hideFloatBall();
        }
    }
}

#pragma mark - 放大动画
- (void)amplifyAnimation {
    if (self.isInHotView) {
        @WeakObj(self);
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            selfWeak.scaleView.alpha = 0.1;
            selfWeak.scaleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            selfWeak.scaleView.layer.cornerRadius = 130*WIDTH_RATIO/2;
            selfWeak.scaleView.layer.masksToBounds = YES;
        } completion:^(BOOL finished) {
            [selfWeak reduceAnimation];
        }];
    }
}

#pragma mark - 缩小动画
-(void)reduceAnimation {
    if (self.isInHotView) {
        @WeakObj(self);
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            selfWeak.scaleView.transform = CGAffineTransformMakeScale(0.87, 0.87);
            selfWeak.scaleView.layer.masksToBounds = YES;
            selfWeak.scaleView.layer.cornerRadius = 130*WIDTH_RATIO/2;
            selfWeak.scaleView.alpha = 0;
        } completion:^(BOOL finished) {
            [selfWeak amplifyAnimation];
        }];
    }
}
#pragma mark - 悬浮球进入热区
-(void)enterHideHotView {
    if (!self.isInHotView) {
        self.closeImg.alpha = 0.8;
        self.scaleView.alpha = 0;
        self.isInHotView = YES;
        [UIView animateWithDuration:0.6 animations:^{
            self.scaleView.alpha = 0.1;
        }];
        [self reduceAnimation];
    }
}
#pragma mark - 悬浮球移出热区
-(void)exitOutHideHotView {
    if (self.isInHotView) {
        self.closeImg.alpha = 0.7;
        self.scaleView.alpha = 0;
        self.scaleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }
    self.isInHotView = NO;
}

#pragma mark - setter & getter

- (UIImageView *)bgImg {
    if (!_bgImg) {
        _bgImg = [UIImageView new];
        _bgImg.userInteractionEnabled = YES;
        if ([GTSDKUtils isPortrait]) {
            _bgImg.image = [[GTThemeManager share] imageWithName:@"mask_bottom_view_P"];
        } else {
            _bgImg.image = [[GTThemeManager share] imageWithName:@"mask_bottom_view_H"];
        }
    }
    return _bgImg;
}

- (UIView *)hideHotView {
    if (!_hideHotView) {
        _hideHotView = [UIView new];
        _hideHotView.layer.cornerRadius = hideHotView_width * WIDTH_RATIO / 2;
        _hideHotView.layer.masksToBounds = YES;
    }
    return _hideHotView;
}

- (UIView *)scaleView {
    if (!_scaleView) {
        _scaleView = [UIView new];
        _scaleView.layer.cornerRadius = 130 * WIDTH_RATIO / 2;
        _scaleView.layer.masksToBounds = YES;
        _scaleView.alpha = 0;
        _scaleView.backgroundColor = [UIColor hexColor:@"#ffffff"];
    }
    return _scaleView;
}

- (UIImageView *)closeImg {
    if (!_closeImg) {
        _closeImg = [UIImageView new];
        _closeImg.image = [[GTThemeManager share] imageWithName:@"mask_bottom_sub"];
        _closeImg.alpha = 0;
    }
    return _closeImg;
}
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [UILabel new];
        _tipsLabel.text = localString(@"拖拽至此可关闭");
        _tipsLabel.textColor = [UIColor hexColor:@"#ffffff" withAlpha:0.9];
        _tipsLabel.alpha = 0;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
    }
    return _tipsLabel;
}

@end
