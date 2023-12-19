//
//  GTRecordPointSetPlanView.m
//  GTSDK
//
//  Created by smwl on 2023/11/2.
//

#import "GTRecordPointSetPlanView.h"
@interface GTRecordPointSetPlanView () <UIScrollViewDelegate>

@end

@implementation GTRecordPointSetPlanView

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];

//    self.backgroundColor = [GTThemeManager share].colorModel.clicker_pointSetView_bg_color;
    self.pointSetPlanScrollView.backgroundColor = [GTThemeManager share].colorModel.clicker_pointSetView_bg_color;
    self.planNameLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.planTextBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    self.planNameTextField.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    self.planNameTextField.textColor = [GTThemeManager share].colorModel.textColor;
    self.countLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    
    
    self.loopNumberLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.loopButtonBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    self.loopTextBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    self.loopNumberTextField.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    self.loopNumberTextField.textColor = [GTThemeManager share].colorModel.textColor;
    self.numberLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    
    [self loopViewInit:self.fincycleIndex];
    self.loopIntervalLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.loopIntervalTextField.textColor = [GTThemeManager share].colorModel.textColor;
    self.loopIntervalTextField.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    self.loopIntervalBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    
    self.millSecondLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
    [self.loopTipButton setImage:[[GTThemeManager share] imageWithName:@"clicker_prompt_icon"] forState:UIControlStateNormal];
    self.loopTipLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.loopTipAngle.image = [[GTThemeManager share] imageWithName:@"gt_triangle_icon"];
    self.loopTipView.backgroundColor = [GTThemeManager share].colorModel.clicker_settipView_color;
    self.loopTipView.layer.borderColor = [GTThemeManager share].colorModel.clicker_tipborder_gray_color.CGColor;
    self.startTypeLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
    self.typeBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    [self StartTypeInit];
    self.setTimeBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    self.timeHour.textColor = [GTThemeManager share].colorModel.textColor;
    self.timeMinute.textColor = [GTThemeManager share].colorModel.textColor;
    self.timeSecond.textColor = [GTThemeManager share].colorModel.textColor;
    self.colonLabel.textColor = [GTThemeManager share].colorModel.textColor;
    self.colonLabel2.textColor = [GTThemeManager share].colorModel.textColor;
    
    [self.planClearButton setImage:[[GTThemeManager share] imageWithName:@"clicker_text_delete_icon"] forState:UIControlStateNormal];
    [self.loopNumberClearButton setImage:[[GTThemeManager share] imageWithName:@"clicker_text_delete_icon"] forState:UIControlStateNormal];
    [self.loopIntervalClearButton setImage:[[GTThemeManager share] imageWithName:@"clicker_text_delete_icon"] forState:UIControlStateNormal];
    
    self.planNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入方案名称～"
        attributes:@{NSForegroundColorAttributeName: [GTThemeManager share].colorModel.clicker_placeholder_color}];
    self.loopNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入方案循环次数～"
        attributes:@{NSForegroundColorAttributeName: [GTThemeManager share].colorModel.clicker_placeholder_color}];
    self.loopIntervalTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入方案循环间隔～"
        attributes:@{NSForegroundColorAttributeName: [GTThemeManager share].colorModel.clicker_placeholder_color}];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GTThemeManager share].colorModel.clicker_pointSetView_bg_color;
        [self addSubview:self.pointSetPlanScrollView];
        [self.pointSetPlanScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        self.model = [GTClickerSchemeModel new];
        self.model = [GTRecordWindowManager shareInstance].schemeModel;
        [self setUpPlan];
        [self setUpLoop];
        [self setUpInterval];
        [self setUpStart];
        self.selectedButtonIndex = (int)self.model.startMethod;
        self.isSelectedType = (int)self.model.startMethod;
        self.oldSelected = (int)self.model.startMethod;
        
        self.startTimeCompare = self.model.startTime;
        self.cycleIndex = self.model.cycleIndex;
        self.cycleInterval = self.model.cycleInterval;
        [self loopViewInit:self.model.cycleIndex];
        [self StartTypeInit];
        self.isAddDeleted = NO;
        if(self.model.cycleIndex){
            CGFloat contentHeight = self.pointSetPlanScrollView.contentSize.height;
            contentHeight += 45 * WIDTH_RATIO;
            self.pointSetPlanScrollView.contentSize = CGSizeMake(self.pointSetPlanScrollView.contentSize.width, contentHeight);
            [self addLoopTextField];
        }
        if(self.model.startMethod){
            [self addTime];
            CGFloat contentHeight = self.pointSetPlanScrollView.contentSize.height;
            contentHeight += 45 * WIDTH_RATIO;
            self.pointSetPlanScrollView.contentSize = CGSizeMake(self.pointSetPlanScrollView.contentSize.width, contentHeight);
        }
    }
    [self textFieldDidChange:self.timeMinute];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlanKeyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlanKeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return self;
}

-(void)setUpPlan{
    [self.pointSetPlanScrollView addSubview:self.planNameLabel];
    [self.planNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointSetPlanScrollView.mas_top);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(20* WIDTH_RATIO);
        make.width.equalTo(@(55 * WIDTH_RATIO));
        make.height.equalTo(@(17 * WIDTH_RATIO));
    }];
    
    [self.pointSetPlanScrollView addSubview:self.planTextBackGround];
    [self.planTextBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.planNameLabel.mas_bottom).offset(6 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(20 * WIDTH_RATIO);
        make.width.equalTo(@(270 * WIDTH_RATIO));
        make.height.equalTo(@(40 * WIDTH_RATIO));
    }];
    
    [self.planTextBackGround addSubview:self.planNameTextField];
    [self.planNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.planNameLabel.mas_bottom).offset(6 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(32 * WIDTH_RATIO);
        make.width.equalTo(@(200 * WIDTH_RATIO));
        make.height.equalTo(@(40 * WIDTH_RATIO));
    }];
    
    [self.planTextBackGround addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.planTextBackGround.mas_centerY);
        make.right.equalTo(self.planTextBackGround.mas_right).offset(-12* WIDTH_RATIO);
        make.width.equalTo(@(33* WIDTH_RATIO));
        make.height.equalTo(@(20* WIDTH_RATIO));
    }];
}

