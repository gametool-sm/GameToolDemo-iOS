//
//  GTClickerChangeNameView.h
//  GTSDK
//
//  Created by shangminet on 2023/8/21.
//


/**
        点击改名按钮后的修改弹窗
 */


#import <UIKit/UIKit.h>
#import "GTBaseView.h"
NS_ASSUME_NONNULL_BEGIN
//取消block
typedef void(^CancelButtonBlock)(void);
//确认bloock
typedef void(^ConfirmButtonBlock)(void);

@interface GTClickerChangeNameView : GTBaseView<UITextFieldDelegate>


@property (nonatomic, copy) CancelButtonBlock cancelButtonBlock;

@property (nonatomic, copy) ConfirmButtonBlock confirmButtonBlock;

@property (nonatomic, strong) GTClickerSchemeModel *model;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *changeNameLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *verifyButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIView *nameBackGroundView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, weak) id<UITextFieldDelegate> delegate;



- (instancetype)initWithStyleconfirm:(GTClickerSchemeModel *)model confirm: (ConfirmButtonBlock)confirmButtonBlock cancel:(CancelButtonBlock)cancelButtonBlock;

@end

NS_ASSUME_NONNULL_END
