//
//  GTClickerWindowNowStartView.h
//  GTSDK
//
//  Created by shangmi on 2023/8/15.
//

#import "GTBaseView.h"

NS_ASSUME_NONNULL_BEGIN
//暂停
typedef void(^PauseBlock)(void);

@interface GTClickerWindowNowStartView : GTBaseView

@property (nonatomic, copy) PauseBlock pauseBlock;

@end

NS_ASSUME_NONNULL_END
