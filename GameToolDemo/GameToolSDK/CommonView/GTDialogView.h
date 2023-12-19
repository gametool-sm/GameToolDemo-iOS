//
//  GTDialogView.h
//  GTSDK
//
//  Created by shangmi on 2023/6/30.
//

#import "GTBaseView.h"

typedef NS_ENUM(NSUInteger, DialogViewStyle) {
    DialogViewStyleDefault,
    DialogViewStyleInput,
    DialogViewStyleNoCancel,
};

NS_ASSUME_NONNULL_BEGIN
//左边按钮block
typedef void(^LeftButtonBlock)(void);
//右边按钮bloock
typedef void(^RightButtonBlock)(void);

@interface GTDialogView : GTBaseView

@property (nonatomic, assign) DialogViewStyle style;

@property (nonatomic, copy) LeftButtonBlock leftButtonBlock;

@property (nonatomic, copy) RightButtonBlock rightButtonBlock;

- (instancetype)initWithStyle:(DialogViewStyle)style title:(NSString *)title content:(NSString *)content leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftButtonBlock:(LeftButtonBlock)leftButtonBlock rightButtonBlock:(RightButtonBlock)rightButtonBlock;

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *contentText;
@property (nonatomic, copy) NSString *leftButtonText;
@property (nonatomic, copy) NSString *rightButtonText;

@property (nonatomic, copy) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

NS_ASSUME_NONNULL_END
