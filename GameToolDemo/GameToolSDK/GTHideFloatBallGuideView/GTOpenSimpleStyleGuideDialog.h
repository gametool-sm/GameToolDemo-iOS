//
//  GTOpenSimpleStyleGuideDialog.h
//  GTSDK
//
//  Created by smwl_dxl on 2023/7/10.
//

#import "GTBaseView.h"

NS_ASSUME_NONNULL_BEGIN


//确认bloock
typedef void(^ConfirmButtonBlock)(void);
//取消bloock
typedef void(^CancelButtonBlock)(void);

@interface GTOpenSimpleStyleGuideDialog : GTBaseView
@property (nonatomic, copy) ConfirmButtonBlock confirmButtonBlock;
@property (nonatomic, copy) CancelButtonBlock cancelButtonBlock;
- (instancetype)initWithTitleText:(nonnull NSString *)TitleText DescText:(nonnull NSString *)descText confirm:(nullable ConfirmButtonBlock)confirmButtonBlock cancel:(nullable CancelButtonBlock)cancelButtonBlock;
@end

NS_ASSUME_NONNULL_END
