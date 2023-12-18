//
//  GTSwitch.m
//  GTSDK
//
//  Created by shangmi on 2023/6/29.
//

#import "GTSwitch.h"

@interface GTSwitch ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *itemView;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation GTSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:GTSDKChangeTheme object:nil];
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.itemView];
    [self addSubview:self.selectButton];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(6 * WIDTH_RATIO);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(12 * WIDTH_RATIO);
        make.height.mas_equalTo(12 * WIDTH_RATIO);
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [self bringSubviewToFront:self.selectButton];
}

- (void)changeTheme:(NSNotification *)noti {
    if (self.on) {
        self.backgroundView.backgroundColor = [GTThemeManager share].colorModel.gtswitch_is_on_bg_color;
    }else {
        self.backgroundView.backgroundColor = [GTThemeManager share].colorModel.gtswitch_bg_color;
    }
}

- (void)switchClick:(UIButton *)sender {
    self.on = !self.on;
    if (self.on) {
        self.backgroundView.backgroundColor = [GTThemeManager share].colorModel.gtswitch_is_on_bg_color;
        [self.itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-6 * WIDTH_RATIO);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }else {
        self.backgroundView.backgroundColor = [GTThemeManager share].colorModel.gtswitch_bg_color;
        [self.itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(6 * WIDTH_RATIO);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setOn:(BOOL)on {
    _on = on;
    self.backgroundView.backgroundColor = on ? [GTThemeManager share].colorModel.gtswitch_is_on_bg_color : [GTThemeManager share].colorModel.gtswitch_bg_color;
    [self.itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (on) {
            make.right.equalTo(self.mas_right).offset(-6 * WIDTH_RATIO);
        }else {
            make.left.equalTo(self.mas_left).offset(6 * WIDTH_RATIO);
        }
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(12 * WIDTH_RATIO);
        make.height.mas_equalTo(12 * WIDTH_RATIO);
    }];
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [GTThemeManager share].colorModel.gtswitch_bg_color;
        _backgroundView.layer.cornerRadius = 12 * WIDTH_RATIO;
        _backgroundView.layer.masksToBounds = YES;
    }
    return _backgroundView;
}

- (UIView *)itemView {
    if (!_itemView) {
        _itemView = [UIView new];
        _itemView.backgroundColor = [UIColor hexColor:@"#FFFFFF"];
        _itemView.layer.cornerRadius = 6 * WIDTH_RATIO;
        _itemView.layer.masksToBounds = YES;
    }
    return _itemView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _selectButton;
}

@end
