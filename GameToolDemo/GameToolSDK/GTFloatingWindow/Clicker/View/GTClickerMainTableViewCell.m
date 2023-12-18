//
//  GTClickerMainTableViewCell.m
//  GTSDK
//
//  Created by shangmi on 2023/8/14.
//

#import "GTClickerMainTableViewCell.h"
#import "GTClickerChangeNameView.h"
#import "GTFloatingWindowManager.h"
#import "GTClickerWindowManager.h"
#import "GTClickerPointSetViewController.h"
#import "UIButton+Extent.h"
#import "GTFloatingBallManager.h"
#import "GTRecordWindowManager.h"
#import "SMEventSensor.h"
@interface GTClickerMainTableViewCell ()
@property (nonatomic, strong) GTBaseView *fBGView;
@property (nonatomic, strong) GTBaseView *bgView;
@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *schemeNameLabel;
@property (nonatomic, strong) UIButton *colonButton;
@property (nonatomic, strong) UIButton *enableButton;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *changeButton;

@property (nonatomic, strong) GTClickerSchemeModel *schemeModel;

@end

@implementation GTClickerMainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
    }
    return self;
}

- (void)changeTheme :(NSNotification *)noti{
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.contentView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.fBGView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.bgView.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
    self.schemeNameLabel.textColor = [GTThemeManager share].colorModel.clicker_cell_text_color;
    [self.colonButton setImage:[[GTThemeManager share] imageWithName:@"clicker_more_icon"] forState:UIControlStateNormal];
    self.tipView.backgroundColor = [GTThemeManager share].colorModel.clicker_settipView_color;
    self.tipImageView.image = [[GTThemeManager share] imageWithName:@"gt_triangle_icon_left"];
    self.tipView.layer.borderColor = [GTThemeManager share].colorModel.clicker_tipborder_gray_color.CGColor;
    [self.enableButton setTitleColor: [GTThemeManager share].colorModel.clicker_cell_start_color forState:UIControlStateNormal];
    [self.deleteButton setTitleColor: [GTThemeManager share].colorModel.clicker_cell_text_color forState:UIControlStateNormal];
    [self.changeButton setTitleColor: [GTThemeManager share].colorModel.clicker_cell_text_color forState:UIControlStateNormal];
    self.tipView.layer.shadowColor = [GTThemeManager share].colorModel.clicker_tipshadow_color.CGColor;
}

- (void)setUp {
    self.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    self.contentView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    [self addSubview:self.fBGView];
    [self.fBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.fBGView addSubview:self.bgView];
    [self.bgView addSubview:self.colonButton];
    [self.bgView addSubview:self.enableButton];
    [self.bgView addSubview:self.schemeNameLabel];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fBGView.mas_left);
        make.right.equalTo(self.fBGView.mas_right);
        make.top.equalTo(self.fBGView.mas_top).offset(3 * WIDTH_RATIO);
        make.bottom.equalTo(self.fBGView.mas_bottom).offset(-3 * WIDTH_RATIO);
    }];

    [self.colonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right).offset(-7 * WIDTH_RATIO);
        make.width.equalTo(@(15 * WIDTH_RATIO));
        make.height.equalTo(@(15 * WIDTH_RATIO));
    }];
    [self.enableButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.colonButton.mas_left).offset(-10 * WIDTH_RATIO);
        make.width.equalTo(@(30 * WIDTH_RATIO));
        make.height.equalTo(@(20 * WIDTH_RATIO));
    }];
    
    [self.schemeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(12 * WIDTH_RATIO);
        make.right.equalTo(self.bgView.mas_right).offset(-78 * WIDTH_RATIO);
        make.top.equalTo(self.bgView.mas_top).offset(12 * WIDTH_RATIO);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-12 * WIDTH_RATIO);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:GTSDKChangeTheme object:nil];
}

- (void)updateWithData:(GTClickerSchemeModel *)model {
    self.schemeModel = model;
    self.schemeNameLabel.text = model.name;
}

- (void)addTapGestureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.testView addGestureRecognizer:tapGesture];
}
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.testView];
    if (!CGRectContainsPoint(self.tipView.frame, location)) {
        [self removeTipView];
    }
}
- (void)removeTipView {
    [self.testView removeFromSuperview];
    self.testView = nil;
}

#pragma mark -response