-(void)setUpLoop{
    [self.pointSetPlanScrollView addSubview:self.loopNumberLabel];
    [self.loopNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.planTextBackGround.mas_bottom).offset(14 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(20 * WIDTH_RATIO);
        make.width.equalTo(@(70 * WIDTH_RATIO));
        make.height.equalTo(@(18 * WIDTH_RATIO));
    }];
    
    [self.pointSetPlanScrollView addSubview:self.loopButtonBackGround];
    [self.loopButtonBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopNumberLabel.mas_bottom).offset(6 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(20 * WIDTH_RATIO);
        make.width.equalTo(@(92 * WIDTH_RATIO));
        make.height.equalTo(@(32 * WIDTH_RATIO));
    }];
    
    if(self.model.cycleIndex == 0){
        [self.loopButtonBackGround addSubview:self.blueButtonView];
        [self.blueButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loopButtonBackGround.mas_top).offset(4 * WIDTH_RATIO);
            make.left.equalTo(self.loopButtonBackGround.mas_left).offset(4 * WIDTH_RATIO);
            make.right.equalTo(self.loopButtonBackGround.mas_centerX);
            make.bottom.equalTo(self.loopButtonBackGround.mas_bottom).offset(-4 * WIDTH_RATIO);
        }];
    }else{
        [self.loopButtonBackGround addSubview:self.blueButtonView];
        [self.blueButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loopButtonBackGround.mas_top).offset(4 * WIDTH_RATIO);
            make.right.equalTo(self.loopButtonBackGround.mas_right).offset(-4 * WIDTH_RATIO);
            make.left.equalTo(self.loopButtonBackGround.mas_centerX);
            make.bottom.equalTo(self.loopButtonBackGround.mas_bottom).offset(-4 * WIDTH_RATIO);
        }];
    }

    [self.loopButtonBackGround addSubview:self.unlimitedNumberButton];
    [self.unlimitedNumberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopButtonBackGround.mas_top).offset(4 * WIDTH_RATIO);
        make.left.equalTo(self.loopButtonBackGround.mas_left).offset(4 * WIDTH_RATIO);
        make.right.equalTo(self.loopButtonBackGround.mas_centerX);
        make.bottom.equalTo(self.loopButtonBackGround.mas_bottom).offset(-4 * WIDTH_RATIO);
    }];
    
    [self.loopButtonBackGround addSubview:self.limitedNumberButton];
    [self.limitedNumberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopButtonBackGround.mas_top).offset(4 * WIDTH_RATIO);
        make.right.equalTo(self.loopButtonBackGround.mas_right).offset(-4 * WIDTH_RATIO);
        make.left.equalTo(self.loopButtonBackGround.mas_centerX);
        make.bottom.equalTo(self.loopButtonBackGround.mas_bottom).offset(-4 * WIDTH_RATIO);
    }];
    [self addLoopTextField];
}

-(void)setUpInterval{
    [self.pointSetPlanScrollView addSubview:self.loopIntervalLabel];
    [self.loopIntervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopButtonBackGround.mas_bottom).offset(14 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(20 * WIDTH_RATIO);
        make.width.equalTo(@(50 * WIDTH_RATIO));
        make.height.equalTo(@(17 * WIDTH_RATIO));
    }];
    
    [self.pointSetPlanScrollView addSubview:self.loopTipButton];
    [self.loopTipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loopIntervalLabel.mas_centerY);
        make.left.equalTo(self.loopIntervalLabel.mas_right);
        make.width.height.equalTo(@(15 * WIDTH_RATIO));
    }];
    
    [self.pointSetPlanScrollView addSubview:self.loopIntervalBackGround];
    [self.loopIntervalBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopIntervalLabel.mas_bottom).offset(6 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(20 * WIDTH_RATIO);
        make.width.equalTo(@(270 * WIDTH_RATIO));
        make.height.equalTo(@(40 * WIDTH_RATIO));
    }];
    
    [self.loopIntervalBackGround addSubview:self.loopIntervalTextField];
    [self.loopIntervalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopIntervalLabel.mas_bottom).offset(6 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(32 * WIDTH_RATIO);
        make.width.equalTo(@(200 * WIDTH_RATIO));
        make.height.equalTo(@(40 * WIDTH_RATIO));
    }];
    [self.loopIntervalBackGround addSubview:self.millSecondLabel];
    [self.millSecondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loopIntervalBackGround.mas_centerY);
        make.right.equalTo(self.loopIntervalBackGround.mas_right).offset(-12 * WIDTH_RATIO);
        make.width.equalTo(@(13 * WIDTH_RATIO));
        make.height.equalTo(@(18 * WIDTH_RATIO));
    }];
}

-(void)setUpStart{
    [self.pointSetPlanScrollView addSubview:self.startTypeLabel];
    [self.startTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopIntervalBackGround.mas_bottom).offset(14 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(20 * WIDTH_RATIO);
        make.width.equalTo(@(55 * WIDTH_RATIO));
        make.height.equalTo(@(17 * WIDTH_RATIO));
    }];
    
    [self.pointSetPlanScrollView addSubview:self.typeBackGround];
    [self.typeBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startTypeLabel.mas_bottom).offset(5 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(20 * WIDTH_RATIO);
        make.width.equalTo(@(146 * WIDTH_RATIO));
        make.height.equalTo(@(32 * WIDTH_RATIO));
    }];
    
    [self.typeBackGround addSubview:self.nowTimeButton];
    [self.nowTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeBackGround.mas_top).offset(4 * WIDTH_RATIO);
        make.left.equalTo(self.typeBackGround.mas_left).offset(4 * WIDTH_RATIO);
        make.bottom.equalTo(self.typeBackGround.mas_bottom).offset(-4 * WIDTH_RATIO);
        make.width.equalTo(@(42 * WIDTH_RATIO));
    }];
    
    [self.typeBackGround addSubview:self.setTimeButton];
    [self.setTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeBackGround.mas_top).offset(4 * WIDTH_RATIO);
        make.left.equalTo(self.nowTimeButton.mas_right);
        make.bottom.equalTo(self.typeBackGround.mas_bottom).offset(-4 * WIDTH_RATIO);
        make.width.equalTo(@(42 * WIDTH_RATIO));
    }];
    
    [self.typeBackGround addSubview:self.countDownButton];
    [self.countDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeBackGround.mas_top).offset(4 * WIDTH_RATIO);
        make.left.equalTo(self.setTimeButton.mas_right);
        make.bottom.equalTo(self.typeBackGround.mas_bottom).offset(-4 * WIDTH_RATIO);
        make.right.equalTo(self.typeBackGround.mas_right).offset(-4 * WIDTH_RATIO);
    }];
}

