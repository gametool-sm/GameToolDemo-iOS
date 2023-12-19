//
//  GTClickerWindowViewController.h
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTBaseViewController.h"

#import "GTClickerWindowNowReadyView.h"
#import "GTClickerWindowFutureReadyView.h"
#import "GTClickerWindowNowStartView.h"
#import "GTClickerWindowFutureStartView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTClickerWindowViewController : GTBaseViewController

/**
 连点器悬浮窗
 */
@property (nonatomic, strong, nullable) GTClickerWindowNowReadyView *nowReadyView;
@property (nonatomic, strong, nullable) GTClickerWindowFutureReadyView *futureReadyView;
@property (nonatomic, strong, nullable) GTClickerWindowNowStartView *nowStartView;
@property (nonatomic, strong, nullable) GTClickerWindowFutureStartView *futureStartView;

@end

NS_ASSUME_NONNULL_END
