//
//  GTDialogPointSetView.h
//  GTSDK
//
//  Created by shangminet on 2023/8/28.
//

#import "GTBaseView.h"
#import "GTClickerSchemeModel.h"
#import "GTDialogView.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^LongPressPointShowPointSetBlock)(GTClickerActionModel *model);

@interface GTDialogPointSetView : GTBaseView <UITextFieldDelegate>

- (instancetype)initWithTitle:(NSString *)title model:(GTClickerActionModel *)modelAction index:(int)index;

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *tapText;
@property (nonatomic, copy) NSString *pressText;
@property (nonatomic, copy) NSString *clickerText;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *tapCountView;
@property (nonatomic, strong) UIView *pressDurationView;
@property (nonatomic, strong) UIView *clickIntervalView;


@property (nonatomic, strong) UILabel *tapCount;
@property (nonatomic, strong) UILabel *pressDuration;
@property (nonatomic, strong) UILabel *clickInterval;

@property (nonatomic, strong) UILabel *tapCountLabel;
@property (nonatomic, strong) UILabel *pressDurationLabel;
@property (nonatomic, strong) UILabel *clickIntervalLabel;

@property (nonatomic, strong) UITextField *tapCountText;
@property (nonatomic, strong) UITextField *pressDurationText;
@property (nonatomic, strong) UITextField *clickIntervalText;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) GTClickerActionModel *modelAction;
//@property (weak, nonatomic) id<GTClickerPointSetTableViewCellDelegate> delegate;
@property (nonatomic, assign) int index;

@property (nonatomic, assign) int row;

@property (nonatomic, copy) LongPressPointShowPointSetBlock longPressPointShowPointSetBlock;

@property (nonatomic, assign) int tapCompare;
@property (nonatomic, assign) int pressCompare;
@property (nonatomic, assign) int clickCompare;
@end

NS_ASSUME_NONNULL_END