-(CGFloat) calculateStringLength:(NSString *) str{
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

#pragma mark -键盘通知
- (void)setPlanKeyBoardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(keyboardEndFrame);

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat screenHeight = window.bounds.size.height;
    CGFloat textFieldHeight = 0;
    CGRect textFieldFrame;
    CGFloat offset = 0;
    
    //获取视图的位置
    if ([self.planNameTextField isFirstResponder]) {
        textFieldFrame = [self.planNameTextField convertRect:self.timeHour.bounds toView:window];
        textFieldHeight = textFieldFrame.origin.y;
    }else if ([self.loopIntervalTextField isFirstResponder]){
        textFieldFrame = [self.loopIntervalTextField convertRect:self.loopIntervalTextField.bounds toView:window];
        textFieldHeight = textFieldFrame.origin.y;
    }else if ([self.loopNumberTextField isFirstResponder]){
        textFieldFrame = [self.loopNumberTextField convertRect:self.loopNumberTextField.bounds toView:window];
        textFieldHeight = textFieldFrame.origin.y;
    }else if([self.timeHour isFirstResponder] || [self.timeMinute isFirstResponder]||[self.timeSecond isFirstResponder]){
        
        textFieldFrame = [self.timeHour convertRect:self.timeHour.bounds toView:window];
        textFieldHeight = textFieldFrame.origin.y;
    }else {
        textFieldFrame = CGRectZero;
        textFieldHeight = textFieldFrame.origin.y;
    }
    
    //对比位置是否被遮挡
    CGRect intersection = CGRectIntersection(textFieldFrame, keyboardEndFrame);
    if (!CGRectIsNull(intersection)) {
        offset = keyboardHeight - (screenHeight - textFieldHeight) + 40;
    }
    self.offsetY = offset;
    if (self.offsetY > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            // 设置视图上移
            [GTFloatingWindowManager shareInstance].windowWindow.transform = CGAffineTransformMakeTranslation(0, -self.offsetY);
        }];
    }
    
    self.closeKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard:)];
    [self.pointSetPlanScrollView addGestureRecognizer:self.closeKeyBoard];
    
}

- (void)closeKeyBoard:(UITapGestureRecognizer *)sender {
    [self.pointSetPlanScrollView endEditing:YES];
}

- (void)setPlanKeyBoardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        // 恢复视图位置
        [GTFloatingWindowManager shareInstance].windowWindow.transform = CGAffineTransformIdentity;
    }];
    [self.pointSetPlanScrollView removeGestureRecognizer:self.closeKeyBoard];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark -TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //键盘弹起太慢，光标移动有一个闪烁的延迟，先设为透明，再设为蓝色。
