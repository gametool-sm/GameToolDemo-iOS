//
//  GTHideSimpleFloatBallGuideDialog.m
//  GTSDK
//
//  Created by smwl_dxl on 2023/7/10.
//

#import "GTHideSimpleFloatBallGuideDialog.h"
#import "GTFloatingWindowManager.h"
#import "GTDialogWindowManager.h"

@interface GTHideSimpleFloatBallGuideDialog ()

@property (nonatomic, copy) NSString * titleText;
@property (nonatomic, copy) UIView * bgView;
/*
 隐藏悬浮球动效
 */
@property (nonatomic, strong) LOTAnimationView * hideFloatBallImg;
/*
 关闭极简模式动效
 */
@property (nonatomic, strong) LOTAnimationView * closeSimpleStyleImg;
@property (nonatomic, strong) UILabel * titleLabel;
/*
 关闭极简模式按钮
 */
@property (nonatomic, strong) UIButton * closeSimpleStyleButton;
/*
 隐藏按钮
 */
@property (nonatomic, strong) UIButton * hideFloatBallBtn;
@property (nonatomic, strong) UIButton * closeBtn;
@end

@implementation GTHideSimpleFloatBallGuideDialog

-(instancetype)initWithTitleText:(NSString *)titleText closeSimpleStype:(closeSimpleStyleButtonBlock)closeButtonBlock hideFloatBall:(hideButtonBlock)hideButtonBlock cancelBtnBlock:(nullable cancelButtonBlock)cancelBtnBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self removeFromSuperview];
        [self removeAllSubviews];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.6];
        self.closeButtonBlock = closeButtonBlock;
        self.hideButtonBlock = hideButtonBlock;
        self.cancelBtnBlock = cancelBtnBlock;
        self.titleText = [titleText copy];

        [self initSubview];
        [self setLayout];
    }
    return self;
}
- (void)initSubview {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:self.hideFloatBallImg];
    [self.bgView addSubview:self.closeSimpleStyleImg];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.hideFloatBallBtn];
    [self.bgView addSubview:self.closeSimpleStyleButton];
}
- (void)setLayout {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(310 * WIDTH_RATIO);
        make.height.mas_equalTo(255 * WIDTH_RATIO);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * WIDTH_RATIO);
        make.right.mas_equalTo(-17 * WIDTH_RATIO);
        make.width.height.mas_offset(20 * WIDTH_RATIO);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_offset(21);
    }];
    
    [self.hideFloatBallImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(59 * WIDTH_RATIO);
        make.left.mas_equalTo(24 * WIDTH_RATIO);
        make.width.mas_offset(126 * WIDTH_RATIO);
        make.height.mas_offset(116 * WIDTH_RATIO);
    }];
    
    [self.closeSimpleStyleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(59 * WIDTH_RATIO);
        make.right.mas_equalTo(-24 * WIDTH_RATIO);
        make.width.mas_offset(126 * WIDTH_RATIO);
        make.height.mas_offset(116 * WIDTH_RATIO);
    }];
    
    [self.hideFloatBallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20 * WIDTH_RATIO);
        make.left.mas_equalTo(24 * WIDTH_RATIO);
        make.width.mas_offset(126 * WIDTH_RATIO);
        make.height.mas_offset(42 * WIDTH_RATIO);
    }];
    
    [self.closeSimpleStyleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20 * WIDTH_RATIO);
        make.right.mas_equalTo(-24 * WIDTH_RATIO);
        make.width.mas_offset(126 * WIDTH_RATIO);
        make.height.mas_offset(42 * WIDTH_RATIO);
    }];
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor hexColor:@"#FFFFFF"];
        _bgView.layer.cornerRadius = 20 * WIDTH_RATIO;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = self.titleText;
        _titleLabel.textColor = [UIColor hexColor:@"#112640"];
        _titleLabel.font = [UIFont systemFontOfSize:15 * WIDTH_RATIO];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UIButton *)hideFloatBallBtn {
    if (!_hideFloatBallBtn) {
        _hideFloatBallBtn = [UIButton new];
        [_hideFloatBallBtn setTitle:localString(@"隐藏悬浮球") forState:UIControlStateNormal];
        [_hideFloatBallBtn setTitleColor:[UIColor colorWithHexString:@"#3E4956"] forState:UIControlStateNormal];
        _hideFloatBallBtn.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        _hideFloatBallBtn.layer.cornerRadius = 12 * WIDTH_RATIO;
        _hideFloatBallBtn.layer.masksToBounds = YES;
        _hideFloatBallBtn.backgroundColor = [UIColor hexColor:@"#112640" withAlpha:0.05];
        [_hideFloatBallBtn addTarget:self action:@selector(hideBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hideFloatBallBtn;
}
-(UIButton *)closeSimpleStyleButton {
    if (!_closeSimpleStyleButton) {
        _closeSimpleStyleButton = [UIButton new];
        [_closeSimpleStyleButton setTitle:localString(@"关闭极简模式") forState:UIControlStateNormal];
        [_closeSimpleStyleButton setTitleColor:[UIColor colorWithHexString:@"#3E4956"] forState:UIControlStateNormal];
        _closeSimpleStyleButton.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        _closeSimpleStyleButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _closeSimpleStyleButton.layer.masksToBounds = YES;
        _closeSimpleStyleButton.backgroundColor = [UIColor hexColor:@"#112640" withAlpha:0.05];
        [_closeSimpleStyleButton addTarget:self action:@selector(closeSimpleStypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeSimpleStyleButton;
}
- (LOTAnimationView *)hideFloatBallImg {
    if (!_hideFloatBallImg) {
        _hideFloatBallImg = [LOTAnimationView autoDirectoryAnimationNamed:@"hide_simple_float_ball" inBundle:[[GTThemeManager share] getGTSDKBundle]];
        _hideFloatBallImg.loopAnimation = YES;
        [_hideFloatBallImg play];
    }
    return _hideFloatBallImg;
}
- (LOTAnimationView *)closeSimpleStyleImg {
    if (!_closeSimpleStyleImg) {
        _closeSimpleStyleImg = [LOTAnimationView autoDirectoryAnimationNamed:@"close_simple_float_ball" inBundle:[[GTThemeManager share] getGTSDKBundle]];
        _closeSimpleStyleImg.loopAnimation = YES;
        [_closeSimpleStyleImg play];
    }
    return _closeSimpleStyleImg;
}
-(UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
 
        [_closeBtn setImage:[[GTThemeManager share] imageWithName:@"icon_close_hide_float_ball_window"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBlick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (void)closeBlick {
    if (self.cancelBtnBlock) {
        self.cancelBtnBlock();
    }
    
    [self removeFromSuperview];
    [[GTDialogWindowManager shareInstance].dialogWindow setHidden:YES];
    [[GTFloatingWindowManager shareInstance].windowWindow setHidden:YES];
    [[GTDialogWindowManager shareInstance].dialogWindow removeFromSuperview];
}
- (void)hideBtnClick:(id)sender {
    [self removeFromSuperview];
    [[GTDialogWindowManager shareInstance].dialogWindow setHidden:YES];
    [[GTFloatingWindowManager shareInstance].windowWindow setHidden:YES];
    [[GTDialogWindowManager shareInstance].dialogWindow removeFromSuperview];
    
    if (self.hideButtonBlock) {
        self.hideButtonBlock();
    }
}
-(void)closeSimpleStypeBtnClick:(id)sender {
    [self removeFromSuperview];
    [[GTDialogWindowManager shareInstance].dialogWindow setHidden:YES];
    [[GTFloatingWindowManager shareInstance].windowWindow setHidden:YES];
    [[GTDialogWindowManager shareInstance].dialogWindow removeFromSuperview];
    
    if (self.closeButtonBlock) {
        self.closeButtonBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
