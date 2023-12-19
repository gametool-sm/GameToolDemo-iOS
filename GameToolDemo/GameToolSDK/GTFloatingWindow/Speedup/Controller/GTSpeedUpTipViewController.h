//
//  GTSpeedUpTipViewController.h
//  GTSDK
//
//  Created by shangmi on 2023/6/26.
//

#import "GTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^StartExploringBlock)(void);

@interface GTSpeedUpTipViewController : GTBaseViewController

@property (nonatomic, copy) StartExploringBlock startExploringBlock;

@end

NS_ASSUME_NONNULL_END
