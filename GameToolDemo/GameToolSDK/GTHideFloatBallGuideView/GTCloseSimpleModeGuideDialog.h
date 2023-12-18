//
//  GTCloseSimpleModeGuideDialog.h
//  GTSDK
//
//  Created by shangmi on 2023/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//关闭极简模式bloock
typedef void(^closeSimpleStyleButtonBlock)(void);
//取消bloock
typedef void(^cancelButtonBlock)(void);

@interface GTCloseSimpleModeGuideDialog : UIView
@property (nonatomic, copy) closeSimpleStyleButtonBlock closeButtonBlock;
@property (nonatomic, copy) cancelButtonBlock cancelBtnBlock;
- (instancetype)initWithTitleText:(nonnull NSString *)titleText closeSimpleStype:(nullable closeSimpleStyleButtonBlock)closeButtonBlock cancelBtnBlock:(nullable cancelButtonBlock)cancelBtnBlock;

@end

NS_ASSUME_NONNULL_END