//    textField.tintColor = [UIColor clearColor];
    if (textField == self.timeHour || textField == self.timeMinute || textField == self.timeSecond) {
        //必须等键盘弹起，再进行光标的移动，默认键盘弹起，会改变光标。
        dispatch_async(dispatch_get_main_queue(), ^{
            UITextPosition *endPosition = [textField endOfDocument];
            textField.selectedTextRange = [textField textRangeFromPosition:endPosition toPosition:endPosition];
            textField.tintColor = [UIColor colorWithRed:0.12 green:0.53 blue:0.90 alpha:1.0];
        });
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.isAddDeleted = YES;
    //设置清除按钮
    if(textField == self.planNameTextField){
        NSString *text = self.planNameTextField.text;
        if (text.length > 0) {
                [self.planTextBackGround addSubview:self.planClearButton];
                [self.planClearButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.countLabel.mas_centerY);
                    make.right.equalTo(self.countLabel.mas_left).offset(-5);
                    make.height.width.equalTo(@(20));
                }];
        }
    }else if(textField == self.loopNumberTextField){
        NSString *text = self.loopNumberTextField.text;
        if (text.length > 0) {
                [self.loopTextBackGround addSubview:self.loopNumberClearButton];
                [self.loopNumberClearButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.numberLabel.mas_centerY);
                    make.right.equalTo(self.numberLabel.mas_left).offset(-5);
                    make.height.width.equalTo(@(20));
                }];
        }
    }else if (textField == self.loopIntervalTextField){
        if ([self.loopIntervalTextField.text intValue]> 0) {
                [self.loopIntervalBackGround addSubview:self.loopIntervalClearButton];
                [self.loopIntervalClearButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.millSecondLabel.mas_centerY);
                    make.right.equalTo(self.millSecondLabel.mas_left).offset(-5);
                    make.height.width.equalTo(@(20));
                }];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    self.isAddDeleted = NO;
    if (self.planClearButton.superview) {
        [self.planClearButton removeFromSuperview];
    }
    if(self.loopNumberClearButton.superview){
        [self.loopNumberClearButton removeFromSuperview];
    }
    if(self.loopIntervalClearButton.superview){
        [self.loopIntervalClearButton removeFromSuperview];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    //方案名称比值
    if(textField == self.planNameTextField){
         GLfloat length = [self calculateStringLength:newText];
         NSInteger maxLength = 12;
         return length <= maxLength;
    }
    
    //设置时间
    if(textField == self.timeHour){
        if ([newText rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
            return NO;
        }
        NSInteger number = 0;
        if (newText.length > 0) {
            number = [newText integerValue];
            if (number > 23) {
               number = 23;
            }
        }
        textField.text = [NSString stringWithFormat:@"%02ld", number];
        [self textFieldDidChange:textField];
       return NO;
    }else if(textField == self.timeMinute){
       if ([newText rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
           return NO;
       }
       NSInteger number = 0;
       if (newText.length > 0) {
           number = [newText integerValue];
           if (number > 59) {
               number = 59;
           }
       }
        textField.text = [NSString stringWithFormat:@"%02ld", number];
        [self textFieldDidChange:textField];
       return NO;
    }else if(textField == self.timeSecond){
       if ([newText rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
           return NO;
       }
       NSInteger number = 0;
       if (newText.length > 0) {
           number = [newText integerValue];
           if (number > 59) {
               number = 59;
           }
       }
        textField.text = [NSString stringWithFormat:@"%02ld", number];
        [self textFieldDidChange:textField];
       return NO;
    }

    else if(textField == self.loopNumberTextField){
        if ([newText rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
            return NO;
        }
        
        if([newText isEqualToString:@"0"]){
            return  NO;
        }
        if(newText.length>3){//
            return NO;
        }
       // textField.text = [NSString stringWithFormat:@"%ld", number];
        return YES;
    }else if(textField == self.loopIntervalTextField){
        if ([newText rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
            return NO;
        }
        NSInteger number = [newText integerValue];
        if (number > 86400) {
            number = 86400;
        }
        textField.text = [NSString stringWithFormat:@"%ld", number];
        [self textFieldDidChange:textField];
        return NO;
    } else{
        if ([newText rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
            return NO;
        }
        return YES;
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    //添加文本删除按钮
    if(textField == self.planNameTextField){
        NSString *text = self.planNameTextField.text;
        if (text.length > 0 && !self.planClearButton.superview) {
            [self.planTextBackGround addSubview:self.planClearButton];
            [self.planClearButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.countLabel.mas_centerY);
                make.right.equalTo(self.countLabel.mas_left).offset(-5);
                make.height.width.equalTo(@(20));
            }];
        }else if(text.length == 0){
            [self.planClearButton removeFromSuperview];
        }
    }else if(textField == self.loopNumberTextField){
        NSString *text = self.loopNumberTextField.text;
        if (text.length > 0 && !self.loopNumberClearButton.superview && self.isAddDeleted) {
            [self.loopTextBackGround addSubview:self.loopNumberClearButton];
            [self.loopNumberClearButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.numberLabel.mas_centerY);
                make.right.equalTo(self.numberLabel.mas_left).offset(-5);
                make.height.width.equalTo(@(20));
            }];
        }else if(text.length == 0){
            [self.loopNumberClearButton removeFromSuperview];
                
        }
    }else if (textField == self.loopIntervalTextField){
        if ([self.loopIntervalTextField.text intValue]>0 && !self.loopIntervalClearButton.superview) {
            [self.loopIntervalBackGround addSubview:self.loopIntervalClearButton];
            [self.loopIntervalClearButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.millSecondLabel.mas_centerY);
                make.right.equalTo(self.millSecondLabel.mas_left).offset(-5);
                make.height.width.equalTo(@(20));
            }];
        }else if([self.loopIntervalTextField.text intValue] == 0){
            [self.loopIntervalClearButton removeFromSuperview];
        }
    }
    //计算时间
   self.startTime = [NSString stringWithFormat:@"%@:%@:%@", self.timeHour.text, self.timeMinute.text, self.timeSecond.text] ;
    
    //实时计算当前文本的长度
    NSString *text = self.planNameTextField.text;
    NSInteger length = [self calculateStringLength:text];
    NSInteger maxLength = 12;
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld", length, maxLength];
    
    //修改值后，传给model
    [GTRecordWindowManager shareInstance].schemeModel.name = self.planNameTextField.text;
    
    if(self.fincycleIndex){
        //有限循环次数
        [GTRecordWindowManager shareInstance].schemeModel.cycleIndex = [self.loopNumberTextField.text intValue];
    }else{
        [GTRecordWindowManager shareInstance].schemeModel.cycleIndex = 0;
    }
    
    //是否显示循环次数的文本框
    if(self.fincycleIndex == 1){
        self.loopTextBackGround.hidden = NO;
        [self.loopIntervalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loopButtonBackGround.mas_bottom).offset(60 * WIDTH_RATIO);
        }];
        [self layoutIfNeeded];
    }else{
        self.loopTextBackGround.hidden = YES;
    }
    
    //循环间隔
    [GTRecordWindowManager shareInstance].schemeModel.cycleInterval = [self.loopIntervalTextField.text intValue];
    [GTRecordWindowManager shareInstance].schemeModel.startTime = self.startTime;
    
    if (![[[GTRecordWindowManager shareInstance].schemeModel modelToJSONString] isEqualToString:[GTRecordWindowManager shareInstance].schemeJsonString])
    {
        [self.planDelegate textFieldDidChangeInCell:YES];
    }else{
        [self.planDelegate textFieldDidChangeInCell:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if(textField == self.timeHour||textField == self.timeMinute||textField == self.timeSecond){
        textField.text = @"00";
    }
    return YES;
}

#pragma mark -总循环次数的实现
- (void)loopViewInit:(int)value{
    if(value){
        self.isLimitedNumberSelected = YES;
        self.limitedNumberButton.backgroundColor = [UIColor  clearColor];
        self.unlimitedNumberButton.backgroundColor = [UIColor clearColor];
        [self.limitedNumberButton setTitleColor: [UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.unlimitedNumberButton setTitleColor: [GTThemeManager share].colorModel.clicker_pointSetplanbutton_color forState:UIControlStateNormal];
        [UIView animateWithDuration:0.12 animations:^{
            [self.blueButtonView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.loopButtonBackGround.mas_top).offset(4 * WIDTH_RATIO);
                make.right.equalTo(self.loopButtonBackGround.mas_right).offset(-4 * WIDTH_RATIO);
                make.left.equalTo(self.loopButtonBackGround.mas_centerX);
                make.bottom.equalTo(self.loopButtonBackGround.mas_bottom).offset(-4 * WIDTH_RATIO);
            }];
        }];
    }else{
        self.isLimitedNumberSelected = NO;
        self.unlimitedNumberButton.backgroundColor = [UIColor clearColor];
        self.limitedNumberButton.backgroundColor = [UIColor clearColor];
        [self.unlimitedNumberButton setTitleColor: [UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.limitedNumberButton setTitleColor: [GTThemeManager share].colorModel.clicker_pointSetplanbutton_color forState:UIControlStateNormal];
        [UIView animateWithDuration:0.12 animations:^{
            [self.blueButtonView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.loopButtonBackGround.mas_top).offset(4 * WIDTH_RATIO);
                make.left.equalTo(self.loopButtonBackGround.mas_left).offset(4 * WIDTH_RATIO);
                make.right.equalTo(self.loopButtonBackGround.mas_centerX);
                make.bottom.equalTo(self.loopButtonBackGround.mas_bottom).offset(-4 * WIDTH_RATIO);
            }];
        }];
        
    }
}

-(void)addLoopTextField {
    [self.pointSetPlanScrollView addSubview:self.loopTextBackGround];
    [self.loopTextBackGround addSubview:self.loopNumberTextField];
    [self.loopTextBackGround addSubview:self.numberLabel];
    [self.loopTextBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopButtonBackGround.mas_bottom).offset(6 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(20 * WIDTH_RATIO);
        make.width.equalTo(@(270 * WIDTH_RATIO));
        make.height.equalTo(@(40 * WIDTH_RATIO));
    }];
    [self.loopNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loopTextBackGround.mas_centerY);
        make.left.equalTo(self.loopTextBackGround.mas_left).offset(12 * WIDTH_RATIO);
        make.width.equalTo(@(200 * WIDTH_RATIO));
        make.height.equalTo(@(40 * WIDTH_RATIO));
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loopTextBackGround.mas_centerY);
        make.right.equalTo(self.loopTextBackGround.mas_right).offset(-12 * WIDTH_RATIO);
        make.width.equalTo(@(13 * WIDTH_RATIO));
        make.height.equalTo(@(28 * WIDTH_RATIO));
    }];
    self.loopTextBackGround.hidden = YES;
}

-(void)unlimitedNumberClicked{
    if(self.isLimitedNumberSelected){
        [GTRecordWindowManager shareInstance].schemeModel.cycleIndex = 0;
        self.fincycleIndex = 0;
        [self loopViewInit:self.fincycleIndex];
       
        [UIView animateWithDuration:0.12 animations:^{
            CGSize contentSize = self.pointSetPlanScrollView.contentSize;
            self.loopTextBackGround.hidden = YES;
            [self.loopIntervalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.loopButtonBackGround.mas_bottom).offset(14 * WIDTH_RATIO);
            }];
            contentSize.height -= 45 * WIDTH_RATIO;
            self.pointSetPlanScrollView.contentSize = contentSize;
            [self layoutIfNeeded];
        }];
        [self textFieldDidChange:self.loopNumberTextField];
    }
}

