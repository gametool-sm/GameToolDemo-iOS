//
//  GTHideSimpleFloatBallGuideDialog.h
//  GTSDK
//
//  Created by smwl_dxl on 2023/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//关闭极简模式bloock
typedef void(^closeSimpleStyleButtonBlock)(void);
//隐藏悬浮球bloock
typedef void(^hideButtonBlock)(void);
//取消bloock
typedef void(^cancelButtonBlock)(void);

@interface GTHideSimpleFloatBallGuideDialog : UIView
@property (nonatomic, copy) closeSimpleStyleButtonBlock closeButtonBlock;
@property (nonatomic, copy) hideButtonBlock hideButtonBlock;
@property (nonatomic, copy) cancelButtonBlock cancelBtnBlock;
- (instancetype)initWithTitleText:(nonnull NSString *)titleText closeSimpleStype:(nullable closeSimpleStyleButtonBlock)closeButtonBlock hideFloatBall:(nullable hideButtonBlock)hideButtonBlock cancelBtnBlock:(nullable cancelButtonBlock)cancelBtnBlock;
@end

NS_ASSUME_NONNULL_END
