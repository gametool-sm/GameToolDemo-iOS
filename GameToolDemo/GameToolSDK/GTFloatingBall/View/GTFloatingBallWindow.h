//
//  GTFloatingBallWindow.h
//  GTSDK
//
//  Created by shangmi on 2023/6/25.
//

#import <UIKit/UIKit.h>
#import "GTFloatingBallBehaveFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTFloatingBallWindow : UIWindow

//控制悬浮球行为工厂
@property (nonatomic, strong, nullable) GTFloatingBallBehaveFactory * behaveFactory;

@end

NS_ASSUME_NONNULL_END