-(void)limitedNumberClicked{
    if(!self.isLimitedNumberSelected){
        self.loopTextBackGround.hidden = NO;
        if([self.loopNumberTextField.text intValue] == 0){
            [GTRecordWindowManager shareInstance].schemeModel.cycleIndex = 1;
            self.loopNumberTextField.text = @"1";
        }else{
            [GTRecordWindowManager shareInstance].schemeModel.cycleIndex = [self.loopNumberTextField.text intValue];
        }
        self.fincycleIndex = 1;
        [self loopViewInit:self.fincycleIndex];
        [UIView animateWithDuration:0.12 animations:^{
            CGSize contentSize = self.pointSetPlanScrollView.contentSize;
            contentSize.height += 45 * WIDTH_RATIO;
            self.pointSetPlanScrollView.contentSize = contentSize;
            // 设置偏移量并添加动画效果
            [self.loopIntervalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.loopButtonBackGround.mas_bottom).offset(60 * WIDTH_RATIO);
            }];
            [self layoutIfNeeded];
        }];
        [self textFieldDidChange:self.loopNumberTextField];
        
    }
}
#pragma mark -提示框
-(void)loopTipButtonClicked{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.loopTipBackGround = [[UIView alloc] initWithFrame:screenRect];
    self.loopTipBackGround.backgroundColor = [UIColor clearColor];

    UITapGestureRecognizer *tapBackgroundGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCustomView)];
    [self.loopTipBackGround addGestureRecognizer:tapBackgroundGesture];
    [[GTSDKUtils getTopWindow].view addSubview:self.loopTipBackGround];

    [self.loopTipBackGround addSubview:self.loopTipView];
    [self.loopTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loopTipButton.mas_top).offset(-8);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(10);
        make.width.equalTo(@(155 *WIDTH_RATIO));
        make.height.equalTo(@(35 *WIDTH_RATIO));
    }];
    [self.loopTipBackGround addSubview:self.loopTipLabel];

    [self.loopTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loopTipView .mas_bottom).offset(-9);
        make.top.equalTo(self.loopTipView .mas_top).offset(9);
        make.left.equalTo(self.loopTipView .mas_left).offset(10);
        make.right.equalTo(self.loopTipView .mas_right).offset(-10);
    }];

    [self.loopTipBackGround addSubview:self.loopTipAngle];
    [self.loopTipAngle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loopTipButton.mas_top).offset(-4);
        make.centerX.equalTo(self.loopTipButton.mas_centerX);
        make.width.equalTo(@(14));
        make.height.equalTo(@(5));
    }];
}

-(void)hideCustomView {
    [self.loopTipBackGround removeFromSuperview];
}

#pragma mark -StartTimeType的实现
//颜色变换
- (void)StartTypeInit{
    if(self.selectedButtonIndex == 0){
        self.nowTimeButton.backgroundColor = [GTThemeManager share].colorModel.clicker_selectedTextColor;
        self.setTimeButton.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        self.countDownButton.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        [self.nowTimeButton setTitleColor: [UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.setTimeButton setTitleColor: [GTThemeManager share].colorModel.clicker_pointSetplanbutton_color forState:UIControlStateNormal];
        [self.countDownButton setTitleColor: [GTThemeManager share].colorModel.clicker_pointSetplanbutton_color forState:UIControlStateNormal];
    }else if(self.selectedButtonIndex == 1){
        self.setTimeButton.backgroundColor = [GTThemeManager share].colorModel.clicker_selectedTextColor;
        self.nowTimeButton.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        self.countDownButton.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        
        [self.setTimeButton setTitleColor: [UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.nowTimeButton setTitleColor: [GTThemeManager share].colorModel.clicker_pointSetplanbutton_color forState:UIControlStateNormal];
        [self.countDownButton setTitleColor: [GTThemeManager share].colorModel.clicker_pointSetplanbutton_color forState:UIControlStateNormal];
    }else{
        self.countDownButton.backgroundColor = [GTThemeManager share].colorModel.clicker_selectedTextColor;
        self.setTimeButton.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        self.nowTimeButton.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        
        [self.countDownButton setTitleColor: [UIColor hexColor:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.setTimeButton setTitleColor: [GTThemeManager share].colorModel.clicker_pointSetplanbutton_color forState:UIControlStateNormal];
        [self.nowTimeButton setTitleColor: [GTThemeManager share].colorModel.clicker_pointSetplanbutton_color forState:UIControlStateNormal];
    }
}

//添加时间视图
- (void)addTime{
    [self.pointSetPlanScrollView addSubview:self.setTimeBackGround];
    [self.setTimeBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeBackGround.mas_bottom).offset(6 * WIDTH_RATIO);
        make.left.equalTo(self.pointSetPlanScrollView.mas_left).offset(20 * WIDTH_RATIO);
        make.width.equalTo(@(270 * WIDTH_RATIO));
        make.height.equalTo(@(40 * WIDTH_RATIO));
    }];
    [self.setTimeBackGround addSubview:self.timeHour];
    [self.setTimeBackGround addSubview:self.timeMinute];
    [self.setTimeBackGround addSubview:self.timeSecond];
    [self.setTimeBackGround addSubview:self.colonLabel];
    [self.setTimeBackGround addSubview:self.colonLabel2];
    [self.timeHour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.setTimeBackGround.mas_left).offset(50 * WIDTH_RATIO);
        make.centerY.equalTo(self.setTimeBackGround.mas_centerY);
        make.width.equalTo(@(50 * WIDTH_RATIO));
        make.height.equalTo(@(20 * WIDTH_RATIO));
    }];
    [self.timeMinute mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeHour.mas_right).offset(7 * WIDTH_RATIO);
        make.centerY.equalTo(self.setTimeBackGround.mas_centerY);
        make.width.equalTo(@(50 * WIDTH_RATIO));
        make.height.equalTo(@(20 * WIDTH_RATIO));
    }];
    [self.timeSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeMinute.mas_right).offset(7 * WIDTH_RATIO);
        make.centerY.equalTo(self.setTimeBackGround.mas_centerY);
        make.width.equalTo(@(50 * WIDTH_RATIO));
        make.height.equalTo(@(20 * WIDTH_RATIO));
    }];
    [self.colonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeHour.mas_right).offset(2);
        make.centerY.equalTo(self.setTimeBackGround.mas_centerY);
        make.width.equalTo(@(3 * WIDTH_RATIO));
        make.height.equalTo(@(20 * WIDTH_RATIO));
    }];
    [self.colonLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeMinute.mas_right).offset(2);
        make.centerY.equalTo(self.setTimeBackGround.mas_centerY);
        make.width.equalTo(@(3 * WIDTH_RATIO));
        make.height.equalTo(@(20 * WIDTH_RATIO));
    }];
}

