//
//  GTClickerPointSetTableViewCell.m
//  GTSDK
//
//  Created by shangminet on 2023/8/23.
//

#import "GTClickerPointSetTableViewCell.h"
#import "GTFloatingWindowManager.h"
#import "UIButton+Extent.h"
@implementation GTClickerPointSetTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:GTSDKChangeTheme object:nil];
    }
    return self;
}

- (void)changeTheme :(NSNotification *)noti{
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.contentView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.fBGView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.tapCountView.backgroundColor = [GTThemeManager share].colorModel.clicker_pointset_cell_color;
    self.pressDurationView.backgroundColor = [GTThemeManager share].colorModel.clicker_pointset_cell_color;
    self.clickIntervalView.backgroundColor = [GTThemeManager share].colorModel.clicker_pointset_cell_color;
    [self.sortButton setImage:[[GTThemeManager share] imageWithName:@"clicker_pointset_sort"] forState:UIControlStateNormal];

    if ([self.tapCountText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.compareAction.tapCount]]){
        self.tapCountText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    }else{
        self.tapCountText.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    }

    if( [self.pressDurationText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.compareAction.pressDuration]] ){
        self.pressDurationText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    }else{
        self.pressDurationText.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    }

    if([self.clickIntervalText.text isEqualToString:[NSString stringWithFormat:@"%d", self.compareAction.clickInterval]]){
        self.clickIntervalText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    }else{
        self.clickIntervalText.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    }

    self.tapCountLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    self.pressDurationLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    self.clickIntervalLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    self.rowNumberLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    
}

-(void)setUp{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.contentView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    [self addSubview:self.fBGView];
    [self.fBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.fBGView addSubview:self.tapCountView];
    [self.fBGView addSubview:self.pressDurationView];
    [self.fBGView addSubview:self.clickIntervalView];
    [self.fBGView addSubview:self.sortButton];
    [self.fBGView addSubview:self.rowNumberLabel];
    
    self.model = [GTClickerSchemeModel new];
    self.model = [GTClickerWindowManager shareInstance].schemeModel;
    [self.tapCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fBGView.mas_top).offset(4 * WIDTH_RATIO);
        make.left.equalTo(self.fBGView.mas_left).offset(31 * WIDTH_RATIO);
        make.width.equalTo(@(72 * WIDTH_RATIO));
        make.bottom.equalTo(self.fBGView.mas_bottom).offset(-4 * WIDTH_RATIO);
    }];
    [self.pressDurationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fBGView.mas_top).offset(4 * WIDTH_RATIO);
        make.left.equalTo(self.tapCountView.mas_right).offset(6 * WIDTH_RATIO);
        make.width.equalTo(@(72 * WIDTH_RATIO));
        make.bottom.equalTo(self.fBGView.mas_bottom).offset(-4 * WIDTH_RATIO);
    }];
    [self.clickIntervalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fBGView.mas_top).offset(4 * WIDTH_RATIO);
        make.left.equalTo(self.pressDurationView.mas_right).offset(6 * WIDTH_RATIO);
        make.width.equalTo(@(72 * WIDTH_RATIO));
        make.bottom.equalTo(self.fBGView.mas_bottom).offset(-4 * WIDTH_RATIO);
    }];
    [self.sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fBGView.mas_centerY);
        make.left.equalTo(self.clickIntervalView.mas_right).offset(6 * WIDTH_RATIO);
        make.width.height.equalTo(@(17 * WIDTH_RATIO));
    }];
    [self.rowNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fBGView.mas_centerY);
        make.left.equalTo(self.fBGView.mas_left).offset(8 * WIDTH_RATIO);
        make.height.equalTo(@(18 * WIDTH_RATIO));
        make.width.equalTo(@(19 * WIDTH_RATIO));
    }];
    
    [self.tapCountView addSubview:self.tapCountText];
    [self.tapCountView addSubview:self.tapCountLabel];
    
    [self.tapCountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tapCountView.mas_centerY);
        make.left.equalTo(self.tapCountView.mas_left).offset(5 * WIDTH_RATIO);
        make.right.equalTo(self.tapCountView.mas_right).offset(-22 * WIDTH_RATIO);
    }];
    
    [self.tapCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.tapCountView.mas_centerY);
        make.left.equalTo(self.tapCountText.mas_right);
        make.right.equalTo(self.tapCountView.mas_right).offset(-7 * WIDTH_RATIO);
    }];

    [self.tapCountText setKeyboardType:UIKeyboardTypeNumberPad];
    [self.pressDurationView addSubview:self.pressDurationText];
    [self.pressDurationView addSubview:self.pressDurationLabel];
    
    [self.pressDurationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pressDurationView.mas_centerY);
        make.left.equalTo(self.pressDurationView.mas_left).offset(5 * WIDTH_RATIO);
        make.right.equalTo(self.pressDurationView.mas_right).offset(-30 * WIDTH_RATIO);
    }];
    [self.pressDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pressDurationView.mas_centerY);
        make.left.equalTo(self.pressDurationText.mas_right);
        make.right.equalTo(self.pressDurationView.mas_right).offset(-7 * WIDTH_RATIO);
    }];
    
    [self.clickIntervalView addSubview:self.clickIntervalText];
    [self.clickIntervalView addSubview:self.clickIntervalLabel];
    [self.clickIntervalText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.clickIntervalView.mas_centerY);
        make.left.equalTo(self.clickIntervalView.mas_left).offset(5 * WIDTH_RATIO);
        make.right.equalTo(self.clickIntervalView.mas_right).offset(-30 * WIDTH_RATIO);
    }];
    [self.clickIntervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.clickIntervalView.mas_centerY);
        make.left.equalTo(self.clickIntervalText.mas_right);
        make.right.equalTo(self.clickIntervalView.mas_right).offset(-7 * WIDTH_RATIO) ;
    }];
    
    [self.tapCountText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pressDurationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.clickIntervalText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark - 键盘
- (void)tableViewkeyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(keyboardEndFrame);
    CGFloat offset = 0;
    CGFloat textFieldHeight =  self.tapTextFieldFrame.origin.y;
    CGRect intersection = CGRectIntersection( self.tapTextFieldFrame, keyboardEndFrame);
    UIWindow *window = [UIApplication sharedApplication].delegate.window;;
    CGFloat screenHeight = window.bounds.size.height;
    if (!CGRectIsNull(intersection)) {
      offset = keyboardHeight - (screenHeight - textFieldHeight) + 40;
    }
    self.offsetY = offset;
    if (self.offsetY > 0) {
        [UIView animateWithDuration:0.25 animations:^{
          // 设置视图上移
          [GTFloatingWindowManager shareInstance].windowWindow.transform = CGAffineTransformMakeTranslation(0, -self.offsetY);
        }];
    }else{
      return ;
    }
}

