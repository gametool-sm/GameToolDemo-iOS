//
//  GTMultiplyingSetView.m
//  GTSDK
//
//  Created by shangmi on 2023/7/1.
//

#import "GTMultiplyingSetView.h"
#import "GTFloatingWindowConfig.h"
#import "GTSDKUtils.h"

@interface GTMultiplyingSetView ()

@property (nonatomic, strong) GTMultiplyingModel *model;
@property (nonatomic, assign) int index;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *subtractButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIImageView *numImg;
@property (nonatomic, strong) UIButton *changeButton;

@end

@implementation GTMultiplyingSetView

#pragma mark - over ride

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    
    if (self.index == 0) {
        self.numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img_gray"];
    }else {
        self.numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img"];
    }
    
    [self.subtractButton setImage:[[GTThemeManager share] imageWithName:@"set_sub_btn"] forState:UIControlStateNormal];
    [self.addButton setImage:[[GTThemeManager share] imageWithName:@"set_add_btn"] forState:UIControlStateNormal];
    
    //判断加减号样式
    if (self.index == 0) {
        self.numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img_gray"];
        [self.subtractButton setBackgroundColor:[GTThemeManager share].colorModel.speed_up_mul_set_unable_selected_sysbol_bg_color];
        [self.addButton setBackgroundColor:[GTThemeManager share].colorModel.speed_up_mul_set_unable_selected_sysbol_bg_color];
        [self.subtractButton setImage:[[GTThemeManager share] imageWithName:@"set_sub_btn_gray"] forState:UIControlStateNormal];
        [self.addButton setImage:[[GTThemeManager share] imageWithName:@"set_add_btn_gray"] forState:UIControlStateNormal];
        self.bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_mul_set_unable_selected_item_bg_color;
        self.numLabel.textColor = [GTThemeManager share].colorModel.unselectedTextColor;
    }else {
        self.numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img"];
        [self.subtractButton setBackgroundColor:[GTThemeManager share].colorModel.speed_up_mul_set_able_selected_sysbol_bg_color];
        [self.addButton setBackgroundColor:[GTThemeManager share].colorModel.speed_up_mul_set_able_selected_sysbol_bg_color];
        [self.subtractButton setImage:[[GTThemeManager share] imageWithName:@"set_sub_btn"] forState:UIControlStateNormal];
        [self.addButton setImage:[[GTThemeManager share] imageWithName:@"set_add_btn"] forState:UIControlStateNormal];
        self.bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_mul_set_able_selected_item_bg_color;
        self.numLabel.textColor = [GTThemeManager share].colorModel.textColor;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.bgView];
    [self addSubview:self.subtractButton];
    [self addSubview:self.addButton];
    [self addSubview:self.numLabel];
    [self addSubview:self.numImg];
    [self addSubview:self.changeButton];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self);
    }];
    
    [self.subtractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(13 * WIDTH_RATIO);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.width.mas_equalTo(21 * WIDTH_RATIO);
        make.height.mas_equalTo(21 * WIDTH_RATIO);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-13 * WIDTH_RATIO);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.width.mas_equalTo(21 * WIDTH_RATIO);
        make.height.mas_equalTo(21 * WIDTH_RATIO);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_right).offset(-60 * WIDTH_RATIO);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    
    [self.numImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numLabel.mas_left).offset(-1 * WIDTH_RATIO);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.width.mas_equalTo(8 * WIDTH_RATIO);
        make.height.mas_equalTo(18 * WIDTH_RATIO);
    }];
    
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    //添加观察者控制加减号能否点击
    [self.numLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self.numLabel removeObserver:self forKeyPath:@"text"];
}

