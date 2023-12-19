//
//  GTFloatingBallViewController.h
//  GTSDK
//
//  Created by shangmi on 2023/6/25.
//

#import "GTBaseViewController.h"
#import "GTOperationControl.h"
#import "GTFloatingBallBaseView.h"
#import "GTHideFloatBallView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTFloatingBallViewController : UIViewController

@property (nonatomic, strong, nullable) GTFloatingBallBaseView *floatingBallView;

/*
 提示隐藏悬浮球区域
 */
@property (nonatomic, strong) GTHideFloatBallView * hideFloatBallView;
@property (nonatomic, assign) CGPoint floatOrignRect;

@end

NS_ASSUME_NONNULL_END
