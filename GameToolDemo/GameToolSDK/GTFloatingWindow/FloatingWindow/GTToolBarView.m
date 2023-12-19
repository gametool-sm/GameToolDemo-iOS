//
//  GTToolBarView.m
//  GTSDK
//
//  Created by shangmi on 2023/6/25.
//

#import "GTToolBarView.h"

@interface GTToolBarView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation GTToolBarView

#pragma mark - override

- (void)changeTheme:(NSNotification *)noti {
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.backButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
    
    if (self.selectedButton == self.speedUpButton) {
        self.speedUpButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_selected_btn_color;
        self.clickerButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        self.setButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
    }else if (self.selectedButton == self.clickerButton) {
        self.speedUpButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        self.clickerButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_selected_btn_color;
        self.setButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
    }else if (self.selectedButton == self.setButton) {
        self.speedUpButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        self.clickerButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        self.setButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_selected_btn_color;
    }
    
    if ([GTSDKUtils isPortrait]) {
        [self.backButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_back_btn_P"] forState:UIControlStateNormal];
    }else {
        [self.backButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_back_btn_H"] forState:UIControlStateNormal];
    }
    
    [self.speedUpButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_speed_up_normal_btn"] forState:UIControlStateNormal];
    [self.clickerButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_clicker_normal_btn"] forState:UIControlStateNormal];
    [self.setButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_set_normal_btn"] forState:UIControlStateNormal];
    
    [self.speedUpButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_speed_up_selected_btn"] forState:UIControlStateSelected];
    [self.clickerButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_clicker_selected_btn"] forState:UIControlStateSelected];
    [self.setButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_set_selected_btn"] forState:UIControlStateSelected];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.layer.cornerRadius = 16 * WIDTH_RATIO;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    
    [self addSubview:self.backButton];
    [self addSubview:self.speedUpButton];
    [self addSubview:self.clickerButton];
    [self addSubview:self.lineView];
    [self addSubview:self.setButton];
    
    self.selectedButton = self.speedUpButton;
    
    if ([GTSDKUtils isPortrait]) {
        [self layOutBasePortrait];
    }else {
        [self layOutBaseHorizontal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:GTSDKChangeTheme object:nil];
}

-(void)layOutBasePortrait {
    [self.backButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_back_btn_P"] forState:UIControlStateNormal];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(8 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
    [self.speedUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).offset(8 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
    [self.clickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.speedUpButton.mas_right).offset(8 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clickerButton.mas_right).offset(8 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(1 * WIDTH_RATIO);
        make.height.mas_equalTo(21 * WIDTH_RATIO);
    }];
    
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(8 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
}

-(void)layOutBaseHorizontal {
    [self.backButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_back_btn_H"] forState:UIControlStateNormal];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(8 * WIDTH_RATIO);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
    [self.speedUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_bottom).offset(8 * WIDTH_RATIO);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
    [self.clickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speedUpButton.mas_bottom).offset(8 * WIDTH_RATIO);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clickerButton.mas_bottom).offset(8 * WIDTH_RATIO);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(21 * WIDTH_RATIO);
        make.height.mas_equalTo(1 * WIDTH_RATIO);

    }];
    
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(8 * WIDTH_RATIO);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(36 * WIDTH_RATIO);
        make.height.mas_equalTo(36 * WIDTH_RATIO);
    }];
}

#pragma mark - response

- (void)backClick:(UIButton *)sender {
    [self.toolBarClickDelegate toolBar:self backClick:sender];
}

- (void)toolClick:(UIButton *)sender {
    self.selectedButton = sender;
    [self.toolBarClickDelegate toolBar:self didSelected:sender];
}

#pragma mark - setter & getter

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor hexColor:@"#F0F0F0"];
    }
    return _lineView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.adjustsImageWhenHighlighted = NO;
        _backButton.layer.cornerRadius = 12;
        _backButton.layer.masksToBounds = YES;
        _backButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        [_backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backButton;
}

- (UIButton *)speedUpButton {
    if (!_speedUpButton) {
        _speedUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _speedUpButton.adjustsImageWhenHighlighted = NO;
        _speedUpButton.selected = YES;
        _speedUpButton.layer.cornerRadius = 12;
        _speedUpButton.layer.masksToBounds = YES;
        _speedUpButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_selected_btn_color;
        [_speedUpButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_speed_up_normal_btn"] forState:UIControlStateNormal];
        [_speedUpButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_speed_up_selected_btn"] forState:UIControlStateSelected];
        [_speedUpButton addTarget:self action:@selector(toolClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedUpButton;
}

- (UIButton *)clickerButton {
    if (!_clickerButton) {
        _clickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickerButton.adjustsImageWhenHighlighted = NO;
        _clickerButton.selected = NO;
        _clickerButton.layer.cornerRadius = 12;
        _clickerButton.layer.masksToBounds = YES;
        _clickerButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        [_clickerButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_clicker_normal_btn"] forState:UIControlStateNormal];
        [_clickerButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_clicker_selected_btn"] forState:UIControlStateSelected];
        [_clickerButton addTarget:self action:@selector(toolClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _clickerButton;
}

- (UIButton *)setButton {
    if (!_setButton) {
        _setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _setButton.adjustsImageWhenHighlighted = NO;
        _setButton.selected = NO;
        _setButton.layer.cornerRadius = 12;
        _setButton.layer.masksToBounds = YES;
        _setButton.backgroundColor = [GTThemeManager share].colorModel.tool_bar_normal_btn_color;
        [_setButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_set_normal_btn"] forState:UIControlStateNormal];
        [_setButton setImage:[[GTThemeManager share] imageWithName:@"toolbar_set_selected_btn"] forState:UIControlStateSelected];
        [_setButton addTarget:self action:@selector(toolClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _setButton;
}

@end
