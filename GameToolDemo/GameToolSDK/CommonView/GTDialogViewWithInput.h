//
//  GTDialogViewWithInput.h
//  GTSDK
//
//  Created by shangmi on 2023/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//取消block
typedef void(^CancelButtonBlock)(void);
//确认bloock
typedef void(^ConfirmButtonBlock)(NSString *str);

@interface GTDialogViewWithInput : UIView

@property (nonatomic, copy) CancelButtonBlock cancelButtonBlock;

@property (nonatomic, copy) ConfirmButtonBlock confirmButtonBlock;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content confirm:(ConfirmButtonBlock)confirmButtonBlock cancel:(CancelButtonBlock)cancelButtonBlock;

@end

NS_ASSUME_NONNULL_END
