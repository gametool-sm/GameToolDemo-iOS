//
//  GTAnimationDialogView.h
//  GTSDK
//
//  Created by shangmi on 2023/7/3.
//

#import "GTBaseView.h"

NS_ASSUME_NONNULL_BEGIN

//确认bloock
typedef void(^ConfirmButtonBlock)(void);

@interface GTAnimationDialogView : GTBaseView

@property (nonatomic, copy) ConfirmButtonBlock confirmButtonBlock;

- (instancetype)initWithTitle:(NSString *)title BundleName:(nonnull NSString *)bundleName confirm:(nullable ConfirmButtonBlock)confirmButtonBlock;

@end

NS_ASSUME_NONNULL_END
