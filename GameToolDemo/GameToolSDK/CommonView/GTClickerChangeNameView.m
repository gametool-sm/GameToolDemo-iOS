//
//  GTClickerChangeNameView.m
//  GTSDK
//
//  Created by shangminet on 2023/8/21.
//

#import "GTClickerChangeNameView.h"

@implementation GTClickerChangeNameView

- (instancetype)initWithStyleconfirm:(GTClickerSchemeModel *)model confirm:(ConfirmButtonBlock)confirmButtonBlock cancel:(CancelButtonBlock)cancelButtonBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0];
        self.confirmButtonBlock = confirmButtonBlock;
        self.cancelButtonBlock = cancelButtonBlock;
        self.nameTextField.text = model.name;
        
        self.model = model;
        [self setUp];
    }
    return self;
}



-(void)setUp{
    [self addSubview:self.bgView];
    self.bgView.alpha = 0;
    self.nameTextField.delegate = self;
    [self.bgView addSubview:self.changeNameLabel];
    [self.bgView addSubview:self.cancelButton];
    [self.bgView addSubview:self.verifyButton];
    [self.bgView addSubview:self.nameBackGroundView];
    [self.nameBackGroundView addSubview:self.nameTextField];
    [self.nameBackGroundView addSubview:self.countLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(310 * WIDTH_RATIO);
        make.height.mas_equalTo(177 * WIDTH_RATIO);
    }];
    [self.changeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(20 * WIDTH_RATIO);
        make.left.equalTo(self.bgView.mas_left).offset(24 * WIDTH_RATIO);
        make.width.equalTo(@(262 * WIDTH_RATIO));
        make.height.equalTo(@(21 * WIDTH_RATIO));
    }];
    
    [self.nameBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeNameLabel.mas_bottom).offset(16 * WIDTH_RATIO);
        make.left.equalTo(self.bgView.mas_left).offset(24 * WIDTH_RATIO);
        make.right.equalTo(self.bgView.mas_right).offset(-24 * WIDTH_RATIO);
        make.height.equalTo(@(40 * WIDTH_RATIO));
    }];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameBackGroundView.mas_centerY);
        make.left.equalTo(self.nameBackGroundView.mas_left).offset(10 * WIDTH_RATIO);
        make.width.equalTo(@(175 * WIDTH_RATIO));
        make.height.equalTo(@(20 * WIDTH_RATIO));
    }];
    [ self.nameTextField becomeFirstResponder];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20 * WIDTH_RATIO);
        make.left.equalTo(self.bgView.mas_left).offset(24 * WIDTH_RATIO);
        make.right.equalTo(self.bgView.mas_centerX).offset(-5 * WIDTH_RATIO);
        make.height.equalTo(@(42 * WIDTH_RATIO));
    }];
    [self.verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20 * WIDTH_RATIO);
        make.right.equalTo(self.bgView.mas_right).offset(-24 * WIDTH_RATIO);
        make.left.equalTo(self.bgView.mas_centerX).offset(5 * WIDTH_RATIO);
        make.height.equalTo(@(42 * WIDTH_RATIO));
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameBackGroundView.mas_bottom).offset(-10 * WIDTH_RATIO);
        make.top.equalTo(self.nameBackGroundView.mas_top).offset(10 * WIDTH_RATIO);
        make.right.equalTo(self.nameBackGroundView.mas_right).offset(-12 * WIDTH_RATIO);
        make.width.equalTo(@(40 * WIDTH_RATIO));
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.6];
        self.bgView.alpha = 1;
    }];
    [self textFieldDidChange];
}

CGFloat calculateStringLength(NSString *str) {
    CGFloat length = 0;
    
    for (NSUInteger i = 0; i < [str length]; i++) {
        unichar character = [str characterAtIndex:i];
        
        if ((character >= '0' && character <= '9') || (character >= 'a' && character <= 'z') ||
            (character >= 'A' && character <= 'Z')) {
            length += 0.5;
        } else {
            length += 1;
        }
    }
    
    return length;
}

#pragma mark -TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = textField.text;
    NSString *newText = [text stringByReplacingCharactersInRange:range withString:string];
    CGFloat length = calculateStringLength(newText);
    NSInteger maxLength = 12;
    return length <= maxLength;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!self.clearButton.superview) {
        [self addSubview:self.clearButton];
        [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.countLabel.mas_centerY);
            make.right.equalTo(self.countLabel.mas_left);
            make.height.width.equalTo(@(20));
        }];
    }
}