//选择类型
- (void)TimeClicked:(UIButton *)button {
    int buttonIndex = (int)button.tag; // 按钮的tag分别为0、1、2
    if (buttonIndex == self.selectedButtonIndex) {
        return;
    }
    self.selectedButtonIndex = buttonIndex;
    switch (self.selectedButtonIndex) {
        case 0:{
            self.setTimeBackGround.hidden = YES;
            [self StartTypeInit];
            [GTRecordWindowManager shareInstance].schemeModel.startMethod = 0;
            self.timeHour.text = @"00";
            self.timeMinute.text = @"00";
            self.timeSecond.text = @"00";
            [self textFieldDidChange:self.timeHour];
            break;
        }
        case 1:{
            self.setTimeBackGround.hidden = NO;
            [self StartTypeInit];
            if(self.oldSelected != 1){
                self.timeHour.text = @"00";
                self.timeMinute.text = @"00";
                self.timeSecond.text = @"00";
            }else{
                self.timeHour.text = [self.startTimeCompare substringWithRange:NSMakeRange(0, 2)];
                self.timeMinute.text = [self.startTimeCompare substringWithRange:NSMakeRange(3, 2)];
                self.timeSecond.text = [self.startTimeCompare substringWithRange:NSMakeRange(6, 2)];
            }
            [self addTime];
            [GTRecordWindowManager shareInstance].schemeModel.startMethod = 1;
            [self textFieldDidChange:self.timeHour];
            
            break;
            }
        case 2:{
            self.setTimeBackGround.hidden = NO;
            [self StartTypeInit];
            if(self.oldSelected != 2){
                self.timeHour.text = @"00";
                self.timeMinute.text = @"00";
                self.timeSecond.text = @"10";
            }else{
                self.timeHour.text = [self.startTimeCompare substringWithRange:NSMakeRange(0, 2)];
                self.timeMinute.text = [self.startTimeCompare substringWithRange:NSMakeRange(3, 2)];
                self.timeSecond.text = [self.startTimeCompare substringWithRange:NSMakeRange(6, 2)];
            }
            [self addTime];
            [GTRecordWindowManager shareInstance].schemeModel.startMethod = 2;
            [self textFieldDidChange:self.timeHour];
            break;
            }
        default:
            break;
    }
   
    CGFloat contentHeight = self.pointSetPlanScrollView.contentSize.height;
    if (self.selectedButtonIndex == 0) {
        contentHeight -= 45;
        self.isSelectedType = 0;
    } else if( !(self.isSelectedType) && self.selectedButtonIndex != 0){
        contentHeight += 45;
        self.isSelectedType = 1;
        CGPoint newOffset = CGPointMake(self.pointSetPlanScrollView.contentOffset.x, self.pointSetPlanScrollView.contentOffset.y + 45);
        // 设置偏移量并添加动画效果
        [self.pointSetPlanScrollView setContentOffset:newOffset animated:YES];
    }
    self.pointSetPlanScrollView.contentSize = CGSizeMake(self.pointSetPlanScrollView.contentSize.width, contentHeight);

}

-(void) clearButtonClicked:(id)sender{
    if(sender == self.planClearButton){
        self.planNameTextField.text = @"";
        self.countLabel.text = [NSString stringWithFormat:@"%d/%d", 0, 12];
        [self textFieldDidChange:self.planNameTextField];
        if (self.planClearButton.superview) {
            [self.planClearButton removeFromSuperview];
        }
    }else if (sender == self.loopNumberClearButton){
        self.loopNumberTextField.text = @"";
        [self textFieldDidChange:self.loopNumberTextField];
        if(self.loopNumberClearButton.superview){
             [self.loopNumberClearButton removeFromSuperview];
        }
    }else if (sender == self.loopIntervalClearButton){
        self.loopIntervalTextField.text = @"0";
        [self textFieldDidChange:self.loopIntervalTextField];
        if(self.loopIntervalClearButton.superview){
             [self.loopIntervalClearButton removeFromSuperview];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditing:YES];
    scrollView.showsVerticalScrollIndicator = NO;
}

#pragma mark -setter&getter
- (UIScrollView *)pointSetPlanScrollView {
    if (!_pointSetPlanScrollView) {
        _pointSetPlanScrollView = [UIScrollView new];
        _pointSetPlanScrollView.backgroundColor = [GTThemeManager share].colorModel.clicker_pointSetView_bg_color;
        _pointSetPlanScrollView.delegate = self;
        _pointSetPlanScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _pointSetPlanScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), 292 * WIDTH_RATIO);
    }
    return _pointSetPlanScrollView;
}

/*
    方案名称
*/
-(UILabel*)planNameLabel{
    if(!_planNameLabel){
        _planNameLabel = [UILabel new];
        _planNameLabel.text = localString(@"方案名称");
        _planNameLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _planNameLabel.font = [UIFont systemFontOfSize:12 * WIDTH_RATIO];
    }
    return _planNameLabel;
}
-(UIView *)planTextBackGround{
    if(!_planTextBackGround){
        _planTextBackGround = [UIView new];
        _planTextBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _planTextBackGround.layer.cornerRadius = 10;
        _planTextBackGround.layer.masksToBounds = YES;
    }
    return _planTextBackGround;
}
-(UITextField *)planNameTextField{
    if(!_planNameTextField){
        _planNameTextField = [UITextField new];
        _planNameTextField.text = [self.model.name mutableCopy];
        _planNameTextField.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _planNameTextField.textColor = [GTThemeManager share].colorModel.textColor;
        _planNameTextField.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
        _planNameTextField.placeholder = @"请输入方案名称～";
        _planNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入方案名称～"
            attributes:@{NSForegroundColorAttributeName: [GTThemeManager share].colorModel.clicker_placeholder_color}];
        [_planNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _planNameTextField.delegate = self;
    }
    return _planNameTextField;
}
-(UILabel*)countLabel{
    if(!_countLabel){
        _countLabel = [UILabel new];
        _countLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
    }
    return _countLabel;
}

/*
    循环次数
*/
-(UILabel*)loopNumberLabel{
    if(!_loopNumberLabel){
        _loopNumberLabel = [UILabel new];
        _loopNumberLabel.text = localString(@"总循环次数");
        _loopNumberLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _loopNumberLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    }
    return _loopNumberLabel;
}

-(UIView *)loopButtonBackGround{
    if(!_loopButtonBackGround){
        _loopButtonBackGround = [UIView new];
        _loopButtonBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _loopButtonBackGround.layer.cornerRadius = 10;
        _loopButtonBackGround.layer.masksToBounds = YES;
    }
    return _loopButtonBackGround;
}