- (void)tableViewWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        // 恢复视图位置
        [GTFloatingWindowManager shareInstance].windowWindow.transform = CGAffineTransformIdentity;
    }];
}


#pragma mark - method
-(void)enterDeleteMode{
    [self.sortButton removeFromSuperview];
    [self.fBGView addSubview:self.deletePointButton];
    [self.deletePointButton setEnlargeEdgeWithTop:3 right:3 bottom:3 left:3];
    [self.deletePointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fBGView.mas_centerY);
        make.left.equalTo(self.clickIntervalView.mas_right).offset(6* WIDTH_RATIO);
        make.width.height.equalTo(@(17* WIDTH_RATIO));
    }];
    self.tapCountText.userInteractionEnabled = NO;
    self.pressDurationText.userInteractionEnabled = NO;
    self.clickIntervalText.userInteractionEnabled = NO;
}

-(void)quitDeleteMode{
    [self.deletePointButton removeFromSuperview];
    [self.fBGView addSubview:self.sortButton];
    [self.sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fBGView.mas_centerY);
        make.left.equalTo(self.clickIntervalView.mas_right).offset(6* WIDTH_RATIO);
        make.width.height.equalTo(@(17* WIDTH_RATIO));
    }];
    self.tapCountText.userInteractionEnabled = YES;
    self.pressDurationText.userInteractionEnabled = YES;
    self.clickIntervalText.userInteractionEnabled = YES;
}

- (void)updateWithData:(GTClickerActionModel *)model compareArray:(GTClickerActionModel *)compare{
    self.compareAction = compare;
    self.modelAction = model;
    self.tapCountText.text = [NSString stringWithFormat:@"%d",  model.tapCount];
    self.pressDurationText.text = [NSString stringWithFormat:@"%d",model.pressDuration];
    self.clickIntervalText.text =[NSString stringWithFormat:@"%d",model.clickInterval];
    self.rowNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.indexPath.row+1];
    [self textFieldDidChange:self.tapCountText];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    //输入文本框的键盘抬起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewkeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UIView *view = [GTSDKUtils getTopWindow].view;
    self.tapTextFieldFrame = [textField convertRect:textField.bounds toView:view];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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

- (void)textFieldDidChange:(UITextField *)textField {
    if(self.row>self.DataArray.count){
        [self.delegate textFieldDidChangeInCell:YES];
    }else{
        if (![self.tapCountText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.compareAction.tapCount]]|| ![self.pressDurationText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.compareAction.pressDuration]] || ![self.clickIntervalText.text isEqualToString:[NSString stringWithFormat:@"%d", self.compareAction.clickInterval]])
        {
            [self.delegate cellDidFinishEditingWithData:self.modelAction indexPath:self.indexPath];
            [self.delegate textFieldDidChangeInCell:YES];
        }else{
            [self.delegate textFieldDidChangeInCell:NO];
        }
    }
    if ([self.tapCountText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.compareAction.tapCount]]){
        self.tapCountText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    }else{
        self.tapCountText.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    }
    if( [self.pressDurationText.text isEqualToString:[NSString stringWithFormat:@"%d",  self.compareAction.pressDuration]] ){
        self.pressDurationText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    }else{
        self.pressDurationText.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    }
    if([self.clickIntervalText.text isEqualToString:[NSString stringWithFormat:@"%d", self.compareAction.clickInterval]]){
        self.clickIntervalText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    }else{
        self.clickIntervalText.textColor = [GTThemeManager share].colorModel.dialog_title_color;
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -response
-(void)sortButtonClicked:(id)sender{
}

-(void)deletePointClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(deleteButtonClickedInCell:)]) {
        [self.delegate deleteButtonClickedInCell:self.indexPath];
    }
}

