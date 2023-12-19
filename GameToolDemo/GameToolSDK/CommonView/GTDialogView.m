//
//  GTDialogView.m
//  GTSDK
//
//  Created by shangmi on 2023/6/30.
//

#import "GTDialogView.h"

@interface GTDialogView ()


@end

@implementation GTDialogView

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    
    self.bgView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.titleLabel.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    self.contentLabel.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    [self.leftButton setTitleColor:[GTThemeManager share].colorModel.dialog_cancel_btn_title_color forState:UIControlStateNormal];
    self.leftButton.backgroundColor = [GTThemeManager share].colorModel.dialog_cancel_btn_bg_color;
}

- (instancetype)initWithStyle:(DialogViewStyle)style title:(NSString *)title content:(NSString *)content leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftButtonBlock:(LeftButtonBlock)leftButtonBlock rightButtonBlock:(RightButtonBlock)rightButtonBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.style = style;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0];
        self.leftButtonBlock = leftButtonBlock;
        self.rightButtonBlock = rightButtonBlock;
        self.titleText = [title copy];
        self.contentText = [content copy];
        self.leftButtonText = [leftButtonTitle copy];
        self.rightButtonText = [rightButtonTitle copy];
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.bgView];
    self.bgView.alpha = 0;
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.leftButton];
    [self.bgView addSubview:self.rightButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(310 * WIDTH_RATIO);
        make.height.mas_equalTo(160 * WIDTH_RATIO);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset( 20 * WIDTH_RATIO);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.height.mas_equalTo(21 * WIDTH_RATIO);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(24 * WIDTH_RATIO);
        make.right.equalTo(self.bgView.mas_right).offset(-24 * WIDTH_RATIO);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-62 * WIDTH_RATIO);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(24 * WIDTH_RATIO);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20 * WIDTH_RATIO);
        make.width.mas_equalTo(126 * WIDTH_RATIO);
        make.height.mas_equalTo(42 * WIDTH_RATIO);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-24 * WIDTH_RATIO);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20 * WIDTH_RATIO);
        make.width.mas_equalTo(126 * WIDTH_RATIO);
        make.height.mas_equalTo(42 * WIDTH_RATIO);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.6];
        self.bgView.alpha = 1;
    }];
}

- (void)rightButtonClick:(UIButton *)sender {
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
    
    [self removeFromSuperview];
}

- (void)leftButtonClick:(UIButton *)sender {
    if (self.leftButtonBlock) {
        self.leftButtonBlock();
    }
    [self removeFromSuperview];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
        _bgView.layer.cornerRadius = 20 * WIDTH_RATIO;
        _bgView.layer.masksToBounds = YES;
        
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = self.titleText;
        _titleLabel.textColor = [GTThemeManager share].colorModel.dialog_title_color;
        _titleLabel.font = [UIFont systemFontOfSize:15 * WIDTH_RATIO];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.text = self.contentText;
        _contentLabel.textColor = [GTThemeManager share].colorModel.dialog_title_color;
        _contentLabel.font = [UIFont systemFontOfSize:15 * WIDTH_RATIO];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.backgroundColor = [GTThemeManager share].colorModel.dialog_cancel_btn_bg_color;
        [_leftButton setTitle:self.leftButtonText forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        [_leftButton setTitleColor:[GTThemeManager share].colorModel.dialog_cancel_btn_title_color forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _leftButton.layer.masksToBounds = YES;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.backgroundColor = [UIColor themeColor];
        [_rightButton setTitle:self.rightButtonText forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        [_rightButton setTitleColor:[UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _rightButton.layer.masksToBounds = YES;
    }
    return _rightButton;
}

@end