-(UIView *)loopTextBackGround{
    if(!_loopTextBackGround){
        _loopTextBackGround = [UIView new];
        _loopTextBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _loopTextBackGround.layer.cornerRadius = 10;
        _loopTextBackGround.layer.masksToBounds = YES;
    }
    return _loopTextBackGround;
}

- (UIButton *)unlimitedNumberButton {
    if (!_unlimitedNumberButton) {
        _unlimitedNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unlimitedNumberButton.selected = YES;
        [_unlimitedNumberButton setTitle:localString(@"无限") forState:UIControlStateNormal];
        _unlimitedNumberButton.titleLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
        _unlimitedNumberButton.layer.cornerRadius = 6 * WIDTH_RATIO;
        _unlimitedNumberButton.layer.masksToBounds = YES;
        [_unlimitedNumberButton addTarget:self action:@selector(unlimitedNumberClicked) forControlEvents:UIControlEventTouchUpInside];
        [_unlimitedNumberButton setEnlargeEdgeWithTop:10 right:0 bottom:6 left:10];
    }
    return _unlimitedNumberButton;
}

- (UIButton *)limitedNumberButton {
    if (!_limitedNumberButton) {
        _limitedNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_limitedNumberButton setTitle:localString(@"有限") forState:UIControlStateNormal];
        _limitedNumberButton.titleLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
        _limitedNumberButton.layer.cornerRadius = 6 * WIDTH_RATIO;
        _limitedNumberButton.layer.masksToBounds = YES;
        [_limitedNumberButton addTarget:self action:@selector(limitedNumberClicked) forControlEvents:UIControlEventTouchUpInside];
        [_limitedNumberButton setEnlargeEdgeWithTop:10 right:10 bottom:6 left:0];
    }
    return _limitedNumberButton;
}

