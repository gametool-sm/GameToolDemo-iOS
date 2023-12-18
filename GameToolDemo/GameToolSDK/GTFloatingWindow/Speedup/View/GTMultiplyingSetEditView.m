//
//  GTMultiplyingSetEditView.m
//  GTSDK
//
//  Created by shangmi on 2023/7/1.
//

#import "GTMultiplyingSetEditView.h"
#import "GTDialogView.h"

@interface GTMultiplyingSetEditView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIImageView *numImg;
@property (nonatomic, strong) UIButton *changeButton;

@end

@implementation GTMultiplyingSetEditView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.bgView];
    [self addSubview:self.numLabel];
    [self addSubview:self.numImg];
    [self addSubview:self.changeButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-28 * WIDTH_RATIO);
    }];
    
    [self.numImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(13 * WIDTH_RATIO);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.width.mas_equalTo(8 * WIDTH_RATIO);
        make.height.mas_equalTo(18 * WIDTH_RATIO);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numImg.mas_right).offset(1 * WIDTH_RATIO);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    // 设置虚框的颜色
    UIColor *borderColor = [UIColor themeColor];
    // 设置虚框的宽度
    CGFloat borderWidth = 1.0;

    // 创建虚线样式
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.fillColor = nil;
    borderLayer.lineWidth = borderWidth;
    borderLayer.lineJoin = kCALineJoinRound;
    borderLayer.lineDashPattern = @[@4, @2]; // 设置虚线的长度和间距，可以根据需要调整
        
    // 创建虚线路径，使用CGRectInset来缩小虚线框，使其不超过视图边界
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(CGRectMake(0, 0, 101 * WIDTH_RATIO, 40 * WIDTH_RATIO), borderWidth / 2, borderWidth / 2) cornerRadius:10 * WIDTH_RATIO];
    borderLayer.path = borderPath.CGPath;
    
    // 将虚线图层添加到视图图层上
    [self.bgView.layer addSublayer:borderLayer];
}

- (void)changeClick:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0;
        }];
    });
    
    if (self.insertButtonBlock) {
        self.insertButtonBlock();
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor hexColor:@"#3391FF" withAlpha:0.05];
        _bgView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _bgView.layer.masksToBounds = YES;
//        _bgView.layer.borderWidth = 1 * WIDTH_RATIO;
//        _bgView.layer.borderColor = [UIColor themeColor].CGColor;
    }
    return _bgView;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.text = @"1";
        _numLabel.textColor = [UIColor themeColor];
        _numLabel.font = [UIFont boldSystemFontOfSize:16*WIDTH_RATIO];
    }
    return _numLabel;
}

- (UIImageView *)numImg {
    if (!_numImg) {
        _numImg = [UIImageView new];
        _numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img_blue"];
    }
    return _numImg;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setImage:[[GTThemeManager share] imageWithName:@"set_append_btn"] forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeButton;
}

@end