- (void)colonButtonClicked:(UIButton *)sender {
    if ([self.celldelegate respondsToSelector:@selector(moreButtonClickedForRow:cell:)]) {
        [self.celldelegate moreButtonClickedForRow:self.indexPath cell:self];
    }
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.testView = [[UIView alloc] initWithFrame:screenRect];
    self.testView.backgroundColor = [UIColor clearColor];
    [[GTSDKUtils getTopWindow].view addSubview:self.testView];
    [self addTapGestureRecognizer];
    [self.testView addSubview:self.tipView];
    
    //显示三角框
    if(self.firstPath == self.indexPath.row){
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.colonButton.mas_left).offset(-7 * WIDTH_RATIO);
            make.top.equalTo(self.contentView.mas_top).offset(5 * WIDTH_RATIO);
            make.width.equalTo(@(70 * WIDTH_RATIO));
            make.height.equalTo(@(76 * WIDTH_RATIO));
        }];

    }else if(self.finalPath == self.indexPath.row){
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.colonButton.mas_left).offset(-7 * WIDTH_RATIO);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5 * WIDTH_RATIO);
            make.width.equalTo(@(70 * WIDTH_RATIO));
            make.height.equalTo(@(76 * WIDTH_RATIO));
        }];
    }else{
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.colonButton.mas_left).offset(-7 * WIDTH_RATIO);
            make.centerY.equalTo(self.colonButton.mas_centerY);
            make.width.equalTo(@(70 * WIDTH_RATIO));
            make.height.equalTo(@(76 * WIDTH_RATIO));
        }];
    }
   
    [self.tipView addSubview:self.changeButton];
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipView.mas_top).offset(6*WIDTH_RATIO);
        make.width.equalTo(@(70 * WIDTH_RATIO));
        make.height.equalTo(@(32 * WIDTH_RATIO));
    }];
    [self.tipView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tipView.mas_bottom).offset(-6*WIDTH_RATIO);
        make.width.equalTo(@(70 * WIDTH_RATIO));
        make.height.equalTo(@(32 * WIDTH_RATIO));
    }];

    [self.testView addSubview:self.tipImageView];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.colonButton.mas_left).offset(-2.5 * WIDTH_RATIO);
        make.centerY.equalTo(self.colonButton.mas_centerY);
        make.width.equalTo(@(5 * WIDTH_RATIO));
        make.height.equalTo(@(14 * WIDTH_RATIO));
    }];
}

