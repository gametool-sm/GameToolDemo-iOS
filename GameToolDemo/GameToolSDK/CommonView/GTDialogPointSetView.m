//
//  GTDialogPointSetView.m
//  GTSDK
//
//  Created by shangminet on 2023/8/28.
//

#import "GTDialogPointSetView.h"
#import "GTDialogWindowManager.h"
#import "GTClickerWindowManager.h"
#import "GTClickerManager.h"

@implementation GTDialogPointSetView

- (instancetype)initWithTitle:(NSString *)title model:(nonnull GTClickerActionModel *)modelAction index:(int)index {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0];
        self.titleText = [title copy];
        self.modelAction = modelAction;
        self.index = index;
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self addSubview:self.bgView];
    
    self.bgView.alpha = 0;
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.tapCount];
    [self.bgView addSubview:self.pressDuration];
    [self.bgView addSubview:self.clickInterval];
    [self.bgView addSubview:self.tapCountView];
    [self.bgView addSubview:self.tapCountText];
    [self.bgView addSubview:self.tapCountLabel];
    [self.bgView addSubview:self.pressDurationView];
    [self.bgView addSubview:self.pressDurationText];
    [self.bgView addSubview:self.pressDurationLabel];
    [self.bgView addSubview:self.clickIntervalView];
    [self.bgView addSubview:self.clickIntervalText];
    [self.bgView addSubview:self.clickIntervalLabel];
    [self.bgView addSubview:self.confirmButton];
    [self.bgView addSubview:self.cancelButton];
    [self.bgView addSubview:self.deleteButton];
    [self.bgView addSubview:self.cancelButton];
    [self.bgView addSubview:self.confirmButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(310 * WIDTH_RATIO);
        make.height.mas_equalTo(200 * WIDTH_RATIO);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset( 20 * WIDTH_RATIO);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.height.mas_equalTo(21 * WIDTH_RATIO);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.bgView.mas_left).offset(24 * WIDTH_RATIO);
        make.width.height.equalTo(@(20 * WIDTH_RATIO));
        
    }];
    [self.tapCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16 * WIDTH_RATIO);
        make.left.equalTo(self.bgView.mas_left).offset(24 * WIDTH_RATIO);
        make.width.mas_equalTo(83 * WIDTH_RATIO);
        make.height.mas_equalTo(17 * WIDTH_RATIO);
    }];
    [self.pressDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16 * WIDTH_RATIO);
        make.left.equalTo(self.tapCount.mas_right).offset(7 * WIDTH_RATIO);
        make.width.mas_equalTo(83 * WIDTH_RATIO);
        make.height.mas_equalTo(17 * WIDTH_RATIO);
    }];
    [self.clickInterval mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16 * WIDTH_RATIO);
        make.left.equalTo(self.pressDuration.mas_right).offset(7 * WIDTH_RATIO);
        make.width.mas_equalTo(83 * WIDTH_RATIO);
        make.height.mas_equalTo(17 * WIDTH_RATIO);
    }];
    [self.tapCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tapCount.mas_bottom).offset(7 * WIDTH_RATIO);
        make.left.equalTo(self.bgView.mas_left).offset(24 * WIDTH_RATIO);
        make.width.mas_equalTo(83 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    [self.pressDurationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tapCount.mas_bottom).offset(7 * WIDTH_RATIO);
        make.left.equalTo(self.tapCountView.mas_right).offset(6 * WIDTH_RATIO);
        make.width.mas_equalTo(83 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    [self.clickIntervalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tapCount.mas_bottom).offset(7 * WIDTH_RATIO);
        make.left.equalTo(self.pressDurationView.mas_right).offset(6 * WIDTH_RATIO);
        make.width.mas_equalTo(83 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    [self.tapCountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tapCountView.mas_centerY);
        make.left.equalTo(self.tapCountView.mas_left).offset(8 * WIDTH_RATIO);
        make.width.mas_equalTo(55 * WIDTH_RATIO);
        make.height.mas_equalTo(14 * WIDTH_RATIO);
    }];
    [self.pressDurationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tapCountView.mas_centerY);
        make.left.equalTo(self.pressDurationView.mas_left).offset(8 * WIDTH_RATIO);
        make.width.mas_equalTo(55 * WIDTH_RATIO);
        make.height.mas_equalTo(14 * WIDTH_RATIO);
    }];
    [self.clickIntervalText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tapCountView.mas_centerY);
        make.left.equalTo(self.clickIntervalView.mas_left).offset(8 * WIDTH_RATIO);
        make.width.mas_equalTo(55 * WIDTH_RATIO);
        make.height.mas_equalTo(14 * WIDTH_RATIO);
    }];
    
    [self.tapCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tapCountView.mas_centerY);
        make.right.equalTo(self.tapCountView.mas_right).offset(-9 * WIDTH_RATIO);
        make.width.mas_equalTo(10 * WIDTH_RATIO);
        make.height.mas_equalTo(14 * WIDTH_RATIO);
    }];
    [self.pressDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tapCountView.mas_centerY);
        make.right.equalTo(self.pressDurationView.mas_right).offset(-9 * WIDTH_RATIO);
        make.width.mas_equalTo(23 * WIDTH_RATIO);
        make.height.mas_equalTo(15 * WIDTH_RATIO);
    }];
    [self.clickIntervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tapCountView.mas_centerY);
        make.right.equalTo(self.clickIntervalView.mas_right).offset(-9 * WIDTH_RATIO);
        make.width.mas_equalTo(23 * WIDTH_RATIO);
        make.height.mas_equalTo(15 * WIDTH_RATIO);
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
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.6];
        self.bgView.alpha = 1;
    }];
    [self.tapCountText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pressDurationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.clickIntervalText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    //保存原始数据
    self.tapCompare = self.modelAction.tapCount;
    self.pressCompare = self.modelAction.pressDuration;
    self.clickCompare = self.modelAction.clickInterval;
}

