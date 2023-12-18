//
//  GTClickerGuide.m
//  GTSDK
//
//  Created by shangminet on 2023/8/18.
//

#import "GTClickerGuide.h"
#import "GTClickerWindowManager.h"
#import "GTDialogWindowManager.h"
#import "GTFloatingBallManager.h"

@implementation GTClickerGuide
- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.backgroundColor = [UIColor hexColor:@"#000000" withAlpha:0.5];
    if ([GTSDKUtils isPortrait]) {
        [self addSubview:self.mengbanImage];
        [self addSubview:self.arrowImage];
        [self addSubview:self.deleteImage];
        [self addSubview:self.deleteLabel];
        [self addSubview:self.tipImage];
        [self addSubview:self.tipLabel];
        [self.mengbanImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.centerX.equalTo(self.mas_centerX);
            if ([GTSDKUtils isPortrait]) {
                make.width.mas_equalTo(375 * WIDTH_RATIO);
                make.height.mas_equalTo(160 * WIDTH_RATIO);
            }else {
                make.width.mas_equalTo(419 * WIDTH_RATIO);
                make.height.mas_equalTo(135 * WIDTH_RATIO);
            }
        }];
        [self.deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-55*WIDTH_RATIO);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@(50*WIDTH_RATIO));
            make.height.equalTo(@(50*WIDTH_RATIO));
        }];
        [self.deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.deleteImage.mas_bottom).offset(13*WIDTH_RATIO);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@(105*WIDTH_RATIO));
            make.height.equalTo(@(18*WIDTH_RATIO));
        }];
        
        
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mengbanImage.mas_top).offset(-8*WIDTH_RATIO);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@(25*WIDTH_RATIO));
            make.height.equalTo(@(50*WIDTH_RATIO));
        }];
        
        [self.tipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(305*WIDTH_RATIO);
            make.left.equalTo(self.mas_left).offset(104*WIDTH_RATIO);
            make.width.equalTo(@(15*WIDTH_RATIO));
            make.height.equalTo(@(42*WIDTH_RATIO));
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipImage.mas_bottom).offset(4*WIDTH_RATIO);
            make.centerX.equalTo(self.tipImage.mas_centerX);
            make.width.equalTo(@(90*WIDTH_RATIO));
            make.height.equalTo(@(20*WIDTH_RATIO));
        }];
    }else {
        [self addSubview:self.mengbanImage];
        [self addSubview:self.arrowImage];
        [self addSubview:self.deleteImage];
        [self addSubview:self.deleteLabel];
        [self.mengbanImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.centerX.equalTo(self.mas_centerX);
            if ([GTSDKUtils isPortrait]) {
                make.width.mas_equalTo(375 * WIDTH_RATIO);
                make.height.mas_equalTo(160 * WIDTH_RATIO);
            }else {
                make.width.mas_equalTo(419 * WIDTH_RATIO);
                make.height.mas_equalTo(135 * WIDTH_RATIO);
            }
        }];
        [self.deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-55*WIDTH_RATIO);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@(50*WIDTH_RATIO));
            make.height.equalTo(@(50*WIDTH_RATIO));
        }];
        [self.deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.deleteImage.mas_bottom).offset(13*WIDTH_RATIO);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@(105*WIDTH_RATIO));
            make.height.equalTo(@(18*WIDTH_RATIO));
        }];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mengbanImage.mas_top).offset(-8*WIDTH_RATIO);
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@(25*WIDTH_RATIO));
            make.height.equalTo(@(50*WIDTH_RATIO));
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideAll];
}

- (void)hideAll {
    [GTClickerWindowManager shareInstance].clickerWinWindow.windowLevel = 29000;
    [GTFloatingBallManager shareInstance].ballWindow.windowLevel = 30000;
    [[GTDialogWindowManager shareInstance] dialogWindowHide];
    [self.superview removeFromSuperview];
    [self removeFromSuperview];
    
}

- (UIImageView *)mengbanImage{
    if(!_mengbanImage){
        _mengbanImage = [UIImageView new];
       
        if ([GTSDKUtils isPortrait]) {
            _mengbanImage.image = [[GTThemeManager share] imageWithName:@"mask_bottom_view_P"];
        }else {
            _mengbanImage.image = [[GTThemeManager share] imageWithName:@"mask_bottom_view_H"];
        }
        
    }
    return _mengbanImage;
}

- (UIImageView *)deleteImage{
    if(!_deleteImage){
        _deleteImage = [UIImageView new];
        _deleteImage.backgroundColor = [UIColor clearColor];
        _deleteImage.image = [[GTThemeManager share] imageWithName:@"clicker_mask_delete"];
        
    }
    return _deleteImage;
}

- (UILabel *)deleteLabel{
    if(!_deleteLabel){
        _deleteLabel = [UILabel new];
        
        _deleteLabel.text = localString(@"拖拽至此可关闭");
        _deleteLabel.textAlignment = NSTextAlignmentCenter;
        _deleteLabel.textColor = [UIColor hexColor:@"FFFFFF"];
        _deleteLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
    }
    return  _deleteLabel;
}

- (UIImageView *)arrowImage{
    if(!_arrowImage){
        _arrowImage = [UIImageView new];
        _arrowImage.backgroundColor = [UIColor clearColor];
        _arrowImage.image = [[GTThemeManager share] imageWithName:@"clicker_mask_arrow"];
    }
    return _arrowImage;
}

- (UIImageView *)tipImage{
    if(!_tipImage){
        _tipImage = [UIImageView new];
        _tipImage.backgroundColor = [UIColor clearColor];
        _tipImage.image = [[GTThemeManager share] imageWithName:@"clicker_mask_icon"];
    }
    return _tipImage;
}

- (UILabel *)tipLabel{
    if(!_tipLabel){
        _tipLabel = [UILabel new];
        _tipLabel.text = localString(@"点击设置连点");
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor hexColor:@"FFFFFF"];
        _tipLabel.font = [UIFont systemFontOfSize:14 * WIDTH_RATIO];
    }
    return  _tipLabel;
}



@end
