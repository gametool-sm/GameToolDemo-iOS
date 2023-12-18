//
//  GTSpeedUpMultiplyingSetViewController.m
//  GTSDK
//
//  Created by shangmi on 2023/6/26.
//

#import "GTSpeedUpMultiplyingSetViewController.h"
#import "GTMultiplyingSetView.h"
#import "GTMultiplyingSetEditView.h"
#import "GTFloatingWindowConfig.h"
#import "GTDialogView.h"

@interface GTSpeedUpMultiplyingSetViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *exitButton;

@property (nonatomic, strong) NSMutableArray *placeholderArray;
@property (nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation GTSpeedUpMultiplyingSetViewController

#pragma mark - override

- (void)changeTheme:(NSNotification *)noti {
    [super changeTheme:noti];
    
    [self.backButton setImage:[[GTThemeManager share] imageWithName:@"window_back_btn"] forState:UIControlStateNormal];
    [self.editButton setImage:[[GTThemeManager share] imageWithName:@"window_edit_btn"] forState:UIControlStateNormal];
    [self.exitButton setImage:[[GTThemeManager share] imageWithName:@"icon_close_hide_float_ball_window"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
}

- (void)setUp {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.editButton];
    [self.view addSubview:self.exitButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 * WIDTH_RATIO);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(190 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20 * WIDTH_RATIO);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
        make.width.mas_equalTo(20 * WIDTH_RATIO);
        make.height.mas_equalTo(20 * WIDTH_RATIO);
    }];
    
    @WeakObj(self);
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //创建item
        GTMultiplyingSetView *setView = [selfWeak setUpSetViewWithIndex:(int)idx isEdit:NO];
        
        [self.viewArray addObject:setView];
        if (idx >= 3) {
            *stop = YES;
        }
    }];
    
    [self.placeholderArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GTMultiplyingSetEditView *editView = [[GTMultiplyingSetEditView alloc] initWithFrame:CGRectZero];
        editView.hidden = YES;
        [self.view addSubview:editView];
        
        [editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(54 * WIDTH_RATIO + (40 + 8) * WIDTH_RATIO);
            if (self.dataArray.count%2 == 0) {
                make.left.mas_equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
            }else {
                make.left.mas_equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO + (129 + 12) * WIDTH_RATIO);
            }
            make.width.mas_equalTo(129 * WIDTH_RATIO);
            make.height.mas_equalTo(40 * WIDTH_RATIO);
        }];
        [editView layoutIfNeeded];
        [self.viewArray addObject:editView];
        
        //增加
        editView.insertButtonBlock = ^{
            if (self.dataArray.count >= 4) {
                return;
            }
            
            GTMultiplyingModel *model = [GTMultiplyingModel new];
            model.number = 1;
            model.isSelected = NO;
            model.isUp = YES;
            
            [self.dataArray addObject:model];
            [GTSDKUtils saveCurrentMultiplying:[self.dataArray copy]];
            //如果满了四个则删除占位数组里的model
            if (self.dataArray.count == 4) {
                [self.placeholderArray removeAllObjects];
                [self.viewArray removeLastObject];
            }
            
            GTMultiplyingSetView *setView = [self setUpSetViewWithIndex:(int)self.dataArray.count - 1 isEdit:YES];
            
            [self.viewArray insertObject:setView atIndex:self.viewArray.count - 1];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.4 animations:^{
                    setView.alpha = 1;
                } completion:^(BOOL finished) {
                    if (self.viewArray.count) {
                        GTMultiplyingSetEditView *view = (GTMultiplyingSetEditView *)[self.viewArray lastObject];
                        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(self.view.mas_top).offset(54 * WIDTH_RATIO + (40 + 8) * WIDTH_RATIO);
                            if (self.dataArray.count%2 == 0) {
                                make.left.mas_equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
                            }else {
                                make.left.mas_equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO + (129 + 12) * WIDTH_RATIO);
                            }
                            make.width.mas_equalTo(129 * WIDTH_RATIO);
                            make.height.mas_equalTo(40 * WIDTH_RATIO);
                        }];
                        
                        view.alpha = 1;
                    }
                }];
            });
            
            
        };
        
        if (idx == 0) {
            *stop = YES;
        }
    }];
}