#pragma mark -response

- (void)confirmClick:(UIButton *)sender {
    [self removeFromSuperview];
    if ([self.confirmButton.backgroundColor isEqual:[UIColor themeColor]]) {
        if (self.longPressPointShowPointSetBlock) {
            self.longPressPointShowPointSetBlock(self.modelAction);
        }
        [[GTDialogWindowManager shareInstance] dialogWindowHide];
    }
}

- (void)cancelClick:(UIButton *)sender {
    [self removeFromSuperview];
    [[GTDialogWindowManager shareInstance] dialogWindowHide];
}

- (void)deleteClick:(UIButton *)sender {
    if([GTClickerWindowManager shareInstance].schemeModel.actionArray.count == 1){
        [[GTDialogWindowManager shareInstance].dialogWindow  makeToast:localString(@"不可删除所有触点") duration:0.5 position:CSToastPositionCenter];
        return;
    }else{
        [self removeFromSuperview];
        GTDialogView *dialogView = [[GTDialogView alloc] initWithStyle:DialogViewStyleDefault
                                                                 title:@"温馨提示"
                                                               content:[NSString stringWithFormat:@"确定要删除序号为%d的触点吗？", self.index]
                                                       leftButtonTitle:@"取消"
                                                      rightButtonTitle:@"删除"
                                                       leftButtonBlock:^{
            [[GTDialogWindowManager shareInstance] dialogWindowHide];
        }
                                                      rightButtonBlock:^{
            [[GTDialogWindowManager shareInstance] dialogWindowHide];
            //删除此触点model
            [[GTClickerWindowManager shareInstance].schemeModel.actionArray removeObjectAtIndex:self.index-1];
            [[GTClickerWindowManager shareInstance].compareArray removeObjectAtIndex:self.index-1];
            //删除此触点window
            [[GTClickerWindowManager shareInstance].pointWindowArray removeObjectAtIndex:self.index-1];
            
            [[GTClickerWindowManager shareInstance] setUp];
        }];
        [[GTDialogWindowManager shareInstance].dialogVC.view addSubview:dialogView];
        [[GTDialogWindowManager shareInstance] dialogWindowShow];
    }
        
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == self.tapCountText){
        if([self.tapCountText.text intValue] == 1){
            self.tapCountText.text = 0;
        }
    }
    if(textField == self.pressDurationText){
        if([self.pressDurationText.text intValue] == 80){
            self.pressDurationText.text = 0;
        }
    }
    if(textField == self.clickIntervalText){
        if([self.clickIntervalText.text intValue] == 1000){
            self.clickIntervalText.text = 0;
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if(textField == self.tapCountText){
        if([self.tapCountText.text intValue] == 0){
            self.tapCountText.text = [NSString stringWithFormat:@"%d",1];
            self.modelAction.tapCount = 1;
        }
    }
    if(textField == self.pressDurationText){
        if([self.pressDurationText.text intValue] == 0){
            self.pressDurationText.text = [NSString stringWithFormat:@"%d",80];
            self.modelAction.pressDuration = 80;
        }
    }
    if(textField == self.clickIntervalText){
        if([self.clickIntervalText.text intValue] == 0){
            self.clickIntervalText.text = [NSString stringWithFormat:@"%d",1000];
            self.modelAction.clickInterval = 1000;
        }
    }
    [self textFieldDidChange:self.tapCountText];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(string.length == 1){
        NSString *regex = @"^[0-9]*$"; // 只允许输入数字的正则表达式
        NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSInteger numberOfMatches = [regExp numberOfMatchesInString:updatedString options:0 range:NSMakeRange(0, updatedString.length)];
        if (numberOfMatches == 0) {
            return NO;
        } else {
            if (textField == self.tapCountText) {
                NSInteger number = [updatedString integerValue];
                if (number > 999) {
                    self.tapCountText.text = [NSString stringWithFormat:@"%d",999];
                    self.modelAction.tapCount = 999;
                    [self textFieldDidChange:self.tapCountText];
                    return NO;
                }
                self.modelAction.tapCount = [updatedString intValue];
                return YES;
            }else if (textField == self.pressDurationText) {
                NSInteger number = [updatedString integerValue];
                if (number > 99999) {
                    self.pressDurationText.text = [NSString stringWithFormat:@"%d",99999];
                    self.modelAction.pressDuration = 99999;
                    [self textFieldDidChange:self.tapCountText];
                    return NO;
                }
                self.modelAction.pressDuration = [updatedString intValue];
                return YES;
            }else if (textField == self.clickIntervalText) {
                NSInteger number = [updatedString integerValue];
                if (number > 99999) {
                    self.clickIntervalText.text = [NSString stringWithFormat:@"%d",99999];
                    self.modelAction.clickInterval = 99999;
                    [self textFieldDidChange:self.tapCountText];
                    return NO;
                }
                self.modelAction.clickInterval = [updatedString intValue];
                return YES;
            }
        }
    }else if(string.length == 0){
        if (textField == self.tapCountText) {
            self.modelAction.tapCount = [updatedString intValue];
        } else if (textField == self.pressDurationText) {
            self.modelAction.pressDuration = [updatedString intValue];
        } else if (textField == self.clickIntervalText) {
            self.modelAction.clickInterval = [updatedString intValue];
        }
        [self textFieldDidChange:self.tapCountText];
        return YES;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (![self.tapCountText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.tapCompare]]|| ![self.pressDurationText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.pressCompare]] || ![self.clickIntervalText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.clickCompare]])
    {
        self.confirmButton.backgroundColor = [UIColor themeColor];
        [self.confirmButton setTitleColor:[UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
    }else{
        self.confirmButton.backgroundColor = [UIColor themeColorWithAlpha:0.4];
        [self.confirmButton setTitleColor:[GTThemeManager share].colorModel.clicker_savebutton_color forState:UIControlStateNormal];
    }
    if ([self.tapCountText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.tapCompare]]){
        self.tapCountText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    }else{
        self.tapCountText.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    }
    if( [self.pressDurationText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.pressCompare]] ){
        self.pressDurationText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    }else{
        self.pressDurationText.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    }
    if([self.clickIntervalText.text isEqualToString:[NSString stringWithFormat:@"%d", self.clickCompare]]){
        self.clickIntervalText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    }else{
        self.clickIntervalText.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark -setter & getter

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
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [GTThemeManager share].colorModel.titleColor;
        _titleLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
    }
    return _titleLabel;
}