-(UITextField *)loopNumberTextField{
    if(!_loopNumberTextField){
        _loopNumberTextField = [UITextField new];
        _loopNumberTextField.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        if(self.model.cycleIndex == 0)
        {
            _loopNumberTextField.text = localString(@"1");
        }else{
            _loopNumberTextField.text = [NSString stringWithFormat:@"%d", self.model.cycleIndex];
            self.fincycleIndex = 1;
        }
        _loopNumberTextField.textColor = [GTThemeManager share].colorModel.textColor;
        _loopNumberTextField.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
        _loopNumberTextField.placeholder = @"请输入方案循环次数～";
        _loopNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入方案循环次数～"
            attributes:@{NSForegroundColorAttributeName: [GTThemeManager share].colorModel.clicker_placeholder_color}];
        _loopNumberTextField.delegate = self;
        [_loopNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _loopNumberTextField;
}

-(UILabel*)numberLabel{
    if(!_numberLabel){
        _numberLabel = [UILabel new];
        _numberLabel.text = localString(@"次");
        _numberLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _numberLabel.textAlignment = NSTextAlignmentRight;
        _numberLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
    }
    return _numberLabel;
}

/*
    循环间隔
 */

-(UILabel*)loopIntervalLabel{
    if(!_loopIntervalLabel){
        _loopIntervalLabel = [UILabel new];
        _loopIntervalLabel.text = localString(@"循环间隔");
        _loopIntervalLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _loopIntervalLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    }
    return _loopIntervalLabel;
}

-(UIView *)loopIntervalBackGround{
    if(!_loopIntervalBackGround){
        _loopIntervalBackGround = [UIView new];
        _loopIntervalBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _loopIntervalBackGround.layer.cornerRadius = 10;
        _loopIntervalBackGround.layer.masksToBounds = YES;
    }
    return _loopIntervalBackGround;
}

-(UITextField *)loopIntervalTextField{
    if(!_loopIntervalTextField){
        _loopIntervalTextField = [UITextField new];
        _loopIntervalTextField.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _loopIntervalTextField.text = [NSString stringWithFormat:@"%d", self.model.cycleInterval];
        _loopIntervalTextField.textColor = [GTThemeManager share].colorModel.textColor;
        _loopIntervalTextField.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
        _loopIntervalTextField.placeholder = @"请输入方案循环间隔～";
        _loopIntervalTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入方案循环间隔～"
            attributes:@{NSForegroundColorAttributeName: [GTThemeManager share].colorModel.clicker_placeholder_color}];
        [_loopIntervalTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _loopIntervalTextField.delegate = self;

        
    }
    return _loopIntervalTextField;
}

-(UILabel*)millSecondLabel{
    if(!_millSecondLabel){
        _millSecondLabel = [UILabel new];
        _millSecondLabel.text = localString(@"秒");
        _millSecondLabel.textColor = [GTThemeManager share].colorModel.clicker_unselectedTextColor;
        _millSecondLabel.textAlignment = NSTextAlignmentRight;
        _millSecondLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
    }
    return _millSecondLabel;
}

- (UIButton *)loopTipButton {
    if (!_loopTipButton) {
        _loopTipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loopTipButton setImage:[[GTThemeManager share] imageWithName:@"clicker_prompt_icon"] forState:UIControlStateNormal];
        [_loopTipButton addTarget:self action:@selector(loopTipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_loopTipButton setEnlargeEdgeWithTop:3 right:3 bottom:3 left:3];
    }
    return _loopTipButton;
}

-(UILabel*)loopTipLabel{
    if(!_loopTipLabel){
        _loopTipLabel = [UILabel new];
        _loopTipLabel.text = localString(@"每次循环间隔的暂停时长");
        _loopTipLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _loopTipLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
        _loopTipLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _loopTipLabel;
}

-(UIImageView *)loopTipAngle{
    if(!_loopTipAngle){
        _loopTipAngle = [UIImageView new];
        _loopTipAngle.image = [[GTThemeManager share] imageWithName:@"gt_triangle_icon"];
    }
    return _loopTipAngle;
}

-(UIView *)loopTipView{
    if(!_loopTipView){
        _loopTipView = [UIView new];
        _loopTipView.backgroundColor = [GTThemeManager share].colorModel.clicker_settipView_color;
        _loopTipView.layer.cornerRadius = 10;
        _loopTipView.layer.shadowColor = [GTThemeManager share].colorModel.clicker_tipshadow_color.CGColor;
        _loopTipView.layer.shadowOffset = CGSizeMake(0,0);
        _loopTipView.layer.shadowOpacity = 1*WIDTH_RATIO;
        _loopTipView.layer.shadowRadius = 14*WIDTH_RATIO;
        _loopTipView.layer.borderColor = [GTThemeManager share].colorModel.clicker_tipborder_gray_color.CGColor;
        _loopTipView.layer.borderWidth = 0.5 ;
    }
    return _loopTipView;
}

-(UILabel*)startTypeLabel{
    if(!_startTypeLabel){
        _startTypeLabel = [UILabel new];
        _startTypeLabel.text = localString(@"启动方式");
        _startTypeLabel.textColor = [GTThemeManager share].colorModel.clicker_text_color;
        _startTypeLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
    }
    return _startTypeLabel;
}

-(UIView *)typeBackGround{
    if(!_typeBackGround){
        _typeBackGround = [UIView new];
        _typeBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _typeBackGround.layer.cornerRadius = 10;
        _typeBackGround.layer.masksToBounds = YES;
    }
    return _typeBackGround;
}

- (UIButton *)nowTimeButton {
    if (!_nowTimeButton) {
        _nowTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nowTimeButton.tag = 0;
        [_nowTimeButton setTitle:localString(@"立即") forState:UIControlStateNormal];
        _nowTimeButton.titleLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
        _nowTimeButton.layer.cornerRadius = 6 * WIDTH_RATIO;
        _nowTimeButton.layer.masksToBounds = YES;
        [_nowTimeButton addTarget:self action:@selector(TimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nowTimeButton;
}
- (UIButton *)setTimeButton {
    if (!_setTimeButton) {
        _setTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _setTimeButton.tag = 1;
        [_setTimeButton setTitle:localString(@"定时") forState:UIControlStateNormal];
       
        _setTimeButton.titleLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
       
        _setTimeButton.layer.cornerRadius = 6 * WIDTH_RATIO;
        _setTimeButton.layer.masksToBounds = YES;
        [_setTimeButton addTarget:self action:@selector(TimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setTimeButton;
}
- (UIButton *)countDownButton {
    if (!_countDownButton) {
        _countDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _countDownButton.tag = 2;
        [_countDownButton setTitle:localString(@"倒计时") forState:UIControlStateNormal];
        _countDownButton.titleLabel.font = [UIFont systemFontOfSize:12*WIDTH_RATIO];
       
        _countDownButton.layer.cornerRadius = 6 * WIDTH_RATIO;
        _countDownButton.layer.masksToBounds = YES;
        [_countDownButton addTarget:self action:@selector(TimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _countDownButton;
}

//定时

-(UIView *)setTimeBackGround{
    if(!_setTimeBackGround){
        _setTimeBackGround = [UIView new];
        _setTimeBackGround.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _setTimeBackGround.layer.cornerRadius = 10;
        _setTimeBackGround.layer.masksToBounds = YES;
    }
    return _setTimeBackGround;
}

-(UITextField *)timeHour{
    if(!_timeHour){
        _timeHour = [UITextField new];
        _timeHour.text = [self.model.startTime substringWithRange:NSMakeRange(0, 2)];
        _timeHour.textAlignment = NSTextAlignmentCenter;
        _timeHour.textColor = [GTThemeManager share].colorModel.textColor;
        _timeHour.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
        [_timeHour addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _timeHour.delegate = self;

    }
    return _timeHour;
}

-(UITextField *)timeMinute{
    if(!_timeMinute){
        _timeMinute = [UITextField new];
        
        _timeMinute.text = [self.model.startTime substringWithRange:NSMakeRange(3, 2)];
        _timeMinute.textAlignment = NSTextAlignmentCenter;
        //_timeMinute.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _timeMinute.textColor = [GTThemeManager share].colorModel.textColor;
        _timeMinute.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
        [_timeMinute addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _timeMinute.delegate = self;

    }
    return _timeMinute;
}

-(UITextField *)timeSecond{
    if(!_timeSecond){
        _timeSecond = [UITextField new];
        _timeSecond.textAlignment = NSTextAlignmentCenter;
        _timeSecond.text = [self.model.startTime substringWithRange:NSMakeRange(6, 2)];
        //_timeSecond.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _timeSecond.textColor = [GTThemeManager share].colorModel.textColor;
        _timeSecond.font = [UIFont systemFontOfSize:13 * WIDTH_RATIO];
        _timeSecond.delegate = self;
        [_timeSecond addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _timeSecond;
}

-(UILabel*)colonLabel{
    if(!_colonLabel){
        _colonLabel = [UILabel new];
        _colonLabel.text = localString(@":");
        _colonLabel.textColor = [GTThemeManager share].colorModel.textColor;
        _colonLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
        //_colonLabel.backgroundColor =  [GTThemeManager share].colorModel.set_main_box_bg_color;
    }
    return _colonLabel;
}
-(UILabel*)colonLabel2{
    if(!_colonLabel2){
        _colonLabel2 = [UILabel new];
        _colonLabel2.text = localString(@":");
        _colonLabel2.textColor = [GTThemeManager share].colorModel.textColor;
        _colonLabel2.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
        //_colonLabel2.backgroundColor =  [GTThemeManager share].colorModel.set_main_box_bg_color;
    }
    return _colonLabel2;
}

- (UIButton *)planClearButton {
    if (!_planClearButton) {
        _planClearButton = [UIButton new];
        [_planClearButton setBackgroundColor:[UIColor clearColor]];
        [_planClearButton setImage:[[GTThemeManager share] imageWithName:@"clicker_text_delete_icon"] forState:UIControlStateNormal];
        [_planClearButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _planClearButton;
}
- (UIButton *)loopNumberClearButton {
    if (!_loopNumberClearButton) {
        _loopNumberClearButton = [UIButton new];
        [_loopNumberClearButton setBackgroundColor:[UIColor clearColor]];
        [_loopNumberClearButton setImage:[[GTThemeManager share] imageWithName:@"clicker_text_delete_icon"] forState:UIControlStateNormal];
        [_loopNumberClearButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loopNumberClearButton;
}
- (UIButton *)loopIntervalClearButton {
    if (!_loopIntervalClearButton) {
        _loopIntervalClearButton = [UIButton new];
        [_loopIntervalClearButton setBackgroundColor:[UIColor clearColor]];
        [_loopIntervalClearButton setImage:[[GTThemeManager share] imageWithName:@"clicker_text_delete_icon"] forState:UIControlStateNormal];
        [_loopIntervalClearButton addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loopIntervalClearButton;
}

- (UIView *)blueButtonView {
    if (!_blueButtonView) {
        _blueButtonView = [UIView new];
       // _blueButtonView.backgroundColor  = [UIColor redColor];
        _blueButtonView.backgroundColor = [GTThemeManager share].colorModel.clicker_selectedTextColor;
        _blueButtonView.layer.cornerRadius = 6 * WIDTH_RATIO;
        _blueButtonView.layer.masksToBounds = YES;
       
    }
    return _blueButtonView;
}
-(GTClickerSchemeModel *)model{
    if(!_model){
        _model = [GTClickerSchemeModel defaultSchemeModel:0];
    }
    return _model;
}
@end
