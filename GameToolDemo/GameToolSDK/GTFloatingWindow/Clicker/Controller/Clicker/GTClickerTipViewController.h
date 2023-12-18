//
//  GTClickerTipViewController.h
//  GTSDK
//
//  Created by shangmi on 2023/8/11.
//

#import "GTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^StartExploringBlock)(void);

@interface GTClickerTipViewController : GTBaseViewController

@property (nonatomic, copy) StartExploringBlock startExploringBlock;

@end

NS_ASSUME_NONNULL_END