- (UILabel *)tapCount {
    if (!_tapCount) {
        _tapCount = [UILabel new];
        _tapCount.text = localString(@"点击次数");
        _tapCount.textAlignment = NSTextAlignmentCenter;
        _tapCount.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _tapCount.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    }
    return _tapCount;
}

- (UILabel *)pressDuration {
    if (!_pressDuration) {
        _pressDuration = [UILabel new];
        _pressDuration.text = localString(@"按压时长");
        _pressDuration.textAlignment = NSTextAlignmentCenter;
        _pressDuration.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _pressDuration.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    }
    return _pressDuration;
}

- (UILabel *)clickInterval {
    if (!_clickInterval) {
        _clickInterval = [UILabel new];
        _clickInterval.text = localString(@"点击间隔");
        _clickInterval.textAlignment = NSTextAlignmentCenter;
        _clickInterval.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _clickInterval.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    }
    return _clickInterval;
}

- (UIView *)tapCountView {
    if (!_tapCountView) {
        _tapCountView = [UIView new];
        _tapCountView.backgroundColor = [GTThemeManager share].colorModel.dialog_cancel_btn_bg_color;
        _tapCountView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _tapCountView.layer.masksToBounds = YES;
    }
    return _tapCountView;
}

- (UIView *)pressDurationView{
    if (!_pressDurationView) {
        _pressDurationView = [UIView new];
        _pressDurationView.backgroundColor = [GTThemeManager share].colorModel.dialog_cancel_btn_bg_color;
        _pressDurationView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _pressDurationView.layer.masksToBounds = YES;
    }
    return _pressDurationView;
}

