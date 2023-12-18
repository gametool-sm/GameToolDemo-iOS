//
//  GTHideFloatBallGuideDialog.h
//  GTSDK
//
//  Created by smwl_dxl on 2023/7/6.
//

#import <UIKit/UIKit.h>
#import "GTDialogWindow.h"

NS_ASSUME_NONNULL_BEGIN

////隐藏悬浮弹窗的状态
//typedef NS_ENUM(NSUInteger, HideFloatBallWindowStyle) {
//    HideFloatBallWindowStyleDefault,           //默认样式
//    HideFloatBallWindowStyleSimple,     //简易控制样式
//};

//确认bloock
typedef void(^ConfirmButtonBlock)(void);
//取消bloock
typedef void(^CancelButtonBlock)(void);

@interface GTHideFloatBallGuideDialog : UIView

@property (nonatomic, copy) ConfirmButtonBlock confirmButtonBlock;
@property (nonatomic, copy) CancelButtonBlock cancelButtonBlock;
- (instancetype)initWithDescText:(nonnull NSString *)descText confirm:(nullable ConfirmButtonBlock)confirmButtonBlock cancel:(nullable CancelButtonBlock)cancelButtonBlock;

@end

NS_ASSUME_NONNULL_END
