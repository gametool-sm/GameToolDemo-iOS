//
//  GTFloatingBallBehaveFactory.h
//  GTSDK
//
//  Created by shangmi on 2023/9/14.
//

#import <Foundation/Foundation.h>
#import "GTFloatingBallBehaveProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTFloatingBallBehaveFactory : NSObject <GTFloatingBallBehaveProtocol>

- (CGPoint)floatingBallMoveArea:(CGPoint)movePoint;

- (void)startFloatingBallHideHalfTimer;

- (void)startFloatingBallDarkTimer;

- (void)removeFloatingBallHideHalfTimer;

- (void)removeFloatingBallDarkTimer;

@end

NS_ASSUME_NONNULL_END