- (UIView *)clickIntervalView {
    if (!_clickIntervalView) {
        _clickIntervalView = [UIView new];
        _clickIntervalView.backgroundColor = [GTThemeManager share].colorModel.dialog_cancel_btn_bg_color;
        _clickIntervalView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _clickIntervalView.layer.masksToBounds = YES;
    }
    return _clickIntervalView;
}

-(UITextField *)tapCountText{
    if(!_tapCountText){
        _tapCountText = [UITextField new];
        _tapCountText.text = [[NSString stringWithFormat:@"%d",  self.modelAction.tapCount ] mutableCopy];
        _tapCountText.textColor = [GTThemeManager share].colorModel.unselectedTextColor;
        _tapCountText.textAlignment = NSTextAlignmentCenter;
        _tapCountText.font = [UIFont systemFontOfSize:10*WIDTH_RATIO];
        _tapCountText.delegate = self;
    }
    return _tapCountText;
}

-(UITextField *)pressDurationText{
    if(!_pressDurationText){
        _pressDurationText = [UITextField new];
        _pressDurationText.text = [[NSString stringWithFormat:@"%d",  self.modelAction.pressDuration ]mutableCopy];
        _pressDurationText.textColor = [GTThemeManager share].colorModel.unselectedTextColor;
        _pressDurationText.textAlignment = NSTextAlignmentCenter;
        _pressDurationText.font = [UIFont systemFontOfSize:10*WIDTH_RATIO];
        _pressDurationText.delegate = self;
    }
    return _pressDurationText;
}

-(UITextField *)clickIntervalText{
    if(!_clickIntervalText){
        _clickIntervalText = [UITextField new];
        _clickIntervalText.text = [[NSString stringWithFormat:@"%d",  self.modelAction.clickInterval]mutableCopy] ;
        _clickIntervalText.textColor = [GTThemeManager share].colorModel.unselectedTextColor;
        _clickIntervalText.textAlignment = NSTextAlignmentCenter;
        _clickIntervalText.font = [UIFont systemFontOfSize:10*WIDTH_RATIO];
        _clickIntervalText.delegate = self;
    }
    return _clickIntervalText;
}

-(UILabel*)tapCountLabel{
    if(!_tapCountLabel){
        _tapCountLabel = [UILabel new];
        _tapCountLabel.text = localString(@"次");
        _tapCountLabel.textColor = [GTThemeManager share].colorModel.unselectedTextColor;
        _tapCountLabel.font = [UIFont systemFontOfSize:10*WIDTH_RATIO];
    }
    return _tapCountLabel;
}

-(UILabel*)pressDurationLabel{
    if(!_pressDurationLabel){
        _pressDurationLabel = [UILabel new];
        _pressDurationLabel.text = localString(@"毫秒");
        _pressDurationLabel.textColor = [GTThemeManager share].colorModel.unselectedTextColor;
        _pressDurationLabel.font = [UIFont systemFontOfSize:11*WIDTH_RATIO];
    }
    return _pressDurationLabel;
}

-(UILabel*)clickIntervalLabel{
    if(!_clickIntervalLabel){
        _clickIntervalLabel = [UILabel new];
        _clickIntervalLabel.text = localString(@"毫秒");
        _clickIntervalLabel.textColor = [GTThemeManager share].colorModel.unselectedTextColor;
        _clickIntervalLabel.font = [UIFont systemFontOfSize:11*WIDTH_RATIO];
    }
    return _clickIntervalLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [GTThemeManager share].colorModel.dialog_cancel_btn_bg_color;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        [_cancelButton setTitleColor:[GTThemeManager share].colorModel.clicker_text_color forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _cancelButton.layer.masksToBounds = YES;
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = [UIColor themeColorWithAlpha:0.4];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        [_confirmButton setTitleColor:[GTThemeManager share].colorModel.clicker_savebutton_color forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[[GTThemeManager share] imageWithName:@"clicker_pointset_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _deleteButton;
}
@end