#pragma mark -setter & getter
- (GTBaseView *)fBGView {
    if (!_fBGView) {
        _fBGView = [GTBaseView new];
        _fBGView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    }
    return _fBGView;
}

- (UIView *)tapCountView {
    if (!_tapCountView) {
        _tapCountView = [UIView new];
        _tapCountView.backgroundColor = [GTThemeManager share].colorModel.clicker_pointset_cell_color;
        _tapCountView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _tapCountView.layer.masksToBounds = YES;
    }
    return _tapCountView;
}

- (UIView *)pressDurationView{
    if (!_pressDurationView) {
        _pressDurationView = [UIView new];
        _pressDurationView.backgroundColor = [GTThemeManager share].colorModel.clicker_pointset_cell_color;
        
        _pressDurationView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _pressDurationView.layer.masksToBounds = YES;
    }
    return _pressDurationView;
}

- (UIView *)clickIntervalView {
    if (!_clickIntervalView) {
        _clickIntervalView = [UIView new];
        _clickIntervalView.backgroundColor = [GTThemeManager share].colorModel.clicker_pointset_cell_color;
        _clickIntervalView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _clickIntervalView.layer.masksToBounds = YES;
    }
    return _clickIntervalView;
}

-(UITextField *)tapCountText{
    if(!_tapCountText){
        _tapCountText = [UITextField new];
        _tapCountText.text = localString(@"1");
        _tapCountText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _tapCountText.textAlignment = NSTextAlignmentCenter;
        _tapCountText.font = [UIFont systemFontOfSize:11*WIDTH_RATIO];
        _tapCountText.delegate = self;
    }
    return _tapCountText;
}

-(UITextField *)pressDurationText{
    if(!_pressDurationText){
        _pressDurationText = [UITextField new];
        _pressDurationText.text = localString(@"80");
        _pressDurationText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _pressDurationText.textAlignment = NSTextAlignmentCenter;
        _pressDurationText.font = [UIFont systemFontOfSize:11*WIDTH_RATIO];
        _pressDurationText.delegate = self;
    }
    return _pressDurationText;
}

-(UITextField *)clickIntervalText{
    if(!_clickIntervalText){
        _clickIntervalText = [UITextField new];
        _clickIntervalText.text = localString(@"1000");
        _clickIntervalText.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _clickIntervalText.textAlignment = NSTextAlignmentCenter;
        _clickIntervalText.font = [UIFont systemFontOfSize:11*WIDTH_RATIO];
        _clickIntervalText.delegate = self;
    }
    return _clickIntervalText;
}

-(UILabel*)tapCountLabel{
    if(!_tapCountLabel){
        _tapCountLabel = [UILabel new];
        _tapCountLabel.text = localString(@"次");
        _tapCountLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _tapCountLabel.font = [UIFont systemFontOfSize:11*WIDTH_RATIO];
    }
    return _tapCountLabel;
}

-(UILabel*)pressDurationLabel{
    if(!_pressDurationLabel){
        _pressDurationLabel = [UILabel new];
        _pressDurationLabel.text = localString(@"毫秒");
        _pressDurationLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _pressDurationLabel.font = [UIFont systemFontOfSize:11*WIDTH_RATIO];
    }
    return _pressDurationLabel;
}

-(UILabel*)clickIntervalLabel{
    if(!_clickIntervalLabel){
        _clickIntervalLabel = [UILabel new];
        _clickIntervalLabel.text = localString(@"毫秒");
        _clickIntervalLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _clickIntervalLabel.font = [UIFont systemFontOfSize:11*WIDTH_RATIO];
    }
    return _clickIntervalLabel;
}
- (UIButton *)sortButton {
    if (!_sortButton) {
        _sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortButton setImage:[[GTThemeManager share] imageWithName:@"clicker_pointset_sort"] forState:UIControlStateNormal];
        _sortButton.adjustsImageWhenHighlighted = NO;
        [_sortButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortButton;
}

-(UILabel *)rowNumberLabel{
    if(!_rowNumberLabel){
        _rowNumberLabel = [UILabel new];
        _rowNumberLabel.font = [UIFont systemFontOfSize:14*WIDTH_RATIO];
        _rowNumberLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _rowNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rowNumberLabel;
}

- (UIButton *)deletePointButton {
    if (!_deletePointButton) {
        _deletePointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletePointButton setImage:[[GTThemeManager share] imageWithName:@"clicker_deletePoint_delete"] forState:UIControlStateNormal];
        [_deletePointButton addTarget:self action:@selector(deletePointClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deletePointButton setEnlargeEdgeWithTop:6 right:6 bottom:6 left:6];
    }
    return _deletePointButton;
}
@end