- (void)enableButtonClicked:(UIButton *)sender {
    //获取行号
    if ([self.celldelegate respondsToSelector:@selector(enableButtonClickedForRow:)]) {
        [self.celldelegate enableButtonClickedForRow:self.tag];
    }
    
    //调出连点器悬浮窗
    [[GTFloatingWindowManager shareInstance] floatingWindowHide];
    
//    [GTClickerWindowManager shareInstance].isFromNewScheme = NO;
    if ([GTOperationControl shareInstance].gtSDKStyle == GTSDKStyleDefault) {
        [[GTFloatingBallManager shareInstance] floatingBallShow];
    }
    //根据录制或连点，展示相应的悬浮窗
    if (self.schemeModel.type == 0) {
        switch (self.schemeModel.startMethod) {
            case ClickerWindowStartMethodNow: {
                if (self.schemeModel.cycleIndex == 0) {
                    [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateNowInfinite;
                }else {
                    [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateNowFinite;
                }
            }
                break;
            case ClickerWindowStartMethodPreset:
            case ClickerWindowStartMethodCountdown: {
                if (self.schemeModel.cycleIndex == 0) {
                    [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureInfinite;
                }else {
                    [GTRecordWindowManager shareInstance].recordWindowState = RecordWindowStateFutureFinite;
                }
            }
                break;
            default:
                break;
        }
        //recordWindowShow
        [[GTRecordWindowManager shareInstance] recordWindowShow];
    }else if (self.schemeModel.type == 1) {
        [[GTClickerWindowManager shareInstance] clickerWindowShow];
        
    }
    
    
}

-(void)changeButtonClicked:(UIButton *)sender{
    [self.testView removeFromSuperview];
    self.testView = nil;
    __block GTClickerChangeNameView *reNameDialogView;
    reNameDialogView = [[GTClickerChangeNameView alloc] initWithStyleconfirm:self.schemeModel confirm:^{
        NSString *name = reNameDialogView.nameTextField.text;
        if(name.length == 0){
            [[GTSDKUtils getTopWindow].view makeToast:localString(@"名称不能为空") duration:0.5 position:CSToastPositionCenter];
        }else{
            self.schemeModel.name = name ;
            if ([self.celldelegate respondsToSelector:@selector(cellDidFinishEditingWithModel:indexPath:)]) {
                [self.celldelegate cellDidFinishEditingWithModel:self.schemeModel indexPath:self.indexPath];
            }
            [[GTSDKUtils getTopWindow].view makeToast:localString(@"修改成功") duration:0.5 position:CSToastPositionCenter];
            [reNameDialogView removeFromSuperview];
        }
    } cancel:^{
        
    }];
    [[GTSDKUtils getTopWindow].view addSubview:reNameDialogView];
}

-(void)deleteButtonClicked:(UIButton *)sender{
    [self.testView removeFromSuperview];
    self.testView = nil;

    __block GTDialogView *dialogView;
    dialogView = [[GTDialogView alloc] initWithStyle:DialogViewStyleDefault
                                               title:@"温馨提示"
                                             content:[NSString stringWithFormat: @"确认要删除该方案吗？"]
                                     leftButtonTitle:@"取消"
                                    rightButtonTitle:@"删除"
                                     leftButtonBlock:^{
    }
                                    rightButtonBlock:^{
        if ([self.celldelegate respondsToSelector:@selector(deleteButtonClickedInCell:)]) {
            [self.celldelegate deleteButtonClickedInCell:self];
        }
    }];
    [[GTSDKUtils getTopWindow].view addSubview:dialogView];
}


#pragma mark -setter & getter
- (GTBaseView *)bgView {
    if (!_bgView) {
        _bgView = [GTBaseView new];
        _bgView.backgroundColor = [GTThemeManager share].colorModel.set_main_box_bg_color;
        _bgView.layer.cornerRadius = 10 * WIDTH_RATIO;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (GTBaseView *)fBGView {
    if (!_fBGView) {
        _fBGView = [GTBaseView new];
        _fBGView.backgroundColor = [GTThemeManager share].colorModel.bgColor;
    }
    return _fBGView;
}

- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [UIView new];
        _tipView.layer.cornerRadius = 10*WIDTH_RATIO;
        _tipView.backgroundColor = [GTThemeManager share].colorModel.clicker_settipView_color;
        _tipView.layer.borderColor = [GTThemeManager share].colorModel.clicker_tipborder_gray_color.CGColor;
        _tipView.layer.borderWidth = 0.5*WIDTH_RATIO;
        _tipView.layer.shadowColor = [GTThemeManager share].colorModel.clicker_tipshadow_color.CGColor;
        _tipView.layer.shadowOffset = CGSizeMake(0,0);
        _tipView.layer.shadowOpacity = 1*WIDTH_RATIO;
        _tipView.layer.shadowRadius = 14*WIDTH_RATIO;
    }
    return _tipView;
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [UIImageView new];
        _tipImageView.image = [[GTThemeManager share] imageWithName:@"gt_triangle_icon_left"];
    }
    return _tipImageView;
}

-(UILabel *)schemeNameLabel{
    if(!_schemeNameLabel){
        _schemeNameLabel = [UILabel new];
        _schemeNameLabel.font = [UIFont systemFontOfSize:14*WIDTH_RATIO];
        _schemeNameLabel.textColor = [GTThemeManager share].colorModel.clicker_cell_text_color;
    }
    return _schemeNameLabel;
}

- (UIButton *)colonButton {
    if (!_colonButton) {
        _colonButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_colonButton setImage:[[GTThemeManager share] imageWithName:@"clicker_more_icon"] forState:UIControlStateNormal];
        [_colonButton addTarget:self action:@selector(colonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_colonButton setEnlargeEdgeWithTop:8 right:8 bottom:8 left:5];
    }
    return _colonButton;
}

- (UIButton *)enableButton {
    if (!_enableButton) {
        _enableButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enableButton setTitle:localString(@"启用") forState:UIControlStateNormal];
        _enableButton.titleLabel.font = [UIFont systemFontOfSize:14*WIDTH_RATIO];
        [_enableButton setTitleColor: [GTThemeManager share].colorModel.clicker_cell_start_color forState:UIControlStateNormal];
        [_enableButton addTarget:self action:@selector(enableButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_colonButton setEnlargeEdgeWithTop:8 right:5 bottom:8 left:8];
    }
    return _enableButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:localString(@"删除") forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
        [_deleteButton setTitleColor: [GTThemeManager share].colorModel.clicker_cell_text_color forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setTitle:localString(@"改名") forState:UIControlStateNormal];
        _changeButton.titleLabel.font = [UIFont systemFontOfSize:13*WIDTH_RATIO];
        [_changeButton setTitleColor: [GTThemeManager share].colorModel.clicker_cell_text_color forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(changeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeButton;
}


@end