#pragma mark - response
- (void)backClick {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)editClick {
    self.backButton.hidden = YES;
    self.editButton.hidden = YES;
    self.exitButton.hidden = NO;
    
    [self.viewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = self.viewArray[idx];
        view.hidden = NO;
        if ([view isKindOfClass:[GTMultiplyingSetView class]]) {
            [(GTMultiplyingSetView *)view startEdit];
        }
    }];
}

- (void)exitClick {
    self.backButton.hidden = NO;
    self.editButton.hidden = NO;
    self.exitButton.hidden = YES;
    
    [self.viewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = self.viewArray[idx];
        if ([view isKindOfClass:[GTMultiplyingSetEditView class]]) {
            view.hidden = YES;
        }else {
            [(GTMultiplyingSetView *)view endEdit];
        }
        
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UILabel *label = (UILabel *)object;
    UIButton *leftButton = [self.view viewWithTag:(label.tag - 2000)];
    UIButton *rightButton = [self.view viewWithTag:(label.tag - 1000)];
    //问一下UI不能点击要不要改变颜色
    if ([change[@"new"] isEqualToString:@"10x"]) {
        leftButton.enabled = YES;
        rightButton.enabled = NO;
    }else if ([change[@"new"] isEqualToString:@"0,1x"]) {
        leftButton.enabled = NO;
        rightButton.enabled = YES;
    }else {
        leftButton.enabled = YES;
        rightButton.enabled = YES;
    }
}

#pragma mark - setter & getter
- (GTMultiplyingSetView *)setUpSetViewWithIndex:(int)index isEdit:(BOOL)isEdit {
    GTMultiplyingSetView *setView = [GTMultiplyingSetView new];
    [setView updateStyleWithSpeedModel:self.dataArray[index] index:(int)index isEdit:isEdit];
    [self.view addSubview:setView];
    
    [setView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(54 * WIDTH_RATIO + (40 + 8) * WIDTH_RATIO * (index/2));
        make.left.mas_equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO + (129 + 12) * WIDTH_RATIO * (index%2));
        make.width.mas_equalTo(129 * WIDTH_RATIO);
        make.height.mas_equalTo(40 * WIDTH_RATIO);
    }];
    
    //减号
    setView.subtractButtonBlock = ^(GTMultiplyingModel *model) {
        [GTSDKUtils saveCurrentMultiplying:[self.dataArray copy]];
    };
    //加号
    setView.addButtonBlock = ^(GTMultiplyingModel * _Nonnull model) {
        [GTSDKUtils saveCurrentMultiplying:[self.dataArray copy]];
    };
    
    //删除
    setView.deleteButtonBlock = ^(GTMultiplyingModel * _Nonnull model, GTMultiplyingSetView * _Nonnull view) {
        GTDialogView *dialogView = [[GTDialogView alloc] initWithStyle:DialogViewStyleDefault
                                                                 title:@"温馨提示"
                                                               content:[NSString stringWithFormat:@"确定要删除%@x的倍率吗？", [NSString getSpeedText:model]]
                                                       leftButtonTitle:@"取消"
                                                      rightButtonTitle:@"确认"
                                                       leftButtonBlock:^{
        }
                                                      rightButtonBlock:^{
            //判断是不是被选中的model，如果是，则把第一个model的被点击属性置为yes
            [self.dataArray removeObject:model];
            
            if (model.isSelected) {
                GTMultiplyingModel *newModel = [self.dataArray firstObject];
                newModel.isSelected = YES;
            }
            
            [GTSDKUtils saveCurrentMultiplying:[self.dataArray copy]];
            
            if (index == (self.dataArray.count - 1)) {
                //最后一个
            }else {
                //倒数第二个
            }
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    view.alpha = 0;
                } completion:^(BOOL finished) {
                    [self.viewArray removeObject:view];
                    UIView *lastView = [self.viewArray lastObject];
                    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
                        
                        make.left.mas_equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
                        
                    }];
                    
                    [UIView animateWithDuration:0.28 animations:^{
                        [self.view layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        if (self.placeholderArray.count == 0) {
                            GTMultiplyingModel *model = [GTMultiplyingModel new];
                            model.number = 1;
                            model.isSelected = NO;
                            model.isUp = YES;
                            
                            [self.placeholderArray addObject:model];
                            
                            
                            GTMultiplyingSetEditView *editView = [GTMultiplyingSetEditView new];
                            [self.view addSubview:editView];
                            
                            [editView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.mas_equalTo(self.view.mas_top).offset(54 * WIDTH_RATIO + (40 + 8) * WIDTH_RATIO);
                                if (self.dataArray.count%2 == 0) {
                                    make.left.mas_equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
                                }else {
                                    make.left.mas_equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO + (129 + 12) * WIDTH_RATIO);
                                }
                                make.width.mas_equalTo(129 * WIDTH_RATIO);
                                make.height.mas_equalTo(40 * WIDTH_RATIO);
                            }];
                            
                            [self.viewArray addObject:editView];
                            
                            //增加
                            editView.insertButtonBlock = ^{
                                if (self.dataArray.count >= 4) {
                                    return;
                                }
                                
                                GTMultiplyingModel *model = [GTMultiplyingModel new];
                                model.number = 1;
                                model.isSelected = NO;
                                model.isUp = YES;
                                
                                [self.dataArray addObject:model];
                                [GTSDKUtils saveCurrentMultiplying:[self.dataArray copy]];
                                //如果满了四个则删除占位数组里的model
                                if (self.dataArray.count == 4) {
                                    [self.placeholderArray removeAllObjects];
                                    [self.viewArray removeLastObject];
                                }
                                
                                GTMultiplyingSetView *setView = [self setUpSetViewWithIndex:(int)self.dataArray.count - 1 isEdit:YES];
                                
                                [self.viewArray insertObject:setView atIndex:self.viewArray.count - 1];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [UIView animateWithDuration:0.4 animations:^{
                                        setView.alpha = 1;
                                    } completion:^(BOOL finished) {
                                        if (self.viewArray.count) {
                                            GTMultiplyingSetEditView *view = (GTMultiplyingSetEditView *)[self.viewArray lastObject];
                                            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                                                make.top.mas_equalTo(self.view.mas_top).offset(54 * WIDTH_RATIO + (40 + 8) * WIDTH_RATIO);
                                                if (self.dataArray.count%2 == 0) {
                                                    make.left.mas_equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO);
                                                }else {
                                                    make.left.mas_equalTo(self.view.mas_left).offset(20 * WIDTH_RATIO + (129 + 12) * WIDTH_RATIO);
                                                }
                                                make.width.mas_equalTo(129 * WIDTH_RATIO);
                                                make.height.mas_equalTo(40 * WIDTH_RATIO);
                                            }];
                                            
                                            view.alpha = 1;
                                        }
                                    }];
                                });
                                
                                
                            };
                        }
                    }];
                }];
            });
        }];
        [[GTSDKUtils getTopWindow].view addSubview:dialogView];
    };
    
    return setView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"倍率设置";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [GTThemeManager share].colorModel.titleColor;
        _titleLabel.font = [UIFont systemFontOfSize:15*WIDTH_RATIO];
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[[GTThemeManager share] imageWithName:@"window_back_btn"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setImage:[[GTThemeManager share] imageWithName:@"window_edit_btn"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (UIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitButton setImage:[[GTThemeManager share] imageWithName:@"icon_close_hide_float_ball_window"] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
        _exitButton.hidden = YES;
    }
    return _exitButton;
}

- (NSMutableArray *)placeholderArray {
    if (!_placeholderArray) {
        _placeholderArray = [NSMutableArray array];
        //这个页面的数据源加一个最后的占位,如果数据源有四个则删除
        if (_dataArray.count < 4) {
            GTMultiplyingModel *model = [GTMultiplyingModel new];
            model.number = 1;
            model.isSelected = NO;
            model.isUp = YES;

            [_placeholderArray addObject:model];
        }
    }
    return _placeholderArray;
}

- (NSMutableArray *)viewArray {
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

@end
