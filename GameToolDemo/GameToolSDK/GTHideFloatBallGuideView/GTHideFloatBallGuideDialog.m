//
//  GTHideFloatBallGuideDialog.m
//  GTSDK
//
//  Created by smwl_dxl on 2023/7/6.
//

#import "GTHideFloatBallGuideDialog.h"
#import "GTDialogWindowManager.h"

@interface GTHideFloatBallGuideDialog ()

@property (nonatomic, copy) NSString * descText;
@property (nonatomic, copy) UIView * bgView;
@property (nonatomic, strong) UIImageView * contentImage;
@property (nonatomic, strong) UILabel * descLabel;
/*
 确认按钮
 */
@property (nonatomic, strong) UIButton * confirmButton;
/*
 取消按钮
 */
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UIButton * checkButton;
@property (nonatomic, strong) UILabel * tipLabel;
@end

@implementation GTHideFloatBallGuideDialog

- (instancetype)initWithDescText:(nonnull NSString *)descText confirm:(nullable ConfirmButtonBlock)confirmButtonBlock cancel:(nullable CancelButtonBlock)cancelButtonBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self removeFromSuperview];
        [self removeAllSubviews];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.6];
        self.confirmButtonBlock = confirmButtonBlock;
        self.cancelButtonBlock = cancelButtonBlock;
        self.descText = [descText copy];
        
        [self initSubview];
        [self setLayout];
    }
    return self;
}
- (void)initSubview {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.contentImage];
    [self.bgView addSubview:self.descLabel];
    [self.bgView addSubview:self.confirmButton];
    [self.bgView addSubview:self.cancelBtn];
    [self.bgView addSubview:self.checkButton];
    [self.bgView addSubview:self.tipLabel];
}
-(void)setLayout {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(310 * WIDTH_RATIO);
        make.height.mas_equalTo(248 * WIDTH_RATIO);
    }];
    
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35 * WIDTH_RATIO);
        make.centerX.mas_equalTo(0);
        make.width.mas_offset(181 * WIDTH_RATIO);
        make.height.mas_offset(69 * WIDTH_RATIO);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(122 * WIDTH_RATIO);
        make.left.right.mas_equalTo(0);
        make.height.mas_offset(16 * WIDTH_RATIO);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20 * WIDTH_RATIO);
        make.left.mas_equalTo(24 * WIDTH_RATIO);
        make.width.mas_offset(126 * WIDTH_RATIO);
        make.height.mas_offset(42 * WIDTH_RATIO);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20 * WIDTH_RATIO);
        make.right.mas_equalTo(-24 * WIDTH_RATIO);
        make.width.mas_offset(126 * WIDTH_RATIO);
        make.height.mas_offset(42 * WIDTH_RATIO);
    }];
    
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(110 * WIDTH_RATIO);
        make.top.equalTo(self.descLabel.mas_bottom).offset(12 * WIDTH_RATIO);
        make.width.mas_equalTo(14 * WIDTH_RATIO);
        make.height.mas_equalTo(14 * WIDTH_RATIO);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkButton.mas_right).offset(4 * WIDTH_RATIO);
        make.centerY.equalTo(self.checkButton.mas_centerY);
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
-(UIImageView *)contentImage {
    if (!_contentImage) {
        _contentImage = [UIImageView new];
        _contentImage.image = [[GTThemeManager share] imageWithName:@"img_hide_floatball_tips"];
    }
    return _contentImage;
}
-(UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [UILabel new];
        _descLabel.text = self.descText;
        _descLabel.textColor = [UIColor hexColor:@"#112640"];
        _descLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}
-(UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton new];
        [_confirmButton setTitle:localString(@"确认") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        _confirmButton.layer.cornerRadius = 12 * WIDTH_RATIO;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.backgroundColor = [UIColor colorWithHexString:@"#3391ff"];
        [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setTitle:localString(@"取消") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#3E4956"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
        _cancelBtn.layer.cornerRadius = 12 * WIDTH_RATIO;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.backgroundColor = [UIColor hexColor:@"#112640" withAlpha:0.05];
        [_cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setImage:[[GTThemeManager share] imageWithName:@"window_check_btn_normal"] forState:UIControlStateNormal];
        _checkButton.selected = NO;
        [_checkButton setImage:[[GTThemeManager share] imageWithName:@"window_check_btn_selected"] forState:UIControlStateSelected];
        [_checkButton addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = @"下次不再弹出";
        _tipLabel.textColor = [UIColor hexColor:@"#112640"];
        _tipLabel.font = [UIFont systemFontOfSize:12 * WIDTH_RATIO];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
- (void)checkClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}
- (void)cancelClick:(UIButton *)sender {
    if (self.cancelButtonBlock) {
        self.cancelButtonBlock();
    }
    [self removeFromSuperview];
    [[GTDialogWindowManager shareInstance] dialogWindowHide];
    
    [self setHideFloatBallTipsNum];
}
- (void)confirmClick:(UIButton *)sender {
    if (self.confirmButtonBlock) {
        self.confirmButtonBlock();
    }
    [[[GTDialogWindowManager shareInstance] dialogWindow] setHidden:YES];
    [[[GTDialogWindowManager shareInstance] dialogWindow] removeFromSuperview];
    
    [self setHideFloatBallTipsNum];
}
-(void)setHideFloatBallTipsNum {
    if (self.checkButton.isSelected) { //如果勾选了下次不再弹出，则直接记作三次
        [GTSDKUtils saveFloatBallHideWindowShowTimes:3];
    }else {
        int num = [GTSDKUtils getFloatBallHideWindowShowTimes];
        [GTSDKUtils saveFloatBallHideWindowShowTimes:num+1];
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