- (void)textFieldDidChange {
    NSString *text = self.nameTextField.text;
    NSInteger length = calculateStringLength(text);
    NSInteger maxLength = 12;
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld", length, maxLength];
    if([text isEqualToString: self.model.name]){
        self.verifyButton.backgroundColor = [UIColor themeColorWithAlpha:0.4];
    }else{
        self.verifyButton.backgroundColor = [UIColor themeColor];
        [self.verifyButton setTitleColor:[UIColor hexColor:@"FFFFFF"] forState:UIControlStateNormal];
    }
    
    if (text.length > 0 && !self.clearButton.superview) {
        [self addSubview:self.clearButton];
        [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.countLabel.mas_centerY);
            make.right.equalTo(self.countLabel.mas_left);
            make.height.width.equalTo(@(20));
        }];
    }else if(text.length == 0){
        [self.clearButton removeFromSuperview];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
    if (self.clearButton.superview) {
        [self.clearButton removeFromSuperview];
    }
}

#pragma mark -respone

- (void)confirmClick:(UIButton *)sender {
    if (self.confirmButtonBlock) {
        self.confirmButtonBlock();
    }
}

- (void)cancelClick:(UIButton *)sender {
    if (self.cancelButtonBlock) {
        self.cancelButtonBlock();
    }
    [self removeFromSuperview];
}

-(void)clearButtonClicked:(id)sender{
    self.nameTextField.text = @"";
    [self textFieldDidChange];
}

#pragma mark -setter & getter
-(UILabel *)changeNameLabel{
    if(!_changeNameLabel){
        _changeNameLabel = [UILabel new];
        _changeNameLabel.text = localString(@"修改名称");
        _changeNameLabel.textAlignment = NSTextAlignmentCenter;
        _changeNameLabel.font = [UIFont systemFontOfSize:15 * WIDTH_RATIO];
        _changeNameLabel.textColor = [GTThemeManager share].colorModel.clicker_title_color;
    }
    return _changeNameLabel;
}

-(UITextField *)nameTextField{
    if(!_nameTextField){
        _nameTextField = [UITextField new];
        _nameTextField.textColor = [GTThemeManager share].colorModel.clicker_rename_text_color;
        _nameTextField.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        _nameTextField.placeholder = @"请输入方案名称～";
        _nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入方案名称～"
            attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
        [_nameTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
        _nameTextField.delegate = self;
        _nameTextField.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    }
    return _nameTextField;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:localString(@"取消") forState:UIControlStateNormal];
        [_cancelButton setTitleColor: [GTThemeManager share].colorModel.clicker_text_color forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14*WIDTH_RATIO];
        _cancelButton.backgroundColor = [GTThemeManager share].colorModel.dialog_cancel_btn_bg_color;
        _cancelButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)verifyButton {
    if (!_verifyButton) {
        _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_verifyButton setTitle:localString(@"确认") forState:UIControlStateNormal];
        [_verifyButton setTitleColor: [GTThemeManager share].colorModel.clicker_savebutton_color forState:UIControlStateNormal];
        [_verifyButton setBackgroundColor:[UIColor themeColorWithAlpha:0.4]];
        _verifyButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _verifyButton.layer.masksToBounds = YES;
        _verifyButton.titleLabel.font = [UIFont systemFontOfSize:14*WIDTH_RATIO];
        [_verifyButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyButton;
}

-(UILabel *)countLabel{
    if(!_countLabel){
        _countLabel = [UILabel new];
        NSString *text = _nameTextField.text;
        NSInteger maxLength = 12;
        _countLabel.text = [NSString stringWithFormat:@"%ld/%ld", text.length, maxLength];
        _countLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        _countLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton new];
        [_clearButton setBackgroundColor:[UIColor clearColor]];
        [_clearButton setImage:[[GTThemeManager share] imageWithName:@"clicker_text_delete_icon"] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (UIView *)nameBackGroundView {
    if (!_nameBackGroundView) {
        _nameBackGroundView = [UIView new];
        _nameBackGroundView.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _nameBackGroundView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _nameBackGroundView.layer.masksToBounds = YES;
    }
    return _nameBackGroundView;
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

@end
