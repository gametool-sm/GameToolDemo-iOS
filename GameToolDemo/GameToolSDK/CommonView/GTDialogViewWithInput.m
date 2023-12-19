//
//  GTDialogViewWithInput.m
//  GTSDK
//
//  Created by shangmi on 2023/7/19.
//

#import "GTDialogViewWithInput.h"

@interface GTDialogViewWithInput ()

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *contentText;

@property (nonatomic, copy) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation GTDialogViewWithInput

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content confirm:(ConfirmButtonBlock)confirmButtonBlock cancel:(CancelButtonBlock)cancelButtonBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0];
        self.confirmButtonBlock = confirmButtonBlock;
        self.cancelButtonBlock = cancelButtonBlock;
        self.titleText = [title copy];
        self.contentText = [content copy];
        
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.bgView];
    self.bgView.alpha = 0;
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.textField];
    [self.bgView addSubview:self.cancelButton];
    [self.bgView addSubview:self.confirmButton];
    
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
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(24 * WIDTH_RATIO);
        make.right.equalTo(self.bgView.mas_right).offset(-24 * WIDTH_RATIO);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-82 * WIDTH_RATIO);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(24 * WIDTH_RATIO);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20 * WIDTH_RATIO);
        make.width.mas_equalTo(126 * WIDTH_RATIO);
        make.height.mas_equalTo(42 * WIDTH_RATIO);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-24 * WIDTH_RATIO);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20 * WIDTH_RATIO);
        make.width.mas_equalTo(126 * WIDTH_RATIO);
        make.height.mas_equalTo(42 * WIDTH_RATIO);
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.6];
        self.bgView.alpha = 1;
    }];
}

- (void)confirmClick:(UIButton *)sender {
    if (self.confirmButtonBlock) {
        self.confirmButtonBlock(self.textField.text);
    }
    
    [self removeFromSuperview];
}

- (void)cancelClick:(UIButton *)sender {
    if (self.cancelButtonBlock) {
        self.cancelButtonBlock();
    }
    [self removeFromSuperview];
}

- (UIView *)bgView {
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

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.placeholder = @"请输入密码";
    }
    return _textField;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor hexColor:@"#112640" withAlpha:0.05];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        [_cancelButton setTitleColor:[UIColor hexColor:@"#3E4956"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _cancelButton.layer.masksToBounds = YES;
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = [UIColor themeColor];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        [_confirmButton setTitleColor:[UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

@end