- (void)updateStyleWithSpeedModel:(GTMultiplyingModel *)model index:(int)index isEdit:(BOOL)isEdit{
    self.model = model;
    self.index = index;
    self.numLabel.text = [NSString getSpeedText:model];
    //判断删除按钮样式
    if (index == 0 || index == 1) {
        self.changeButton.userInteractionEnabled = NO;
        [self.changeButton setImage:[[GTThemeManager share] imageWithName:@"set_del_btn_gray"] forState:UIControlStateNormal];
    }else {
        self.changeButton.userInteractionEnabled = YES;
        [self.changeButton setImage:[[GTThemeManager share] imageWithName:@"set_del_btn"] forState:UIControlStateNormal];
    }
    //判断加减号样式
    if (index == 0) {
        self.numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img_gray"];
        self.subtractButton.userInteractionEnabled = NO;
        self.addButton.userInteractionEnabled = NO;
        [self.subtractButton setBackgroundColor:[GTThemeManager share].colorModel.speed_up_mul_set_unable_selected_sysbol_bg_color];
        [self.addButton setBackgroundColor:[GTThemeManager share].colorModel.speed_up_mul_set_unable_selected_sysbol_bg_color];
        [self.subtractButton setImage:[[GTThemeManager share] imageWithName:@"set_sub_btn_gray"] forState:UIControlStateNormal];
        [self.addButton setImage:[[GTThemeManager share] imageWithName:@"set_add_btn_gray"] forState:UIControlStateNormal];
        self.bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_mul_set_unable_selected_item_bg_color;
        self.numLabel.textColor = [GTThemeManager share].colorModel.unselectedTextColor;
    }else {
        self.numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img"];
        self.subtractButton.userInteractionEnabled = YES;
        self.addButton.userInteractionEnabled = YES;
        [self.subtractButton setBackgroundColor:[GTThemeManager share].colorModel.speed_up_mul_set_able_selected_sysbol_bg_color];
        [self.addButton setBackgroundColor:[GTThemeManager share].colorModel.speed_up_mul_set_able_selected_sysbol_bg_color];
        [self.subtractButton setImage:[[GTThemeManager share] imageWithName:@"set_sub_btn"] forState:UIControlStateNormal];
        [self.addButton setImage:[[GTThemeManager share] imageWithName:@"set_add_btn"] forState:UIControlStateNormal];
        self.bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_mul_set_able_selected_item_bg_color;
        self.numLabel.textColor = [GTThemeManager share].colorModel.textColor;
    }
    
    if (isEdit) {
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-28 * WIDTH_RATIO);
        }];
        [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(13 * WIDTH_RATIO);
            make.centerY.equalTo(self.bgView.mas_centerY);
        }];
        
        self.alpha = 0;
        self.numLabel.textColor = [GTThemeManager share].colorModel.textColor;
        self.numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img_gray"];
        self.subtractButton.alpha = 0;
        self.addButton.alpha = 0;
        self.changeButton.alpha = 1;
    }
}

- (void)startEdit {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.28 animations:^{
            [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.equalTo(self);
                make.right.equalTo(self.mas_right).offset(-28 * WIDTH_RATIO);
            }];
            [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(13 * WIDTH_RATIO);
                make.centerY.equalTo(self.bgView.mas_centerY);
            }];
            [self layoutSubviews];
            
            self.bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_mul_set_unable_selected_item_bg_color;
            self.numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img_gray"];
            self.numLabel.textColor = [GTThemeManager share].colorModel.textColor;
            self.subtractButton.alpha = 0;
            self.addButton.alpha = 0;
            self.changeButton.alpha = 1;
        }];
    });
}

- (void)endEdit {
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
    }];
    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_left).offset(60 * WIDTH_RATIO);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.28 animations:^{
            [self layoutIfNeeded];
            if (self.index == 0) {
                self.bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_mul_set_unable_selected_item_bg_color;
                self.numLabel.textColor = [GTThemeManager share].colorModel.unselectedTextColor;
                self.numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img_gray"];
            }else {
                self.bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_mul_set_able_selected_item_bg_color;
                self.numLabel.textColor = [GTThemeManager share].colorModel.textColor;
                self.numImg.image = [[GTThemeManager share] imageWithName:@"set_mul_img"];
            }
            
            self.subtractButton.alpha = 1;
            self.addButton.alpha = 1;
            self.changeButton.alpha = 0;
        }];
    });
}

