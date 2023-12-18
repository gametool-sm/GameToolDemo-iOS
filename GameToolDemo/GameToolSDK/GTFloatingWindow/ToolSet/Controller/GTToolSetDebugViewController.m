//
//  GTToolSetDebugViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/7/19.
//

#import "GTToolSetDebugViewController.h"
#import "GTNetworkManager.h"
#import "GTDialogView.h"

@interface GTToolSetDebugViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIView *bbgView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation GTToolSetDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
}

- (void)setUp {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.leftButton];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.submitButton];
        
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(54 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];

    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(90 * WIDTH_RATIO);
        make.width.mas_equalTo(60 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
}

#pragma mark - response

- (void)backClick {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)submitClick {
    //处理debugToken
    if (!self.textField.text.length) {
        return;
    }
    [GTNetworkManager shareManager].debugDict = [NSString handleDebugToken:self.textField.text];
    [GTSDKUtils saveDebugToken:[GTNetworkManager shareManager].debugDict];
    GTDialogView *dialogView = [[GTDialogView alloc] initWithStyle:DialogViewStyleDefault
                                                             title:@"提示"
                                                           content:@"提交成功"
                                                   leftButtonTitle:@"取消"
                                                  rightButtonTitle:@"确认"
                                                   leftButtonBlock:^{
    }
                                                  rightButtonBlock:^{
    }];
    [[GTSDKUtils getTopWindow].view addSubview:dialogView];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"调试界面";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor hexColor:@"#112640"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15*WIDTH_RATIO];
    }
    return _titleLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[[GTThemeManager share] imageWithName:@"window_back_btn"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.placeholder = @"请输入";
    }
    return _textField;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.backgroundColor = [UIColor themeColor];
        [_submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
