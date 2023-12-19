//
//  GTCloseSimpleModeGuideDialog.m
//  GTSDK
//
//  Created by shangmi on 2023/8/4.
//

#import "GTCloseSimpleModeGuideDialog.h"
#import "GTFloatingWindowManager.h"
#import "GTDialogWindowManager.h"

@interface GTCloseSimpleModeGuideDialog ()

@property (nonatomic, copy) NSString * titleText;
@property (nonatomic, copy) UIView * bgView;
/*
 关闭极简模式动效
 */
@property (nonatomic, strong) LOTAnimationView * closeSimpleStyleImg;
@property (nonatomic, strong) UILabel * titleLabel;
/*
 关闭极简模式按钮
 */
@property (nonatomic, strong) UIButton * closeSimpleStyleButton;
@property (nonatomic, strong) UIButton * closeBtn;
@end

@implementation GTCloseSimpleModeGuideDialog

-(instancetype)initWithTitleText:(NSString *)titleText closeSimpleStype:(closeSimpleStyleButtonBlock)closeButtonBlock cancelBtnBlock:(nullable cancelButtonBlock)cancelBtnBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self removeFromSuperview];
        [self removeAllSubviews];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.6];
        self.closeButtonBlock = closeButtonBlock;
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
    [self.bgView addSubview:self.closeSimpleStyleImg];
    [self.bgView addSubview:self.titleLabel];
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
    
    [self.closeSimpleStyleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(59 * WIDTH_RATIO);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.width.mas_offset(126 * WIDTH_RATIO);
        make.height.mas_offset(116 * WIDTH_RATIO);
    }];
    
    [self.closeSimpleStyleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20 * WIDTH_RATIO);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
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

-(void)closeSimpleStypeBtnClick:(id)sender {
    [self removeFromSuperview];
    [[GTDialogWindowManager shareInstance].dialogWindow setHidden:YES];
    [[GTFloatingWindowManager shareInstance].windowWindow setHidden:YES];
    [[GTDialogWindowManager shareInstance].dialogWindow removeFromSuperview];
    
    if (self.closeButtonBlock) {
        self.closeButtonBlock();
    }
}

@end