#pragma mark - response

- (void)subtractClick:(UIButton *)sender {
    //didOperation参数，加传yes，减no
    GTMultiplyingModel *model = [GTFloatingWindowConfig didOperation:NO SpeedModel:self.model];
    
    self.numLabel.text = [NSString getSpeedText:model];
    
    if (self.subtractButtonBlock) {
        self.subtractButtonBlock(self.model);
    }
}

- (void)addClick:(UIButton *)sender {
    //didOperation参数，加传yes，减no
    GTMultiplyingModel *model = [GTFloatingWindowConfig didOperation:YES SpeedModel:self.model];
    
    self.numLabel.text = [NSString getSpeedText:model];
    
    if (self.addButtonBlock) {
        self.addButtonBlock(self.model);
    }
}

- (void)changeClick:(UIButton *)sender {
    if (self.deleteButtonBlock) {
        self.deleteButtonBlock(self.model, self);
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //问一下UI不能点击要不要改变颜色
    NSDictionary *dict = (NSDictionary *)change;
    if ([dict[@"new"] isEqualToString:@"10"]) {
        self.subtractButton.userInteractionEnabled = YES;
        self.addButton.userInteractionEnabled = NO;
        [self.subtractButton setImage:[[GTThemeManager share] imageWithName:@"set_sub_btn"] forState:UIControlStateNormal];
        [self.addButton setImage:[[GTThemeManager share] imageWithName:@"set_add_btn_gray"] forState:UIControlStateNormal];
    }else if ([dict[@"new"] isEqualToString:@"0.1"]) {
        self.subtractButton.userInteractionEnabled = NO;
        self.addButton.userInteractionEnabled = YES;
        [self.subtractButton setImage:[[GTThemeManager share] imageWithName:@"set_sub_btn_gray"] forState:UIControlStateNormal];
        [self.addButton setImage:[[GTThemeManager share] imageWithName:@"set_add_btn"] forState:UIControlStateNormal];
    }else {
        self.subtractButton.userInteractionEnabled = YES;
        self.addButton.userInteractionEnabled = YES;
        [self.subtractButton setImage:[[GTThemeManager share] imageWithName:@"set_sub_btn"] forState:UIControlStateNormal];
        [self.addButton setImage:[[GTThemeManager share] imageWithName:@"set_add_btn"] forState:UIControlStateNormal];
    }
}

#pragma mark - setter & getter

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [GTThemeManager share].colorModel.speed_up_mul_set_able_selected_item_bg_color;
        _bgView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIButton *)subtractButton {
    if (!_subtractButton) {
        _subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _subtractButton.layer.cornerRadius = 6 * WIDTH_RATIO;
        _subtractButton.layer.masksToBounds = YES;
        [_subtractButton setImage:[[GTThemeManager share] imageWithName:@"set_sub_btn"] forState:UIControlStateNormal];
        [_subtractButton addTarget:self action:@selector(subtractClick:) forControlEvents:UIControlEventTouchUpInside];
        [_subtractButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _subtractButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.layer.cornerRadius = 6 * WIDTH_RATIO;
        _addButton.layer.masksToBounds = YES;
        [_addButton setImage:[[GTThemeManager share] imageWithName:@"set_add_btn"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _addButton;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont systemFontOfSize:16*WIDTH_RATIO];
    }
    return _numLabel;
}

- (UIImageView *)numImg {
    if (!_numImg) {
        _numImg = [UIImageView new];
    }
    return _numImg;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setImage:[[GTThemeManager share] imageWithName:@"set_del_btn"] forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        _changeButton.alpha = 0;
    }
    return _changeButton;
}

@end
