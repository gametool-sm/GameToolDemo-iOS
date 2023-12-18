//
//  GTClickerPointSetTableViewCell.h
//  GTSDK
//
//  Created by shangminet on 2023/8/23.
//

#import <UIKit/UIKit.h>
#import "GTClickerActionModel.h"
#import "GTClickerWindowManager.h"

NS_ASSUME_NONNULL_BEGIN
@class GTClickerPointSetTableViewCell;

@protocol GTClickerPointSetTableViewCellDelegate <NSObject>
//文本框编辑
- (void)textFieldDidChangeInCell:(BOOL)textChange;

//删除行
- (void)deleteButtonClickedInCell:(NSIndexPath *)indexPath;

//编辑完成后的数据更新
- (void)cellDidFinishEditingWithData:(GTClickerActionModel *)data indexPath:(NSIndexPath *)indexPath;
@end

typedef void (^CellTapHandler)(void);

@interface GTClickerPointSetTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, copy) CellTapHandler tapHandler;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) UIView *tapCountView;
@property (nonatomic, strong) UIView *pressDurationView;
@property (nonatomic, strong) UIView *clickIntervalView;

@property (nonatomic, strong) UILabel *tapCountLabel;
@property (nonatomic, strong) UILabel *pressDurationLabel;
@property (nonatomic, strong) UILabel *clickIntervalLabel;

@property (nonatomic, strong) UITextField *tapCountText;
@property (nonatomic, strong) UITextField *pressDurationText;
@property (nonatomic, strong) UITextField *clickIntervalText;
@property (nonatomic, strong) UIButton *sortButton;
@property (nonatomic, strong) UIButton *deletePointButton;

@property (nonatomic, strong) UILabel *rowNumberLabel;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, strong) GTClickerActionModel *modelAction;
@property (nonatomic, strong) GTClickerActionModel *compareAction;
@property (nonatomic, strong) GTClickerSchemeModel *model;
@property (nonatomic, strong) NSMutableArray *DataArray;
@property (weak, nonatomic) id<GTClickerPointSetTableViewCellDelegate> delegate;
@property (nonatomic, strong) GTBaseView *fBGView;

//进入删除模式
- (void)enterDeleteMode;

//退出删除模式
- (void)quitDeleteMode;

//获取数据
- (void)updateWithData:(GTClickerActionModel *)model compareArray:(GTClickerActionModel *)model;

//键盘移动量
@property (nonatomic, assign) CGRect tapTextFieldFrame;
@property (nonatomic, assign) CGFloat offsetY;
@end

NS_ASSUME_NONNULL_END
